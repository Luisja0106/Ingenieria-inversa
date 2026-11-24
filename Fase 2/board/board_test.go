package board

import "testing"

func TestDefaultBoardDimensions(t *testing.T) {
	b := DefaultBoard()
	if b.Rows != 10 {
		t.Errorf("expected 10 rows, got %d", b.Rows)
	}
	if b.Cols != 15 {
		t.Errorf("expected 15 cols, got %d", b.Cols)
	}
	if !b.InBounds(b.Start) || !b.InBounds(b.Goal) {
		t.Errorf("start %v or goal %v out of bounds", b.Start, b.Goal)
	}
}

func TestNewBoard(t *testing.T) {
	b := NewBoard(10, 10)
	if b.Rows != 10 || b.Cols != 10 {
		t.Fatalf("expected 10x10 board, got %dx%d", b.Rows, b.Cols)
	}
	if !b.Start.Equals(Position{0, 0}) {
		t.Errorf("expected start at (0,0), got %v", b.Start)
	}
	if !b.Goal.Equals(Position{9, 9}) {
		t.Errorf("expected goal at (9,9), got %v", b.Goal)
	}
}

func TestWalkabilityAndBounds(t *testing.T) {
	b := NewBoard(5, 5)
	if !b.InBounds(Position{2, 2}) {
		t.Error("expected (2,2) to be in bounds")
	}
	if b.InBounds(Position{-1, 0}) || b.InBounds(Position{5, 5}) {
		t.Error("expected out of bounds positions to return false")
	}

	b.SetCell(Position{2, 2}, CellWall)
	if b.IsWalkable(Position{2, 2}) {
		t.Error("expected wall at (2,2) not to be walkable")
	}
	if !b.IsWalkable(Position{1, 1}) {
		t.Error("expected free cell at (1,1) to be walkable")
	}
}

func TestCycleCellType(t *testing.T) {
	b := NewBoard(5, 5)
	p := Position{2, 2}

	// Initial is Free
	if b.Cells[p.Row][p.Col] != CellFree {
		t.Fatalf("expected initial Free")
	}

	// 1st cycle -> Wall
	c1 := b.CycleCellType(p)
	if c1 != CellWall || b.Cells[p.Row][p.Col] != CellWall {
		t.Errorf("expected CellWall, got %v", c1)
	}

	// 2nd cycle -> Free
	c2 := b.CycleCellType(p)
	if c2 != CellFree || b.Cells[p.Row][p.Col] != CellFree {
		t.Errorf("expected CellFree, got %v", c2)
	}

	// Start and Goal must not cycle
	b.CycleCellType(b.Start)
	if b.Cells[b.Start.Row][b.Start.Col] != CellStart {
		t.Error("start cell should not be toggled")
	}
}

func TestClone(t *testing.T) {
	orig := DefaultBoard()
	clone := orig.Clone()

	if clone.Rows != orig.Rows || clone.Cols != orig.Cols {
		t.Fatal("dimensions mismatch")
	}

	// Modify clone and verify original is untouched
	clone.SetCell(Position{0, 0}, CellWall)
	if orig.Cells[0][0] == CellWall {
		t.Error("modifying clone affected original board")
	}
}
