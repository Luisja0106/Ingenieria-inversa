package solver

import (
	"sync"
	"testing"
	"time"

	"maze-solver/board"
	"maze-solver/search"
)

func TestRunnerSolveAsync(t *testing.T) {
	b := board.DefaultBoard()
	runner := NewRunner(b)

	var wg sync.WaitGroup
	wg.Add(1)

	var result *search.Result
	var searchErr error

	err := runner.SolveAsync(
		search.NewBFS(),
		0,
		nil,
		func(r *search.Result, err error) {
			result = r
			searchErr = err
			wg.Done()
		},
	)
	if err != nil {
		t.Fatalf("failed to start async solve: %v", err)
	}

	wg.Wait()

	if searchErr != nil {
		t.Fatalf("async search returned error: %v", searchErr)
	}
	if result == nil || !result.Metrics.SolutionFound {
		t.Fatalf("expected solution to be found")
	}
	if runner.GetStatus() != StatusCompleted {
		t.Errorf("expected StatusCompleted, got %v", runner.GetStatus())
	}
}

func TestRunnerStop(t *testing.T) {
	b := board.DefaultBoard()
	runner := NewRunner(b)

	var wg sync.WaitGroup
	wg.Add(1)

	var result *search.Result
	var searchErr error

	// Add slight delay per step so we can stop it
	err := runner.SolveAsync(
		search.NewBFS(),
		50*time.Millisecond,
		nil,
		func(r *search.Result, err error) {
			result = r
			searchErr = err
			wg.Done()
		},
	)
	if err != nil {
		t.Fatalf("failed to start async solve: %v", err)
	}

	time.Sleep(10 * time.Millisecond)
	runner.Stop()

	wg.Wait()

	if runner.GetStatus() != StatusStopped {
		t.Errorf("expected StatusStopped, got %v", runner.GetStatus())
	}
	if searchErr == nil {
		t.Errorf("expected cancellation error upon stopping")
	}
	_ = result
}
