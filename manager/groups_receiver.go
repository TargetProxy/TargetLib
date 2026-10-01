package manager

import (
	"context"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/metadata"
)

// groupsReceiver captures the first Groups message from sing-box.
type groupsReceiver struct {
	groups *daemon.Groups
}

func (r *groupsReceiver) Send(value *daemon.Groups) error {
	r.groups = value
	return nil
}

func (*groupsReceiver) SetHeader(metadata.MD) error  { return nil }
func (*groupsReceiver) SendHeader(metadata.MD) error { return nil }
func (*groupsReceiver) SetTrailer(metadata.MD)       {}
func (*groupsReceiver) Context() context.Context     { return context.Background() }
func (*groupsReceiver) SendMsg(interface{}) error    { return nil }
func (*groupsReceiver) RecvMsg(interface{}) error    { return nil }
