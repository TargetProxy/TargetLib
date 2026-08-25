//go:build android || ios

package manager

import (
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
func (mobilePlatform) ReadWIFIState() adapter.WIFIState                       { return adapter.WIFIState{} }
func (mobilePlatform) SystemCertificates() []string                           { return nil }
func (mobilePlatform) UsePlatformConnectionOwnerFinder() bool                 { return false }
func (mobilePlatform) FindConnectionOwner(*adapter.FindConnectionOwnerRequest) (*adapter.ConnectionOwner, error) {
	return nil, errors.New("Android connection owner lookup is unavailable")
}
func (mobilePlatform) UsePlatformWIFIMonitor() bool                 { return false }
func (mobilePlatform) UsePlatformNotification() bool                { return false }
func (mobilePlatform) SendNotification(*adapter.Notification) error { return nil }
func (mobilePlatform) MyInterfaceAddress() []netip.Addr             { return nil }

var _ adapter.PlatformInterface = mobilePlatform{}

// Android's active network is managed by VpnService. sing-tun has no native
// network monitor for GOOS=android, but sing-box requires a non-nil monitor
// whenever a platform interface is registered.
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
