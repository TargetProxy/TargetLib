package subscriptions

import (
	"context"
	"errors"
	"testing"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

type fixedFetcher struct {
	body []byte
	err  error
}

func (f fixedFetcher) Fetch(context.Context, Subscription) (FetchResponse, error) {
	return FetchResponse{Body: f.body}, f.err
}

func TestAddSubscriptionRollsBackFailedImmediateUpdate(t *testing.T) {
	manager := NewManager(Options{
		Fetcher: fixedFetcher{err: errors.New("fetch failed")},
		Store:   &MemoryStore{},
	})
	handler := NewHandler(manager)

	_, err := handler.AddSubscription(context.Background(), &targetlibapi.AddSubscriptionRequest{
		Id: "youtu", Name: "youtu", Url: "https://example.com/sub", UpdateNow: true,
	})
	if err == nil {
		t.Fatal("expected immediate update failure")
	}
	if views := manager.Views(); len(views) != 0 {
		t.Fatalf("failed subscription was retained: %+v", views)
	}
}

func TestAddSubscriptionReturnsUpdatedActiveProfile(t *testing.T) {
	manager := NewManager(Options{
		Fetcher: fixedFetcher{body: []byte(`{"outbounds":[{"type":"ssh","tag":"youtu","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`)},
		Store:   &MemoryStore{},
	})
	handler := NewHandler(manager)

	view, err := handler.AddSubscription(context.Background(), &targetlibapi.AddSubscriptionRequest{
		Id: "youtu", Name: "youtu", Url: "https://example.com/sub", UpdateNow: true, Activate: true,
	})
	if err != nil {
		t.Fatal(err)
	}
	if manager.ActiveID() != "youtu" {
		t.Fatalf("active ID = %q, want youtu", manager.ActiveID())
	}
	if len(view.GetProfile().GetNodes()) != 1 || view.GetProfile().GetNodes()[0].GetTag() != "youtu" {
		t.Fatalf("updated profile was not returned: %+v", view.GetProfile())
	}
}
