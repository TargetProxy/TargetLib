package manager

import (
	"context"
	"errors"
	"io"
	"strings"
	"sync"
	"time"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

const (
	defaultLatencyTimeout     = 15 * time.Second
	maximumLatencyTimeout     = 60 * time.Second
	defaultLatencyConcurrency = 4
	maximumLatencyConcurrency = 4
)

type latencyService interface {
	SubscribeGroups(*emptypb.Empty, grpc.ServerStreamingServer[daemon.Groups]) error
	URLTest(context.Context, *daemon.URLTestRequest) (*emptypb.Empty, error)
}

type latencyTarget struct {
	tag      string
	baseline int64
}

type latencyGroupPlan struct {
	tag     string
	targets []latencyTarget
}

func (m *Manager) TestOutbound(ctx context.Context, request *targetlibapi.TestOutboundRequest) (*targetlibapi.LatencyTestResult, error) {
	if request == nil || strings.TrimSpace(request.GetOutboundTag()) == "" {
		return nil, status.Error(codes.InvalidArgument, "outbound tag is required")
	}
	timeout, err := latencyTimeout(request.GetTimeoutMilliseconds())
	if err != nil {
		return nil, err
	}
	var result *targetlibapi.LatencyTestResult
	err = m.runLatencyTests(ctx, []string{request.GetOutboundTag()}, timeout, 1, func(value *targetlibapi.LatencyTestResult) error {
		result = value
		return nil
	})
	if err != nil {
		return nil, err
	}
	if result == nil {
		return nil, status.Error(codes.Internal, "latency test completed without a result")
	}
	return result, nil
}

func (m *Manager) TestOutbounds(request *targetlibapi.TestOutboundsRequest, stream grpc.ServerStreamingServer[targetlibapi.LatencyTestResult]) error {
	if request == nil {
		return status.Error(codes.InvalidArgument, "request is required")
	}
	tags := normalizeOutboundTags(request.GetOutboundTags())
	if len(tags) == 0 {
		return status.Error(codes.InvalidArgument, "at least one outbound tag is required")
	}
	timeout, err := latencyTimeout(request.GetTimeoutMilliseconds())
	if err != nil {
		return err
	}
	concurrency := latencyConcurrency(request.GetMaxConcurrency())
	return m.runLatencyTests(stream.Context(), tags, timeout, concurrency, stream.Send)
}

func (m *Manager) runLatencyTests(
	ctx context.Context,
	tags []string,
	timeout time.Duration,
	concurrency int,
	emit func(*targetlibapi.LatencyTestResult) error,
) error {
	initial, err := m.readInitialGroups(ctx)
	if err != nil {
		if errors.Is(err, context.Canceled) || errors.Is(err, context.DeadlineExceeded) {
			return err
		}
		return status.Error(codes.FailedPrecondition, "proxy service is not running")
	}
	plans, results := planLatencyTests(initial, normalizeOutboundTags(tags))
	for _, result := range results {
		if err := emit(result); err != nil {
			return err
		}
	}
	if len(plans) == 0 {
		return nil
	}

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	resultChannel := make(chan *targetlibapi.LatencyTestResult, len(tags))
	semaphore := make(chan struct{}, concurrency)
	var workers sync.WaitGroup
	for _, plan := range plans {
		plan := plan
		workers.Add(1)
		go func() {
			defer workers.Done()
			select {
			case semaphore <- struct{}{}:
				defer func() { <-semaphore }()
			case <-ctx.Done():
				return
			}
			m.testLatencyGroup(ctx, plan, timeout, resultChannel)
		}()
	}
	go func() {
		workers.Wait()
		close(resultChannel)
	}()
	for result := range resultChannel {
		if err := emit(result); err != nil {
			cancel()
			return err
		}
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	return nil
}

func (m *Manager) testLatencyGroup(
	ctx context.Context,
	plan latencyGroupPlan,
	timeout time.Duration,
	output chan<- *targetlibapi.LatencyTestResult,
) {
	if err := m.acquireLatencyGroup(ctx, plan.tag); err != nil {
		return
	}
	defer m.releaseLatencyGroup(plan.tag)

	testContext, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	groups, subscriptionErrors := m.subscribeGroups(testContext)
	initial, err := nextGroups(testContext, groups, subscriptionErrors)
	if err != nil {
		emitLatencyResults(ctx, output, failedLatencyResults(plan.targets, err.Error()))
		return
	}
	plan.targets = refreshBaselines(initial, plan.tag, plan.targets)
	if err := waitForFreshLatencyTimestamp(testContext, plan.targets); err != nil {
		emitLatencyResults(ctx, output, timeoutLatencyResults(plan.targets))
		return
	}
	if _, err := m.latency.URLTest(testContext, &daemon.URLTestRequest{OutboundTag: plan.tag}); err != nil {
		emitLatencyResults(ctx, output, failedLatencyResults(plan.targets, err.Error()))
		return
	}

	pending := make(map[string]latencyTarget, len(plan.targets))
	for _, target := range plan.targets {
		pending[target.tag] = target
	}
	for len(pending) > 0 {
		snapshot, err := nextGroups(testContext, groups, subscriptionErrors)
		if err != nil {
			break
		}
		for _, item := range groupItems(snapshot, plan.tag) {
			target, ok := pending[item.GetTag()]
			if !ok {
				continue
			}
			if item.GetUrlTestTime() > target.baseline {
				if !emitLatencyResult(testContext, output, &targetlibapi.LatencyTestResult{
					OutboundTag:       target.tag,
					Status:            targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_SUCCESS,
					DelayMilliseconds: uint32(max(item.GetUrlTestDelay(), 0)),
					TestedAtUnixMs:    item.GetUrlTestTime() * 1000,
				}) {
					return
				}
				delete(pending, target.tag)
			} else if target.baseline > 0 && item.GetUrlTestTime() == 0 {
				if !emitLatencyResult(testContext, output, failedLatencyResult(target.tag, "latency test failed")) {
					return
				}
				delete(pending, target.tag)
			}
		}
	}
	for _, target := range pending {
		if !emitLatencyResult(ctx, output, &targetlibapi.LatencyTestResult{
			OutboundTag:  target.tag,
			Status:       targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_TIMEOUT,
			ErrorMessage: "latency test timed out",
		}) {
			return
		}
	}
}

// sing-box 的 URLTest 历史时间戳精度为一秒；必要时等待下一个时间边界，
// 使新结果可与基线区分，而不依赖延迟数值变化。
func waitForFreshLatencyTimestamp(ctx context.Context, targets []latencyTarget) error {
	var latest int64
	for _, target := range targets {
		latest = max(latest, target.baseline)
	}
	wait := time.Until(time.Unix(latest+1, 0))
	if wait <= 0 {
		return nil
	}
	timer := time.NewTimer(wait)
	defer timer.Stop()
	select {
	case <-timer.C:
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

func emitLatencyResults(ctx context.Context, output chan<- *targetlibapi.LatencyTestResult, results []*targetlibapi.LatencyTestResult) {
	for _, result := range results {
		if !emitLatencyResult(ctx, output, result) {
			return
		}
	}
}

func emitLatencyResult(ctx context.Context, output chan<- *targetlibapi.LatencyTestResult, result *targetlibapi.LatencyTestResult) bool {
	select {
	case output <- result:
		return true
	case <-ctx.Done():
		return false
	}
}

func (m *Manager) readInitialGroups(ctx context.Context) (*daemon.Groups, error) {
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	groups, subscriptionErrors := m.subscribeGroups(ctx)
	return nextGroups(ctx, groups, subscriptionErrors)
}

func (m *Manager) subscribeGroups(ctx context.Context) (<-chan *daemon.Groups, <-chan error) {
	groups := make(chan *daemon.Groups, 1)
	errors := make(chan error, 1)
	receiver := &groupsReceiver{ctx: ctx, groups: groups}
	go func() {
		errors <- m.latency.SubscribeGroups(&emptypb.Empty{}, receiver)
		close(errors)
		close(groups)
	}()
	return groups, errors
}

func nextGroups(ctx context.Context, groups <-chan *daemon.Groups, subscriptionErrors <-chan error) (*daemon.Groups, error) {
	select {
	case value, ok := <-groups:
		if ok {
			return value, nil
		}
		if err := <-subscriptionErrors; err != nil {
			return nil, err
		}
		return nil, io.EOF
	case err := <-subscriptionErrors:
		if err != nil {
			return nil, err
		}
		return nil, io.EOF
	case <-ctx.Done():
		return nil, ctx.Err()
	}
}

func planLatencyTests(groups *daemon.Groups, tags []string) ([]latencyGroupPlan, []*targetlibapi.LatencyTestResult) {
	groupByOutbound := make(map[string]string)
	baselineByOutbound := make(map[string]int64)
	for _, group := range groups.GetGroup() {
		if normalizeGroupType(group.GetType()) != "urltest" {
			continue
		}
		for _, item := range group.GetItems() {
			if _, exists := groupByOutbound[item.GetTag()]; exists {
				continue
			}
			groupByOutbound[item.GetTag()] = group.GetTag()
			baselineByOutbound[item.GetTag()] = item.GetUrlTestTime()
		}
	}
	planByGroup := make(map[string]*latencyGroupPlan)
	results := make([]*targetlibapi.LatencyTestResult, 0)
	for _, tag := range tags {
		groupTag, ok := groupByOutbound[tag]
		if !ok {
			results = append(results, &targetlibapi.LatencyTestResult{
				OutboundTag:  tag,
				Status:       targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_NOT_FOUND,
				ErrorMessage: "outbound is not part of a URLTest group",
			})
			continue
		}
		plan := planByGroup[groupTag]
		if plan == nil {
			plan = &latencyGroupPlan{tag: groupTag}
			planByGroup[groupTag] = plan
		}
		plan.targets = append(plan.targets, latencyTarget{tag: tag, baseline: baselineByOutbound[tag]})
	}
	plans := make([]latencyGroupPlan, 0, len(planByGroup))
	for _, plan := range planByGroup {
		plans = append(plans, *plan)
	}
	return plans, results
}

func refreshBaselines(groups *daemon.Groups, groupTag string, targets []latencyTarget) []latencyTarget {
	baselines := make(map[string]int64)
	for _, item := range groupItems(groups, groupTag) {
		baselines[item.GetTag()] = item.GetUrlTestTime()
	}
	for index := range targets {
		if baseline, exists := baselines[targets[index].tag]; exists {
			targets[index].baseline = baseline
		}
	}
	return targets
}

func groupItems(groups *daemon.Groups, groupTag string) []*daemon.GroupItem {
	for _, group := range groups.GetGroup() {
		if group.GetTag() == groupTag {
			return group.GetItems()
		}
	}
	return nil
}

func normalizeOutboundTags(tags []string) []string {
	seen := make(map[string]struct{}, len(tags))
	normalized := make([]string, 0, len(tags))
	for _, tag := range tags {
		tag = strings.TrimSpace(tag)
		if tag == "" {
			continue
		}
		if _, exists := seen[tag]; exists {
			continue
		}
		seen[tag] = struct{}{}
		normalized = append(normalized, tag)
	}
	return normalized
}

func normalizeGroupType(value string) string {
	return strings.ReplaceAll(strings.ReplaceAll(strings.ToLower(value), "-", ""), "_", "")
}

func latencyTimeout(milliseconds uint32) (time.Duration, error) {
	if milliseconds == 0 {
		return defaultLatencyTimeout, nil
	}
	timeout := time.Duration(milliseconds) * time.Millisecond
	if timeout > maximumLatencyTimeout {
		return 0, status.Error(codes.InvalidArgument, "latency timeout must not exceed 60 seconds")
	}
	return timeout, nil
}

func latencyConcurrency(requested uint32) int {
	if requested == 0 {
		return defaultLatencyConcurrency
	}
	return min(int(requested), maximumLatencyConcurrency)
}

func failedLatencyResults(targets []latencyTarget, message string) []*targetlibapi.LatencyTestResult {
	results := make([]*targetlibapi.LatencyTestResult, 0, len(targets))
	for _, target := range targets {
		results = append(results, failedLatencyResult(target.tag, message))
	}
	return results
}

func timeoutLatencyResults(targets []latencyTarget) []*targetlibapi.LatencyTestResult {
	results := make([]*targetlibapi.LatencyTestResult, 0, len(targets))
	for _, target := range targets {
		results = append(results, &targetlibapi.LatencyTestResult{
			OutboundTag:  target.tag,
			Status:       targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_TIMEOUT,
			ErrorMessage: "latency test timed out",
		})
	}
	return results
}

func failedLatencyResult(tag string, message string) *targetlibapi.LatencyTestResult {
	return &targetlibapi.LatencyTestResult{
		OutboundTag:  tag,
		Status:       targetlibapi.LatencyTestStatus_LATENCY_TEST_STATUS_FAILED,
		ErrorMessage: message,
	}
}

func (m *Manager) acquireLatencyGroup(ctx context.Context, tag string) error {
	m.latencyMu.Lock()
	if m.latencyGroups == nil {
		m.latencyGroups = make(map[string]chan struct{})
	}
	gate := m.latencyGroups[tag]
	if gate == nil {
		gate = make(chan struct{}, 1)
		m.latencyGroups[tag] = gate
	}
	m.latencyMu.Unlock()
	select {
	case gate <- struct{}{}:
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

func (m *Manager) releaseLatencyGroup(tag string) {
	m.latencyMu.Lock()
	gate := m.latencyGroups[tag]
	m.latencyMu.Unlock()
	if gate != nil {
		<-gate
	}
}

type groupsReceiver struct {
	ctx    context.Context
	groups chan<- *daemon.Groups
}

func (r *groupsReceiver) Send(value *daemon.Groups) error {
	select {
	case r.groups <- value:
		return nil
	case <-r.ctx.Done():
		return r.ctx.Err()
	}
}
func (*groupsReceiver) SetHeader(metadata.MD) error  { return nil }
func (*groupsReceiver) SendHeader(metadata.MD) error { return nil }
func (*groupsReceiver) SetTrailer(metadata.MD)       {}
func (r *groupsReceiver) Context() context.Context   { return r.ctx }
func (*groupsReceiver) SendMsg(any) error            { return nil }
func (*groupsReceiver) RecvMsg(any) error            { return io.EOF }
