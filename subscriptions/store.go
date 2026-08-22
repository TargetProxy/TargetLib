package subscriptions

import (
	"context"
)

type Store interface {
	Load(context.Context) ([]Subscription, error)
	Put(context.Context, Subscription) error
	Delete(context.Context, string) error
}

type MemoryStore struct{ items []Subscription }

func (s *MemoryStore) Load(context.Context) ([]Subscription, error) {
	return cloneSubscriptions(s.items), nil
}
func (s *MemoryStore) Put(_ context.Context, item Subscription) error {
	for index := range s.items {
		if s.items[index].ID == item.ID {
			s.items[index] = cloneSubscription(item)
			return nil
		}
	}
	s.items = append(s.items, cloneSubscription(item))
	return nil
}
func (s *MemoryStore) Delete(_ context.Context, id string) error {
	for index := range s.items {
		if s.items[index].ID == id {
			s.items = append(s.items[:index], s.items[index+1:]...)
			break
		}
	}
	return nil
}

func cloneSubscriptions(items []Subscription) []Subscription {
	out := make([]Subscription, len(items))
	for i, item := range items {
		out[i] = cloneSubscription(item)
	}
	return out
}
