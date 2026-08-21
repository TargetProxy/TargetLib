//go:build (!windows && !darwin && !linux) || android || ios

package systemproxy

import (
	"errors"
	"runtime"
)

func GetStatus() (Status, error) {
	return Status{
		Platform:  runtime.GOOS,
		Supported: false,
		Enabled:   false,
	}, nil
}

func Set(bool, string, int32, string) error {
	return errors.New("system proxy is only implemented on desktop platforms")
}
