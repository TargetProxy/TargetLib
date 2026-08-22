package subscriptions

import (
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"mime"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/go-resty/resty/v2"
)

const defaultMaxBodyBytes int64 = 2 << 20

type FetchResponse struct {
	Body                         []byte
	ETag, LastModified, UserInfo string
	NotModified                  bool
	// 响应头元数据（订阅协议约定）：服务器建议的更新间隔、订阅标题、
	// 到期时间与展示链接。仅在响应头提供时非零，调用方按需覆盖。
	SuggestedInterval  time.Duration
	ExpiresAt          time.Time
	Title              string
	WebPageURL         string
	SupportURL         string
	MovedPermanentlyTo string
}

type Fetcher interface {
	Fetch(context.Context, Subscription) (FetchResponse, error)
}

type HTTPFetcherOptions struct {
	Client            *http.Client
	Timeout           time.Duration
	RetryCount        int
	MaxBodyBytes      int64
	UserAgent         string
	AllowInsecureHTTP bool
	DisableRetry      bool
}

type HTTPFetcher struct {
	client            *resty.Client
	maxBodyBytes      int64
	allowInsecureHTTP bool
}

func NewHTTPFetcher(options HTTPFetcherOptions) *HTTPFetcher {
	timeout := options.Timeout
	if timeout <= 0 {
		timeout = 30 * time.Second
	}
	maxBody := options.MaxBodyBytes
	if maxBody <= 0 {
		maxBody = defaultMaxBodyBytes
	}
	retries := 2
	if options.DisableRetry {
		retries = 0
	} else if options.RetryCount > 0 {
		retries = options.RetryCount
	}
	client := options.Client
	if client == nil {
		client = &http.Client{Timeout: timeout, CheckRedirect: secureRedirectPolicy(options.AllowInsecureHTTP)}
	}
	r := resty.NewWithClient(client).
		SetTimeout(timeout).
		SetRetryCount(retries).
		SetRetryWaitTime(300*time.Millisecond).
		SetRetryMaxWaitTime(3*time.Second).
		SetHeader("Accept", "application/json, */*")
	ua := options.UserAgent
	if ua == "" {
		ua = "TargetLib/experimental-subscriptions"
	}
	r.SetHeader("User-Agent", ua)
	r.AddRetryCondition(func(response *resty.Response, err error) bool {
		return err != nil || response.StatusCode() == http.StatusTooManyRequests || response.StatusCode() >= 500
	})
	return &HTTPFetcher{client: r, maxBodyBytes: maxBody, allowInsecureHTTP: options.AllowInsecureHTTP}
}

func (f *HTTPFetcher) Fetch(ctx context.Context, subscription Subscription) (FetchResponse, error) {
	parsed, err := url.ParseRequestURI(subscription.URL)
	if err != nil || parsed.Host == "" {
		return FetchResponse{}, ErrInvalidURL
	}
	if parsed.Scheme != "https" && !(f.allowInsecureHTTP && parsed.Scheme == "http") {
		return FetchResponse{}, ErrHTTPSRequired
	}
	request := f.client.R().SetContext(ctx).SetDoNotParseResponse(true)
	for key, value := range subscription.Headers {
		request.SetHeader(key, value)
	}
	if subscription.ETag != "" {
		request.SetHeader("If-None-Match", subscription.ETag)
	}
	if subscription.LastModified != "" {
		request.SetHeader("If-Modified-Since", subscription.LastModified)
	}
	response, err := request.Get(subscription.URL)
	if err != nil {
		return FetchResponse{}, fmt.Errorf("fetch subscription: %w", err)
	}
	if response.RawBody() != nil {
		defer response.RawBody().Close()
	}
	if response.StatusCode() == http.StatusNotModified {
		// 304 也可能刷新 ETag/Last-Modified 与流量、到期时间等元数据。
		result := fetchHeaderMetadata(response)
		result.NotModified = true
		return result, nil
	}
	if response.StatusCode() < 200 || response.StatusCode() >= 300 {
		return FetchResponse{}, fmt.Errorf("subscription fetch returned HTTP %d", response.StatusCode())
	}
	reader := io.LimitReader(response.RawBody(), f.maxBodyBytes+1)
	body, err := io.ReadAll(reader)
	if err != nil {
		return FetchResponse{}, fmt.Errorf("read subscription: %w", err)
	}
	if int64(len(body)) > f.maxBodyBytes {
		return FetchResponse{}, fmt.Errorf("subscription exceeds %d bytes", f.maxBodyBytes)
	}
	if len(strings.TrimSpace(string(body))) == 0 {
		return FetchResponse{}, errors.New("subscription body is empty")
	}
	result := fetchHeaderMetadata(response)
	result.Body = body
	return result, nil
}

