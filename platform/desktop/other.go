//go:build !windows && !darwin && !linux

package desktop

func newDesktopPlatform() *DesktopPlatform {
	return &DesktopPlatform{target: desktopTargetOther}
}
