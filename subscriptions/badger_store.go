package subscriptions

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/dgraph-io/badger/v4"
	badgeroptions "github.com/dgraph-io/badger/v4/options"
	"github.com/fxamacker/cbor/v2"
	targetprofile "github.com/loafman1120/TargetLib/profile"
	"github.com/sagernet/sing-box/option"
	singjson "github.com/sagernet/sing/common/json"
)

const (
	badgerPrefix         = "subscription-profile/"
	badgerMetadataPrefix = "meta/runtime/"
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
		WithNumGoroutines(2)
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
		return nil
	})
	return result, err
}

func (s *BadgerStore) encodeSubscription(item Subscription) ([]byte, error) {
	if item.ID == "" {
		return nil, ErrIDRequired
	}
	stored, err := storedSubscriptionFrom(item)
	if err != nil {
		return nil, err
	}
	encoded, err := s.encode.Marshal(stored)
	if err != nil {
		return nil, err
	}
	if int64(len(encoded)) >= s.db.MaxBatchSize() {
		return nil, fmt.Errorf("subscription record exceeds %d bytes", s.db.MaxBatchSize())
	}
	return encoded, nil
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

func (tx badgerStoreTx) SetMetadata(key string, value []byte) error {
	return tx.tx.Set(metadataKey(key), append([]byte(nil), value...))
}

func metadataKey(key string) []byte {
	return []byte(badgerMetadataPrefix + base64.RawURLEncoding.EncodeToString([]byte(key)))
}

func (s *BadgerStore) decodeSubscription(value []byte) (Subscription, error) {
	var stored storedSubscription
	if err := s.decode.Unmarshal(value, &stored); err != nil {
		return Subscription{}, err
	}
	item, err := stored.subscription()
	if err != nil {
		return Subscription{}, fmt.Errorf("restore subscription %q: %w", stored.ID, err)
	}
	return item, nil
}

type storedSubscription struct {
	ID                 string
	Name               string
	URL                string
	Enabled            bool
	AutoUpdate         bool
	UpdateInterval     time.Duration
	Headers            map[string]string
	Status             Status
	Stage              UpdateStage
	Profile            storedProfile
	NodesHash          string
	ETag               string
	LastModified       string
	ErrorCode          string
	Error              string
	UpdatedAt          time.Time
	NextUpdateAt       time.Time
	UploadBytes        int64
	DownloadBytes      int64
	TotalBytes         int64
	ResolvedEndpoints  []string
	ExpiresAt          time.Time
	Title              string
	WebPageURL         string
	SupportURL         string
	MovedPermanentlyTo string
}

type storedProfile struct {
	Nodes []storedNode
}

type storedNode struct {
	ID             string
	SubscriptionID string
	Name           string
	Type           string
	CountryCode    string
	Server         string
	Port           int
	Phase          targetprofile.NodePhase
	Error          string
	OutboundJSON   json.RawMessage
}

func storedSubscriptionFrom(item Subscription) (storedSubscription, error) {
	stored := storedSubscription{
		ID: item.ID, Name: item.Name, URL: item.URL, Enabled: item.Enabled,
		AutoUpdate: item.AutoUpdate, UpdateInterval: item.UpdateInterval,
		Headers: cloneStringMap(item.Headers), Status: item.Status, Stage: item.Stage,
		NodesHash: item.NodesHash, ETag: item.ETag, LastModified: item.LastModified,
		ErrorCode: item.ErrorCode, Error: item.Error, UpdatedAt: item.UpdatedAt,
		NextUpdateAt: item.NextUpdateAt, UploadBytes: item.UploadBytes,
		DownloadBytes: item.DownloadBytes, TotalBytes: item.TotalBytes,
		ResolvedEndpoints: append([]string(nil), item.ResolvedEndpoints...),
		ExpiresAt:         item.ExpiresAt, Title: item.Title, WebPageURL: item.WebPageURL,
		SupportURL: item.SupportURL, MovedPermanentlyTo: item.MovedPermanentlyTo,
		Profile: storedProfile{Nodes: make([]storedNode, len(item.Profile.Nodes))},
	}
	for index, node := range item.Profile.Nodes {
		var outboundJSON []byte
		if node.Outbound != nil {
			encoded, err := singjson.MarshalContext(targetprofile.Context(), node.Outbound)
			if err != nil {
				return storedSubscription{}, fmt.Errorf("encode node %q: %w", node.ID, err)
			}
			outboundJSON = encoded
		}
		stored.Profile.Nodes[index] = storedNode{
			ID: node.ID, SubscriptionID: node.SubscriptionID, Name: node.Name,
			Type: node.Type, CountryCode: node.CountryCode, Server: node.Server,
			Port: node.Port, Phase: node.Phase, Error: node.Error, OutboundJSON: outboundJSON,
		}
	}
	return stored, nil
}

func (stored storedSubscription) subscription() (Subscription, error) {
	item := Subscription{
		ID: stored.ID, Name: stored.Name, URL: stored.URL, Enabled: stored.Enabled,
		AutoUpdate: stored.AutoUpdate, UpdateInterval: stored.UpdateInterval,
		Headers: stored.Headers, Status: stored.Status, Stage: stored.Stage,
		NodesHash: stored.NodesHash, ETag: stored.ETag, LastModified: stored.LastModified,
		ErrorCode: stored.ErrorCode, Error: stored.Error, UpdatedAt: stored.UpdatedAt,
		NextUpdateAt: stored.NextUpdateAt, UploadBytes: stored.UploadBytes,
		DownloadBytes: stored.DownloadBytes, TotalBytes: stored.TotalBytes,
		ResolvedEndpoints: stored.ResolvedEndpoints, ExpiresAt: stored.ExpiresAt,
		Title: stored.Title, WebPageURL: stored.WebPageURL, SupportURL: stored.SupportURL,
		MovedPermanentlyTo: stored.MovedPermanentlyTo,
		Profile:            targetprofile.Profile{Nodes: make([]targetprofile.Node, len(stored.Profile.Nodes))},
	}
	for index, node := range stored.Profile.Nodes {
		runtimeNode := targetprofile.Node{
			ID: node.ID, SubscriptionID: node.SubscriptionID, Name: node.Name,
			Type: node.Type, CountryCode: node.CountryCode, Server: node.Server,
			Port: node.Port, Phase: node.Phase, Error: node.Error,
		}
		if len(node.OutboundJSON) > 0 {
			outbound, err := singjson.UnmarshalExtendedContext[option.Outbound](targetprofile.Context(), node.OutboundJSON)
			if err != nil {
				return Subscription{}, fmt.Errorf("decode node %q: %w", node.ID, err)
			}
			runtimeNode.Outbound = &outbound
		}
		item.Profile.Nodes[index] = runtimeNode
	}
	return item, nil
}

func badgerKey(id string) []byte {
	return []byte(badgerPrefix + base64.RawURLEncoding.EncodeToString([]byte(id)))
}