// fetchHeaderMetadata 提取响应头中携带的订阅协议元数据。
func fetchHeaderMetadata(response *resty.Response) FetchResponse {
	header := response.Header()
	return FetchResponse{
		ETag:               header.Get("ETag"),
		LastModified:       header.Get("Last-Modified"),
		UserInfo:           header.Get("Subscription-Userinfo"),
		SuggestedInterval:  parseSuggestedInterval(header),
		ExpiresAt:          parseExpiresAt(header),
		Title:              parseTitle(header),
		WebPageURL:         strings.TrimSpace(header.Get("Profile-Web-Page-Url")),
		SupportURL:         strings.TrimSpace(header.Get("Support-Url")),
		MovedPermanentlyTo: strings.TrimSpace(header.Get("Moved-Permanently-To")),
	}
}

// parseSuggestedInterval 解析 profile-update-interval（单位小时）。
// 缺失或非正数时返回 0，由调用方决定是否采纳。
func parseSuggestedInterval(header http.Header) time.Duration {
	value := strings.TrimSpace(header.Get("Profile-Update-Interval"))
	if value == "" {
		return 0
	}
	hours, err := strconv.ParseInt(value, 10, 64)
	if err != nil || hours <= 0 {
		return 0
	}
	return time.Duration(hours) * time.Hour
}

// parseExpiresAt 从 Subscription-Userinfo 的 expire 键解析到期时间
// （Unix 秒）。缺失或非正数时返回零值。
func parseExpiresAt(header http.Header) time.Time {
	for _, part := range strings.Split(header.Get("Subscription-Userinfo"), ";") {
		pair := strings.SplitN(strings.TrimSpace(part), "=", 2)
		if len(pair) != 2 || !strings.EqualFold(pair[0], "expire") {
			continue
		}
		seconds, err := strconv.ParseInt(strings.TrimSpace(pair[1]), 10, 64)
		if err != nil || seconds <= 0 {
			return time.Time{}
		}
		return time.Unix(seconds, 0).UTC()
	}
	return time.Time{}
}

// parseTitle 解析订阅标题：profile-title（可带 base64: 前缀）优先，
// 回退到 content-disposition 的 filename。
func parseTitle(header http.Header) string {
	title := strings.TrimSpace(header.Get("Profile-Title"))
	if title != "" {
		if encoded, found := strings.CutPrefix(title, "base64:"); found {
			if decoded, err := base64.StdEncoding.DecodeString(encoded); err == nil {
				return string(decoded)
			}
		}
		return title
	}
	disposition := header.Get("Content-Disposition")
	if disposition == "" {
		return ""
	}
	_, parameters, err := mime.ParseMediaType(disposition)
	if err == nil {
		return parameters["filename"]
	}
	return ""
}

func secureRedirectPolicy(allowHTTP bool) func(*http.Request, []*http.Request) error {
	return func(request *http.Request, via []*http.Request) error {
		if len(via) >= 5 {
			return errors.New("too many redirects")
		}
		if !allowHTTP && request.URL.Scheme != "https" {
			return errors.New("refusing HTTPS downgrade redirect")
		}
		return nil
	}
}
