package search

import (
	"context"
	"time"

	"maze-solver/board"
)

// DFS implements Depth-First Search.
type DFS struct{}

// NewDFS constructs a new Depth-First Search algorithm instance.
func NewDFS() *DFS {
	return &DFS{}
}

func (d *DFS) Name() string {
	return "Búsqueda en Profundidad (DFS)"
}

func (d *DFS) Solve(ctx context.Context, p *Problem, observer StepObserver) (*Result, error) {
	startTime := time.Now()

	root := NewRootNode(p.InitialState)
	nodesGenerated := 1
	nodesVisited := 0
	var visitedOrder []board.Position

	frontier := NewStack()
	frontier.Push(root)

	explored := make(map[board.Position]bool)

	for !frontier.IsEmpty() {
		select {
		case <-ctx.Done():
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

		// In graph DFS, skip if already explored
		if explored[node.State.Pos] {
			continue
		}

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

		// Goal check on pop
		if p.GoalTest(node.State) {
			path := node.ReconstructPath()
			var stepNames []string
			for _, a := range path {
				stepNames = append(stepNames, a.Name())
			}

			duration := time.Since(startTime)
			metrics := Metrics{
				SolutionFound:  true,
				Steps:          stepNames,
				Cost:           node.PathCost,
				GoalPos:        p.GoalPos,
				Duration:       duration,
				NodesGenerated: nodesGenerated,
				NodesVisited:   nodesVisited,
				NodesPending:   frontier.Size(),
			}

			if observer != nil {
				observer(StepEvent{Type: StepGoalFound, Position: node.State.Pos, Node: node, Metrics: metrics})
			}

			return &Result{
				SolutionNode:     node,
				Path:             path,
				PathPositions:    node.ReconstructPositions(),
				VisitedPositions: visitedOrder,
				Metrics:          metrics,
			}, nil
		}

		// Successors: to evaluate in natural order with LIFO, push in reverse so first action is popped first
		actions := p.Actions(node.State)
		for i := len(actions) - 1; i >= 0; i-- {
			action := actions[i]
			childState := p.Result(node.State, action)

			if !explored[childState.Pos] {
				childNode := NewChildNode(node, action, childState)
				nodesGenerated++
				frontier.Push(childNode)

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
