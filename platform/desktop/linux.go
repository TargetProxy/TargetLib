//go:build linux

package desktop

func newDesktopPlatform() *DesktopPlatform {
	return &DesktopPlatform{target: desktopTargetLinux}
}
