package subscriptions

import (
	"errors"
	"time"

	targetprofile "github.com/loafman1120/TargetLib/profile"
)

// 哨兵错误：适配层用 errors.Is 判定失败类别，避免依赖错误文案导致错误码漂移。
var (
	ErrNotFound         = errors.New("subscription not found")
	ErrAlreadyExists    = errors.New("subscription already exists")
	ErrIDRequired       = errors.New("subscription ID is required")
	ErrNameRequired     = errors.New("subscription name is required")
	ErrInvalidURL       = errors.New("invalid subscription URL")
	ErrHTTPSRequired    = errors.New("subscription URL must use HTTPS")
	ErrIntervalTooShort = errors.New("update interval is too short")
)

type Status string

const (
	StatusIdle     Status = "idle"
	StatusUpdating Status = "updating"
	StatusReady    Status = "ready"
	StatusFailed   Status = "failed"
)

type UpdateStage string

const (
	StageIdle       UpdateStage = "idle"
	StageFetching   UpdateStage = "fetching"
	StageParsing    UpdateStage = "parsing"
	StageResolving  UpdateStage = "resolving"
	StagePersisting UpdateStage = "persisting"
	StageComplete   UpdateStage = "complete"
	StageFailed     UpdateStage = "failed"
)

type NodePhase = targetprofile.NodePhase
type Node = targetprofile.Node

const (
	NodeDiscovered = targetprofile.NodeDiscovered
	NodeNormalized = targetprofile.NodeNormalized
	NodeReady      = targetprofile.NodeReady
	NodeFailed     = targetprofile.NodeFailed
)

type Subscription struct {
	ID                string                `json:"id"`
	Name              string                `json:"name"`
	URL               string                `json:"url"`
	Enabled           bool                  `json:"enabled"`
	AutoUpdate        bool                  `json:"auto_update"`
	UpdateInterval    time.Duration         `json:"update_interval"`
	Headers           map[string]string     `json:"headers,omitempty"`
	Status            Status                `json:"status"`
	Stage             UpdateStage           `json:"stage"`
	Profile           targetprofile.Profile `json:"profile"`
	NodesHash         string                `json:"nodes_hash,omitempty"`
	ETag              string                `json:"etag,omitempty"`
	LastModified      string                `json:"last_modified,omitempty"`
	ErrorCode         string                `json:"error_code,omitempty"`
	Error             string                `json:"error,omitempty"`
	UpdatedAt         time.Time             `json:"updated_at,omitempty"`
	NextUpdateAt      time.Time             `json:"next_update_at,omitempty"`
	UploadBytes       int64                 `json:"upload_bytes,omitempty"`
	DownloadBytes     int64                 `json:"download_bytes,omitempty"`
	TotalBytes        int64                 `json:"total_bytes,omitempty"`
	ResolvedEndpoints []string              `json:"resolved_endpoints,omitempty"`
	// 响应头元数据（订阅协议约定），仅在服务器提供时更新。
	ExpiresAt          time.Time `json:"expires_at,omitempty"`
	Title              string    `json:"title,omitempty"`
	WebPageURL         string    `json:"web_page_url,omitempty"`
	SupportURL         string    `json:"support_url,omitempty"`
	MovedPermanentlyTo string    `json:"moved_permanently_to,omitempty"`
}

type AddRequest struct {
	ID, Name, URL       string
	Enabled, AutoUpdate bool
	UpdateInterval      time.Duration
	Headers             map[string]string
}

type UpdateResult struct {
	Subscription Subscription
	Changed      bool
	NotModified  bool
	Duration     time.Duration
}

type EventType string

const (
	EventAdded   EventType = "added"
	EventUpdated EventType = "updated"
	EventRemoved EventType = "removed"
	EventStage   EventType = "stage"
)

type Event struct {
	Type         EventType
	Subscription View
	At           time.Time
}

// View 可安全提供给 UI 和传输层使用，不包含凭据、自定义请求头、原始配置、校验器及供应商专属节点配置。
type View struct {
	ID, Name, Source        string
	Enabled, AutoUpdate     bool
	UpdateInterval          time.Duration
	Status                  Status
	Stage                   UpdateStage
	Profile                 ProfileView
	ErrorCode, Error        string
	UpdatedAt, NextUpdateAt time.Time
	UploadBytes             int64
	DownloadBytes           int64
	TotalBytes              int64
	ExpiresAt               time.Time
	Title, WebPageURL       string
	SupportURL              string
	MovedPermanentlyTo      string
}

type NodeView struct {
	Tag, Name, Type, Server string
	Port                    int
	Phase                   NodePhase
	Error                   string
}

type ProfileView struct {
	Nodes []NodeView
}

func cloneSubscription(s Subscription) Subscription {
	s.Headers = cloneStringMap(s.Headers)
	s.ResolvedEndpoints = append([]string(nil), s.ResolvedEndpoints...)
	s.Profile = cloneProfile(s.Profile)
	return s
}

func cloneProfile(source targetprofile.Profile) targetprofile.Profile {
	return targetprofile.Profile{Nodes: cloneNodes(source.Nodes)}
}

func cloneNodes(source []targetprofile.Node) []targetprofile.Node {
	result := make([]targetprofile.Node, len(source))
	for index, node := range source {
		result[index] = node
		if node.OutboundJSON != nil {
			result[index].OutboundJSON = append([]byte(nil), node.OutboundJSON...)
		}
	}
	return result
}

func cloneStringMap(source map[string]string) map[string]string {
	if source == nil {
		return nil
	}
	out := make(map[string]string, len(source))
	for key, value := range source {
		out[key] = value
	}
	return out
}
