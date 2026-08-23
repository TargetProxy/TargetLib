package manager

import (
	"context"
	"sync"
	"testing"
	"time"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

func TestRunLatencyTestsCoalescesOutboundsInSameGroup(t *testing.T) {
	backend := newFakeLatencyService(
		latencyGroups(groupItem("a", 0, 0), groupItem("b", 0, 0)),
		latencyGroups(groupItem("a", 10, 31), groupItem("b", 11, 47)),
	)
	manager := &Manager{latency: backend}
	var results []*targetlibapi.LatencyTestResult

	err := manager.runLatencyTests(context.Background(), []string{"a", "b"}, time.Second, 4, func(result *targetlibapi.LatencyTestResult) error {
		results = append(results, result)
		return nil
	})

	if err != nil {
		t.Fatal(err)
	}
	if backend.testCount() != 1 {
		t.Fatalf("expected one group test, got %d", backend.testCount())
	}
	if len(results) != 2 {
		t.Fatalf("expected two results, got %d", len(results))
	}
	byTag := map[string]*targetlibapi.LatencyTestResult{}
	for _, result := range results {
		byTag[result.GetOutboundTag()] = result
	}
	if byTag["a"].GetStatus() != targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_SUCCESS || byTag["a"].GetDelayMilliseconds() != 31 {
		t.Fatalf("unexpected result for a: %v", byTag["a"])
	}
	if byTag["b"].GetStatus() != targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_SUCCESS || byTag["b"].GetDelayMilliseconds() != 47 {
		t.Fatalf("unexpected result for b: %v", byTag["b"])
	}
}

func TestRunLatencyTestsReturnsNotFoundWithoutTriggeringCore(t *testing.T) {
	backend := newFakeLatencyService(latencyGroups(groupItem("a", 0, 0)), nil)
	manager := &Manager{latency: backend}
	var result *targetlibapi.LatencyTestResult

	err := manager.runLatencyTests(context.Background(), []string{"missing"}, time.Second, 4, func(value *targetlibapi.LatencyTestResult) error {
		result = value
		return nil
	})

	if err != nil {
		t.Fatal(err)
	}
	if result.GetStatus() != targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_NOT_FOUND {
		t.Fatalf("unexpected result: %v", result)
	}
	if backend.testCount() != 0 {
		t.Fatalf("core test should not be triggered, got %d calls", backend.testCount())
	}
}

func TestLatencyTimeoutRejectsValuesAboveLimit(t *testing.T) {
	if _, err := latencyTimeout(60_001); err == nil {
		t.Fatal("expected timeout validation error")
	}
}

type fakeLatencyService struct {
	mu          sync.Mutex
	initial     *daemon.Groups
	updated     *daemon.Groups
	subscribers map[chan struct{}]struct{}
	tests       int
}

func newFakeLatencyService(initial, updated *daemon.Groups) *fakeLatencyService {
	return &fakeLatencyService{
		initial: initial, updated: updated,
		subscribers: make(map[chan struct{}]struct{}),
	}
}

func (s *fakeLatencyService) SubscribeGroups(_ *emptypb.Empty, stream grpc.ServerStreamingServer[daemon.Groups]) error {
	if err := stream.Send(s.initial); err != nil {
		return err
	}
	notification := make(chan struct{}, 1)
	s.mu.Lock()
	s.subscribers[notification] = struct{}{}
	s.mu.Unlock()
	defer func() {
		s.mu.Lock()
		delete(s.subscribers, notification)
		s.mu.Unlock()
	}()
	select {
	case <-notification:
		if s.updated != nil {
			if err := stream.Send(s.updated); err != nil {
				return err
			}
		}
		<-stream.Context().Done()
		return stream.Context().Err()
	case <-stream.Context().Done():
		return stream.Context().Err()
	}
}

func (s *fakeLatencyService) URLTest(context.Context, *daemon.URLTestRequest) (*emptypb.Empty, error) {
	s.mu.Lock()
	s.tests++
	for subscriber := range s.subscribers {
		select {
		case subscriber <- struct{}{}:
		default:
		}
	}
	s.mu.Unlock()
	return &emptypb.Empty{}, nil
}

func (s *fakeLatencyService) testCount() int {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.tests
}

func latencyGroups(items ...*daemon.GroupItem) *daemon.Groups {
	return &daemon.Groups{Group: []*daemon.Group{{
		Tag: "urltest", Type: "urltest", Items: items,
	}}}
}

func groupItem(tag string, testedAt int64, delay int32) *daemon.GroupItem {
	return &daemon.GroupItem{Tag: tag, UrlTestTime: testedAt, UrlTestDelay: delay}
}
