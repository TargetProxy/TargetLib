package manager

import (
	"context"
	"fmt"

	"github.com/fxamacker/cbor/v2"
	"github.com/loafman1120/TargetLib/config"
	"github.com/loafman1120/TargetLib/subscriptions"
)

const runtimeIntentKey = "runtime-intent"

type runtimeConfigStore struct{ store subscriptions.Store }

type storedRuntimeIntent struct {
	Settings         config.Settings
	Selectors        []config.Selector
	ServiceRoutes    []config.ServiceRoute
	NodePoolRevision string
}

func (s runtimeConfigStore) Load(ctx context.Context) (*runtimeIntent, error) {
	content, err := s.store.GetMetadata(ctx, runtimeIntentKey)
	if err != nil {
		return nil, fmt.Errorf("load runtime config: %w", err)
	}
	if len(content) == 0 {
		return nil, nil
	}
	var record storedRuntimeIntent
	if err := cbor.Unmarshal(content, &record); err != nil {
		return nil, fmt.Errorf("decode runtime config: %w", err)
	}
	return &runtimeIntent{
		settings: record.Settings, selectors: record.Selectors,
		serviceRoutes: record.ServiceRoutes, nodePoolRevision: record.NodePoolRevision,
	}, nil
}

func (s runtimeConfigStore) Save(ctx context.Context, intent runtimeIntent) error {
	content, err := cbor.Marshal(storedRuntimeIntent{
		Settings: intent.settings, Selectors: intent.selectors,
		ServiceRoutes: intent.serviceRoutes, NodePoolRevision: intent.nodePoolRevision,
	})
	if err != nil {
		return fmt.Errorf("encode runtime config: %w", err)
	}
	if err := s.store.Update(ctx, func(tx subscriptions.StoreTx) error {
		return tx.SetMetadata(runtimeIntentKey, content)
	}); err != nil {
		return fmt.Errorf("save runtime config: %w", err)
	}
	return nil
}
