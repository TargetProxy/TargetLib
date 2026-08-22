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
)

const (
	badgerSchemaVersion byte = 1
	badgerPrefix             = "subscription/"
)

type BadgerStore struct {
	db     *badger.DB
	encode cbor.EncMode
	decode cbor.DecMode
}

// OpenBadgerStore opens the mobile-sized encrypted subscription database.
// The 32-byte key comes from Android Keystore or Apple Keychain integration.
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

func (s *BadgerStore) Load(ctx context.Context) ([]Subscription, error) {
	var result []Subscription
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
			result = append(result, item)
		}
		return nil
	})
	return result, err
}

func (s *BadgerStore) Put(ctx context.Context, item Subscription) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	if item.ID == "" {
		return ErrIDRequired
	}
	stored := cloneSubscription(item)
	stored.Nodes = nil
	encoded, err := s.encode.Marshal(stored)
	if err != nil {
		return err
	}
	value := append([]byte{badgerSchemaVersion}, encoded...)
	if int64(len(value)) >= s.db.MaxBatchSize() {
		return fmt.Errorf("subscription record exceeds %d bytes", s.db.MaxBatchSize())
	}
	return s.db.Update(func(transaction *badger.Txn) error { return transaction.Set(badgerKey(item.ID), value) })
}

func (s *BadgerStore) Delete(ctx context.Context, id string) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	return s.db.Update(func(transaction *badger.Txn) error { return transaction.Delete(badgerKey(id)) })
}

func (s *BadgerStore) decodeSubscription(value []byte) (Subscription, error) {
	if len(value) == 0 || value[0] != badgerSchemaVersion {
		return Subscription{}, errors.New("unsupported subscription record version")
	}
	var item Subscription
	if err := s.decode.Unmarshal(value[1:], &item); err != nil {
		return Subscription{}, err
	}
	if len(item.RawConfig) > 0 {
		profile, err := ParseProfile(item.RawConfig)
		if err != nil {
			return Subscription{}, fmt.Errorf("restore subscription %q: %w", item.ID, err)
		}
		item.Nodes = profile.Nodes
	}
	return item, nil
}

func badgerKey(id string) []byte {
	return []byte(badgerPrefix + base64.RawURLEncoding.EncodeToString([]byte(id)))
}
