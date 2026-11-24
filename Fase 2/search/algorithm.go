package search

import (
	"context"

	"maze-solver/board"
)

// StepEventType defines the nature of a search progress event.
type StepEventType int

const (
	StepNodeVisiting StepEventType = iota
	StepFrontierAdded
	StepGoalFound
)

// StepEvent carries real-time progress information from the searcher to observers.
type StepEvent struct {
	Type     StepEventType
	Position board.Position
	Node     *Node
	Metrics  Metrics
}

// StepObserver is a callback invoked during search execution.
type StepObserver func(event StepEvent)

// Searcher represents any search strategy conforming to the common contract.
type Searcher interface {
	Name() string
	Solve(ctx context.Context, problem *Problem, observer StepObserver) (*Result, error)
}
