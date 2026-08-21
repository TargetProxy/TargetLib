package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"

	"github.com/loafman1120/libbox/manager"
	"google.golang.org/grpc"
)

type endpointInfo struct {
	Network string `json:"network"`
	Address string `json:"address"`
}

func main() {
	basePath := flag.String("base-path", ".", "runtime base directory")
	workingPath := flag.String("working-path", "", "sing-box working directory")
	tempPath := flag.String("temp-path", "", "sing-box temporary directory")
	locale := flag.String("locale", "", "locale identifier")
	endpointFile := flag.String("endpoint-file", "", "write endpoint JSON to this file")
	logMaxLines := flag.Int("log-max-lines", 300, "number of retained log lines")
	debugMode := flag.Bool("debug", false, "enable debug mode")
	flag.Parse()

	absBasePath, err := filepath.Abs(*basePath)
	if err != nil {
		fatal(err)
	}
	_, server, err := manager.NewLocal(context.Background(), manager.Options{
		BasePath:    absBasePath,
		WorkingPath: *workingPath,
		TempPath:    *tempPath,
		Locale:      *locale,
		LogMaxLines: *logMaxLines,
		Debug:       *debugMode,
	}, filepath.Join(absBasePath, "command.sock"))
	if err != nil {
		fatal(err)
	}
	defer server.Close()

	info := endpointInfo{Network: server.Network(), Address: server.Endpoint()}
	payload, err := json.Marshal(info)
	if err != nil {
		fatal(err)
	}
	if *endpointFile != "" {
		if err := os.MkdirAll(filepath.Dir(*endpointFile), 0o700); err != nil {
			fatal(err)
		}
		if err := os.WriteFile(*endpointFile, payload, 0o600); err != nil {
			fatal(err)
		}
		defer os.Remove(*endpointFile)
	}
	fmt.Println(string(payload))

	serveError := make(chan error, 1)
	go func() { serveError <- server.Serve() }()
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, os.Interrupt, syscall.SIGTERM)
	select {
	case <-signals:
	case err := <-serveError:
		if err != nil && !errors.Is(err, grpc.ErrServerStopped) {
			fatal(err)
		}
	}
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
