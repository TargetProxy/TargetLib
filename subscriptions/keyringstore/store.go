// Package keyringstore provides the optional desktop credential-store adapter.
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

// New uses Credential Manager on Windows, Keychain on macOS, and Secret
// Service on desktop Linux. Android and iOS hosts should instead inject key
// material into subscriptions.OpenBadgerStore.
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
