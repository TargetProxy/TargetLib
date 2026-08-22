package subscriptions

import (
	"context"
	"errors"
	"strings"
	"time"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

type Handler struct {
	targetlibapi.UnimplementedTargetLibServer
	manager *Manager
}

func NewHandler(manager *Manager) *Handler {
	return &Handler{manager: manager}
}

func (s *Handler) ListSubscriptions(context.Context, *emptypb.Empty) (*targetlibapi.SubscriptionList, error) {
	views := s.manager.Views()
	result := &targetlibapi.SubscriptionList{Subscriptions: make([]*targetlibapi.SubscriptionView, len(views))}
	for i := range views {
		result.Subscriptions[i] = grpcSubscriptionView(views[i])
	}
	return result, nil
}

func (s *Handler) GetSubscription(_ context.Context, request *targetlibapi.SubscriptionId) (*targetlibapi.SubscriptionView, error) {
	id, err := subscriptionID(request)
	if err != nil {
		return nil, err
	}
	view, ok := s.manager.View(id)
	if !ok {
		return nil, status.Errorf(codes.NotFound, "subscription %q not found", id)
	}
	return grpcSubscriptionView(view), nil
}

func (s *Handler) AddSubscription(_ context.Context, request *targetlibapi.AddSubscriptionRequest) (*targetlibapi.SubscriptionView, error) {
	if request == nil {
		return nil, status.Error(codes.InvalidArgument, "request is required")
	}
	enabled, autoUpdate := true, true
	if request.Enabled != nil {
		enabled = request.GetEnabled()
	}
	if request.AutoUpdate != nil {
		autoUpdate = request.GetAutoUpdate()
	}
	interval, err := subscriptionDuration(request.GetUpdateIntervalSeconds())
	if err != nil {
		return nil, err
	}
	item, err := s.manager.AddRequest(AddRequest{
		ID: request.GetId(), Name: request.GetName(), URL: request.GetUrl(),
		Enabled: enabled, AutoUpdate: autoUpdate,
		UpdateInterval: interval,
		Headers:        request.GetHeaders(),
	})
	if err != nil {
		return nil, subscriptionError(err)
	}
	view, _ := s.manager.View(item.ID)
	return grpcSubscriptionView(view), nil
}

func (s *Handler) RemoveSubscription(_ context.Context, request *targetlibapi.SubscriptionId) (*emptypb.Empty, error) {
	id, err := subscriptionID(request)
	if err != nil {
		return nil, err
	}
	if _, ok := s.manager.View(id); !ok {
		return nil, status.Errorf(codes.NotFound, "subscription %q not found", id)
	}
	if !s.manager.Remove(id) {
		return nil, status.Error(codes.Internal, "remove subscription failed")
	}
	return &emptypb.Empty{}, nil
}

func (s *Handler) RenameSubscription(ctx context.Context, request *targetlibapi.RenameSubscriptionRequest) (*targetlibapi.SubscriptionView, error) {
	if request == nil || strings.TrimSpace(request.GetId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "subscription ID is required")
	}
	if err := s.manager.Rename(ctx, request.GetId(), request.GetName()); err != nil {
		return nil, subscriptionError(err)
	}
	return s.view(request.GetId())
}

func (s *Handler) SetSubscriptionEnabled(ctx context.Context, request *targetlibapi.SetSubscriptionEnabledRequest) (*targetlibapi.SubscriptionView, error) {
	if request == nil || strings.TrimSpace(request.GetId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "subscription ID is required")
	}
	if err := s.manager.SetEnabled(ctx, request.GetId(), request.GetEnabled()); err != nil {
		return nil, subscriptionError(err)
	}
	return s.view(request.GetId())
}

func (s *Handler) ConfigureSubscriptionUpdates(ctx context.Context, request *targetlibapi.ConfigureSubscriptionUpdatesRequest) (*targetlibapi.SubscriptionView, error) {
	if request == nil || strings.TrimSpace(request.GetId()) == "" {
		return nil, status.Error(codes.InvalidArgument, "subscription ID is required")
	}
	interval, err := subscriptionDuration(request.GetUpdateIntervalSeconds())
	if err != nil {
		return nil, err
	}
	if err := s.manager.ConfigureUpdates(ctx, request.GetId(), request.GetEnabled(), interval); err != nil {
		return nil, subscriptionError(err)
	}
	return s.view(request.GetId())
}

