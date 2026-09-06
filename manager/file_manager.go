package manager

import (
	"context"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/sagernet/sing/service"
	"github.com/sagernet/sing/service/filemanager"
)

// absoluteAwareFileManager keeps paths resolved by sing-box from being
// resolved against the working directory a second time on Windows.
type absoluteAwareFileManager struct {
	filemanager.Manager
}

var _ filemanager.Manager = (*absoluteAwareFileManager)(nil)

func withFileManager(ctx context.Context, basePath, tempPath string, userID, groupID int) context.Context {
	ctx = filemanager.WithDefault(ctx, basePath, tempPath, userID, groupID)
	manager := service.FromContext[filemanager.Manager](ctx)
	return service.ContextWith[filemanager.Manager](ctx, &absoluteAwareFileManager{Manager: manager})
}

func (m *absoluteAwareFileManager) BasePath(name string) string {
	if filepath.IsAbs(name) {
		return name
	}
	return m.Manager.BasePath(name)
}

func (m *absoluteAwareFileManager) OpenFile(name string, flag int, perm os.FileMode) (*os.File, error) {
	return m.Manager.OpenFile(delegatePath(name), flag, perm)
}

func (m *absoluteAwareFileManager) Create(name string) (*os.File, error) {
	return m.Manager.Create(delegatePath(name))
}

func (m *absoluteAwareFileManager) Chown(name string) error {
	return m.Manager.Chown(delegatePath(name))
}

func (m *absoluteAwareFileManager) Mkdir(path string, perm os.FileMode) error {
	return m.Manager.Mkdir(delegatePath(path), perm)
}

func (m *absoluteAwareFileManager) MkdirAll(path string, perm os.FileMode) error {
	return m.Manager.MkdirAll(delegatePath(path), perm)
}

func (m *absoluteAwareFileManager) Remove(path string) error {
	return m.Manager.Remove(delegatePath(path))
}

func (m *absoluteAwareFileManager) RemoveAll(path string) error {
	return m.Manager.RemoveAll(delegatePath(path))
}

func (m *absoluteAwareFileManager) Rename(oldPath, newPath string) error {
	return m.Manager.Rename(delegatePath(oldPath), delegatePath(newPath))
}

func delegatePath(path string) string {
	if runtime.GOOS != "windows" || !filepath.IsAbs(path) {
		return path
	}
	slashed := filepath.ToSlash(path)
	if strings.HasPrefix(slashed, "//") {
		return slashed
	}
	return "//?/" + slashed
}
