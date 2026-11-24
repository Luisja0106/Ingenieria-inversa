package board

import "fmt"

// Default grid dimensions
const (
	DefaultRows = 10
	DefaultCols = 15
)

// Board represents the 2D maze environment.
type Board struct {
	Rows  int
	Cols  int
	Cells [][]CellType
	Start Position
	Goal  Position
}

// NewBoard initializes an empty board of given dimensions with default start and goal.
func NewBoard(rows, cols int) *Board {
	if rows < 2 {
		rows = 2
	}
	if cols < 2 {
		cols = 2
	}

	cells := make([][]CellType, rows)
	for r := 0; r < rows; r++ {
		cells[r] = make([]CellType, cols)
		for c := 0; c < cols; c++ {
			cells[r][c] = CellFree
		}
	}

	start := Position{Row: 0, Col: 0}
	goal := Position{Row: rows - 1, Col: cols - 1}
	cells[start.Row][start.Col] = CellStart
	cells[goal.Row][goal.Col] = CellGoal

	return &Board{
		Rows:  rows,
		Cols:  cols,
		Cells: cells,
		Start: start,
		Goal:  goal,
	}
}

// DefaultBoard returns a pre-configured standard maze board from the default blueprint.
func DefaultBoard() *Board {
	bp, found := GetBlueprint("Laberinto 1")
	if found {
		return bp.CreateBoard()
	}
	return NewBoard(DefaultRows, DefaultCols)
}

// InBounds checks if a position is within the board boundaries.
func (b *Board) InBounds(p Position) bool {
	return p.Row >= 0 && p.Row < b.Rows && p.Col >= 0 && p.Col < b.Cols
}

// IsWalkable returns true if the position can be traversed (not a wall and within bounds).
func (b *Board) IsWalkable(p Position) bool {
	if !b.InBounds(p) {
		return false
	}
	t := b.Cells[p.Row][p.Col]
	return t != CellWall
}

// GetCell returns the cell type at the given coordinate.
func (b *Board) GetCell(p Position) (CellType, error) {
	if !b.InBounds(p) {
		return CellFree, fmt.Errorf("position %v out of bounds", p)
	}
	return b.Cells[p.Row][p.Col], nil
}

// SetCell changes the cell type at (row, col) and updates Start/Goal references if necessary.
func (b *Board) SetCell(p Position, t CellType) error {
	if !b.InBounds(p) {
		return fmt.Errorf("position %v out of bounds", p)
	}

	if t == CellStart {
		// Clear previous start
		b.Cells[b.Start.Row][b.Start.Col] = CellFree
		b.Start = p
	} else if t == CellGoal {
		// Clear previous goal
		b.Cells[b.Goal.Row][b.Goal.Col] = CellFree
		b.Goal = p
	} else {
		// If overwriting existing start or goal with another type, guard or reassign
		if p.Equals(b.Start) && t != CellStart {
			return fmt.Errorf("cannot overwrite start cell with %s; move start cell instead", t)
		}
		if p.Equals(b.Goal) && t != CellGoal {
			return fmt.Errorf("cannot overwrite goal cell with %s; move goal cell instead", t)
		}
	}

	b.Cells[p.Row][p.Col] = t
	return nil
}

// CycleCellType cycles a cell between Free and Wall when clicked (unless it is Start or Goal).
func (b *Board) CycleCellType(p Position) CellType {
	if !b.InBounds(p) || p.Equals(b.Start) || p.Equals(b.Goal) {
		return b.Cells[p.Row][p.Col]
	}

	if b.Cells[p.Row][p.Col] == CellWall {
		b.Cells[p.Row][p.Col] = CellFree
	} else {
		b.Cells[p.Row][p.Col] = CellWall
	}
	return b.Cells[p.Row][p.Col]
}

// Clear resets all cells to Free, retaining Start and Goal.
func (b *Board) Clear() {
	for r := 0; r < b.Rows; r++ {
		for c := 0; c < b.Cols; c++ {
			b.Cells[r][c] = CellFree
		}
	}
	b.Cells[b.Start.Row][b.Start.Col] = CellStart
	b.Cells[b.Goal.Row][b.Goal.Col] = CellGoal
}

// ClearSearchVisuals removes Visited, Path, and Agent markers from the board.
func (b *Board) ClearSearchVisuals() {
	for r := 0; r < b.Rows; r++ {
		for c := 0; c < b.Cols; c++ {
			t := b.Cells[r][c]
			if t == CellVisited || t == CellPath || t == CellAgent {
				b.Cells[r][c] = CellFree
			}
		}
	}
	b.Cells[b.Start.Row][b.Start.Col] = CellStart
	b.Cells[b.Goal.Row][b.Goal.Col] = CellGoal
}

// Clone creates a deep copy of the board.
func (b *Board) Clone() *Board {
	cells := make([][]CellType, b.Rows)
	for r := 0; r < b.Rows; r++ {
		cells[r] = make([]CellType, b.Cols)
		copy(cells[r], b.Cells[r])
	}
	return &Board{
		Rows:  b.Rows,
		Cols:  b.Cols,
		Cells: cells,
		Start: b.Start,
		Goal:  b.Goal,
	}
}
