//go:build android || ios

package manager

import (
	"context"
	"errors"
	"net/netip"
	"sync/atomic"

	"github.com/sagernet/sing-box/adapter"
	"github.com/sagernet/sing-box/option"
	tun "github.com/sagernet/sing-tun"
	"github.com/sagernet/sing/common/control"
	"github.com/sagernet/sing/common/logger"
	"github.com/sagernet/sing/common/x/list"
)

var mobileTunFD atomic.Int64

func SetTunFD(fd int32) error {
	if fd < 0 {
		return errors.New("invalid mobile TUN file descriptor")
	}
	mobileTunFD.Store(int64(fd))
	return nil
}

func newPlatformInterface() adapter.PlatformInterface { return mobilePlatform{} }

type mobilePlatform struct{}

func (mobilePlatform) Initialize(adapter.NetworkManager) error     { return nil }
func (mobilePlatform) UsePlatformAutoDetectInterfaceControl() bool { return false }
func (mobilePlatform) AutoDetectInterfaceControl(int) error        { return nil }
func (mobilePlatform) UsePlatformInterface() bool                  { return true }

func (mobilePlatform) OpenInterface(options *tun.Options, _ option.TunPlatformOptions) (tun.Tun, error) {
	fd := mobileTunFD.Swap(-1)
	if fd < 0 {
		return nil, errors.New("mobile TUN file descriptor is not set")
	}
	options.FileDescriptor = int(fd)
	return tun.New(*options)
}

func (mobilePlatform) UsePlatformDefaultInterfaceMonitor() bool { return false }
func (mobilePlatform) CreateDefaultInterfaceMonitor(logger.Logger) tun.DefaultInterfaceMonitor {
	return &mobileInterfaceMonitor{}
}
func (mobilePlatform) UsePlatformNetworkInterfaces() bool                     { return false }
func (mobilePlatform) NetworkInterfaces() ([]adapter.NetworkInterface, error) { return nil, nil }
func (mobilePlatform) UnderNetworkExtension() bool                            { return false }
func (mobilePlatform) NetworkExtensionIncludeAllNetworks() bool               { return false }
func (mobilePlatform) ClearDNSCache()                                         {}
func (mobilePlatform) RequestPermissionForWIFIState() error                   { return nil }
func (mobilePlatform) ReadWIFIState(context.Context) adapter.WIFIState { return adapter.WIFIState{} }
func (mobilePlatform) SystemCertificates() []string                           { return nil }
func (mobilePlatform) UsePlatformConnectionOwnerFinder() bool                 { return false }
func (mobilePlatform) FindConnectionOwner(*adapter.FindConnectionOwnerRequest) (*adapter.ConnectionOwner, error) {
	return nil, errors.New("Android connection owner lookup is unavailable")
}
func (mobilePlatform) UsePlatformWIFIMonitor() bool                 { return false }
func (mobilePlatform) UsePlatformNotification() bool                { return false }
func (mobilePlatform) SendNotification(*adapter.Notification) error { return nil }
func (mobilePlatform) MyInterfaceAddress() []netip.Addr             { return nil }

// sing-box 的桌面级平台能力在 Android/iOS 上不可用，这些实现只为满足 adapter.PlatformInterface。
func (mobilePlatform) ProcessPlatformOptions(option.TunPlatformOptions) error { return nil }
func (mobilePlatform) CancelNotification(string, int32) error                 { return nil }

func (mobilePlatform) UsePlatformNeighborResolver() bool { return false }
func (mobilePlatform) StartNeighborMonitor(adapter.NeighborUpdateListener) error {
	return errors.New("Android neighbor resolution is unavailable")
}
func (mobilePlatform) CloseNeighborMonitor(adapter.NeighborUpdateListener) error { return nil }

func (mobilePlatform) UsePlatformShell() bool    { return false }
func (mobilePlatform) CheckPlatformShell() error { return errors.New("platform shell is unavailable") }
func (mobilePlatform) OpenShellSession(*adapter.PlatformUser, string, []string, string, int32, int32) (adapter.ShellSession, error) {
	return nil, errors.New("platform shell is unavailable")
}
func (mobilePlatform) LookupUser(string) (*adapter.PlatformUser, error) {
	return nil, errors.New("platform user lookup is unavailable")
}
func (mobilePlatform) LookupSFTPServer() (string, error) { return "", errors.New("platform SFTP is unavailable") }
func (mobilePlatform) ReadSystemSSHHostKey() ([]byte, error) {
	return nil, errors.New("system SSH host key is unavailable")
}
func (mobilePlatform) TailscaleHostname() string { return "" }

func (mobilePlatform) UsePlatformBridge() bool { return false }
func (mobilePlatform) CreateBridge(adapter.BridgeOptions) (adapter.BridgeSession, error) {
	return nil, errors.New("platform bridge is unavailable")
}
var _ adapter.PlatformInterface = mobilePlatform{}

// Android 的活动网络由 VpnService 管理。GOOS=android 下 sing-tun 没有原生网络监视器，
// 但 sing-box 注册平台接口时要求监视器不能为空。
type mobileInterfaceMonitor struct{}

func (*mobileInterfaceMonitor) Start() error                         { return nil }
func (*mobileInterfaceMonitor) Close() error                         { return nil }
func (*mobileInterfaceMonitor) DefaultInterface() *control.Interface { return nil }
func (*mobileInterfaceMonitor) OverrideAndroidVPN() bool             { return false }
func (*mobileInterfaceMonitor) AndroidVPNEnabled() bool              { return true }
func (*mobileInterfaceMonitor) RegisterCallback(tun.DefaultInterfaceUpdateCallback) *list.Element[tun.DefaultInterfaceUpdateCallback] {
	return nil
}
func (*mobileInterfaceMonitor) UnregisterCallback(*list.Element[tun.DefaultInterfaceUpdateCallback]) {
}
func (*mobileInterfaceMonitor) RegisterMyInterface(string) {}
func (*mobileInterfaceMonitor) MyInterfaces() []string     { return nil }

var _ tun.DefaultInterfaceMonitor = (*mobileInterfaceMonitor)(nil)
