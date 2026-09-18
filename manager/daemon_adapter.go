package manager

import (
	"context"
	"errors"
	"time"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/emptypb"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
)

// daemonAdapter isolates the sing-box daemon API from lifecycle decisions.
type daemonAdapter struct{ service *daemon.StartedService }

func newDaemonAdapter(service *daemon.StartedService) *daemonAdapter {
	return &daemonAdapter{service: service}
}

func (d *daemonAdapter) Close() { d.service.Close() }

func (d *daemonAdapter) Status() (*daemon.ServiceStatus, error) {
	receiver := new(firstStatusReceiver)
	err := d.service.SubscribeServiceStatus(&emptypb.Empty{}, receiver)
	if errors.Is(err, errStatusReceived) && receiver.status != nil {
		return receiver.status, nil
	}
	if err == nil && receiver.status != nil {
		return receiver.status, nil
	}
	return nil, err
}

func (d *daemonAdapter) SelectOutbound(ctx context.Context, group, outbound string) (*emptypb.Empty, error) {
	return d.service.SelectOutbound(ctx, &daemon.SelectOutboundRequest{GroupTag: group, OutboundTag: outbound})
}

func (d *daemonAdapter) SubscribeGroups(request *emptypb.Empty, stream grpc.ServerStreamingServer[daemon.Groups]) error {
	return d.service.SubscribeGroups(request, stream)
}

func (d *daemonAdapter) URLTest(ctx context.Context, request *daemon.URLTestRequest) (*emptypb.Empty, error) {
	return d.service.URLTest(ctx, request)
}

func runtimeState(source *daemon.ServiceStatus) *targetlibapi.ServiceState {
	stateType := targetlibapi.ServiceStateType_SERVICE_STATE_UNSPECIFIED
	switch source.GetStatus() {
	case daemon.ServiceStatus_IDLE:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_IDLE
	case daemon.ServiceStatus_STARTING:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_STARTING
	case daemon.ServiceStatus_STARTED:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_RUNNING
	case daemon.ServiceStatus_STOPPING:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_STOPPING
	case daemon.ServiceStatus_FATAL:
		stateType = targetlibapi.ServiceStateType_SERVICE_STATE_FAILED
	}
	return &targetlibapi.ServiceState{State: stateType, ErrorMessage: source.GetErrorMessage(), ChangedAtUnixMs: time.Now().UnixMilli()}
}

var _ latencyService = (*daemonAdapter)(nil)
