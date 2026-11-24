package search

import "maze-solver/board"

// State models the state of the agent in the environment.
type State struct {
	Pos board.Position
}

// NewState creates a state at the given position.
func NewState(pos board.Position) State {
	return State{Pos: pos}
}

// Equals checks whether two states occupy the same position.
func (s State) Equals(other State) bool {
	return s.Pos.Equals(other.Pos)
}
