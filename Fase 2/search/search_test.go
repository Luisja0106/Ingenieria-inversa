package search

import (
	"context"
	"testing"

	"maze-solver/board"
)

func TestBFSAndDFSSolvesDefaultBoard(t *testing.T) {
	b := board.DefaultBoard()
	p := NewProblem(b)

	algorithms := []Searcher{
		NewBFS(),
		NewDFS(),
	}

	for _, algo := range algorithms {
		t.Run(algo.Name(), func(t *testing.T) {
			res, err := algo.Solve(context.Background(), p, nil)
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if !res.Metrics.SolutionFound {
				t.Fatalf("expected solution to be found")
			}
			if len(res.Path) == 0 {
				t.Fatalf("expected non-empty path")
			}
			if len(res.PathPositions) != len(res.Path)+1 {
				t.Fatalf("path positions length mismatch")
			}
			if !res.PathPositions[0].Equals(b.Start) {
				t.Errorf("expected path to start at %v, got %v", b.Start, res.PathPositions[0])
			}
			if !res.PathPositions[len(res.PathPositions)-1].Equals(b.Goal) {
				t.Errorf("expected path to end at %v, got %v", b.Goal, res.PathPositions[len(res.PathPositions)-1])
			}
		})
	}
}

func TestBFSOptimality(t *testing.T) {
	b := board.DefaultBoard()
	p := NewProblem(b)

	bfs := NewBFS()
	dfs := NewDFS()

	bfsRes, err := bfs.Solve(context.Background(), p, nil)
	if err != nil || !bfsRes.Metrics.SolutionFound {
		t.Fatalf("BFS failed: %v", err)
	}

	dfsRes, err := dfs.Solve(context.Background(), p, nil)
	if err != nil || !dfsRes.Metrics.SolutionFound {
		t.Fatalf("DFS failed: %v", err)
	}

	// BFS must find a path with cost <= DFS path cost
	if bfsRes.Metrics.Cost > dfsRes.Metrics.Cost {
		t.Errorf("BFS path cost (%.0f) should be <= DFS path cost (%.0f)", bfsRes.Metrics.Cost, dfsRes.Metrics.Cost)
	}
}

func TestUnsolvableMaze(t *testing.T) {
	b := board.NewBoard(5, 5)
	// Surround goal with walls
	b.SetCell(board.Position{Row: 3, Col: 4}, board.CellWall)
	b.SetCell(board.Position{Row: 4, Col: 3}, board.CellWall)

	p := NewProblem(b)

	bfs := NewBFS()
	res, err := bfs.Solve(context.Background(), p, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if res.Metrics.SolutionFound {
		t.Errorf("expected no solution found for walled goal")
	}
}

func TestContextCancellation(t *testing.T) {
	b := board.DefaultBoard()
	p := NewProblem(b)

	ctx, cancel := context.WithCancel(context.Background())
	cancel() // cancel immediately

	bfs := NewBFS()
	_, err := bfs.Solve(ctx, p, nil)
	if err != context.Canceled {
		t.Errorf("expected context.Canceled error, got: %v", err)
	}
}
