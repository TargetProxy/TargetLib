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
	const char *command_secret;
	int32_t command_port;
	int32_t log_max_lines;
	bool debug;
	bool oom_killer_enabled;
	bool oom_killer_disabled;
	int64_t oom_memory_limit;
} libbox_init_options;
*/
import "C"

import (
	"encoding/json"
	"unsafe"
)

func main() {}

//export libbox_version
func libbox_version() *C.char {
	return C.CString(libboxVersion())
}

//export libbox_go_version
func libbox_go_version() *C.char {
	return C.CString(libboxGoVersion())
}

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
		setErr(errOut, "libbox_init: nil options")
		return -1
	}
	opts := fromInitOptions(raw)
	err := setupLibbox(opts)
	if err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	setCurrentInitOptions(opts)
	return 0
}

//export libbox_check_config
func libbox_check_config(configJSON *C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if configJSON == nil {
		setErr(errOut, "libbox_check_config: nil config")
		return -1
	}
	if err := checkLibboxConfig(C.GoString(configJSON)); err != nil {
		setErr(errOut, err.Error())
		return -1
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
		setErr(errOut, "libbox_start: nil config")
		return -1
	}
	if out == nil {
		setErr(errOut, "libbox_start: nil handle output")
		return -1
	}
	config := C.GoString(configJSON)
	if config == "" {
		setErr(errOut, "libbox_start: empty config")
		return -1
	}
	service, controller := newDesktopStartedService()
	if err := service.StartOrReloadService(config); err != nil {
		service.Close()
		setErr(errOut, err.Error())
		return -1
	}
	runtime := newRuntimeHandle(service)
	runtime.setConfig(config)
	if controller != nil {
		controller.bind(runtime)
	}
	handle := nextHandle.Add(1)
	handlesMu.Lock()
	handles[handle] = runtime
	handlesMu.Unlock()
	*out = C.libbox_handle(handle)
	return 0
}

//export libbox_reload
func libbox_reload(handle C.libbox_handle, configJSON *C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if configJSON == nil {
		setErr(errOut, "libbox_reload: nil config")
		return -1
	}
	runtime, ok := getHandle(uint64(handle))
	if !ok {
		setErr(errOut, "libbox_reload: invalid handle")
		return -1
	}
	if err := runtime.reload(C.GoString(configJSON)); err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	return 0
}

//export libbox_stop
func libbox_stop(handle C.libbox_handle, errOut **C.char) C.int32_t {
	clearErr(errOut)
	runtime, ok := getHandle(uint64(handle))
	if !ok {
		setErr(errOut, "libbox_stop: invalid handle")
		return -1
	}
	if err := runtime.stop(); err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	return 0
}

//export libbox_free_handle
func libbox_free_handle(handle C.libbox_handle) C.int32_t {
	handlesMu.Lock()
	runtime, ok := handles[uint64(handle)]
	if ok {
		delete(handles, uint64(handle))
	}
	handlesMu.Unlock()
	if !ok {
		return -1
	}
	runtime.close()
	return 0
}

//export libbox_service_state
func libbox_service_state(handle C.libbox_handle, jsonOut **C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if jsonOut == nil {
		setErr(errOut, "libbox_service_state: nil output")
		return -1
	}
	*jsonOut = nil
	runtime, ok := getHandle(uint64(handle))
	if !ok {
		setErr(errOut, "libbox_service_state: invalid handle")
		return -1
	}
	payload, err := json.Marshal(runtime.snapshot())
	if err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	*jsonOut = C.CString(string(payload))
	return 0
}

//export libbox_system_proxy_status
func libbox_system_proxy_status(jsonOut **C.char, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if jsonOut == nil {
		setErr(errOut, "libbox_system_proxy_status: nil output")
		return -1
	}
	*jsonOut = nil
	status, err := systemProxyStatus()
	if err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	payload, err := json.Marshal(status)
	if err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	*jsonOut = C.CString(string(payload))
	return 0
}

//export libbox_set_system_proxy
func libbox_set_system_proxy(host *C.char, port C.int32_t, bypass *C.char, enabled C.bool, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if err := setSystemProxy(bool(enabled), C.GoString(host), int32(port), C.GoString(bypass)); err != nil {
		setErr(errOut, err.Error())
		return -1
	}
	return 0
}

func fromInitOptions(raw *C.libbox_init_options) initOptions {
	return initOptions{
		basePath:          cstr(raw.base_path),
		workingPath:       cstr(raw.working_path),
		tempPath:          cstr(raw.temp_path),
		locale:            cstr(raw.locale),
		commandSecret:     cstr(raw.command_secret),
		commandPort:       int32(raw.command_port),
		logMaxLines:       int32(raw.log_max_lines),
		debug:             bool(raw.debug),
		oomKillerEnabled:  bool(raw.oom_killer_enabled),
		oomKillerDisabled: bool(raw.oom_killer_disabled),
		oomMemoryLimit:    int64(raw.oom_memory_limit),
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

func setErr(errOut **C.char, message string) {
	if errOut != nil {
		*errOut = C.CString(message)
	}
}
