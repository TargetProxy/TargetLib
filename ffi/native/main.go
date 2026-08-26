package main

/*
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

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
	"runtime"
	"sync"
	"unsafe"

	libbox "github.com/sagernet/sing-box/experimental/libbox"

	"github.com/loafman1120/TargetLib/config"
	"github.com/loafman1120/TargetLib/manager"
)

var (
	serviceMu    sync.Mutex
	activeServer *manager.Server
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

//export targetlib_start
func targetlib_start(raw *C.targetlib_init_options, errOut **C.char) C.int32_t {
	clearErr(errOut)
	if raw == nil {
		return fail(errOut, "targetlib_start: nil options")
	}
	serviceMu.Lock()
	defer serviceMu.Unlock()
	if activeServer != nil {
		return fail(errOut, "targetlib_start: service is already running")
	}
	options := manager.Options{
		BasePath:    cstr(raw.base_path),
		WorkingPath: cstr(raw.working_path),
		TempPath:    cstr(raw.temp_path),
		Locale:      cstr(raw.locale),
		LogMaxLines: int(raw.log_max_lines),
		Debug:       bool(raw.debug),
		OOMKiller:   bool(raw.oom_killer_enabled) && !bool(raw.oom_killer_disabled),
	}
	_, server, err := manager.NewLocal(context.Background(), options)
	if err != nil {
		return fail(errOut, err.Error())
	}
	activeServer = server
	go serve(server)
	return 0
}

//export targetlib_tun_ipv4_address
func targetlib_tun_ipv4_address() *C.char { return C.CString(config.TunIPv4Address()) }

//export targetlib_tun_ipv4_prefix_bits
func targetlib_tun_ipv4_prefix_bits() C.int32_t { return C.int32_t(config.TunIPv4PrefixBits()) }

//export targetlib_set_tun_fd
func targetlib_set_tun_fd(fd C.int32_t) C.int32_t {
	if err := manager.SetTunFD(int32(fd)); err != nil {
		return -1
	}
	return 0
}

//export targetlib_stop
func targetlib_stop(errOut **C.char) C.int32_t {
	clearErr(errOut)
	serviceMu.Lock()
	server := activeServer
	activeServer = nil
	serviceMu.Unlock()
	if server == nil {
		return 0
	}
	server.Close()
	return 0
}

func serve(server *manager.Server) {
	_ = server.Serve()
	serviceMu.Lock()
	if activeServer == server {
		activeServer = nil
	}
	serviceMu.Unlock()
	server.Close()
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
