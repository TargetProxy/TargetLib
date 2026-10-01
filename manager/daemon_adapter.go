package manager

import (
	"context"
	"errors"
	"io"

	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc"
	"google.golang.org/grpc/metadata"
	"google.golang.org/protobuf/types/known/emptypb"
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

var errStatusReceived = errors.New("status received")

type firstStatusReceiver struct {
	status *daemon.ServiceStatus
}

func (r *firstStatusReceiver) Send(value *daemon.ServiceStatus) error {
	r.status = value
	return errStatusReceived
}
func (*firstStatusReceiver) SetHeader(metadata.MD) error  { return nil }
func (*firstStatusReceiver) SendHeader(metadata.MD) error { return nil }
func (*firstStatusReceiver) SetTrailer(metadata.MD)       {}
func (*firstStatusReceiver) Context() context.Context     { return context.Background() }
func (*firstStatusReceiver) SendMsg(any) error            { return nil }
func (*firstStatusReceiver) RecvMsg(any) error            { return io.EOF }
