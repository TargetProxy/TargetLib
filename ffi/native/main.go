package main

/*
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef uint64_t targetlib_handle;

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
} targetlib_init_options;
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

	targetlibv1 "github.com/loafman1120/TargetLib/api/TargetLib/v1"
	"github.com/loafman1120/TargetLib/manager"
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

//export targetlib_version
func targetlib_version() *C.char { return C.CString(libbox.Version()) }

//export targetlib_go_version
func targetlib_go_version() *C.char { return C.CString(runtime.Version()) }

//export targetlib_free_string
func targetlib_free_string(ptr *C.char) {
	if ptr != nil {
		C.free(unsafe.Pointer(ptr))
	}
}

//export targetlib_init
func targetlib_init(raw *C.targetlib_init_options, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if raw == nil {
		return fail(errOut, "targetlib_init: nil options")
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

//export targetlib_check_config
func targetlib_check_config(configJSON *C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if configJSON == nil {
		return fail(errOut, "targetlib_check_config: nil config")
	}
	if err := libbox.CheckConfig(C.GoString(configJSON)); err != nil {
		return fail(errOut, err.Error())
	}
	return 0
}

//export targetlib_start
func targetlib_start(configJSON *C.char, out *C.targetlib_handle, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if out != nil {
		*out = 0
	}
	if configJSON == nil {
		return fail(errOut, "targetlib_start: nil config")
	}
	if out == nil {
		return fail(errOut, "targetlib_start: nil handle output")
	}
	config := C.GoString(configJSON)
	if config == "" {
		return fail(errOut, "targetlib_start: empty config")
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
	*out = C.targetlib_handle(handle)
	return 0
}

//export targetlib_reload
func targetlib_reload(handle C.targetlib_handle, configJSON *C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if configJSON == nil {
		return fail(errOut, "targetlib_reload: nil config")
	}
	service, ok := getService(uint64(handle))
	if !ok {
		return fail(errOut, "targetlib_reload: invalid handle")
	}
	if err := service.manager.ReloadConfig(C.GoString(configJSON)); err != nil {
		return fail(errOut, err.Error())
	}
	return 0
}

//export targetlib_stop
func targetlib_stop(handle C.targetlib_handle, errOut **C.char) C.int32_t {
	clearErr(errOut)
	service, ok := getService(uint64(handle))
	if !ok {
		return fail(errOut, "targetlib_stop: invalid handle")
	}
	if err := service.manager.StopService(); err != nil {
		return fail(errOut, err.Error())
	}
	return 0
}

//export targetlib_free_handle
func targetlib_free_handle(handle C.targetlib_handle) C.int32_t {
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

//export targetlib_service_state
func targetlib_service_state(handle C.targetlib_handle, jsonOut **C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if jsonOut == nil {
		return fail(errOut, "targetlib_service_state: nil output")
	}
	*jsonOut = nil
	service, ok := getService(uint64(handle))
	if !ok {
		return fail(errOut, "targetlib_service_state: invalid handle")
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

func nativeState(state *targetlibv1.ServiceState) serviceSnapshot {
	name := "unknown"
	switch state.GetState() {
	case targetlibv1.ServiceStateType_SERVICE_STATE_IDLE:
		name = "stopped"
	case targetlibv1.ServiceStateType_SERVICE_STATE_STARTING:
		name = "starting"
	case targetlibv1.ServiceStateType_SERVICE_STATE_RUNNING:
		name = "running"
	case targetlibv1.ServiceStateType_SERVICE_STATE_STOPPING:
		name = "stopping"
	case targetlibv1.ServiceStateType_SERVICE_STATE_FAILED:
		name = "failed"
	}
	return serviceSnapshot{
		State:     name,
		Running:   state.GetState() == targetlibv1.ServiceStateType_SERVICE_STATE_RUNNING,
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
