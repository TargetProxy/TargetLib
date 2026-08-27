package manager

import (
	"bytes"
	"context"
	"testing"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
)

type configDebugFetcher struct{ body []byte }

func (f configDebugFetcher) Fetch(context.Context, subscriptions.Subscription) (subscriptions.FetchResponse, error) {
	return subscriptions.FetchResponse{Body: f.body}, nil
}

func TestUpdateSubscriptionReturnsOriginalAndGeneratedConfigs(t *testing.T) {
	original := []byte(`{"outbounds":[{"type":"ssh","tag":"node","server":"127.0.0.1","server_port":22,"user":"test","password":"secret"}]}`)
	store := &subscriptions.MemoryStore{}
	subscriptionManager := subscriptions.NewManager(subscriptions.Options{
		Fetcher: configDebugFetcher{body: original},
		Store:   store,
	})
	t.Cleanup(subscriptionManager.Close)
	if _, err := subscriptionManager.AddRequest(context.Background(), subscriptions.AddRequest{
		ID: "debug", Name: "Debug", URL: "https://example.com/sub",
		Enabled: true,
	}); err != nil {
		t.Fatal(err)
	}
	m := &Manager{
		Handler:       subscriptions.NewHandler(subscriptionManager),
		subscriptions: subscriptionManager,
		runtimeConfig: defaultRuntimeConfig(),
		cacheFilePath: t.TempDir() + "/cache.db",
	}

	result, err := m.UpdateSubscription(context.Background(), &targetlibapi.SubscriptionId{Id: "debug"})
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(result.GetOriginalConfig(), original) {
		t.Fatalf("original config = %q, want %q", result.GetOriginalConfig(), original)
	}
	if len(result.GetGeneratedConfig()) == 0 {
		t.Fatal("generated config is empty")
	}
	if !bytes.Contains(result.GetGeneratedConfig(), []byte(`"tag":"proxy"`)) {
		t.Fatalf("generated config does not contain TargetLib selector: %s", result.GetGeneratedConfig())
	}
}
