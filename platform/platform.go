package platform

import (
	"github.com/loafman1120/libbox/platform/desktop"
	"github.com/loafman1120/libbox/platform/systemproxy"
)

// DesktopPlatform is the desktop implementation of libbox.PlatformInterface.
type DesktopPlatform = desktop.DesktopPlatform

// Desktop is kept as a source-compatible name for callers using the old API.
type Desktop = desktop.DesktopPlatform

// SystemProxyStatus describes the current operating system proxy state.
type SystemProxyStatus = systemproxy.Status

func New() *DesktopPlatform {
	return desktop.New()
}

func GetSystemProxyStatus() (SystemProxyStatus, error) {
	return systemproxy.GetStatus()
}

func SetSystemProxy(enabled bool, host string, port int32, bypass string) error {
	return systemproxy.Set(enabled, host, port, bypass)
}
