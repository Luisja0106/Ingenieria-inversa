package gui

import (
	"fmt"
	"strings"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"

	"maze-solver/search"
)

// MetricsPanel presents search diagnostics in Spanish.
type MetricsPanel struct {
	Container      *fyne.Container
	statusLabel    *widget.Label
	solutionLabel  *widget.Label
	costLabel      *widget.Label
	goalLabel      *widget.Label
	timeLabel      *widget.Label
	generatedLabel *widget.Label
	visitedLabel   *widget.Label
	pendingLabel   *widget.Label
	stepsEntry     *widget.Entry
}

// NewMetricsPanel creates a formatted results card.
func NewMetricsPanel() *MetricsPanel {
	mp := &MetricsPanel{
		statusLabel:    widget.NewLabelWithStyle("Estado: Listo", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		solutionLabel:  widget.NewLabel("Solución encontrada: -"),
		costLabel:      widget.NewLabel("Costo del camino: -"),
		goalLabel:      widget.NewLabel("Posición de la meta: -"),
		timeLabel:      widget.NewLabel("Tiempo transcurrido: -"),
		generatedLabel: widget.NewLabel("Nodos generados: 0"),
		visitedLabel:   widget.NewLabel("Nodos visitados: 0"),
		pendingLabel:   widget.NewLabel("Nodos pendientes: 0"),
		stepsEntry:     widget.NewMultiLineEntry(),
	}

	mp.stepsEntry.SetPlaceHolder("Los pasos de la solución aparecerán aquí...")
	mp.stepsEntry.Wrapping = fyne.TextWrapWord
	mp.stepsEntry.Disable() // Read-only

	stepsContainer := container.NewVScroll(mp.stepsEntry)
	stepsContainer.SetMinSize(fyne.NewSize(220, 100))

	header := widget.NewLabelWithStyle("Diagnóstico y Resultados", fyne.TextAlignLeading, fyne.TextStyle{Bold: true})

	cardContent := container.NewVBox(
		header,
		widget.NewSeparator(),
		mp.statusLabel,
		mp.solutionLabel,
		mp.costLabel,
		mp.goalLabel,
		mp.timeLabel,
		mp.generatedLabel,
		mp.visitedLabel,
		mp.pendingLabel,
		widget.NewLabelWithStyle("Secuencia de pasos:", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		stepsContainer,
	)

	mp.Container = container.NewPadded(cardContent)
	return mp
}

// SetStatus updates the status header.
func (mp *MetricsPanel) SetStatus(status string) {
	mp.statusLabel.SetText(fmt.Sprintf("Estado: %s", status))
}

// UpdateLiveMetrics updates the node counts during active search.
func (mp *MetricsPanel) UpdateLiveMetrics(m search.Metrics) {
	mp.generatedLabel.SetText(fmt.Sprintf("Nodos generados: %d", m.NodesGenerated))
	mp.visitedLabel.SetText(fmt.Sprintf("Nodos visitados: %d", m.NodesVisited))
	mp.pendingLabel.SetText(fmt.Sprintf("Nodos pendientes: %d", m.NodesPending))
}

// DisplayResult binds the final completed search metrics into the UI.
func (mp *MetricsPanel) DisplayResult(res *search.Result) {
	if res == nil {
		return
	}

	m := res.Metrics
	solText := "No"
	if m.SolutionFound {
		solText = "Sí"
		mp.SetStatus("¡Solución Encontrada!")
	} else {
		mp.SetStatus("Sin Solución")
	}

	mp.solutionLabel.SetText(fmt.Sprintf("Solución encontrada: %s", solText))
	mp.costLabel.SetText(fmt.Sprintf("Costo del camino: %.0f casillas", m.Cost))
	mp.goalLabel.SetText(fmt.Sprintf("Posición de la meta: %s", m.GoalPos.String()))
	mp.timeLabel.SetText(fmt.Sprintf("Tiempo transcurrido: %v", m.Duration))
	mp.generatedLabel.SetText(fmt.Sprintf("Nodos generados: %d", m.NodesGenerated))
	mp.visitedLabel.SetText(fmt.Sprintf("Nodos visitados: %d", m.NodesVisited))
	mp.pendingLabel.SetText(fmt.Sprintf("Nodos pendientes: %d", m.NodesPending))

	if len(m.Steps) > 0 {
		mp.stepsEntry.SetText(strings.Join(m.Steps, " -> "))
	} else {
		mp.stepsEntry.SetText("Sin pasos disponibles.")
	}
}

// Reset clears the panel to its initial state.
func (mp *MetricsPanel) Reset() {
	mp.statusLabel.SetText("Estado: Listo")
	mp.solutionLabel.SetText("Solución encontrada: -")
	mp.costLabel.SetText("Costo del camino: -")
	mp.goalLabel.SetText("Posición de la meta: -")
	mp.timeLabel.SetText("Tiempo transcurrido: -")
	mp.generatedLabel.SetText("Nodos generados: 0")
	mp.visitedLabel.SetText("Nodos visitados: 0")
	mp.pendingLabel.SetText("Nodos pendientes: 0")
	mp.stepsEntry.SetText("")
}
