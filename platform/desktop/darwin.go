//go:build darwin

package desktop

func newDesktopPlatform() *DesktopPlatform {
	return &DesktopPlatform{target: desktopTargetDarwin}
}
