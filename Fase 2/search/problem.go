package search

import "maze-solver/board"

// Problem formalizes the state space search problem.
type Problem struct {
	Board        *board.Board
	InitialState State
	GoalPos      board.Position
}

// NewProblem creates a search problem given a maze board.
func NewProblem(b *board.Board) *Problem {
	return &Problem{
		Board:        b,
		InitialState: NewState(b.Start),
		GoalPos:      b.Goal,
	}
}

// GoalTest checks whether the given state reached the goal coordinate.
func (p *Problem) GoalTest(s State) bool {
	return s.Pos.Equals(p.GoalPos)
}

// Actions returns all legal movement actions from the given state.
func (p *Problem) Actions(s State) []Action {
	var legal []Action
	for _, a := range AllActions {
		nextPos := a.Apply(s.Pos)
		if p.Board.IsWalkable(nextPos) {
			legal = append(legal, a)
		}
	}
	return legal
}

// Result computes the successor state resulting from taking action a in state s.
func (p *Problem) Result(s State, a Action) State {
	return State{Pos: a.Apply(s.Pos)}
}
