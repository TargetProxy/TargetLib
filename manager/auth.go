package manager

import (
	"context"
	"crypto/rand"
	"crypto/subtle"
	"encoding/base64"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

const controlTokenFile = "control.token"

func loadControlToken(basePath, supplied string) (string, error) {
	if token := strings.TrimSpace(supplied); token != "" {
		if len(token) < 32 || len(token) > 512 {
			return "", fmt.Errorf("control token must be 32-512 bytes")
		}
		return token, nil
	}
	if strings.TrimSpace(basePath) == "" {
		return "", fmt.Errorf("base path is required to store the control token")
	}
	if err := os.MkdirAll(basePath, 0o700); err != nil {
		return "", fmt.Errorf("create control token directory: %w", err)
	}
	path := filepath.Join(basePath, controlTokenFile)
	content, err := os.ReadFile(path)
	if err == nil {
		token := strings.TrimSpace(string(content))
		if len(token) < 32 || len(token) > 512 {
			return "", fmt.Errorf("invalid control token file")
		}
		_ = os.Chmod(path, 0o600)
		return token, nil
	}
	if !os.IsNotExist(err) {
		return "", fmt.Errorf("read control token: %w", err)
	}
	raw := make([]byte, 32)
	if _, err := rand.Read(raw); err != nil {
		return "", fmt.Errorf("generate control token: %w", err)
	}
	token := base64.RawURLEncoding.EncodeToString(raw)
	file, err := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_EXCL, 0o600)
	if err != nil {
		if os.IsExist(err) {
			return loadControlToken(basePath, "")
		}
		return "", fmt.Errorf("create control token: %w", err)
	}
	if _, err = file.WriteString(token + "\n"); err != nil {
		_ = file.Close()
		return "", fmt.Errorf("write control token: %w", err)
	}
	if err = file.Close(); err != nil {
		return "", fmt.Errorf("close control token: %w", err)
	}
	return token, nil
}

func intentMethod(method string) bool {
	name := method[strings.LastIndex(method, "/")+1:]
	switch name {
	case "GetSmartConnectSnapshot", "SetSmartConnectEnabled", "ListServicePolicies", "UpsertServicePolicy", "DeleteServicePolicy", "SetNodePreference", "RequestServiceEvaluation", "ApproveSwitchProposal", "RejectSwitchProposal", "ForceServiceBinding", "GetOperation", "ListOperations", "SubscribeSmartConnectEvents":
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
	if len(values) != 1 || !strings.HasPrefix(values[0], "Bearer ") {
		return status.Error(codes.Unauthenticated, "missing control token")
	}
	provided := strings.TrimPrefix(values[0], "Bearer ")
	if subtle.ConstantTimeCompare([]byte(provided), []byte(m.controlToken)) != 1 {
		return status.Error(codes.Unauthenticated, "invalid control token")
	}
	return nil
}

func (m *Manager) authenticateUnary(ctx context.Context, request any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
	if err := m.authenticate(ctx, info.FullMethod); err != nil {
		return nil, err
	}
	return handler(ctx, request)
}

func (m *Manager) authenticateStream(server any, stream grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
	if err := m.authenticate(stream.Context(), info.FullMethod); err != nil {
		return err
	}
	return handler(server, stream)
}
