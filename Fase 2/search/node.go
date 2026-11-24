package search

import "maze-solver/board"

// Node represents a search tree node containing state, parent link, and path cost.
type Node struct {
	State    State
	Parent   *Node
	Action   Action
	Depth    int
	PathCost float64
}

// NewRootNode initializes the root search node with initial state.
func NewRootNode(state State) *Node {
	return &Node{
		State:    state,
		Parent:   nil,
		Action:   nil,
		Depth:    0,
		PathCost: 0,
	}
}

// NewChildNode generates a child node from expanding a parent through an action.
func NewChildNode(parent *Node, action Action, state State) *Node {
	return &Node{
		State:    state,
		Parent:   parent,
		Action:   action,
		Depth:    parent.Depth + 1,
		PathCost: parent.PathCost + action.Cost(),
	}
}

// ReconstructPath returns the sequence of actions taken from the root to this node.
func (n *Node) ReconstructPath() []Action {
	var actions []Action
	curr := n
	for curr.Parent != nil {
		actions = append(actions, curr.Action)
		curr = curr.Parent
	}

	// Reverse to get root -> leaf order
	for i, j := 0, len(actions)-1; i < j; i, j = i+1, j-1 {
		actions[i], actions[j] = actions[j], actions[i]
	}
	return actions
}

// ReconstructPositions returns the sequence of grid coordinates from root to this node.
func (n *Node) ReconstructPositions() []board.Position {
	var positions []board.Position
	curr := n
	for curr != nil {
		positions = append(positions, curr.State.Pos)
		curr = curr.Parent
	}

	// Reverse to get root -> leaf order
	for i, j := 0, len(positions)-1; i < j; i, j = i+1, j-1 {
		positions[i], positions[j] = positions[j], positions[i]
	}
	return positions
}
