package subscriptions

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/http"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"
)

const (
	defaultUpdateInterval = 12 * time.Hour
	minimumUpdateInterval = 5 * time.Minute
)

type Options struct {
	Fetcher               Fetcher
	Store                 Store
	Resolver              Resolver
	Now                   func() time.Time
	DefaultUpdateInterval time.Duration
	SchedulerTick         time.Duration
	// Legacy HTTP injection fields.
	Client    *http.Client
	UserAgent string
}

type Manager struct {
	mu                             sync.RWMutex
	fetcher                        Fetcher
	store                          Store
	resolver                       Resolver
	now                            func() time.Time
	defaultInterval, schedulerTick time.Duration
	items                          map[string]Subscription
	updating                       map[string]struct{}
	subscribers                    map[uint64]chan Event
	nextSubscriber                 uint64
	schedulerUpdates               sync.WaitGroup
	activeID                       string
}

func NewManager(options Options) *Manager {
	fetcher := options.Fetcher
	if fetcher == nil {
		fetcher = NewHTTPFetcher(HTTPFetcherOptions{Client: options.Client, UserAgent: options.UserAgent})
	}
	store := options.Store
	if store == nil {
		store = &MemoryStore{}
	}
	resolver := options.Resolver
	if resolver == nil {
		resolver = netResolver{net.DefaultResolver}
	}
	now := options.Now
	if now == nil {
		now = time.Now
	}
	interval := options.DefaultUpdateInterval
	if interval <= 0 {
		interval = defaultUpdateInterval
	}
	tick := options.SchedulerTick
	if tick <= 0 {
		tick = time.Minute
	}
	return &Manager{fetcher: fetcher, store: store, resolver: resolver, now: now, defaultInterval: interval, schedulerTick: tick, items: make(map[string]Subscription), updating: make(map[string]struct{}), subscribers: make(map[uint64]chan Event)}
}

func (m *Manager) Load(ctx context.Context) error {
	items, err := m.store.Load(ctx)
	if err != nil {
		return fmt.Errorf("load subscriptions: %w", err)
	}
	activeID, err := m.store.GetActiveID(ctx)
	if err != nil {
		return fmt.Errorf("load active subscription: %w", err)
	}
	m.mu.Lock()
	defer m.mu.Unlock()
	m.items = make(map[string]Subscription, len(items))
	for _, item := range items {
		if item.ID == "" {
			continue
		}
		if item.Status == StatusUpdating {
			item.Status, item.Stage = StatusIdle, StageIdle
		}
		m.items[item.ID] = cloneSubscription(item)
	}
	// Drop stale references so a removed subscription cannot stay active.
	if activeID != "" {
		if _, ok := m.items[activeID]; !ok {
			activeID = ""
		}
	}
	m.activeID = activeID
	return nil
}

func (m *Manager) Add(id, name, rawURL string) (Subscription, error) {
	return m.AddRequest(AddRequest{ID: id, Name: name, URL: rawURL, Enabled: true, AutoUpdate: true})
}

func (m *Manager) AddRequest(request AddRequest) (Subscription, error) {
	if strings.TrimSpace(request.ID) == "" {
		request.ID = uuid.NewString()
	}
	normalized, err := NormalizeSubscriptionURL(request.URL)
	if err != nil {
		return Subscription{}, err
	}
	request.URL = normalized
	if err := validateURL(request.URL); err != nil {
		return Subscription{}, err
	}
	if strings.TrimSpace(request.Name) == "" {
		request.Name = request.ID
	}
	if request.UpdateInterval <= 0 {
		request.UpdateInterval = m.defaultInterval
	}
	if request.UpdateInterval < minimumUpdateInterval {
		return Subscription{}, fmt.Errorf("%w (minimum %s)", ErrIntervalTooShort, minimumUpdateInterval)
	}
	now := m.now()
	item := Subscription{ID: request.ID, Name: strings.TrimSpace(request.Name), URL: request.URL, Enabled: request.Enabled, AutoUpdate: request.AutoUpdate, UpdateInterval: request.UpdateInterval, Headers: cloneStringMap(request.Headers), Status: StatusIdle, Stage: StageIdle, NextUpdateAt: now}
	m.mu.Lock()
	if _, exists := m.items[item.ID]; exists {
		m.mu.Unlock()
		return Subscription{}, fmt.Errorf("%s: %w", item.ID, ErrAlreadyExists)
	}
	m.items[item.ID] = item
	err = m.store.Put(context.Background(), cloneSubscription(item))
	if err != nil {
		delete(m.items, item.ID)
		m.mu.Unlock()
		return Subscription{}, err
	}
	m.mu.Unlock()
	m.publish(EventAdded, item)
	return cloneSubscription(item), nil
}

