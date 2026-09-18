package manager

import (
	"context"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (m *Manager) publishRuntime(event *api.RuntimeEvent) {
	s := m.smart
	if s == nil {
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.closed {
		return
	}
	s.sequence++
	event = proto.Clone(event).(*api.RuntimeEvent)
	event.Sequence = s.sequence
	event.OccurredAtUnixMs = time.Now().UnixMilli()
	for ch := range s.subscribers {
		select {
		case ch <- event:
		default:
			// Disconnect slow consumers so missed transitions cannot look complete.
			close(ch)
			delete(s.subscribers, ch)
		}
	}
}

func (m *Manager) SubscribeRuntimeEvents(_ *emptypb.Empty, stream grpc.ServerStreamingServer[api.RuntimeEvent]) error {
	s := m.smart
	s.mu.Lock()
	if s.closed {
		s.mu.Unlock()
		return status.Error(codes.Unavailable, "manager is closed")
	}
	ch := make(chan *api.RuntimeEvent, 64)
	s.subscribers[ch] = struct{}{}
	sequence := s.sequence
	s.mu.Unlock()
	defer func() { s.mu.Lock(); delete(s.subscribers, ch); s.mu.Unlock() }()
	state, err := m.GetRuntimeState(stream.Context(), &emptypb.Empty{})
	if err != nil {
		return err
	}
	if err := stream.Send(&api.RuntimeEvent{Sequence: sequence, Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_SNAPSHOT, OccurredAtUnixMs: time.Now().UnixMilli(), State: state}); err != nil {
		return err
	}
	for {
		select {
		case <-stream.Context().Done():
			return status.FromContextError(stream.Context().Err()).Err()
		case <-s.done:
			return status.Error(codes.Unavailable, "manager is closed")
		case event, ok := <-ch:
			if !ok {
				return status.Error(codes.ResourceExhausted, "runtime event consumer fell behind; reconnect for a snapshot")
			}
			if err := stream.Send(proto.Clone(event).(*api.RuntimeEvent)); err != nil {
				return err
			}
		}
	}
}

func (m *Manager) watchSmartConnect(ctx context.Context) {
	initialRevision := m.subscriptions.NodePool().Revision
	events, unsubscribe := m.subscriptions.Subscribe(16)
	m.smart.workers.Add(1)
	go func() {
		defer m.smart.workers.Done()
		defer unsubscribe()
		ticker := time.NewTicker(time.Second)
		defer ticker.Stop()
		revision := initialRevision
		var previous *api.RuntimeState
		var previousBindings *api.RuntimeState
		for {
			select {
			case <-ctx.Done():
				return
			case <-m.smart.done:
				return
			case _, ok := <-events:
				if !ok {
					return
				}
			case <-ticker.C:
				m.dispatchDueSmartTasks()
			}
			state, err := m.GetRuntimeState(ctx, &emptypb.Empty{})
			if err != nil {
				continue
			}
			if state.NodePoolRevision != revision {
				revision = state.NodePoolRevision
				m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_NODE_POOL, State: state})
			}
			bindings := &api.RuntimeState{ServiceBindings: state.ServiceBindings}
			if previousBindings != nil && !proto.Equal(previousBindings, bindings) {
				m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_BINDING, State: state})
			}
			previousBindings = bindings
			if !proto.Equal(previous, state) {
				m.publishRuntime(&api.RuntimeEvent{Type: api.RuntimeEventType_RUNTIME_EVENT_TYPE_CONFIG, State: state})
			}
			previous = state
		}
	}()
}
