package main

import (
	"errors"

	"github.com/loafman1120/libbox/platform"
	"github.com/sagernet/sing-box/experimental/libbox"
)

// newDesktopStartedService is the only place where the FFI runtime binds to
// experimental/libbox and the desktop platform implementation.
func newDesktopStartedService() (serviceAdapter, *serviceController) {
	controller := new(serviceController)
	server, err := libbox.NewCommandServer(&desktopCommandHandler{controller: controller}, platform.New())
	if err != nil {
		return &failedService{err: err}, nil
	}
	if err := server.Start(); err != nil {
		server.Close()
		return &failedService{err: err}, nil
	}
	return &libboxService{server: server}, controller
}

func libboxVersion() string   { return libbox.Version() }
func libboxGoVersion() string { return libbox.GoVersion() }

func setupLibbox(options initOptions) error {
	if options.locale != "" {
		if err := libbox.SetLocale(options.locale); err != nil {
			return err
		}
	}
	return libbox.Setup(&libbox.SetupOptions{
		BasePath:                options.basePath,
		WorkingPath:             options.workingPath,
		TempPath:                options.tempPath,
		CommandServerListenPort: options.commandPort,
		CommandServerSecret:     options.commandSecret,
		LogMaxLines:             int(options.logMaxLines),
		Debug:                   options.debug,
		CrashReportSource:       "libbox",
		OomKillerEnabled:        options.oomKillerEnabled,
		OomKillerDisabled:       options.oomKillerDisabled,
		OomMemoryLimit:          options.oomMemoryLimit,
	})
}

func checkLibboxConfig(config string) error { return libbox.CheckConfig(config) }

func systemProxyStatus() (platform.SystemProxyStatus, error) {
	return platform.GetSystemProxyStatus()
}

func setSystemProxy(enabled bool, host string, port int32, bypass string) error {
	return platform.SetSystemProxy(enabled, host, port, bypass)
}

type libboxService struct{ server *libbox.CommandServer }

func (s *libboxService) StartOrReloadService(config string) error {
	return s.server.StartOrReloadService(config, &libbox.OverrideOptions{})
}
func (s *libboxService) CloseService() error { return s.server.CloseService() }
func (s *libboxService) Close()              { s.server.Close() }

type failedService struct{ err error }

func (s *failedService) StartOrReloadService(string) error { return s.err }
func (s *failedService) CloseService() error               { return s.err }
func (s *failedService) Close()                            {}

// desktopCommandHandler is the small command surface exposed by libbox to
// the desktop host. Lifecycle operations delegate to the shared controller.
type desktopCommandHandler struct {
	controller *serviceController
}

func (h *desktopCommandHandler) ServiceStop() error {
	return h.controller.ServiceStop()
}
func (h *desktopCommandHandler) ServiceReload() error {
	return h.controller.ServiceReload()
}
func (*desktopCommandHandler) GetSystemProxyStatus() (*libbox.SystemProxyStatus, error) {
	status, err := platform.GetSystemProxyStatus()
	if err != nil {
		return nil, err
	}
	return &libbox.SystemProxyStatus{Available: status.Supported, Enabled: status.Enabled}, nil
}
func (*desktopCommandHandler) SetSystemProxyEnabled(enabled bool) error {
	return platform.SetSystemProxy(enabled, "127.0.0.1", 2080, "<local>")
}
func (*desktopCommandHandler) TriggerNativeCrash() error { return errors.New("native crash disabled") }
func (*desktopCommandHandler) WriteDebugMessage(string)  {}
func (*desktopCommandHandler) ConnectSSHAgent() (int32, error) {
	return 0, errors.New("ssh agent is not implemented by libbox")
}
