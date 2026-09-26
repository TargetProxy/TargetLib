package manager

import (
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (m *Manager) publishRuntime(event *api.RuntimeEvent) {
	s := m.runtimeState
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.closed {
		return
	}
	s.sequence++
	event.Sequence = s.sequence
	event.OccurredAtUnixMs = time.Now().UnixMilli()
	for ch := range s.subscribers {
		select {
		case ch <- proto.Clone(event).(*api.RuntimeEvent):
		default:
			close(ch)
			delete(s.subscribers, ch)
		}
	}
}

func (m *Manager) SubscribeRuntimeEvents(_ *emptypb.Empty, stream grpc.ServerStreamingServer[api.RuntimeEvent]) error {
	s := m.runtimeState
	s.mu.Lock()
	if s.closed {
		s.mu.Unlock()
		return status.Error(codes.Unavailable, "manager is closed")
	}
	ch := make(chan *api.RuntimeEvent, 32)
	s.subscribers[ch] = struct{}{}
	s.sequence++
	initial := &api.RuntimeEvent{
		Sequence:         s.sequence,
		Type:             api.RuntimeEventType_RUNTIME_EVENT_TYPE_SNAPSHOT,
		OccurredAtUnixMs: time.Now().UnixMilli(),
	}
	s.mu.Unlock()
	initial.State, _ = m.GetRuntimeState(stream.Context(), &emptypb.Empty{})
	defer func() { s.mu.Lock(); delete(s.subscribers, ch); s.mu.Unlock() }()
	if err := stream.Send(initial); err != nil {
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
				return status.Error(codes.ResourceExhausted, "runtime event consumer is too slow")
			}
			if err := stream.Send(event); err != nil {
				return err
			}
		}
	}
}
