package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"sync"

	"github.com/kardianos/service"
	"github.com/loafman1120/TargetLib/manager"
	"github.com/loafman1120/TargetLib/subscriptions/keyringstore"
	"google.golang.org/grpc"
)

const serviceName = "TargetLib"

type commandOptions struct {
	basePath    string
	workingPath string
	tempPath    string
	locale      string
	logMaxLines int
	debug       bool
}

type program struct {
	options    manager.Options
	socketPath string
	logger     service.Logger

	mu     sync.Mutex
	server *manager.Server
}

func main() {
	action, options, err := parseCommandLine(os.Args[1:])
	if err != nil {
		if errors.Is(err, flag.ErrHelp) {
			return
		}
		fatal(err)
	}

	program := &program{
		options: manager.Options{
			BasePath:    options.basePath,
			WorkingPath: options.workingPath,
			TempPath:    options.tempPath,
			Locale:      options.locale,
			LogMaxLines: options.logMaxLines,
			Debug:       options.debug,
		},
		socketPath: filepath.Join(options.basePath, "command.sock"),
	}
	serviceConfig := &service.Config{
		Name:        serviceName,
		DisplayName: serviceName,
		Description: "TargetLib gRPC daemon for sing-box",
		Arguments:   serviceArguments(options),
		Option: service.KeyValue{
			"StartType":              "automatic",
			"OnFailure":              "restart",
			"OnFailureDelayDuration": "5s",
			"Restart":                "on-failure",
			"LimitNOFILE":            -1,
		},
	}
	svc, err := service.New(program, serviceConfig)
	if err != nil {
		fatal(err)
	}
	program.logger, _ = svc.Logger(nil)

	if action != "" {
		if err := control(svc, action); err != nil {
			fatal(err)
		}
		return
	}
	if err := svc.Run(); err != nil {
		fatal(err)
	}
}

func (p *program) Start(service.Service) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.server != nil {
		return nil
	}
	store, err := keyringstore.New(filepath.Join(p.options.BasePath, "subscriptions.badger"), "TargetLib")
	if err != nil {
		return err
	}
	options := p.options
	options.SubscriptionStore = store
	_, server, err := manager.NewLocal(context.Background(), options, p.socketPath)
	if err != nil {
		return err
	}
	p.server = server
	go func() {
		serveErr := server.Serve()
		if serveErr != nil && !errors.Is(serveErr, grpc.ErrServerStopped) && p.logger != nil {
			_ = p.logger.Errorf("gRPC server stopped: %v", serveErr)
		}
	}()
	return nil
}

func (p *program) Stop(service.Service) error {
	p.mu.Lock()
	server := p.server
	p.server = nil
	p.mu.Unlock()
	if server != nil {
		server.Close()
	}
	return nil
}

func (p *program) Shutdown(s service.Service) error {
	return p.Stop(s)
}

func parseCommandLine(arguments []string) (string, commandOptions, error) {
	var action string
	if len(arguments) > 0 && isServiceAction(arguments[0]) {
		action = arguments[0]
		arguments = arguments[1:]
	}

	flags := flag.NewFlagSet(serviceName, flag.ContinueOnError)
	basePath := flags.String("base-path", ".", "runtime base directory")
	workingPath := flags.String("working-path", "", "sing-box working directory")
	tempPath := flags.String("temp-path", "", "sing-box temporary directory")
	locale := flags.String("locale", "", "locale identifier")
	logMaxLines := flags.Int("log-max-lines", 300, "number of retained log lines")
	debugMode := flags.Bool("debug", false, "enable debug mode")
	if err := flags.Parse(arguments); err != nil {
		return "", commandOptions{}, err
	}
	if flags.NArg() != 0 {
		return "", commandOptions{}, fmt.Errorf("unknown command: %s", flags.Arg(0))
	}
	absBasePath, err := filepath.Abs(*basePath)
	if err != nil {
		return "", commandOptions{}, err
	}
	return action, commandOptions{
		basePath:    absBasePath,
		workingPath: *workingPath,
		tempPath:    *tempPath,
		locale:      *locale,
		logMaxLines: *logMaxLines,
		debug:       *debugMode,
	}, nil
}

func isServiceAction(value string) bool {
	for _, action := range append(service.ControlAction[:], "status") {
		if value == action {
			return true
		}
	}
	return false
}

func serviceArguments(options commandOptions) []string {
	arguments := []string{
		"--base-path", options.basePath,
		"--log-max-lines", strconv.Itoa(options.logMaxLines),
	}
	if options.workingPath != "" {
		arguments = append(arguments, "--working-path", options.workingPath)
	}
	if options.tempPath != "" {
		arguments = append(arguments, "--temp-path", options.tempPath)
	}
	if options.locale != "" {
		arguments = append(arguments, "--locale", options.locale)
	}
	if options.debug {
		arguments = append(arguments, "--debug")
	}
	return arguments
}

func control(svc service.Service, action string) error {
	if action != "status" {
		return service.Control(svc, action)
	}
	status, err := svc.Status()
	if err != nil {
		return err
	}
	switch status {
	case service.StatusRunning:
		fmt.Println("running")
	case service.StatusStopped:
		fmt.Println("stopped")
	default:
		fmt.Println("unknown")
	}
	return nil
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
