package platform

import (
	"github.com/loafman1120/libbox/platform/systemproxy"
)

// SystemProxyStatus describes the current operating system proxy state.
type SystemProxyStatus = systemproxy.Status

func GetSystemProxyStatus() (SystemProxyStatus, error) {
	return systemproxy.GetStatus()
}

func SetSystemProxy(enabled bool, host string, port int32, bypass string) error {
	return systemproxy.Set(enabled, host, port, bypass)
}
