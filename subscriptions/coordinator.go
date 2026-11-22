package subscriptions

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"slices"
	"strings"
)

var errManagerClosed = errors.New("subscription manager is closed")

type managerState struct {
	items    map[string]Subscription
	revision string
}

type stateMutation struct {
	next    *managerState
	failure *managerState
	persist func(StoreTx) error
	events  []pendingEvent
}

type pendingEvent struct {
	type_ EventType
	item  Subscription
}

type stateCommand struct {
	ctx    context.Context
	build  func(*managerState) (stateMutation, error)
	result chan error
}

func (m *Manager) runCoordinator(ctx context.Context) {
	defer close(m.coordinatorDone)
	current := &managerState{items: make(map[string]Subscription)}
	current.revision = managerStateRevision(current)
	m.snapshot.Store(current)
	for {
		select {
		case <-ctx.Done():
			return
		case command := <-m.commands:
			mutation, err := command.build(current)
			if err == nil {
				err = m.applyMutation(command.ctx, current, mutation)
			}
			if err == nil {
				current = mutation.next
				current.revision = managerStateRevision(current)
				m.snapshot.Store(current)
				for _, event := range mutation.events {
					m.publish(event.type_, event.item)
				}
			} else if mutation.failure != nil {
				current = mutation.failure
				current.revision = managerStateRevision(current)
				m.snapshot.Store(current)
			}
			command.result <- err
		}
	}
}

func managerStateRevision(state *managerState) string {
	items := make([]Subscription, 0, len(state.items))
	for _, item := range state.items {
		if item.Enabled {
			items = append(items, item)
		}
	}
	slices.SortFunc(items, func(a, b Subscription) int { return strings.Compare(a.ID, b.ID) })
	hash := sha256.New()
	for _, item := range items {
		_, _ = fmt.Fprintf(hash, "%s\x00%s\x00", item.ID, item.NodesHash)
		for _, node := range item.Profile.Nodes {
			_, _ = fmt.Fprintf(hash, "%s\x00%s\x00%s\x00%s\x00%s\x00%d\x00%s\x00", node.ID, node.Name, node.Type, node.CountryCode, node.Server, node.Port, node.Phase)
		}
	}
	return hex.EncodeToString(hash.Sum(nil))
}

func (m *Manager) applyMutation(ctx context.Context, current *managerState, mutation stateMutation) error {
	if mutation.next == nil {
		return errors.New("state mutation returned no state")
	}
	if mutation.persist != nil {
		if err := m.store.Update(ctx, mutation.persist); err != nil {
			return err
		}
	}
	return nil
}

func (m *Manager) submit(ctx context.Context, build func(*managerState) (stateMutation, error)) error {
	if ctx == nil {
		ctx = context.Background()
	}
	command := stateCommand{ctx: ctx, build: build, result: make(chan error, 1)}
	select {
	case <-ctx.Done():
		return ctx.Err()
	case <-m.coordinatorContext.Done():
		return errManagerClosed
	case m.commands <- command:
	}
	select {
	case <-m.coordinatorContext.Done():
		return errManagerClosed
	case err := <-command.result:
		return err
	}
}

func cloneManagerState(source *managerState) *managerState {
	result := &managerState{items: make(map[string]Subscription, len(source.items))}
	for id, item := range source.items {
		result.items[id] = cloneSubscription(item)
	}
	return result
}

func unchangedState(current *managerState) stateMutation {
	return stateMutation{next: current}
}
