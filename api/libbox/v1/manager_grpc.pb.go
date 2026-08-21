// Code generated from manager.proto. DO NOT EDIT.

package libboxv1

import (
	context "context"

	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
	emptypb "google.golang.org/protobuf/types/known/emptypb"
)

const (
	LibboxManager_GetVersion_FullMethodName           = "/libbox.v1.LibboxManager/GetVersion"
	LibboxManager_GetCapabilities_FullMethodName      = "/libbox.v1.LibboxManager/GetCapabilities"
	LibboxManager_CheckConfig_FullMethodName          = "/libbox.v1.LibboxManager/CheckConfig"
	LibboxManager_Start_FullMethodName                = "/libbox.v1.LibboxManager/Start"
	LibboxManager_Reload_FullMethodName               = "/libbox.v1.LibboxManager/Reload"
	LibboxManager_Restart_FullMethodName              = "/libbox.v1.LibboxManager/Restart"
	LibboxManager_Stop_FullMethodName                 = "/libbox.v1.LibboxManager/Stop"
	LibboxManager_GetState_FullMethodName             = "/libbox.v1.LibboxManager/GetState"
	LibboxManager_SubscribeState_FullMethodName       = "/libbox.v1.LibboxManager/SubscribeState"
	LibboxManager_GetSystemProxyStatus_FullMethodName = "/libbox.v1.LibboxManager/GetSystemProxyStatus"
	LibboxManager_SetSystemProxy_FullMethodName       = "/libbox.v1.LibboxManager/SetSystemProxy"
)

type LibboxManagerClient interface {
	GetVersion(context.Context, *emptypb.Empty, ...grpc.CallOption) (*VersionResponse, error)
	GetCapabilities(context.Context, *emptypb.Empty, ...grpc.CallOption) (*CapabilitiesResponse, error)
	CheckConfig(context.Context, *ConfigRequest, ...grpc.CallOption) (*CheckConfigResponse, error)
	Start(context.Context, *StartRequest, ...grpc.CallOption) (*OperationResponse, error)
	Reload(context.Context, *ReloadRequest, ...grpc.CallOption) (*OperationResponse, error)
	Restart(context.Context, *RestartRequest, ...grpc.CallOption) (*OperationResponse, error)
	Stop(context.Context, *emptypb.Empty, ...grpc.CallOption) (*OperationResponse, error)
	GetState(context.Context, *emptypb.Empty, ...grpc.CallOption) (*ServiceState, error)
	SubscribeState(context.Context, *emptypb.Empty, ...grpc.CallOption) (grpc.ServerStreamingClient[ServiceState], error)
	GetSystemProxyStatus(context.Context, *emptypb.Empty, ...grpc.CallOption) (*SystemProxyStatus, error)
	SetSystemProxy(context.Context, *SetSystemProxyRequest, ...grpc.CallOption) (*SystemProxyStatus, error)
}

type libboxManagerClient struct{ cc grpc.ClientConnInterface }

func NewLibboxManagerClient(cc grpc.ClientConnInterface) LibboxManagerClient {
	return &libboxManagerClient{cc: cc}
}

func invoke[Req, Resp any](ctx context.Context, cc grpc.ClientConnInterface, method string, in *Req, opts ...grpc.CallOption) (*Resp, error) {
	out := new(Resp)
	if err := cc.Invoke(ctx, method, in, out, opts...); err != nil {
		return nil, err
	}
	return out, nil
}

