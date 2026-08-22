package manager

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"time"

	targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

// ipInfoEndpoint mirrors the ip-api.com query the desktop client used
// before the lookup moved to the backend egress.
const ipInfoEndpoint = "http://ip-api.com/json/?fields=query,country,countryCode,city,isp,org,as"

// GetIpInfo queries the egress IP geolocation from the backend so the result
// reflects the proxy path when the core is running.
func (m *Manager) GetIpInfo(ctx context.Context, _ *emptypb.Empty) (*targetlibapi.IpInfoResponse, error) {
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, ipInfoEndpoint, nil)
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	client := &http.Client{Timeout: 5 * time.Second}
	response, err := client.Do(request)
	if err != nil {
		return nil, status.Error(codes.Unavailable, err.Error())
	}
	defer response.Body.Close()
	if response.StatusCode != http.StatusOK {
		return nil, status.Errorf(codes.Unavailable, "ip info service returned status %d", response.StatusCode)
	}
	body, err := io.ReadAll(io.LimitReader(response.Body, 1<<20))
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	var payload struct {
		Query       string `json:"query"`
		Country     string `json:"country"`
		CountryCode string `json:"countryCode"`
		City        string `json:"city"`
		ISP         string `json:"isp"`
		Org         string `json:"org"`
		AS          string `json:"as"`
	}
	if err := json.Unmarshal(body, &payload); err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}
	return &targetlibapi.IpInfoResponse{
		Ip:          payload.Query,
		Country:     payload.Country,
		CountryCode: payload.CountryCode,
		City:        payload.City,
		Isp:         payload.ISP,
		Org:         payload.Org,
		AsName:      payload.AS,
	}, nil
}