func (s *Handler) UpdateSubscription(ctx context.Context, request *targetlibapi.SubscriptionId) (*targetlibapi.SubscriptionUpdateResult, error) {
	id, err := subscriptionID(request)
	if err != nil {
		return nil, err
	}
	result, updateErr := s.manager.Update(ctx, id)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return nil, status.FromContextError(ctxErr).Err()
	}
	if updateErr != nil && result.Subscription.ID == "" {
		return nil, subscriptionError(updateErr)
	}
	view, ok := s.manager.View(id)
	if !ok {
		return nil, status.Errorf(codes.NotFound, "subscription %q not found", id)
	}
	return &targetlibapi.SubscriptionUpdateResult{
		Subscription: grpcSubscriptionView(view), Changed: result.Changed,
		NotModified: result.NotModified, DurationMilliseconds: result.Duration.Milliseconds(),
	}, nil
}

func (s *Handler) GetSubscriptionConfig(_ context.Context, request *targetlibapi.SubscriptionId) (*targetlibapi.SubscriptionConfig, error) {
	id, err := subscriptionID(request)
	if err != nil {
		return nil, err
	}
	if _, ok := s.manager.View(id); !ok {
		return nil, status.Errorf(codes.NotFound, "subscription %q not found", id)
	}
	content, ok := s.manager.Config(id)
	if !ok {
		return nil, status.Error(codes.FailedPrecondition, "subscription has no downloaded config")
	}
	return &targetlibapi.SubscriptionConfig{Content: content}, nil
}

func (s *Handler) GetResolvedEndpoints(_ context.Context, request *targetlibapi.ResolvedEndpointsRequest) (*targetlibapi.ResolvedEndpoints, error) {
	enabledOnly := request != nil && request.GetEnabledOnly()
	return &targetlibapi.ResolvedEndpoints{Addresses: s.manager.ResolvedEndpoints(enabledOnly)}, nil
}

func (s *Handler) SubscribeSubscriptionEvents(_ *emptypb.Empty, stream grpc.ServerStreamingServer[targetlibapi.SubscriptionEvent]) error {
	events, unsubscribe := s.manager.Subscribe(32)
	defer unsubscribe()
	for {
		select {
		case <-stream.Context().Done():
			return status.FromContextError(stream.Context().Err()).Err()
		case event, ok := <-events:
			if !ok {
				return nil
			}
			if err := stream.Send(subscriptionEvent(event)); err != nil {
				return err
			}
		}
	}
}

func (s *Handler) view(id string) (*targetlibapi.SubscriptionView, error) {
	view, ok := s.manager.View(id)
	if !ok {
		return nil, status.Errorf(codes.NotFound, "subscription %q not found", id)
	}
	return grpcSubscriptionView(view), nil
}

func subscriptionID(request *targetlibapi.SubscriptionId) (string, error) {
	if request == nil || strings.TrimSpace(request.GetId()) == "" {
		return "", status.Error(codes.InvalidArgument, "subscription ID is required")
	}
	return request.GetId(), nil
}

func subscriptionDuration(seconds int64) (time.Duration, error) {
	const maxDurationSeconds = int64((1<<63 - 1) / time.Second)
	if seconds < 0 || seconds > maxDurationSeconds {
		return 0, status.Error(codes.InvalidArgument, "update interval is out of range")
	}
	return time.Duration(seconds) * time.Second, nil
}

func subscriptionError(err error) error {
	code := codes.Internal
	switch {
	case errors.Is(err, ErrNotFound):
		code = codes.NotFound
	case errors.Is(err, ErrAlreadyExists):
		code = codes.AlreadyExists
	case errors.Is(err, ErrAlreadyUpdating):
		code = codes.Aborted
	case errors.Is(err, ErrInvalidURL),
		errors.Is(err, ErrHTTPSRequired),
		errors.Is(err, ErrIDRequired),
		errors.Is(err, ErrNameRequired),
		errors.Is(err, ErrIntervalTooShort):
		code = codes.InvalidArgument
	}
	return status.Error(code, err.Error())
}

