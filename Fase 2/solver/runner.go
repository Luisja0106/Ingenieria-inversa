package solver

import (
	"context"
	"fmt"
	"sync"
	"time"

	"maze-solver/board"
	"maze-solver/search"
)

// Status represents the execution state of the solver.
type Status int

const (
	StatusIdle Status = iota
	StatusSearching
	StatusStopped
	StatusCompleted
)

func (s Status) String() string {
	switch s {
	case StatusIdle:
		return "Inactivo"
	case StatusSearching:
		return "Buscando"
	case StatusStopped:
		return "Detenido"
	case StatusCompleted:
		return "Completado"
	default:
		return "Desconocido"
	}
}

// Runner manages goroutine execution, cancellation, and progress dispatching.
type Runner struct {
	mu           sync.Mutex
	board        *board.Board
	status       Status
	cancel       context.CancelFunc
	activeCancel context.CancelFunc
}

// NewRunner creates a solver runner tied to a maze board.
func NewRunner(b *board.Board) *Runner {
	return &Runner{
		board:  b,
		status: StatusIdle,
	}
}

// GetStatus returns the current execution status.
func (r *Runner) GetStatus() Status {
	r.mu.Lock()
	defer r.mu.Unlock()
	return r.status
}

// SolveAsync launches the search algorithm in a background goroutine.
func (r *Runner) SolveAsync(
	algo search.Searcher,
	stepDelay time.Duration,
	onStep func(search.StepEvent),
	onFinish func(*search.Result, error),
) error {
	r.mu.Lock()
	if r.status == StatusSearching {
		r.mu.Unlock()
		return fmt.Errorf("a search is already in progress")
	}

	ctx, cancel := context.WithCancel(context.Background())
	r.cancel = cancel
	r.activeCancel = cancel
	r.status = StatusSearching
	r.mu.Unlock()

	problem := search.NewProblem(r.board)

	go func() {
		var res *search.Result
		var err error

		defer func() {
			r.mu.Lock()
			if ctx.Err() != nil {
				r.status = StatusStopped
			} else {
				r.status = StatusCompleted
			}
			r.cancel = nil
			r.mu.Unlock()

			if onFinish != nil {
				onFinish(res, err)
			}
		}()

		var observer search.StepObserver
		if onStep != nil || stepDelay > 0 {
			observer = func(e search.StepEvent) {
				if onStep != nil {
					onStep(e)
				}
				if stepDelay > 0 {
					time.Sleep(stepDelay)
				}
			}
		}

		res, err = algo.Solve(ctx, problem, observer)
	}()

	return nil
}

// Stop cancels the running search immediately.
func (r *Runner) Stop() {
	r.mu.Lock()
	defer r.mu.Unlock()
	if r.cancel != nil {
		r.cancel()
		r.status = StatusStopped
	}
}