func (m *Manager) Remove(id string) bool {
	m.mu.Lock()
	item, ok := m.items[id]
	if !ok {
		m.mu.Unlock()
		return false
	}
	delete(m.items, id)
	err := m.store.Delete(context.Background(), id)
	if err != nil {
		m.items[id] = item
		m.mu.Unlock()
		return false
	}
	// Removing the active subscription clears the persisted active state.
	if m.activeID == id {
		m.activeID = ""
		_ = m.store.SetActiveID(context.Background(), "")
	}
	m.mu.Unlock()
	m.publish(EventRemoved, item)
	return true
}

// SetActive persists which subscription is currently active. An empty id
// clears the active subscription.
func (m *Manager) SetActive(ctx context.Context, id string) error {
	id = strings.TrimSpace(id)
	m.mu.Lock()
	defer m.mu.Unlock()
	if id != "" {
		if _, ok := m.items[id]; !ok {
			return fmt.Errorf("%s: %w", id, ErrNotFound)
		}
	}
	if err := m.store.SetActiveID(ctx, id); err != nil {
		return err
	}
	m.activeID = id
	return nil
}

// ActiveID returns the persisted active subscription id, or "" when none.
func (m *Manager) ActiveID() string {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.activeID
}

func (m *Manager) Rename(ctx context.Context, id, name string) error {
	name = strings.TrimSpace(name)
	if name == "" {
		return ErrNameRequired
	}
	return m.modify(ctx, id, func(item *Subscription) { item.Name = name })
}

func (m *Manager) ConfigureUpdates(ctx context.Context, id string, enabled bool, interval time.Duration) error {
	if enabled && interval < minimumUpdateInterval {
		return fmt.Errorf("%w (minimum %s)", ErrIntervalTooShort, minimumUpdateInterval)
	}
	return m.modify(ctx, id, func(item *Subscription) {
		item.AutoUpdate = enabled
		if interval > 0 {
			item.UpdateInterval = interval
		}
		if enabled {
			item.NextUpdateAt = m.now()
		}
	})
}

func (m *Manager) SetEnabled(ctx context.Context, id string, enabled bool) error {
	return m.modify(ctx, id, func(item *Subscription) { item.Enabled = enabled })
}

func (m *Manager) Config(id string) ([]byte, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	item, ok := m.items[id]
	if !ok || len(item.RawConfig) == 0 {
		return nil, false
	}
	return append([]byte(nil), item.RawConfig...), true
}

func (m *Manager) ResolvedEndpoints(enabledOnly bool) []string {
	set := make(map[string]struct{})
	for _, item := range m.List() {
		if enabledOnly && !item.Enabled {
			continue
		}
		for _, endpoint := range item.ResolvedEndpoints {
			set[endpoint] = struct{}{}
		}
	}
	out := make([]string, 0, len(set))
	for prefix := range set {
		out = append(out, prefix)
	}
	sort.Strings(out)
	return out
}

func (m *Manager) Get(id string) (Subscription, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	item, ok := m.items[id]
	return cloneSubscription(item), ok
}

