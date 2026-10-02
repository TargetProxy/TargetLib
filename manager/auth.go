package manager

import (
	"context"
	"crypto/rand"
	"crypto/subtle"
	"encoding/base64"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	boxlog "github.com/sagernet/sing-box/log"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

const controlTokenFile = "control.token"

func validateToken(token string) (string, error) {
	token = strings.TrimSpace(token)
	if len(token) < 32 || len(token) > 512 {
		return "", fmt.Errorf("control token must be 32-512 bytes")
	}
	return token, nil
}

func loadControlToken(basePath, supplied string) (string, error) {
	if supplied != "" {
		return validateToken(supplied)
	}
	basePath = strings.TrimSpace(basePath)
	if basePath == "" {
		return "", fmt.Errorf("base path is required to store the control token")
	}
	if err := os.MkdirAll(basePath, 0o700); err != nil {
		return "", fmt.Errorf("create control token directory: %w", err)
	}

	tokenPath := filepath.Join(basePath, controlTokenFile)
	if content, err := os.ReadFile(tokenPath); err == nil {
		_ = os.Chmod(tokenPath, 0o600)
		return validateToken(string(content))
	} else if !os.IsNotExist(err) {
		return "", fmt.Errorf("read control token: %w", err)
	}

	raw := make([]byte, 32)
	if _, err := rand.Read(raw); err != nil {
		return "", fmt.Errorf("generate control token: %w", err)
	}
	token := base64.RawURLEncoding.EncodeToString(raw)

	file, err := os.OpenFile(tokenPath, os.O_WRONLY|os.O_CREATE|os.O_EXCL, 0o600)
	if err != nil {
		if os.IsExist(err) {
			return loadControlToken(basePath, "")
		}
		return "", fmt.Errorf("create control token: %w", err)
	}
	defer file.Close()

	if _, err = fmt.Fprintln(file, token); err != nil {
		return "", fmt.Errorf("write control token: %w", err)
	}
	return token, nil
}

func intentMethod(method string) bool {
	switch path.Base(method) {
	case "UpdateRuntimeConfig", "UpsertRoute", "DeleteRoute", "SelectRouteNode":
		return true
	default:
		return false
	}
}

func (m *Manager) authenticate(ctx context.Context, method string) error {
	if !intentMethod(method) {
		return nil
	}
	values := metadata.ValueFromIncomingContext(ctx, "authorization")
	if len(values) != 1 {
		return status.Error(codes.Unauthenticated, "missing control token")
	}
	provided, ok := strings.CutPrefix(values[0], "Bearer ")
	if !ok {
		return status.Error(codes.Unauthenticated, "missing control token")
	}
	if subtle.ConstantTimeCompare([]byte(provided), []byte(m.controlToken)) != 1 {
		return status.Error(codes.Unauthenticated, "invalid control token")
	}
	return nil
}

func (m *Manager) authenticateUnary(ctx context.Context, request any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp any, err error) {
	defer func() {
		if err != nil {
			m.logGRPCError(info.FullMethod, err)
		}
	}()
	if err = m.authenticate(ctx, info.FullMethod); err != nil {
		return nil, err
	}
	return handler(ctx, request)
}

func (m *Manager) authenticateStream(server any, stream grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) (err error) {
	defer func() {
		if err != nil {
			m.logGRPCError(info.FullMethod, err)
		}
	}()
	if err = m.authenticate(stream.Context(), info.FullMethod); err != nil {
		return err
	}
	return handler(server, stream)
}

func (m *Manager) logGRPCError(method string, err error) {
	if m.started == nil || err == nil {
		return
	}
	st := status.Convert(err)
	m.started.WriteMessage(boxlog.LevelError, fmt.Sprintf("gRPC ERROR %s: %s: %s", method, st.Code(), st.Message()))
}
