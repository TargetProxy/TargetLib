package subscriptions

import (
	"context"
	"sync"
)

type StoredState struct {
	Subscriptions []Subscription
	ActiveID      string
}

type StoreTx interface {
	Put(Subscription) error
	Delete(string) error
	SetActiveID(string) error
	SetMetadata(string, []byte) error
}

type Store interface {
	Load(context.Context) (StoredState, error)
	GetMetadata(context.Context, string) ([]byte, error)
	Update(context.Context, func(StoreTx) error) error
}

type MemoryStore struct {
	mu       sync.RWMutex
	items    []Subscription
	activeID string
	metadata map[string][]byte
}

func (s *MemoryStore) Load(context.Context) (StoredState, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return StoredState{Subscriptions: cloneSubscriptions(s.items), ActiveID: s.activeID}, nil
}

func (s *MemoryStore) GetMetadata(_ context.Context, key string) ([]byte, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return append([]byte(nil), s.metadata[key]...), nil
}

func (s *MemoryStore) Update(ctx context.Context, update func(StoreTx) error) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	tx := &memoryStoreTx{items: cloneSubscriptions(s.items), activeID: s.activeID, metadata: cloneBytesMap(s.metadata)}
	if err := update(tx); err != nil {
		return err
	}
	s.items, s.activeID, s.metadata = tx.items, tx.activeID, tx.metadata
	return nil
}

type memoryStoreTx struct {
	items    []Subscription
	activeID string
	metadata map[string][]byte
}

func (tx *memoryStoreTx) Put(item Subscription) error {
	for index := range tx.items {
		if tx.items[index].ID == item.ID {
			tx.items[index] = cloneSubscription(item)
			return nil
		}
	}
	tx.items = append(tx.items, cloneSubscription(item))
	return nil
}

func (tx *memoryStoreTx) Delete(id string) error {
	for index := range tx.items {
		if tx.items[index].ID == id {
			tx.items = append(tx.items[:index], tx.items[index+1:]...)
			break
		}
	}
	return nil
}

func (tx *memoryStoreTx) SetActiveID(id string) error {
	tx.activeID = id
	return nil
}

func (tx *memoryStoreTx) SetMetadata(key string, value []byte) error {
	if tx.metadata == nil {
		tx.metadata = make(map[string][]byte)
	}
	tx.metadata[key] = append([]byte(nil), value...)
	return nil
}

func cloneSubscriptions(items []Subscription) []Subscription {
	out := make([]Subscription, len(items))
	for i, item := range items {
		out[i] = cloneSubscription(item)
	}
	return out
}

func cloneBytesMap(source map[string][]byte) map[string][]byte {
	if source == nil {
		return nil
	}
	result := make(map[string][]byte, len(source))
	for key, value := range source {
		result[key] = append([]byte(nil), value...)
	}
	return result
}
