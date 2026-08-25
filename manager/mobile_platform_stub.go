//go:build !android && !ios

package manager

import "github.com/sagernet/sing-box/adapter"

func SetTunFD(int32) error { return nil }

func newPlatformInterface() adapter.PlatformInterface { return nil }
