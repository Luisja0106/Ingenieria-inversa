package board_test

import (
	"context"
	"testing"

	"maze-solver/board"
	"maze-solver/search"
)

func TestAllBlueprintsExistAndValid(t *testing.T) {
	names := board.GetBlueprintNames()
	if len(names) != 6 {
		t.Fatalf("expected 6 blueprints, got %d", len(names))
	}

	for _, name := range names {
		t.Run(name, func(t *testing.T) {
			bp, found := board.GetBlueprint(name)
			if !found {
				t.Fatalf("blueprint %s not found", name)
			}
			if bp.Rows != 10 || bp.Cols != 15 {
				t.Errorf("%s: expected 10x15, got %dx%d", name, bp.Rows, bp.Cols)
			}
			if !bp.Start.Equals(board.Position{Row: 2, Col: 0}) {
				t.Errorf("%s: expected start at (2, 0), got %v", name, bp.Start)
			}
			if !bp.Goal.Equals(board.Position{Row: 7, Col: 14}) {
				t.Errorf("%s: expected goal at (7, 14), got %v", name, bp.Goal)
			}

			b := bp.CreateBoard()
			if b.Cells[bp.Start.Row][bp.Start.Col] != board.CellStart {
				t.Errorf("%s: start cell is not CellStart", name)
			}
			if b.Cells[bp.Goal.Row][bp.Goal.Col] != board.CellGoal {
				t.Errorf("%s: goal cell is not CellGoal", name)
			}

			// Verify that BFS can solve every blueprint
			problem := search.NewProblem(b)
			bfs := search.NewBFS()
			res, err := bfs.Solve(context.Background(), problem, nil)
			if err != nil {
				t.Fatalf("%s: solve error: %v", name, err)
			}
			if !res.Metrics.SolutionFound {
				t.Errorf("%s: BFS should find a solution", name)
			}
		})
	}
}
