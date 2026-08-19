package main

import (
	"errors"
	"sync"
)

// serviceAdapter is the only runtime dependency on the native service API.
// Keeping this boundary small lets the ABI/runtime stay independent of
// sing-box implementation details while the libbox adapter evolves.
type serviceAdapter interface {
	StartOrReloadService(config string) error
	CloseService() error
	Close()
}

// serviceController is shared by the FFI entry points and libbox's
// ManagedService callbacks. Both paths therefore use the same runtime state
// and service lock.
type serviceController struct {
	runtimeMu sync.RWMutex
	runtime   *runtimeHandle
}

func (c *serviceController) bind(runtime *runtimeHandle) {
	c.runtimeMu.Lock()
	c.runtime = runtime
	c.runtimeMu.Unlock()
}

func (c *serviceController) get() (*runtimeHandle, error) {
	c.runtimeMu.RLock()
	runtime := c.runtime
	c.runtimeMu.RUnlock()
	if runtime == nil {
		return nil, errors.New("libbox: service is not ready")
	}
	return runtime, nil
}

func (c *serviceController) ServiceStop() error {
	runtime, err := c.get()
	if err != nil {
		return err
	}
	return runtime.stop()
}

func (c *serviceController) ServiceReload() error {
	runtime, err := c.get()
	if err != nil {
		return err
	}
	return runtime.reloadCurrent()
}
