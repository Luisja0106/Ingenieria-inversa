package board

import "fmt"

// CellType represents the physical or visual state of a cell on the board.
type CellType int

const (
	CellFree CellType = iota
	CellWall
	CellStart
	CellGoal
	CellVisited
	CellPath
	CellAgent
)

// String returns a human-readable representation of the CellType.
func (c CellType) String() string {
	switch c {
	case CellFree:
		return "Libre"
	case CellWall:
		return "Pared"
	case CellStart:
		return "Inicio"
	case CellGoal:
		return "Meta"
	case CellVisited:
		return "Visitado"
	case CellPath:
		return "Camino"
	case CellAgent:
		return "Agente"
	default:
		return "Desconocido"
	}
}

// Position represents 2D row-column coordinates on the board.
type Position struct {
	Row int
	Col int
}

// String formats the Position as (row, col).
func (p Position) String() string {
	return fmt.Sprintf("(%d, %d)", p.Row, p.Col)
}

// Equals checks whether two positions point to the same coordinate.
func (p Position) Equals(other Position) bool {
	return p.Row == other.Row && p.Col == other.Col
}

// Cell represents an individual square within the maze board.
type Cell struct {
	Pos  Position
	Type CellType
}
