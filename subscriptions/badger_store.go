package subscriptions

import (
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"time"

	"github.com/dgraph-io/badger/v4"
	badgeroptions "github.com/dgraph-io/badger/v4/options"
	"github.com/fxamacker/cbor/v2"
	targetprofile "github.com/loafman1120/TargetLib/profile"
)

const (
	badgerSchemaVersion  byte = 2
	badgerPrefix              = "subscription/"
	badgerActiveIDKey         = "meta/active_subscription_id"
	badgerMetadataPrefix      = "meta/runtime/"
)

type BadgerStore struct {
	db     *badger.DB
	encode cbor.EncMode
	decode cbor.DecMode
}

// OpenBadgerStore 打开适合移动端的加密订阅数据库。
// 32 字节密钥来自 Android Keystore 或 Apple Keychain 集成。
func OpenBadgerStore(path string, key []byte) (*BadgerStore, error) {
	if path == "" {
		return nil, errors.New("Badger path is required")
	}
	if len(key) != 32 {
		return nil, errors.New("Badger encryption key must be 32 bytes")
	}
	encode, err := cbor.CanonicalEncOptions().EncMode()
	if err != nil {
		return nil, err
	}
	decode, err := (cbor.DecOptions{MaxArrayElements: 100000, MaxMapPairs: 100000, MaxNestedLevels: 64}).DecMode()
	if err != nil {
		return nil, err
	}
	options := badger.LSMOnlyOptions(path).
		WithEncryptionKey(append([]byte(nil), key...)).
		WithEncryptionKeyRotationDuration(30 * 24 * time.Hour).
		WithLogger(nil).
		WithMetricsEnabled(false).
		WithSyncWrites(true).
		WithCompression(badgeroptions.Snappy).
		WithBlockCacheSize(4 << 20).
		WithIndexCacheSize(4 << 20).
		WithMemTableSize(16 << 20).
		WithBaseTableSize(2 << 20).
		WithBaseLevelSize(8 << 20).
		WithValueThreshold(64 << 10).
		WithNumMemtables(2).
		WithNumCompactors(2).
		WithValueLogFileSize(8 << 20).
		WithValueLogMaxEntries(10000).
		WithNumGoroutines(2).
		WithExternalMagic(uint16(badgerSchemaVersion))
	db, err := badger.Open(options)
	if err != nil {
		return nil, fmt.Errorf("open subscription database: %w", err)
	}
	return &BadgerStore{db: db, encode: encode, decode: decode}, nil
}

func (s *BadgerStore) Close() error { return s.db.Close() }

func (s *BadgerStore) Load(ctx context.Context) (StoredState, error) {
	var result StoredState
	err := s.db.View(func(transaction *badger.Txn) error {
		options := badger.DefaultIteratorOptions
		options.Prefix = []byte(badgerPrefix)
		iterator := transaction.NewIterator(options)
		defer iterator.Close()
		for iterator.Rewind(); iterator.Valid(); iterator.Next() {
			if err := ctx.Err(); err != nil {
				return err
			}
			value, err := iterator.Item().ValueCopy(nil)
			if err != nil {
				return err
			}
			item, err := s.decodeSubscription(value)
			if err != nil {
				return err
			}
			result.Subscriptions = append(result.Subscriptions, item)
		}
		item, err := transaction.Get([]byte(badgerActiveIDKey))
		if errors.Is(err, badger.ErrKeyNotFound) {
			return nil
		}
		if err != nil {
			return err
		}
		return item.Value(func(value []byte) error {
			result.ActiveID = string(value)
			return nil
		})
	})
	return result, err
}

func (s *BadgerStore) encodeSubscription(item Subscription) ([]byte, error) {
	if item.ID == "" {
		return nil, ErrIDRequired
	}
	stored := cloneSubscription(item)
	encoded, err := s.encode.Marshal(stored)
	if err != nil {
		return nil, err
	}
	value := append([]byte{badgerSchemaVersion}, encoded...)
	if int64(len(value)) >= s.db.MaxBatchSize() {
		return nil, fmt.Errorf("subscription record exceeds %d bytes", s.db.MaxBatchSize())
	}
	return value, nil
}

func (s *BadgerStore) Update(ctx context.Context, update func(StoreTx) error) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	return s.db.Update(func(transaction *badger.Txn) error {
		return update(badgerStoreTx{store: s, tx: transaction})
	})
}

func (s *BadgerStore) GetMetadata(ctx context.Context, key string) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	var value []byte
	err := s.db.View(func(transaction *badger.Txn) error {
		item, err := transaction.Get(metadataKey(key))
		if errors.Is(err, badger.ErrKeyNotFound) {
			return nil
		}
		if err != nil {
			return err
		}
		value, err = item.ValueCopy(nil)
		return err
	})
	return value, err
}

type badgerStoreTx struct {
	store *BadgerStore
	tx    *badger.Txn
}

func (tx badgerStoreTx) Put(item Subscription) error {
	value, err := tx.store.encodeSubscription(item)
	if err != nil {
		return err
	}
	return tx.tx.Set(badgerKey(item.ID), value)
}

func (tx badgerStoreTx) Delete(id string) error { return tx.tx.Delete(badgerKey(id)) }

func (tx badgerStoreTx) SetActiveID(id string) error {
	if id == "" {
		return tx.tx.Delete([]byte(badgerActiveIDKey))
	}
	return tx.tx.Set([]byte(badgerActiveIDKey), []byte(id))
}

func (tx badgerStoreTx) SetMetadata(key string, value []byte) error {
	return tx.tx.Set(metadataKey(key), append([]byte(nil), value...))
}

func metadataKey(key string) []byte {
	return []byte(badgerMetadataPrefix + base64.RawURLEncoding.EncodeToString([]byte(key)))
}

func (s *BadgerStore) decodeSubscription(value []byte) (Subscription, error) {
	if len(value) == 0 || value[0] != badgerSchemaVersion {
		return Subscription{}, errors.New("unsupported subscription record version")
	}
	var item Subscription
	if err := s.decode.Unmarshal(value[1:], &item); err != nil {
		return Subscription{}, err
	}
	if err := restoreNodeOutbounds(&item.Profile); err != nil {
		return Subscription{}, fmt.Errorf("restore subscription %q: %w", item.ID, err)
	}
	return item, nil
}

func restoreNodeOutbounds(profile *targetprofile.Profile) error {
	if profile == nil {
		return nil
	}
	for index := range profile.Nodes {
		node := &profile.Nodes[index]
		if node.Outbound != nil || len(node.OutboundJSON) == 0 {
			continue
		}
		if err := targetprofile.RestoreNodeOutbound(node); err != nil {
			return err
		}
	}
	return nil
}

func badgerKey(id string) []byte {
	return []byte(badgerPrefix + base64.RawURLEncoding.EncodeToString([]byte(id)))
}
