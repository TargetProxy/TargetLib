package manager

import (
	"bytes"
	"context"
	"crypto/rand"
	"time"

	api "github.com/loafman1120/TargetLib/api/TargetLib"
)

// Each datagram carries a fresh nonce. Delayed replies cannot acknowledge a
// later packet, and payload equality verifies an RFC 862 echo response.
func probePackets(ctx context.Context, p *api.ServiceProbe, transport *nodeProbeTransport, result *api.ProbeResult) {
	if p.UdpEchoAddress == "" {
		return
	}
	ctx, cancel := context.WithTimeout(ctx, time.Duration(p.PacketCount+1)*time.Duration(p.PacketTimeoutMilliseconds)*time.Millisecond)
	defer cancel()
	conn, err := transport.dial(ctx, "udp", p.UdpEchoAddress)
	if err != nil {
		result.PacketError = "UDP transport unavailable"
		return
	}
	defer conn.Close()
	stop := context.AfterFunc(ctx, func() { conn.Close() })
	defer stop()
	for i := uint32(0); i < p.PacketCount; i++ {
		if ctx.Err() != nil {
			result.PacketError = "UDP probe canceled"
			return
		}
		deadline := time.Now().Add(time.Duration(p.PacketTimeoutMilliseconds) * time.Millisecond)
		if err := conn.SetDeadline(deadline); err != nil {
			result.PacketError = "UDP deadlines unavailable"
			return
		}
		payload := make([]byte, 32)
		if _, err := rand.Read(payload); err != nil {
			result.PacketError = "cannot generate probe payload"
			return
		}
		if n, err := conn.Write(payload); err != nil || n != len(payload) {
			result.PacketError = "UDP send failed"
			return
		}
		result.PacketsSent++
		buffer := make([]byte, 2048)
		for time.Now().Before(deadline) {
			n, err := conn.Read(buffer)
			if err != nil {
				break
			}
			if bytes.Equal(buffer[:n], payload) {
				result.PacketsReceived++
				break
			}
		}
	}
	if result.PacketsSent > 0 {
		result.PacketLossAvailable = true
		result.PacketLossRatio = 1 - float64(result.PacketsReceived)/float64(result.PacketsSent)
	}
}
