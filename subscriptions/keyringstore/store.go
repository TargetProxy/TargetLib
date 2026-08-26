// Package keyringstore 提供可选的桌面凭据存储适配器。
package keyringstore

import (
	"crypto/rand"
	"encoding/base64"
	"errors"
	"io"

	"github.com/loafman1120/TargetLib/subscriptions"
	"github.com/zalando/go-keyring"
)

const account = "subscriptions-file-key-v1"

// New 在 Windows 使用 Credential Manager，在 macOS 使用 Keychain，在桌面 Linux 使用
// Secret Service；Android 和 iOS 应改为向 subscriptions.OpenBadgerStore 注入密钥材料。
func New(path, service string) (*subscriptions.BadgerStore, error) {
	if service == "" {
		service = "TargetLib"
	}
	encoded, err := keyring.Get(service, account)
	if errors.Is(err, keyring.ErrNotFound) {
		key := make([]byte, 32)
		if _, err = io.ReadFull(rand.Reader, key); err != nil {
			return nil, err
		}
		if err = keyring.Set(service, account, base64.RawStdEncoding.EncodeToString(key)); err != nil {
			return nil, err
		}
		return subscriptions.OpenBadgerStore(path, key)
	}
	if err != nil {
		return nil, err
	}
	key, err := base64.RawStdEncoding.DecodeString(encoded)
	if err != nil {
		return nil, err
	}
	return subscriptions.OpenBadgerStore(path, key)
}
