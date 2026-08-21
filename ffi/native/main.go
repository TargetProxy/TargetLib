package main

/*
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef uint64_t libbox_handle;

typedef struct {
	const char *base_path;
	const char *working_path;
	const char *temp_path;
	const char *locale;
	int32_t log_max_lines;
	bool debug;
	bool oom_killer_enabled;
	bool oom_killer_disabled;
	int64_t oom_memory_limit;
} libbox_init_options;
*/
import "C"

import (
	"context"
	"encoding/json"
	"path/filepath"
	"runtime"
	"sync"
	"sync/atomic"
	"unsafe"

	libbox "github.com/sagernet/sing-box/experimental/libbox"

	libboxv1 "github.com/loafman1120/libbox/api/libbox/v1"
	"github.com/loafman1120/libbox/manager"
)

type initOptions struct {
	manager.Options
}

type nativeService struct {
	manager *manager.Manager
	server  *manager.Server
}

var (
	optionsMu   sync.RWMutex
	currentInit initOptions
	nextHandle  atomic.Uint64
	servicesMu  sync.RWMutex
	services    = make(map[uint64]*nativeService)
)

func main() {}

//export libbox_version
func libbox_version() *C.char { return C.CString(libbox.Version()) }

//export libbox_go_version
func libbox_go_version() *C.char { return C.CString(runtime.Version()) }

//export libbox_free_string
func libbox_free_string(ptr *C.char) {
	if ptr != nil {
		C.free(unsafe.Pointer(ptr))
	}
}

//export libbox_init
func libbox_init(raw *C.libbox_init_options, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if raw == nil {
		return fail(errOut, "libbox_init: nil options")
	}
	options := initOptions{
		Options: manager.Options{
			BasePath:    cstr(raw.base_path),
			WorkingPath: cstr(raw.working_path),
			TempPath:    cstr(raw.temp_path),
			Locale:      cstr(raw.locale),
			LogMaxLines: int(raw.log_max_lines),
			Debug:       bool(raw.debug),
			OOMKiller:   bool(raw.oom_killer_enabled) && !bool(raw.oom_killer_disabled),
		},
	}
	if err := manager.Setup(options.Options); err != nil {
		return fail(errOut, err.Error())
	}
	optionsMu.Lock()
	currentInit = options
	optionsMu.Unlock()
	return 0
}

//export libbox_check_config
func libbox_check_config(configJSON *C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if configJSON == nil {
		return fail(errOut, "libbox_check_config: nil config")
	}
	if err := libbox.CheckConfig(C.GoString(configJSON)); err != nil {
		return fail(errOut, err.Error())
	}
	return 0
}

//export libbox_start
func libbox_start(configJSON *C.char, out *C.libbox_handle, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if out != nil {
		*out = 0
	}
	if configJSON == nil {
		return fail(errOut, "libbox_start: nil config")
	}
	if out == nil {
		return fail(errOut, "libbox_start: nil handle output")
	}
	config := C.GoString(configJSON)
	if config == "" {
		return fail(errOut, "libbox_start: empty config")
	}

	optionsMu.RLock()
	options := currentInit
	optionsMu.RUnlock()
	serviceManager, server, err := manager.NewLocal(
		context.Background(), options.Options, filepath.Join(options.BasePath, "command.sock"),
	)
	if err != nil {
		return fail(errOut, err.Error())
	}
	if err := serviceManager.StartConfig(config); err != nil {
		server.Close()
		return fail(errOut, err.Error())
	}
	go func() { _ = server.Serve() }()

	handle := nextHandle.Add(1)
	servicesMu.Lock()
	services[handle] = &nativeService{manager: serviceManager, server: server}
	servicesMu.Unlock()
	*out = C.libbox_handle(handle)
	return 0
}

//export libbox_reload
func libbox_reload(handle C.libbox_handle, configJSON *C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if configJSON == nil {
		return fail(errOut, "libbox_reload: nil config")
	}
	service, ok := getService(uint64(handle))
	if !ok {
		return fail(errOut, "libbox_reload: invalid handle")
	}
	if err := service.manager.ReloadConfig(C.GoString(configJSON)); err != nil {
		return fail(errOut, err.Error())
	}
	return 0
}

//export libbox_stop
func libbox_stop(handle C.libbox_handle, errOut **C.char) C.int32_t {
	clearErr(errOut)
	service, ok := getService(uint64(handle))
	if !ok {
		return fail(errOut, "libbox_stop: invalid handle")
	}
	if err := service.manager.StopService(); err != nil {
		return fail(errOut, err.Error())
	}
	return 0
}

//export libbox_free_handle
func libbox_free_handle(handle C.libbox_handle) C.int32_t {
	servicesMu.Lock()
	service, ok := services[uint64(handle)]
	if ok {
		delete(services, uint64(handle))
	}
	servicesMu.Unlock()
	if !ok {
		return -1
	}
	service.server.Close()
	return 0
}

//export libbox_service_state
func libbox_service_state(handle C.libbox_handle, jsonOut **C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if jsonOut == nil {
		return fail(errOut, "libbox_service_state: nil output")
	}
	*jsonOut = nil
	service, ok := getService(uint64(handle))
	if !ok {
		return fail(errOut, "libbox_service_state: invalid handle")
	}
	state, err := service.manager.State()
	if err != nil {
		return fail(errOut, err.Error())
	}
	payload, err := json.Marshal(nativeState(state))
	if err != nil {
		return fail(errOut, err.Error())
	}
	*jsonOut = C.CString(string(payload))
	return 0
}

func getService(handle uint64) (*nativeService, bool) {
	servicesMu.RLock()
	service, ok := services[handle]
	servicesMu.RUnlock()
	return service, ok
}

type serviceSnapshot struct {
	State     string `json:"state"`
	Running   bool   `json:"running"`
	Closed    bool   `json:"closed"`
	LastError string `json:"lastError,omitempty"`
}

func nativeState(state *libboxv1.ServiceState) serviceSnapshot {
	name := "unknown"
	switch state.GetState() {
	case libboxv1.ServiceStateType_SERVICE_STATE_IDLE:
		name = "stopped"
	case libboxv1.ServiceStateType_SERVICE_STATE_STARTING:
		name = "starting"
	case libboxv1.ServiceStateType_SERVICE_STATE_RUNNING:
		name = "running"
	case libboxv1.ServiceStateType_SERVICE_STATE_STOPPING:
		name = "stopping"
	case libboxv1.ServiceStateType_SERVICE_STATE_FAILED:
		name = "failed"
	}
	return serviceSnapshot{
		State:     name,
		Running:   state.GetState() == libboxv1.ServiceStateType_SERVICE_STATE_RUNNING,
		LastError: state.GetErrorMessage(),
	}
}

func cstr(value *C.char) string {
	if value == nil {
		return ""
	}
	return C.GoString(value)
}

func clearErr(errOut **C.char) {
	if errOut != nil {
		*errOut = nil
	}
}

func fail(errOut **C.char, message string) C.int32_t {
	if errOut != nil {
		*errOut = C.CString(message)
	}
	return -1
}