func (m *Manager) List() []Subscription {
	m.mu.RLock()
	defer m.mu.RUnlock()
	out := make([]Subscription, 0, len(m.items))
	for _, item := range m.items {
		out = append(out, cloneSubscription(item))
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Name < out[j].Name })
	return out
}

func (m *Manager) View(id string) (View, bool) {
	item, ok := m.Get(id)
	if !ok {
		return View{}, false
	}
	return subscriptionView(item), true
}

func (m *Manager) Views() []View {
	items := m.List()
	out := make([]View, len(items))
	for index, item := range items {
		out[index] = subscriptionView(item)
	}
	return out
}

func (m *Manager) Update(ctx context.Context, id string) (UpdateResult, error) {
	started := m.now()
	current, err := m.beginUpdate(id)
	if err != nil {
		return UpdateResult{}, err
	}
	return m.updateClaimed(ctx, id, current, started)
}

// updateClaimed runs an update after the caller has atomically claimed the
// subscription in m.updating. This lets the scheduler claim work before
// starting a goroutine, avoiding duplicate goroutines on each scheduler tick.
func (m *Manager) updateClaimed(ctx context.Context, id string, current Subscription, started time.Time) (UpdateResult, error) {
	defer m.endUpdate(id)
	m.setStage(id, StageFetching)
	fetched, err := m.fetcher.Fetch(ctx, current)
	if err != nil {
		return m.failUpdate(ctx, current, "fetch", err, started)
	}
	if fetched.NotModified {
		current.Status, current.Stage, current.Error, current.ErrorCode = StatusReady, StageComplete, "", ""
		if fetched.ETag != "" {
			current.ETag = fetched.ETag
		}
		if fetched.LastModified != "" {
			current.LastModified = fetched.LastModified
		}
		m.applyHeaderMetadata(&current, fetched)
		current.UpdatedAt = m.now()
		current.NextUpdateAt = current.UpdatedAt.Add(current.UpdateInterval)
		if err = m.commit(ctx, current); err != nil {
			return UpdateResult{}, err
		}
		return UpdateResult{Subscription: cloneSubscription(current), NotModified: true, Duration: m.now().Sub(started)}, nil
	}
	m.setStage(id, StageParsing)
	profile, err := ParseProfile(fetched.Body)
	if err != nil {
		return m.failUpdate(ctx, current, "parse", err, started)
	}
	m.setStage(id, StageResolving)
	endpoints := ResolveEndpoints(ctx, m.resolver, profile.Nodes)
	changed := current.RawHash != profile.RawHash
	current.Nodes, current.RawConfig, current.RawHash = profile.Nodes, profile.RawConfig, profile.RawHash
	current.ResolvedEndpoints = endpoints
	current.ETag, current.LastModified = fetched.ETag, fetched.LastModified
	current.Status, current.Stage, current.Error, current.ErrorCode = StatusReady, StageComplete, "", ""
	m.applyHeaderMetadata(&current, fetched)
	current.UpdatedAt = m.now()
	current.NextUpdateAt = current.UpdatedAt.Add(current.UpdateInterval)
	m.setStage(id, StagePersisting)
	if err = m.commit(ctx, current); err != nil {
		return UpdateResult{}, err
	}
	return UpdateResult{Subscription: cloneSubscription(current), Changed: changed, Duration: m.now().Sub(started)}, nil
}

