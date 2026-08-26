package manager

import (
	"context"
	"fmt"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
	"google.golang.org/protobuf/proto"
)

const runtimeConfigMetadataKey = "runtime-config-v1"

type runtimeConfigStore struct{ store subscriptions.Store }

func (s runtimeConfigStore) Load(ctx context.Context) (*targetlibapi.RuntimeConfig, error) {
	content, err := s.store.GetMetadata(ctx, runtimeConfigMetadataKey)
	if err != nil {
		return nil, fmt.Errorf("load runtime config: %w", err)
	}
	if len(content) == 0 {
		return nil, nil
	}
	result := new(targetlibapi.RuntimeConfig)
	if err := proto.Unmarshal(content, result); err != nil {
		return nil, fmt.Errorf("decode runtime config: %w", err)
	}
	return result, nil
}

func (s runtimeConfigStore) Save(ctx context.Context, value *targetlibapi.RuntimeConfig) error {
	content, err := proto.Marshal(value)
	if err != nil {
		return fmt.Errorf("encode runtime config: %w", err)
	}
	if err := s.store.Update(ctx, func(tx subscriptions.StoreTx) error {
		return tx.SetMetadata(runtimeConfigMetadataKey, content)
	}); err != nil {
		return fmt.Errorf("save runtime config: %w", err)
	}
	return nil
}
