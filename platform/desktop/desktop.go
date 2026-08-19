package desktop

import (
	"errors"

	"github.com/sagernet/sing-box/experimental/libbox"
)

// DesktopPlatform is the common PlatformInterface boundary for desktop
// targets. OS-specific construction lives in the corresponding platform file;
// new native capabilities should be added there and delegated from this type.
//
// The type deliberately does not embed libbox.PlatformInterface. Embedding an
// uninitialised interface makes missing methods compile and turns them into
// runtime nil-interface panics.
type DesktopPlatform struct {
	target desktopTarget
}

// Desktop is kept as a source-compatible name for callers using the old API.
type Desktop = DesktopPlatform

var _ libbox.PlatformInterface = (*DesktopPlatform)(nil)

func New() *DesktopPlatform { return newDesktopPlatform() }

func (*DesktopPlatform) LocalDNSTransport() libbox.LocalDNSTransport { return nil }

func (*DesktopPlatform) UsePlatformAutoDetectInterfaceControl() bool { return false }
func (*DesktopPlatform) AutoDetectInterfaceControl(int32) error {
	return unsupported("interface control")
}
func (*DesktopPlatform) OpenTun(libbox.TunOptions) (int32, error) {
	return -1, unsupported("TUN")
}
func (*DesktopPlatform) UseProcFS() bool { return false }
func (*DesktopPlatform) FindConnectionOwner(int32, string, int32, string, int32) (*libbox.ConnectionOwner, error) {
	return nil, unsupported("connection owner lookup")
}

// Interface discovery and change notifications are intentionally left as
// no-ops until each desktop backend supplies its native implementation.
func (*DesktopPlatform) StartDefaultInterfaceMonitor(libbox.InterfaceUpdateListener) error {
	return nil
}
func (*DesktopPlatform) CloseDefaultInterfaceMonitor(libbox.InterfaceUpdateListener) error {
	return nil
}
func (*DesktopPlatform) GetInterfaces() (libbox.NetworkInterfaceIterator, error) {
	return nil, nil
}

func (*DesktopPlatform) UnderNetworkExtension() bool { return false }
func (*DesktopPlatform) IncludeAllNetworks() bool    { return false }
func (*DesktopPlatform) ReadWIFIState() *libbox.WIFIState {
	return nil
}
func (*DesktopPlatform) ClearDNSCache() {}
func (*DesktopPlatform) SendNotification(*libbox.Notification) error {
	return nil
}
func (*DesktopPlatform) CancelNotification(string, int32) error {
	return nil
}
func (*DesktopPlatform) StartNeighborMonitor(libbox.NeighborUpdateListener) error {
	return nil
}
func (*DesktopPlatform) CloseNeighborMonitor(libbox.NeighborUpdateListener) error {
	return nil
}
func (*DesktopPlatform) RegisterMyInterface(string) {}

func (*DesktopPlatform) UsePlatformShell() bool { return false }
func (*DesktopPlatform) CheckPlatformShell() error {
	return unsupported("platform shell")
}
func (*DesktopPlatform) OpenShellSession(*libbox.PlatformUser, string, libbox.StringIterator, string, int32, int32) (libbox.ShellSession, error) {
	return nil, unsupported("platform shell")
}
func (*DesktopPlatform) LookupUser(string) (*libbox.PlatformUser, error) {
	return nil, unsupported("user lookup")
}
func (*DesktopPlatform) LookupSFTPServer() (string, error) {
	return "", unsupported("SFTP")
}
func (*DesktopPlatform) ReadSystemSSHHostKey() (string, error) {
	return "", unsupported("SSH host key")
}
func (*DesktopPlatform) TailscaleHostname() string { return "" }

func (*DesktopPlatform) UsePlatformBridge() bool { return false }
func (*DesktopPlatform) CreateBridge(*libbox.BridgeOptions) (libbox.BridgeSession, error) {
	return nil, unsupported("platform bridge")
}

type desktopTarget string

const (
	desktopTargetWindows desktopTarget = "windows"
	desktopTargetDarwin  desktopTarget = "darwin"
	desktopTargetLinux   desktopTarget = "linux"
	desktopTargetOther   desktopTarget = "other"
)

func unsupported(name string) error {
	return errors.New("libbox: " + name + " is unsupported")
}