// applyHeaderMetadata 把响应头元数据应用到订阅（Dart 端 `??` 语义：
// 仅在服务器提供时覆盖，避免缺失响应头时清掉既有数据）。
func (m *Manager) applyHeaderMetadata(item *Subscription, fetched FetchResponse) {
	if fetched.UserInfo != "" {
		item.UploadBytes, item.DownloadBytes, item.TotalBytes = parseUserInfo(fetched.UserInfo)
	}
	if !fetched.ExpiresAt.IsZero() {
		item.ExpiresAt = fetched.ExpiresAt
	}
	if fetched.Title != "" {
		item.Title = fetched.Title
	}
	if fetched.WebPageURL != "" {
		item.WebPageURL = fetched.WebPageURL
	}
	if fetched.SupportURL != "" {
		item.SupportURL = fetched.SupportURL
	}
	if fetched.MovedPermanentlyTo != "" {
		item.MovedPermanentlyTo = fetched.MovedPermanentlyTo
	}
	// 服务器建议间隔需过下限防御，避免调度器被诱导成高频请求。
	if fetched.SuggestedInterval >= minimumUpdateInterval {
		item.UpdateInterval = fetched.SuggestedInterval
	}
}

func (m *Manager) Run(ctx context.Context) error {
	ticker := time.NewTicker(m.schedulerTick)
	defer ticker.Stop()
	m.updateDue(ctx)
	for {
		select {
		case <-ctx.Done():
			m.schedulerUpdates.Wait()
			return ctx.Err()
		case <-ticker.C:
			m.updateDue(ctx)
		}
	}
}

func (m *Manager) Subscribe(buffer int) (<-chan Event, func()) {
	if buffer < 1 {
		buffer = 1
	}
	channel := make(chan Event, buffer)
	m.mu.Lock()
	id := m.nextSubscriber
	m.nextSubscriber++
	m.subscribers[id] = channel
	m.mu.Unlock()
	var once sync.Once
	return channel, func() {
		once.Do(func() {
			m.mu.Lock()
			if existing, ok := m.subscribers[id]; ok {
				delete(m.subscribers, id)
				close(existing)
			}
			m.mu.Unlock()
		})
	}
}

func (m *Manager) beginUpdate(id string) (Subscription, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	item, ok := m.items[id]
	if !ok {
		return Subscription{}, fmt.Errorf("%s: %w", id, ErrNotFound)
	}
	if _, busy := m.updating[id]; busy {
		return Subscription{}, fmt.Errorf("%s: %w", id, ErrAlreadyUpdating)
	}
	current := cloneSubscription(item)
	m.updating[id] = struct{}{}
	item.Status, item.Stage, item.Error = StatusUpdating, StageFetching, ""
	m.items[id] = item
	return current, nil
}
func (m *Manager) endUpdate(id string) { m.mu.Lock(); delete(m.updating, id); m.mu.Unlock() }
func (m *Manager) setStage(id string, stage UpdateStage) {
	m.mu.Lock()
	item, ok := m.items[id]
	if ok {
		item.Stage = stage
		m.items[id] = item
	}
	m.mu.Unlock()
	if ok {
		m.publish(EventStage, item)
	}
}
func (m *Manager) commit(ctx context.Context, item Subscription) error {
	m.mu.Lock()
	previous, existed := m.items[item.ID]
	m.items[item.ID] = cloneSubscription(item)
	if err := m.store.Put(ctx, cloneSubscription(item)); err != nil {
		if existed {
			m.items[item.ID] = previous
		} else {
			delete(m.items, item.ID)
		}
		m.mu.Unlock()
		return fmt.Errorf("persist subscription: %w", err)
	}
	m.mu.Unlock()
	m.publish(EventUpdated, item)
	return nil
}
func (m *Manager) failUpdate(ctx context.Context, item Subscription, code string, cause error, started time.Time) (UpdateResult, error) {
	previous := cloneSubscription(item)
	item.Status, item.Stage, item.ErrorCode, item.Error = StatusFailed, StageFailed, code, cause.Error()
	item.UpdatedAt = m.now()
	item.NextUpdateAt = item.UpdatedAt.Add(failureDelay(item.UpdateInterval))
	if err := m.commit(ctx, item); err != nil {
		cause = errors.Join(cause, err)
		m.mu.Lock()
		m.items[item.ID] = previous
		m.mu.Unlock()
		item = previous
	}
	return UpdateResult{Subscription: cloneSubscription(item), Duration: m.now().Sub(started)}, cause
}
func (m *Manager) modify(ctx context.Context, id string, change func(*Subscription)) error {
	m.mu.Lock()
	item, ok := m.items[id]
	if !ok {
		m.mu.Unlock()
		return fmt.Errorf("%s: %w", id, ErrNotFound)
	}
	previous := cloneSubscription(item)
	change(&item)
	m.items[id] = item
	if err := m.store.Put(ctx, cloneSubscription(item)); err != nil {
		m.items[id] = previous
		m.mu.Unlock()
		return err
	}
	m.mu.Unlock()
	m.publish(EventUpdated, item)
	return nil
}
func (m *Manager) updateDue(ctx context.Context) {
	now := m.now()
	for _, item := range m.List() {
		if item.Enabled && item.AutoUpdate && !item.NextUpdateAt.After(now) {
			current, err := m.beginUpdate(item.ID)
			if err != nil {
				// A manual update or an already-running scheduled update owns it.
				continue
			}
			m.schedulerUpdates.Add(1)
			go func(id string, current Subscription) {
				defer m.schedulerUpdates.Done()
				_, _ = m.updateClaimed(ctx, id, current, m.now())
			}(item.ID, current)
		}
	}
}
func (m *Manager) publish(eventType EventType, item Subscription) {
	event := Event{Type: eventType, Subscription: subscriptionView(item), At: m.now()}
	m.mu.RLock()
	defer m.mu.RUnlock()
	for _, channel := range m.subscribers {
		select {
		case channel <- event:
		default:
		}
	}
}

