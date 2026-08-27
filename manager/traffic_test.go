package manager

import (
	"testing"
	"time"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"github.com/sagernet/sing-box/daemon"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/proto"
)

func TestTrafficInterval(t *testing.T) {
	tests := []struct {
		name         string
		milliseconds uint32
		want         time.Duration
		wantCode     codes.Code
	}{
		{name: "default", want: time.Second},
		{name: "minimum", milliseconds: 250, want: 250 * time.Millisecond},
		{name: "maximum", milliseconds: 5000, want: 5 * time.Second},
		{name: "too small", milliseconds: 249, wantCode: codes.InvalidArgument},
		{name: "too large", milliseconds: 5001, wantCode: codes.InvalidArgument},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got, err := trafficInterval(test.milliseconds)
			if status.Code(err) != test.wantCode {
				t.Fatalf("error code = %v, want %v", status.Code(err), test.wantCode)
			}
			if got != test.want {
				t.Fatalf("interval = %v, want %v", got, test.want)
			}
		})
	}
}

func TestTrafficStatusNormalizesSampleToBytesPerSecond(t *testing.T) {
	sampledAt := time.UnixMilli(1_725_000_000_123)
	got := trafficStatus(&daemon.Status{
		TrafficAvailable: true,
		Uplink:           512 * 1024,
		Downlink:         1024 * 1024,
		UplinkTotal:      10_000,
		DownlinkTotal:    20_000,
		ConnectionsIn:    3,
		ConnectionsOut:   4,
	}, 500*time.Millisecond, sampledAt)

	want := &targetlibapi.TrafficStatus{
		Available:              true,
		UploadBytesPerSecond:   1024 * 1024,
		DownloadBytesPerSecond: 2 * 1024 * 1024,
		UploadTotalBytes:       10_000,
		DownloadTotalBytes:     20_000,
		InboundConnections:     3,
		OutboundConnections:    4,
		SampledAtUnixMs:        sampledAt.UnixMilli(),
		IntervalMilliseconds:   500,
	}
	if !proto.Equal(got, want) {
		t.Fatalf("traffic status = %v, want %v", got, want)
	}
}

func TestBytesPerSecondRejectsInvalidSamples(t *testing.T) {
	if got := bytesPerSecond(-1, time.Second); got != 0 {
		t.Fatalf("negative sample rate = %d, want 0", got)
	}
	if got := bytesPerSecond(1, 0); got != 0 {
		t.Fatalf("zero interval rate = %d, want 0", got)
	}
}
