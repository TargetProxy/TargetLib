package manager

import (
	"context"
	"encoding/json"
	"fmt"
	targetprofile "github.com/loafman1120/TargetLib/profile"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/loafman1120/TargetLib/subscriptions"
	"google.golang.org/protobuf/proto"
)

const runtimeConfigMetadataKey = "runtime-config-v1"
const runtimeNodesMetadataKey = "runtime-nodes-v1"

func (s runtimeConfigStore) LoadNodes(ctx context.Context) ([]targetprofile.Node, error) {
	content, err := s.store.GetMetadata(ctx, runtimeNodesMetadataKey)
	if err != nil || len(content) == 0 {
		return nil, err
	}
	var nodes []targetprofile.Node
	if err := json.Unmarshal(content, &nodes); err != nil {
		return nil, fmt.Errorf("decode runtime nodes: %w", err)
	}
	for i := range nodes {
		if err := targetprofile.RestoreNodeOutbound(&nodes[i]); err != nil {
			return nil, err
		}
	}
	return nodes, nil
}

func (s runtimeConfigStore) SaveSnapshot(ctx context.Context, value *targetlibapi.RuntimeConfig, nodes []targetprofile.Node) error {
	return s.store.Update(ctx, func(tx subscriptions.StoreTx) error {
		return s.saveSnapshotTx(tx, value, nodes)
	})
}

func (s runtimeConfigStore) saveSnapshotTx(tx subscriptions.StoreTx, value *targetlibapi.RuntimeConfig, nodes []targetprofile.Node) error {
	content, err := proto.Marshal(value)
	if err != nil {
		return err
	}
	nodeContent, err := json.Marshal(nodes)
	if err != nil {
		return err
	}
	if err := tx.SetMetadata(runtimeConfigMetadataKey, content); err != nil {
		return err
	}
	return tx.SetMetadata(runtimeNodesMetadataKey, nodeContent)
}

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
