//go:build windows

package desktop

func newDesktopPlatform() *DesktopPlatform {
	return &DesktopPlatform{target: desktopTargetWindows}
}
