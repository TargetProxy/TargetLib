package subscriptions

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/url"
	"sort"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/google/uuid"
	"golang.org/x/sync/errgroup"
	"golang.org/x/sync/singleflight"

	targetprofile "github.com/loafman1120/TargetLib/profile"
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
}

type Manager struct {
	fetcher                        Fetcher
	store                          Store
	resolver                       Resolver
	now                            func() time.Time
	defaultInterval, schedulerTick time.Duration
	snapshot                       atomic.Pointer[managerState]
	commands                       chan stateCommand
	coordinatorContext             context.Context
	coordinatorCancel              context.CancelFunc
	coordinatorDone                chan struct{}
	runtimeCallback                atomic.Pointer[runtimeCallback]
	updates                        singleflight.Group
	subscribersMu                  sync.RWMutex
	subscribers                    map[uint64]chan Event
	nextSubscriber                 uint64
	closeOnce                      sync.Once
}

type runtimeCallback struct {
	apply func(context.Context, *Subscription) error
}

func NewManager(options Options) *Manager {
	fetcher := options.Fetcher
	if fetcher == nil {
		fetcher = NewHTTPFetcher(HTTPFetcherOptions{})
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
	coordinatorContext, coordinatorCancel := context.WithCancel(context.Background())
	m := &Manager{
		fetcher: fetcher, store: store, resolver: resolver, now: now,
		defaultInterval: interval, schedulerTick: tick,
		commands: make(chan stateCommand), coordinatorContext: coordinatorContext,
		coordinatorCancel: coordinatorCancel, coordinatorDone: make(chan struct{}),
		subscribers: make(map[uint64]chan Event),
	}
	m.snapshot.Store(&managerState{items: make(map[string]Subscription)})
	go m.runCoordinator(coordinatorContext)
	return m
}

func (m *Manager) Load(ctx context.Context) error {
	stored, err := m.store.Load(ctx)
	if err != nil {
		return fmt.Errorf("load subscriptions: %w", err)
	}
	return m.submit(ctx, func(*managerState) (stateMutation, error) {
		next := &managerState{items: make(map[string]Subscription, len(stored.Subscriptions)), activeID: stored.ActiveID}
		for _, item := range stored.Subscriptions {
			if item.ID == "" {
				continue
			}
			if item.Status == StatusUpdating {
				item.Status, item.Stage = StatusIdle, StageIdle
			}
			next.items[item.ID] = cloneSubscription(item)
		}
		if _, ok := next.items[next.activeID]; !ok {
			next.activeID = ""
		}
		return stateMutation{next: next}, nil
	})
}

func (m *Manager) SetRuntimeChangedCallback(callback func(context.Context, *Subscription) error) {
	if callback == nil {
		m.runtimeCallback.Store(nil)
		return
	}
	m.runtimeCallback.Store(&runtimeCallback{apply: callback})
}

func (m *Manager) AddRequest(ctx context.Context, request AddRequest) (Subscription, error) {
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
	err = m.submit(ctx, func(current *managerState) (stateMutation, error) {
		if _, exists := current.items[item.ID]; exists {
			return unchangedState(current), fmt.Errorf("%s: %w", item.ID, ErrAlreadyExists)
		}
		next := cloneManagerState(current)
		next.items[item.ID] = cloneSubscription(item)
		return stateMutation{
			next:    next,
			persist: func(tx StoreTx) error { return tx.Put(item) },
			events:  []pendingEvent{{type_: EventAdded, item: item}},
		}, nil
	})
	if err != nil {
		return Subscription{}, err
	}
	return cloneSubscription(item), nil
}

func (m *Manager) Remove(ctx context.Context, id string) error {
	return m.submit(ctx, func(current *managerState) (stateMutation, error) {
		item, ok := current.items[id]
		if !ok {
			return unchangedState(current), fmt.Errorf("%s: %w", id, ErrNotFound)
		}
		next := cloneManagerState(current)
		delete(next.items, id)
		wasActive := next.activeID == id
		if wasActive {
			next.activeID = ""
		}
		return stateMutation{
			next: next, runtimeChanged: wasActive,
			persist: func(tx StoreTx) error {
				if err := tx.Delete(id); err != nil {
					return err
				}
				if wasActive {
					return tx.SetActiveID("")
				}
				return nil
			},
			events: []pendingEvent{{type_: EventRemoved, item: item}},
		}, nil
	})
}

// SetActive 持久化当前活动订阅；传入空 ID 会清除活动订阅。
func (m *Manager) SetActive(ctx context.Context, id string) error {
	id = strings.TrimSpace(id)
	return m.submit(ctx, func(current *managerState) (stateMutation, error) {
		if id != "" {
			if _, ok := current.items[id]; !ok {
				return unchangedState(current), fmt.Errorf("%s: %w", id, ErrNotFound)
			}
		}
		if current.activeID == id {
			return unchangedState(current), nil
		}
		next := cloneManagerState(current)
		next.activeID = id
		return stateMutation{
			next: next, runtimeChanged: true,
			persist: func(tx StoreTx) error { return tx.SetActiveID(id) },
		}, nil
	})
}

// ActiveID 返回持久化的活动订阅 ID；没有活动订阅时返回空字符串。
func (m *Manager) ActiveID() string {
	return m.snapshot.Load().activeID
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
	item, ok := m.snapshot.Load().items[id]
	return cloneSubscription(item), ok
}

func (m *Manager) List() []Subscription {
	state := m.snapshot.Load()
	out := make([]Subscription, 0, len(state.items))
	for _, item := range state.items {
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
	result := m.updates.DoChan(id, func() (any, error) {
		started := m.now()
		current, err := m.beginUpdate(ctx, id)
		if err != nil {
			return UpdateResult{}, err
		}
		return m.updateClaimed(ctx, id, current, started)
	})
	select {
	case <-ctx.Done():
		return UpdateResult{}, ctx.Err()
	case completed := <-result:
		if completed.Val == nil {
			return UpdateResult{}, completed.Err
		}
		return completed.Val.(UpdateResult), completed.Err
	}
}

func (m *Manager) updateClaimed(ctx context.Context, id string, current Subscription, started time.Time) (UpdateResult, error) {
	previous := cloneSubscription(current)
	m.setStage(ctx, id, StageFetching)
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
		if err = m.commit(ctx, current, previous); err != nil {
			return UpdateResult{}, err
		}
		return UpdateResult{Subscription: cloneSubscription(current), NotModified: true, Duration: m.now().Sub(started)}, nil
	}
	m.setStage(ctx, id, StageParsing)
	profile, err := ParseProfile(fetched.Body)
	if err != nil {
		return m.failUpdate(ctx, current, "parse", err, started)
	}
	m.setStage(ctx, id, StageResolving)
	endpoints := ResolveEndpoints(ctx, m.resolver, profile.Nodes)
	changed := current.NodesHash != profile.NodesHash
	current.Profile, current.NodesHash = profile.Profile, profile.NodesHash
	current.ResolvedEndpoints = endpoints
	current.ETag, current.LastModified = fetched.ETag, fetched.LastModified
	current.Status, current.Stage, current.Error, current.ErrorCode = StatusReady, StageComplete, "", ""
	m.applyHeaderMetadata(&current, fetched)
	current.UpdatedAt = m.now()
	current.NextUpdateAt = current.UpdatedAt.Add(current.UpdateInterval)
	m.setStage(ctx, id, StagePersisting)
	if err = m.commit(ctx, current, previous); err != nil {
		return UpdateResult{}, err
	}
	return UpdateResult{
		Subscription:   cloneSubscription(current),
		Changed:        changed,
		Duration:       m.now().Sub(started),
		OriginalConfig: append([]byte(nil), fetched.Body...),
	}, nil
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
	group, groupContext := errgroup.WithContext(ctx)
	group.SetLimit(4)
	ticker := time.NewTicker(m.schedulerTick)
	defer ticker.Stop()
	m.updateDue(groupContext, group)
	for {
		select {
		case <-groupContext.Done():
			_ = group.Wait()
			return groupContext.Err()
		case <-ticker.C:
			m.updateDue(groupContext, group)
		}
	}
}

func (m *Manager) Subscribe(buffer int) (<-chan Event, func()) {
	if buffer < 1 {
		buffer = 1
	}
	channel := make(chan Event, buffer)
	m.subscribersMu.Lock()
	id := m.nextSubscriber
	m.nextSubscriber++
	m.subscribers[id] = channel
	m.subscribersMu.Unlock()
	var once sync.Once
	return channel, func() {
		once.Do(func() {
			m.subscribersMu.Lock()
			if existing, ok := m.subscribers[id]; ok {
				delete(m.subscribers, id)
				close(existing)
			}
			m.subscribersMu.Unlock()
		})
	}
}

func (m *Manager) beginUpdate(ctx context.Context, id string) (Subscription, error) {
	var result Subscription
	err := m.submit(ctx, func(current *managerState) (stateMutation, error) {
		item, ok := current.items[id]
		if !ok {
			return unchangedState(current), fmt.Errorf("%s: %w", id, ErrNotFound)
		}
		result = cloneSubscription(item)
		next := cloneManagerState(current)
		item.Status, item.Stage, item.Error = StatusUpdating, StageFetching, ""
		next.items[id] = item
		return stateMutation{next: next, events: []pendingEvent{{type_: EventStage, item: item}}}, nil
	})
	return result, err
}
func (m *Manager) setStage(ctx context.Context, id string, stage UpdateStage) {
	_ = m.submit(ctx, func(current *managerState) (stateMutation, error) {
		item, ok := current.items[id]
		if !ok {
			return unchangedState(current), nil
		}
		next := cloneManagerState(current)
		item.Stage = stage
		next.items[id] = item
		return stateMutation{next: next, events: []pendingEvent{{type_: EventStage, item: item}}}, nil
	})
}
func (m *Manager) commit(ctx context.Context, item, persisted Subscription) error {
	return m.submit(context.WithoutCancel(ctx), func(current *managerState) (stateMutation, error) {
		previous, existed := current.items[item.ID]
		next := cloneManagerState(current)
		next.items[item.ID] = cloneSubscription(item)
		failure := cloneManagerState(current)
		failure.items[item.ID] = cloneSubscription(persisted)
		return stateMutation{
			next:           next,
			failure:        failure,
			runtimeChanged: existed && current.activeID == item.ID && previous.NodesHash != item.NodesHash,
			persist:        func(tx StoreTx) error { return tx.Put(item) },
			events:         []pendingEvent{{type_: EventUpdated, item: item}},
		}, nil
	})
}
func (m *Manager) failUpdate(ctx context.Context, item Subscription, code string, cause error, started time.Time) (UpdateResult, error) {
	previous := cloneSubscription(item)
	item.Status, item.Stage, item.ErrorCode, item.Error = StatusFailed, StageFailed, code, cause.Error()
	item.UpdatedAt = m.now()
	item.NextUpdateAt = item.UpdatedAt.Add(failureDelay(item.UpdateInterval))
	if err := m.commit(ctx, item, previous); err != nil {
		cause = errors.Join(cause, err)
		item = previous
	}
	return UpdateResult{Subscription: cloneSubscription(item), Duration: m.now().Sub(started)}, cause
}
func (m *Manager) modify(ctx context.Context, id string, change func(*Subscription)) error {
	return m.submit(ctx, func(current *managerState) (stateMutation, error) {
		item, ok := current.items[id]
		if !ok {
			return unchangedState(current), fmt.Errorf("%s: %w", id, ErrNotFound)
		}
		change(&item)
		next := cloneManagerState(current)
		next.items[id] = item
		return stateMutation{
			next:    next,
			persist: func(tx StoreTx) error { return tx.Put(item) },
			events:  []pendingEvent{{type_: EventUpdated, item: item}},
		}, nil
	})
}
func (m *Manager) updateDue(ctx context.Context, group *errgroup.Group) {
	now := m.now()
	for _, item := range m.List() {
		if item.Enabled && item.AutoUpdate && !item.NextUpdateAt.After(now) {
			id := item.ID
			group.Go(func() error {
				_, _ = m.Update(ctx, id)
				return nil
			})
		}
	}
}
func (m *Manager) publish(eventType EventType, item Subscription) {
	event := Event{Type: eventType, Subscription: subscriptionView(item), At: m.now()}
	m.subscribersMu.RLock()
	defer m.subscribersMu.RUnlock()
	for _, channel := range m.subscribers {
		select {
		case channel <- event:
		default:
		}
	}
}

func (m *Manager) Close() {
	m.closeOnce.Do(func() {
		m.coordinatorCancel()
		<-m.coordinatorDone
	})
}

func subscriptionView(item Subscription) View {
	return View{ID: item.ID, Name: item.Name, Source: sourceHost(item.URL), Enabled: item.Enabled, AutoUpdate: item.AutoUpdate, UpdateInterval: item.UpdateInterval, Status: item.Status, Stage: item.Stage, ErrorCode: item.ErrorCode, Error: item.Error, UpdatedAt: item.UpdatedAt, NextUpdateAt: item.NextUpdateAt, UploadBytes: item.UploadBytes, DownloadBytes: item.DownloadBytes, TotalBytes: item.TotalBytes, ExpiresAt: item.ExpiresAt, Title: item.Title, WebPageURL: item.WebPageURL, SupportURL: item.SupportURL, MovedPermanentlyTo: item.MovedPermanentlyTo, Profile: profileView(item.Profile)}
}

func profileView(source targetprofile.Profile) ProfileView {
	nodes := make([]NodeView, len(source.Nodes))
	for index, node := range source.Nodes {
		nodes[index] = NodeView{Tag: node.ID, Name: node.Name, Type: node.Type, CountryCode: node.CountryCode, Server: node.Server, Port: node.Port, Phase: node.Phase, Error: node.Error}
	}
	sort.Slice(nodes, func(i, j int) bool {
		if nodes[i].Name != nodes[j].Name {
			return nodes[i].Name < nodes[j].Name
		}
		if nodes[i].Type != nodes[j].Type {
			return nodes[i].Type < nodes[j].Type
		}
		if nodes[i].Server != nodes[j].Server {
			return nodes[i].Server < nodes[j].Server
		}
		return nodes[i].Port < nodes[j].Port
	})
	view := ProfileView{Nodes: nodes}
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
