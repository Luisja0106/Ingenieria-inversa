package search

import (
	"fmt"
	"strings"
	"time"

	"maze-solver/board"
)

// Metrics holds the performance and diagnostic indicators of a search execution.
type Metrics struct {
	SolutionFound  bool
	Steps          []string
	Cost           float64
	GoalPos        board.Position
	Duration       time.Duration
	NodesGenerated int
	NodesVisited   int
	NodesPending   int
}

// Result bundles the solution node, path, visited history, and metrics.
type Result struct {
	SolutionNode     *Node
	Path             []Action
	PathPositions    []board.Position
	VisitedPositions []board.Position
	Metrics          Metrics
}

// FormatSpanishSummary produces the user-facing diagnostic text in Spanish.
func (m Metrics) FormatSpanishSummary() string {
	solStr := "No"
	if m.SolutionFound {
		solStr = "Sí"
	}

	stepsStr := "Ninguno"
	if len(m.Steps) > 0 {
		stepsStr = strings.Join(m.Steps, ", ")
	}

	return fmt.Sprintf(
		"Solución encontrada: %s\n"+
			"Pasos tomados: %s\n"+
			"Costo del camino: %.0f\n"+
			"Posición de la meta: %s\n"+
			"Tiempo transcurrido: %v\n"+
			"Nodos generados: %d\n"+
			"Nodos visitados: %d\n"+
			"Nodos pendientes: %d",
		solStr,
		stepsStr,
		m.Cost,
		m.GoalPos.String(),
		m.Duration,
		m.NodesGenerated,
		m.NodesVisited,
		m.NodesPending,
	)
}
