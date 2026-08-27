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
	if len(view.GetProfile().GetNodes()) != 1 ||
		view.GetProfile().GetNodes()[0].GetTag() == "" ||
		view.GetProfile().GetNodes()[0].GetName() != "youtu" {
		t.Fatalf("updated profile was not returned: %+v", view.GetProfile())
	}
}

func TestUpdateSubscriptionReturnsFetchedConfigWithoutPersistingIt(t *testing.T) {
	body := []byte(`{"outbounds":[{"type":"ssh","tag":"youtu","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`)
	manager := NewManager(Options{
		Fetcher: fixedFetcher{body: body},
		Store:   &MemoryStore{},
	})
	t.Cleanup(manager.Close)
	handler := NewHandler(manager)
	if _, err := manager.AddRequest(context.Background(), AddRequest{
		ID: "youtu", Name: "youtu", URL: "https://example.com/sub", Enabled: true,
	}); err != nil {
		t.Fatal(err)
	}

	result, err := handler.UpdateSubscription(context.Background(), &targetlibapi.SubscriptionId{Id: "youtu"})
	if err != nil {
		t.Fatal(err)
	}
	if string(result.GetOriginalConfig()) != string(body) {
		t.Fatalf("original config = %q, want %q", result.GetOriginalConfig(), body)
	}
	stored, ok := manager.Get("youtu")
	if !ok {
		t.Fatal("updated subscription was not stored")
	}
	if encoded := string(stored.Profile.Nodes[0].OutboundJSON); encoded == string(body) {
		t.Fatal("full original document was persisted in the profile")
	}
}
