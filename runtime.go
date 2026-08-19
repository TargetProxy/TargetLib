package main

import (
	"errors"
	"sync"
	"sync/atomic"
)

type initOptions struct {
	basePath          string
	workingPath       string
	tempPath          string
	locale            string
	commandSecret     string
	commandPort       int32
	logMaxLines       int32
	debug             bool
	oomKillerEnabled  bool
	oomKillerDisabled bool
	oomMemoryLimit    int64
}

var (
	initOptionsMu sync.RWMutex
	currentInit   initOptions
)

func setCurrentInitOptions(options initOptions) {
	initOptionsMu.Lock()
	currentInit = options
	initOptionsMu.Unlock()
}

func getCurrentInitOptions() initOptions {
	initOptionsMu.RLock()
	defer initOptionsMu.RUnlock()
	return currentInit
}

type runtimeHandle struct {
	service   serviceAdapter
	stateMu   sync.RWMutex
	serviceMu sync.Mutex
	nowState  serviceState
	lastError string
	config    string
}

func (h *runtimeHandle) withService(fn func(serviceAdapter) error) error {
	h.serviceMu.Lock()
	defer h.serviceMu.Unlock()
	return fn(h.service)
}

type serviceState string

const (
	serviceStateRunning serviceState = "running"
	serviceStateStopped serviceState = "stopped"
	serviceStateClosed  serviceState = "closed"
)

type serviceSnapshot struct {
	State     serviceState `json:"state"`
	Running   bool         `json:"running"`
	Closed    bool         `json:"closed"`
	LastError string       `json:"lastError,omitempty"`
}

var (
	nextHandle atomic.Uint64
	handlesMu  sync.Mutex
	handles    = map[uint64]*runtimeHandle{}
)

func newRuntimeHandle(service serviceAdapter) *runtimeHandle {
	return &runtimeHandle{
		service:  service,
		nowState: serviceStateRunning,
	}
}

func (h *runtimeHandle) setConfig(config string) {
	h.stateMu.Lock()
	h.config = config
	h.stateMu.Unlock()
}

func (h *runtimeHandle) currentConfig() string {
	h.stateMu.RLock()
	defer h.stateMu.RUnlock()
	return h.config
}

func (h *runtimeHandle) reload(config string) error {
	if config == "" {
		return errors.New("libbox: config is empty")
	}
	if h.state() == serviceStateClosed {
		return errors.New("libbox: service is closed")
	}
	err := h.withService(func(service serviceAdapter) error {
		if h.state() == serviceStateClosed {
			return errors.New("libbox: service is closed")
		}
		return service.StartOrReloadService(config)
	})
	if err != nil {
		h.setLastError(err.Error())
		return err
	}
	h.stateMu.Lock()
	h.config = config
	h.nowState = serviceStateRunning
	h.stateMu.Unlock()
	return nil
}

func (h *runtimeHandle) reloadCurrent() error {
	return h.reload(h.currentConfig())
}

func (h *runtimeHandle) stop() error {
	state := h.state()
	if state == serviceStateClosed {
		return errors.New("libbox: service is closed")
	}
	if state == serviceStateStopped {
		return nil
	}
	err := h.withService(func(service serviceAdapter) error {
		if h.state() == serviceStateClosed {
			return errors.New("libbox: service is closed")
		}
		return service.CloseService()
	})
	if err != nil {
		h.setLastError(err.Error())
		return err
	}
	h.setState(serviceStateStopped)
	return nil
}

func getHandle(handle uint64) (*runtimeHandle, bool) {
	handlesMu.Lock()
	defer handlesMu.Unlock()
	runtime, ok := handles[handle]
	return runtime, ok
}

func (h *runtimeHandle) close() {
	_ = h.withService(func(service serviceAdapter) error {
		service.Close()
		h.setState(serviceStateClosed)
		return nil
	})
}

func (h *runtimeHandle) state() serviceState {
	h.stateMu.RLock()
	defer h.stateMu.RUnlock()
	return h.nowState
}

func (h *runtimeHandle) setState(state serviceState) {
	h.stateMu.Lock()
	h.nowState = state
	h.stateMu.Unlock()
}

func (h *runtimeHandle) setLastError(message string) {
	h.stateMu.Lock()
	h.lastError = message
	h.stateMu.Unlock()
}

func (h *runtimeHandle) snapshot() serviceSnapshot {
	h.stateMu.RLock()
	defer h.stateMu.RUnlock()
	return serviceSnapshot{
		State:     h.nowState,
		Running:   h.nowState == serviceStateRunning,
		Closed:    h.nowState == serviceStateClosed,
		LastError: h.lastError,
	}
}
