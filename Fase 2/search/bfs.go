package search

import (
	"context"
	"time"

	"maze-solver/board"
)

// BFS implements Breadth-First Search.
type BFS struct{}

// NewBFS constructs a new Breadth-First Search algorithm instance.
func NewBFS() *BFS {
	return &BFS{}
}

func (b *BFS) Name() string {
	return "Búsqueda en Anchura (BFS)"
}

func (b *BFS) Solve(ctx context.Context, p *Problem, observer StepObserver) (*Result, error) {
	startTime := time.Now()

	root := NewRootNode(p.InitialState)
	nodesGenerated := 1
	nodesVisited := 0
	var visitedOrder []board.Position

	// Check if root is already the goal
	if p.GoalTest(root.State) {
		duration := time.Since(startTime)
		metrics := Metrics{
			SolutionFound:  true,
			Steps:          []string{},
			Cost:           0,
			GoalPos:        p.GoalPos,
			Duration:       duration,
			NodesGenerated: nodesGenerated,
			NodesVisited:   1,
			NodesPending:   0,
		}
		if observer != nil {
			observer(StepEvent{Type: StepGoalFound, Position: root.State.Pos, Node: root, Metrics: metrics})
		}
		return &Result{
			SolutionNode:     root,
			Path:             []Action{},
			PathPositions:    []board.Position{root.State.Pos},
			VisitedPositions: []board.Position{root.State.Pos},
			Metrics:          metrics,
		}, nil
	}

	frontier := NewQueue()
	frontier.Push(root)

	// Keep track of explored positions and frontier positions to avoid re-expansion
	inFrontier := make(map[board.Position]bool)
	inFrontier[root.State.Pos] = true

	explored := make(map[board.Position]bool)

	for !frontier.IsEmpty() {
		select {
		case <-ctx.Done():
			// Search was stopped/cancelled
			duration := time.Since(startTime)
			return &Result{
				VisitedPositions: visitedOrder,
				Metrics: Metrics{
					SolutionFound:  false,
					GoalPos:        p.GoalPos,
					Duration:       duration,
					NodesGenerated: nodesGenerated,
					NodesVisited:   nodesVisited,
					NodesPending:   frontier.Size(),
				},
			}, ctx.Err()
		default:
		}

		node := frontier.Pop()
		delete(inFrontier, node.State.Pos)
		explored[node.State.Pos] = true
		nodesVisited++
		visitedOrder = append(visitedOrder, node.State.Pos)

		if observer != nil {
			observer(StepEvent{
				Type:     StepNodeVisiting,
				Position: node.State.Pos,
				Node:     node,
				Metrics: Metrics{
					NodesGenerated: nodesGenerated,
					NodesVisited:   nodesVisited,
					NodesPending:   frontier.Size(),
				},
			})
		}

		// Expand child nodes
		for _, action := range p.Actions(node.State) {
			childState := p.Result(node.State, action)

			if !explored[childState.Pos] && !inFrontier[childState.Pos] {
				childNode := NewChildNode(node, action, childState)
				nodesGenerated++

				// Goal test upon generation
				if p.GoalTest(childState) {
					nodesVisited++ // the goal was visited
					visitedOrder = append(visitedOrder, childState.Pos)
					path := childNode.ReconstructPath()
					var stepNames []string
					for _, a := range path {
						stepNames = append(stepNames, a.Name())
					}

					duration := time.Since(startTime)
					metrics := Metrics{
						SolutionFound:  true,
						Steps:          stepNames,
						Cost:           childNode.PathCost,
						GoalPos:        p.GoalPos,
						Duration:       duration,
						NodesGenerated: nodesGenerated,
						NodesVisited:   nodesVisited,
						NodesPending:   frontier.Size(),
					}

					if observer != nil {
						observer(StepEvent{Type: StepGoalFound, Position: childState.Pos, Node: childNode, Metrics: metrics})
					}

					return &Result{
						SolutionNode:     childNode,
						Path:             path,
						PathPositions:    childNode.ReconstructPositions(),
						VisitedPositions: visitedOrder,
						Metrics:          metrics,
					}, nil
				}

				frontier.Push(childNode)
				inFrontier[childState.Pos] = true

				if observer != nil {
					observer(StepEvent{
						Type:     StepFrontierAdded,
						Position: childState.Pos,
						Node:     childNode,
						Metrics: Metrics{
							NodesGenerated: nodesGenerated,
							NodesVisited:   nodesVisited,
							NodesPending:   frontier.Size(),
						},
					})
				}
			}
		}
	}

	// No solution found
	duration := time.Since(startTime)
	return &Result{
		SolutionNode:     nil,
		Path:             nil,
		PathPositions:    nil,
		VisitedPositions: visitedOrder,
		Metrics: Metrics{
			SolutionFound:  false,
			Steps:          nil,
			Cost:           0,
			GoalPos:        p.GoalPos,
			Duration:       duration,
			NodesGenerated: nodesGenerated,
			NodesVisited:   nodesVisited,
			NodesPending:   0,
		},
	}, nil
}
