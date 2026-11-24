package search

// Frontier is an abstraction for open node collections during search.
type Frontier interface {
	Push(n *Node)
	Pop() *Node
	IsEmpty() bool
	Size() int
}

// Queue implements a FIFO frontier for Breadth-First Search (BFS).
type Queue struct {
	items []*Node
}

func NewQueue() *Queue {
	return &Queue{items: make([]*Node, 0)}
}

func (q *Queue) Push(n *Node) {
	q.items = append(q.items, n)
}

func (q *Queue) Pop() *Node {
	if len(q.items) == 0 {
		return nil
	}
	n := q.items[0]
	q.items = q.items[1:]
	return n
}

func (q *Queue) IsEmpty() bool {
	return len(q.items) == 0
}

func (q *Queue) Size() int {
	return len(q.items)
}

// Stack implements a LIFO frontier for Depth-First Search (DFS).
type Stack struct {
	items []*Node
}

func NewStack() *Stack {
	return &Stack{items: make([]*Node, 0)}
}

func (s *Stack) Push(n *Node) {
	s.items = append(s.items, n)
}

func (s *Stack) Pop() *Node {
	if len(s.items) == 0 {
		return nil
	}
	lastIdx := len(s.items) - 1
	n := s.items[lastIdx]
	s.items = s.items[:lastIdx]
	return n
}

func (s *Stack) IsEmpty() bool {
	return len(s.items) == 0
}

func (s *Stack) Size() int {
	return len(s.items)
}