func grpcSubscriptionView(view View) *targetlibapi.SubscriptionView {
	nodes := make([]*targetlibapi.SubscriptionNode, len(view.Nodes))
	for i, node := range view.Nodes {
		nodes[i] = &targetlibapi.SubscriptionNode{
			Id: node.ID, Name: node.Name, Type: node.Type, Server: node.Server,
			Port: int32(node.Port), Group: node.Group, Groups: append([]string(nil), node.Groups...),
			Phase: subscriptionNodePhase(node.Phase), ErrorMessage: node.Error,
		}
	}
	return &targetlibapi.SubscriptionView{
		Id: view.ID, Name: view.Name, Source: view.Source, Enabled: view.Enabled,
		AutoUpdate: view.AutoUpdate, UpdateIntervalSeconds: int64(view.UpdateInterval / time.Second),
		Status: subscriptionStatus(view.Status), Stage: subscriptionStage(view.Stage), Nodes: nodes,
		ErrorCode: view.ErrorCode, ErrorMessage: view.Error,
		UpdatedAtUnixMs: unixMilliseconds(view.UpdatedAt), NextUpdateAtUnixMs: unixMilliseconds(view.NextUpdateAt),
		UploadBytes: view.UploadBytes, DownloadBytes: view.DownloadBytes, TotalBytes: view.TotalBytes,
		ExpiresAtUnixMs: unixMilliseconds(view.ExpiresAt), Title: view.Title,
		WebPageUrl: view.WebPageURL, SupportUrl: view.SupportURL, MovedPermanentlyTo: view.MovedPermanentlyTo,
	}
}

func subscriptionEvent(event Event) *targetlibapi.SubscriptionEvent {
	return &targetlibapi.SubscriptionEvent{
		Type: subscriptionEventType(event.Type), Subscription: grpcSubscriptionView(event.Subscription),
		OccurredAtUnixMs: unixMilliseconds(event.At),
	}
}

func unixMilliseconds(value time.Time) int64 {
	if value.IsZero() {
		return 0
	}
	return value.UnixMilli()
}

func subscriptionStatus(value Status) targetlibapi.SubscriptionStatus {
	switch value {
	case StatusIdle:
		return targetlibapi.SubscriptionStatus_SUBSCRIPTION_STATUS_IDLE
	case StatusUpdating:
		return targetlibapi.SubscriptionStatus_SUBSCRIPTION_STATUS_UPDATING
	case StatusReady:
		return targetlibapi.SubscriptionStatus_SUBSCRIPTION_STATUS_READY
	case StatusFailed:
		return targetlibapi.SubscriptionStatus_SUBSCRIPTION_STATUS_FAILED
	default:
		return targetlibapi.SubscriptionStatus_SUBSCRIPTION_STATUS_UNSPECIFIED
	}
}

func subscriptionStage(value UpdateStage) targetlibapi.SubscriptionUpdateStage {
	switch value {
	case StageIdle:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_IDLE
	case StageFetching:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_FETCHING
	case StageParsing:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_PARSING
	case StageResolving:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_RESOLVING
	case StagePersisting:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_PERSISTING
	case StageComplete:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_COMPLETE
	case StageFailed:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_FAILED
	default:
		return targetlibapi.SubscriptionUpdateStage_SUBSCRIPTION_UPDATE_STAGE_UNSPECIFIED
	}
}

func subscriptionNodePhase(value NodePhase) targetlibapi.SubscriptionNodePhase {
	switch value {
	case NodeDiscovered:
		return targetlibapi.SubscriptionNodePhase_SUBSCRIPTION_NODE_PHASE_DISCOVERED
	case NodeNormalized:
		return targetlibapi.SubscriptionNodePhase_SUBSCRIPTION_NODE_PHASE_NORMALIZED
	case NodeReady:
		return targetlibapi.SubscriptionNodePhase_SUBSCRIPTION_NODE_PHASE_READY
	case NodeFailed:
		return targetlibapi.SubscriptionNodePhase_SUBSCRIPTION_NODE_PHASE_FAILED
	default:
		return targetlibapi.SubscriptionNodePhase_SUBSCRIPTION_NODE_PHASE_UNSPECIFIED
	}
}

func subscriptionEventType(value EventType) targetlibapi.SubscriptionEventType {
	switch value {
	case EventAdded:
		return targetlibapi.SubscriptionEventType_SUBSCRIPTION_EVENT_TYPE_ADDED
	case EventUpdated:
		return targetlibapi.SubscriptionEventType_SUBSCRIPTION_EVENT_TYPE_UPDATED
	case EventRemoved:
		return targetlibapi.SubscriptionEventType_SUBSCRIPTION_EVENT_TYPE_REMOVED
	case EventStage:
		return targetlibapi.SubscriptionEventType_SUBSCRIPTION_EVENT_TYPE_STAGE
	default:
		return targetlibapi.SubscriptionEventType_SUBSCRIPTION_EVENT_TYPE_UNSPECIFIED
	}
}

var _ targetlibapi.TargetLibServer = (*Handler)(nil)
