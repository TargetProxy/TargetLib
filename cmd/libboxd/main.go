package main

import (
	"context"
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

func main() {
	basePath := flag.String("base-path", ".", "runtime base directory")
	workingPath := flag.String("working-path", "", "sing-box working directory")
	tempPath := flag.String("temp-path", "", "sing-box temporary directory")
	locale := flag.String("locale", "", "locale identifier")
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
