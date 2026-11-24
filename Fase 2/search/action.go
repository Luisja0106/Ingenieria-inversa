package search

import "maze-solver/board"

// Action represents a movement action that an agent can take.
type Action interface {
	Name() string
	Cost() float64
	Apply(pos board.Position) board.Position
}

// DirectionAction implements Action for 2D orthogonal grid movements.
type DirectionAction struct {
	name     string
	cost     float64
	deltaRow int
	deltaCol int
}

func (a DirectionAction) Name() string {
	return a.name
}

func (a DirectionAction) Cost() float64 {
	return a.cost
}

func (a DirectionAction) Apply(pos board.Position) board.Position {
	return board.Position{
		Row: pos.Row + a.deltaRow,
		Col: pos.Col + a.deltaCol,
	}
}

// Canonical search actions with Spanish names
var (
	ActionUp    = DirectionAction{name: "Arriba", cost: 1.0, deltaRow: -1, deltaCol: 0}
	ActionDown  = DirectionAction{name: "Abajo", cost: 1.0, deltaRow: 1, deltaCol: 0}
	ActionLeft  = DirectionAction{name: "Izquierda", cost: 1.0, deltaRow: 0, deltaCol: -1}
	ActionRight = DirectionAction{name: "Derecha", cost: 1.0, deltaRow: 0, deltaCol: 1}

	// Standard order of evaluation
	AllActions = []Action{ActionUp, ActionDown, ActionLeft, ActionRight}
)