func (c *libboxManagerClient) GetVersion(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*VersionResponse, error) {
	return invoke[emptypb.Empty, VersionResponse](ctx, c.cc, LibboxManager_GetVersion_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) GetCapabilities(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*CapabilitiesResponse, error) {
	return invoke[emptypb.Empty, CapabilitiesResponse](ctx, c.cc, LibboxManager_GetCapabilities_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) CheckConfig(ctx context.Context, in *ConfigRequest, opts ...grpc.CallOption) (*CheckConfigResponse, error) {
	return invoke[ConfigRequest, CheckConfigResponse](ctx, c.cc, LibboxManager_CheckConfig_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) Start(ctx context.Context, in *StartRequest, opts ...grpc.CallOption) (*OperationResponse, error) {
	return invoke[StartRequest, OperationResponse](ctx, c.cc, LibboxManager_Start_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) Reload(ctx context.Context, in *ReloadRequest, opts ...grpc.CallOption) (*OperationResponse, error) {
	return invoke[ReloadRequest, OperationResponse](ctx, c.cc, LibboxManager_Reload_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) Restart(ctx context.Context, in *RestartRequest, opts ...grpc.CallOption) (*OperationResponse, error) {
	return invoke[RestartRequest, OperationResponse](ctx, c.cc, LibboxManager_Restart_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) Stop(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*OperationResponse, error) {
	return invoke[emptypb.Empty, OperationResponse](ctx, c.cc, LibboxManager_Stop_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) GetState(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*ServiceState, error) {
	return invoke[emptypb.Empty, ServiceState](ctx, c.cc, LibboxManager_GetState_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) SubscribeState(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (grpc.ServerStreamingClient[ServiceState], error) {
	stream, err := c.cc.NewStream(ctx, &LibboxManager_ServiceDesc.Streams[0], LibboxManager_SubscribeState_FullMethodName, opts...)
	if err != nil {
		return nil, err
	}
	x := &grpc.GenericClientStream[emptypb.Empty, ServiceState]{ClientStream: stream}
	if err := x.ClientStream.SendMsg(in); err != nil {
		return nil, err
	}
	if err := x.ClientStream.CloseSend(); err != nil {
		return nil, err
	}
	return x, nil
}
func (c *libboxManagerClient) GetSystemProxyStatus(ctx context.Context, in *emptypb.Empty, opts ...grpc.CallOption) (*SystemProxyStatus, error) {
	return invoke[emptypb.Empty, SystemProxyStatus](ctx, c.cc, LibboxManager_GetSystemProxyStatus_FullMethodName, in, opts...)
}
func (c *libboxManagerClient) SetSystemProxy(ctx context.Context, in *SetSystemProxyRequest, opts ...grpc.CallOption) (*SystemProxyStatus, error) {
	return invoke[SetSystemProxyRequest, SystemProxyStatus](ctx, c.cc, LibboxManager_SetSystemProxy_FullMethodName, in, opts...)
}

type LibboxManagerServer interface {
	GetVersion(context.Context, *emptypb.Empty) (*VersionResponse, error)
	GetCapabilities(context.Context, *emptypb.Empty) (*CapabilitiesResponse, error)
	CheckConfig(context.Context, *ConfigRequest) (*CheckConfigResponse, error)
	Start(context.Context, *StartRequest) (*OperationResponse, error)
	Reload(context.Context, *ReloadRequest) (*OperationResponse, error)
	Restart(context.Context, *RestartRequest) (*OperationResponse, error)
	Stop(context.Context, *emptypb.Empty) (*OperationResponse, error)
	GetState(context.Context, *emptypb.Empty) (*ServiceState, error)
	SubscribeState(*emptypb.Empty, grpc.ServerStreamingServer[ServiceState]) error
	GetSystemProxyStatus(context.Context, *emptypb.Empty) (*SystemProxyStatus, error)
	SetSystemProxy(context.Context, *SetSystemProxyRequest) (*SystemProxyStatus, error)
	mustEmbedUnimplementedLibboxManagerServer()
}

type UnimplementedLibboxManagerServer struct{}

func (UnimplementedLibboxManagerServer) GetVersion(context.Context, *emptypb.Empty) (*VersionResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method GetVersion not implemented")
}
func (UnimplementedLibboxManagerServer) GetCapabilities(context.Context, *emptypb.Empty) (*CapabilitiesResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method GetCapabilities not implemented")
}
func (UnimplementedLibboxManagerServer) CheckConfig(context.Context, *ConfigRequest) (*CheckConfigResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method CheckConfig not implemented")
}
func (UnimplementedLibboxManagerServer) Start(context.Context, *StartRequest) (*OperationResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method Start not implemented")
}
func (UnimplementedLibboxManagerServer) Reload(context.Context, *ReloadRequest) (*OperationResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method Reload not implemented")
}
func (UnimplementedLibboxManagerServer) Restart(context.Context, *RestartRequest) (*OperationResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method Restart not implemented")
}
func (UnimplementedLibboxManagerServer) Stop(context.Context, *emptypb.Empty) (*OperationResponse, error) {
	return nil, status.Error(codes.Unimplemented, "method Stop not implemented")
}
func (UnimplementedLibboxManagerServer) GetState(context.Context, *emptypb.Empty) (*ServiceState, error) {
	return nil, status.Error(codes.Unimplemented, "method GetState not implemented")
}
func (UnimplementedLibboxManagerServer) SubscribeState(*emptypb.Empty, grpc.ServerStreamingServer[ServiceState]) error {
	return status.Error(codes.Unimplemented, "method SubscribeState not implemented")
}
func (UnimplementedLibboxManagerServer) GetSystemProxyStatus(context.Context, *emptypb.Empty) (*SystemProxyStatus, error) {
	return nil, status.Error(codes.Unimplemented, "method GetSystemProxyStatus not implemented")
}
func (UnimplementedLibboxManagerServer) SetSystemProxy(context.Context, *SetSystemProxyRequest) (*SystemProxyStatus, error) {
	return nil, status.Error(codes.Unimplemented, "method SetSystemProxy not implemented")
}
func (UnimplementedLibboxManagerServer) mustEmbedUnimplementedLibboxManagerServer() {}

func RegisterLibboxManagerServer(s grpc.ServiceRegistrar, srv LibboxManagerServer) {
	s.RegisterService(&LibboxManager_ServiceDesc, srv)
}

func makeUnaryHandler[Req any](fullMethod string, call func(LibboxManagerServer, context.Context, *Req) (any, error)) func(any, context.Context, func(any) error, grpc.UnaryServerInterceptor) (any, error) {
	return func(srv any, ctx context.Context, dec func(any) error, interceptor grpc.UnaryServerInterceptor) (any, error) {
		in := new(Req)
		if err := dec(in); err != nil {
			return nil, err
		}
		if interceptor == nil {
			return call(srv.(LibboxManagerServer), ctx, in)
		}
		info := &grpc.UnaryServerInfo{Server: srv, FullMethod: fullMethod}
		handler := func(ctx context.Context, req any) (any, error) {
			return call(srv.(LibboxManagerServer), ctx, req.(*Req))
		}
		return interceptor(ctx, in, info, handler)
	}
}

func subscribeStateHandler(srv any, stream grpc.ServerStream) error {
	in := new(emptypb.Empty)
	if err := stream.RecvMsg(in); err != nil {
		return err
	}
	return srv.(LibboxManagerServer).SubscribeState(in, &grpc.GenericServerStream[emptypb.Empty, ServiceState]{ServerStream: stream})
}

var LibboxManager_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "libbox.v1.LibboxManager",
	HandlerType: (*LibboxManagerServer)(nil),
	Methods: []grpc.MethodDesc{
		{MethodName: "GetVersion", Handler: makeUnaryHandler(LibboxManager_GetVersion_FullMethodName, func(s LibboxManagerServer, c context.Context, r *emptypb.Empty) (any, error) {
			return s.GetVersion(c, r)
		})},
		{MethodName: "GetCapabilities", Handler: makeUnaryHandler(LibboxManager_GetCapabilities_FullMethodName, func(s LibboxManagerServer, c context.Context, r *emptypb.Empty) (any, error) {
			return s.GetCapabilities(c, r)
		})},
		{MethodName: "CheckConfig", Handler: makeUnaryHandler(LibboxManager_CheckConfig_FullMethodName, func(s LibboxManagerServer, c context.Context, r *ConfigRequest) (any, error) {
			return s.CheckConfig(c, r)
		})},
		{MethodName: "Start", Handler: makeUnaryHandler(LibboxManager_Start_FullMethodName, func(s LibboxManagerServer, c context.Context, r *StartRequest) (any, error) { return s.Start(c, r) })},
		{MethodName: "Reload", Handler: makeUnaryHandler(LibboxManager_Reload_FullMethodName, func(s LibboxManagerServer, c context.Context, r *ReloadRequest) (any, error) { return s.Reload(c, r) })},
		{MethodName: "Restart", Handler: makeUnaryHandler(LibboxManager_Restart_FullMethodName, func(s LibboxManagerServer, c context.Context, r *RestartRequest) (any, error) { return s.Restart(c, r) })},
		{MethodName: "Stop", Handler: makeUnaryHandler(LibboxManager_Stop_FullMethodName, func(s LibboxManagerServer, c context.Context, r *emptypb.Empty) (any, error) { return s.Stop(c, r) })},
		{MethodName: "GetState", Handler: makeUnaryHandler(LibboxManager_GetState_FullMethodName, func(s LibboxManagerServer, c context.Context, r *emptypb.Empty) (any, error) { return s.GetState(c, r) })},
		{MethodName: "GetSystemProxyStatus", Handler: makeUnaryHandler(LibboxManager_GetSystemProxyStatus_FullMethodName, func(s LibboxManagerServer, c context.Context, r *emptypb.Empty) (any, error) {
			return s.GetSystemProxyStatus(c, r)
		})},
		{MethodName: "SetSystemProxy", Handler: makeUnaryHandler(LibboxManager_SetSystemProxy_FullMethodName, func(s LibboxManagerServer, c context.Context, r *SetSystemProxyRequest) (any, error) {
			return s.SetSystemProxy(c, r)
		})},
	},
	Streams:  []grpc.StreamDesc{{StreamName: "SubscribeState", Handler: subscribeStateHandler, ServerStreams: true}},
	Metadata: "api/libbox/v1/manager.proto",
}
