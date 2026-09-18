package subscriptions

import (
	"context"
	"errors"
	"sync"
	"sync/atomic"
	"testing"
	"time"
)

type failingStore struct {
	*MemoryStore
	mu   sync.Mutex
	fail bool
}

type blockingFetcher struct {
	calls   atomic.Int32
	started chan struct{}
	release chan struct{}
}

type cancellationFetcher struct{ started chan struct{} }

func (f cancellationFetcher) Fetch(ctx context.Context, _ Subscription) (FetchResponse, error) {
	close(f.started)
	<-ctx.Done()
	return FetchResponse{}, ctx.Err()
}

func (f *blockingFetcher) Fetch(ctx context.Context, _ Subscription) (FetchResponse, error) {
	if f.calls.Add(1) == 1 {
		close(f.started)
	}
	select {
	case <-ctx.Done():
		return FetchResponse{}, ctx.Err()
	case <-f.release:
		return FetchResponse{Body: []byte(`{"outbounds":[{"type":"ssh","tag":"node","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`)}, nil
	}
}

func (s *failingStore) Update(ctx context.Context, update func(StoreTx) error) error {
	s.mu.Lock()
	fail := s.fail
	s.mu.Unlock()
	if fail {
		return errors.New("store update failed")
	}
	return s.MemoryStore.Update(ctx, update)
}

func (s *failingStore) setFail(value bool) {
	s.mu.Lock()
	s.fail = value
	s.mu.Unlock()
}

func TestRemoveSubscriptionCommitsStoreTransaction(t *testing.T) {
	store := &MemoryStore{}
	manager := newTestManager(t, store)
	addTestSubscription(t, manager, "active")
	if err := manager.Remove(context.Background(), "active"); err != nil {
		t.Fatal(err)
	}
	stored, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if len(stored.Subscriptions) != 0 {
		t.Fatalf("non-atomic stored state: %+v", stored)
	}
}

func TestRemoveDoesNotPublishWhenStoreFails(t *testing.T) {
	store := &failingStore{MemoryStore: &MemoryStore{}}
	manager := newTestManager(t, store)
	addTestSubscription(t, manager, "next")
	store.setFail(true)
	if err := manager.Remove(context.Background(), "next"); err == nil {
		t.Fatal("remove unexpectedly succeeded")
	}
	if _, ok := manager.Get("next"); !ok {
		t.Fatal("failed removal changed snapshot")
	}
}

func TestConcurrentUpdatesShareOneFetch(t *testing.T) {
	fetcher := &blockingFetcher{started: make(chan struct{}), release: make(chan struct{})}
	manager := NewManager(Options{Store: &MemoryStore{}, Fetcher: fetcher})
	t.Cleanup(manager.Close)
	if err := manager.Load(context.Background()); err != nil {
		t.Fatal(err)
	}
	addTestSubscription(t, manager, "shared")

	results := make(chan error, 2)
	go func() {
		_, err := manager.Update(context.Background(), "shared")
		results <- err
	}()
	<-fetcher.started
	go func() {
		_, err := manager.Update(context.Background(), "shared")
		results <- err
	}()
	time.Sleep(20 * time.Millisecond)
	close(fetcher.release)
	for range 2 {
		if err := <-results; err != nil {
			t.Fatal(err)
		}
	}
	if calls := fetcher.calls.Load(); calls != 1 {
		t.Fatalf("fetch calls = %d, want 1", calls)
	}
}

func TestMemoryStoreUpdateRollsBackCallbackFailure(t *testing.T) {
	store := &MemoryStore{}
	errExpected := errors.New("abort transaction")
	err := store.Update(context.Background(), func(tx StoreTx) error {
		if err := tx.Put(Subscription{ID: "discarded"}); err != nil {
			return err
		}
		if err := tx.SetMetadata("revision", []byte("discarded")); err != nil {
			return err
		}
		return errExpected
	})
	if !errors.Is(err, errExpected) {
		t.Fatalf("update error = %v", err)
	}
	stored, err := store.Load(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	metadata, _ := store.GetMetadata(context.Background(), "revision")
	if len(stored.Subscriptions) != 0 || len(metadata) != 0 {
		t.Fatalf("aborted transaction was committed: %+v", stored)
	}
}

func TestCanceledUpdateDoesNotLeaveTransientState(t *testing.T) {
	fetcher := cancellationFetcher{started: make(chan struct{})}
	manager := NewManager(Options{Store: &MemoryStore{}, Fetcher: fetcher})
	t.Cleanup(manager.Close)
	if err := manager.Load(context.Background()); err != nil {
		t.Fatal(err)
	}
	addTestSubscription(t, manager, "cancel")
	ctx, cancel := context.WithCancel(context.Background())
	result := make(chan error, 1)
	go func() {
		_, err := manager.Update(ctx, "cancel")
		result <- err
	}()
	<-fetcher.started
	cancel()
	if err := <-result; !errors.Is(err, context.Canceled) {
		t.Fatalf("update error = %v", err)
	}
	deadline := time.Now().Add(time.Second)
	for {
		item, ok := manager.Get("cancel")
		if !ok {
			t.Fatal("subscription disappeared")
		}
		if item.Status != StatusUpdating {
			if item.Status != StatusFailed || item.Stage != StageFailed {
				t.Fatalf("final state = %s/%s", item.Status, item.Stage)
			}
			break
		}
		if time.Now().After(deadline) {
			t.Fatalf("subscription remained transient: %s/%s", item.Status, item.Stage)
		}
		time.Sleep(time.Millisecond)
	}
}

func newTestManager(t *testing.T, store Store) *Manager {
	t.Helper()
	manager := NewManager(Options{Store: store})
	t.Cleanup(manager.Close)
	if err := manager.Load(context.Background()); err != nil {
		t.Fatal(err)
	}
	return manager
}

func addTestSubscription(t *testing.T, manager *Manager, id string) {
	t.Helper()
	_, err := manager.AddRequest(context.Background(), AddRequest{
		ID: id, Name: id, URL: "https://example.com/" + id,
		Enabled: true, UpdateInterval: 5 * time.Minute,
	})
	if err != nil {
		t.Fatal(err)
	}
}
