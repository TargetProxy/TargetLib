package subscriptions

import (
	"context"
	"errors"
)

var errManagerClosed = errors.New("subscription manager is closed")

type managerState struct {
	items map[string]Subscription
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
				m.snapshot.Store(current)
				for _, event := range mutation.events {
					m.publish(event.type_, event.item)
				}
			} else if mutation.failure != nil {
				current = mutation.failure
				m.snapshot.Store(current)
			}
			command.result <- err
		}
	}
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