func subscriptionView(item Subscription) View {
	view := View{ID: item.ID, Name: item.Name, Source: sourceHost(item.URL), Enabled: item.Enabled, AutoUpdate: item.AutoUpdate, UpdateInterval: item.UpdateInterval, Status: item.Status, Stage: item.Stage, ErrorCode: item.ErrorCode, Error: item.Error, UpdatedAt: item.UpdatedAt, NextUpdateAt: item.NextUpdateAt, UploadBytes: item.UploadBytes, DownloadBytes: item.DownloadBytes, TotalBytes: item.TotalBytes, ExpiresAt: item.ExpiresAt, Title: item.Title, WebPageURL: item.WebPageURL, SupportURL: item.SupportURL, MovedPermanentlyTo: item.MovedPermanentlyTo, Nodes: make([]NodeView, len(item.Nodes))}
	for index, node := range item.Nodes {
		view.Nodes[index] = NodeView{ID: node.ID, Name: node.Name, Type: node.Type, Server: node.Server, Port: node.Port, Group: node.Group, Groups: append([]string(nil), node.Groups...), Phase: node.Phase, Error: node.Error}
	}
	return view
}

func sourceHost(raw string) string {
	parsed, err := url.Parse(raw)
	if err != nil {
		return ""
	}
	return parsed.Host
}

func validateURL(raw string) error {
	parsed, err := url.ParseRequestURI(raw)
	if err != nil || parsed.Host == "" {
		return ErrInvalidURL
	}
	if parsed.Scheme != "https" {
		return ErrHTTPSRequired
	}
	return nil
}
func failureDelay(interval time.Duration) time.Duration {
	delay := interval / 8
	if delay < time.Minute {
		return time.Minute
	}
	if delay > 30*time.Minute {
		return 30 * time.Minute
	}
	return delay
}
func parseUserInfo(value string) (upload, download, total int64) {
	for _, part := range strings.Split(value, ";") {
		pair := strings.SplitN(strings.TrimSpace(part), "=", 2)
		if len(pair) != 2 {
			continue
		}
		n, _ := strconv.ParseInt(pair[1], 10, 64)
		switch strings.ToLower(pair[0]) {
		case "upload":
			upload = n
		case "download":
			download = n
		case "total":
			total = n
		}
	}
	return
}
