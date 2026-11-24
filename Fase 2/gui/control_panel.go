package gui

import (
	"time"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"

	"maze-solver/board"
	"maze-solver/search"
)

// EditMode determines the action when a user clicks a cell on the grid.
type EditMode int

const (
	EditModeToggleWall EditMode = iota
	EditModeSetStart
	EditModeSetGoal
)

// ControlPanel contains the user-interactive buttons and selectors.
type ControlPanel struct {
	Container       *fyne.Container
	MazeSelect      *widget.Select
	AlgorithmRadio  *widget.RadioGroup
	EditModeRadio   *widget.RadioGroup
	SpeedSelect     *widget.Select
	ResolveButton   *widget.Button
	StopButton      *widget.Button
	ResetButton     *widget.Button
	ClearButton     *widget.Button
	GetAlgorithm    func() search.Searcher
	GetEditMode     func() EditMode
	GetStepDelay    func() time.Duration
}

// NewControlPanel constructs the controls container.
func NewControlPanel(
	onSelectMaze func(name string),
	onResolve func(),
	onStop func(),
	onReset func(),
	onClear func(),
) *ControlPanel {
	cp := &ControlPanel{}

	// Pre-created Maze Selection (Dropdown Select)
	mazeNames := board.GetBlueprintNames()
	cp.MazeSelect = widget.NewSelect(mazeNames, func(selected string) {
		if onSelectMaze != nil && selected != "" {
			onSelectMaze(selected)
		}
	})
	if len(mazeNames) > 0 {
		cp.MazeSelect.SetSelected(mazeNames[0])
	}

	// Algorithm selection (Radio Buttons)
	algorithms := []string{
		"Búsqueda en Anchura (BFS)",
		"Búsqueda en Profundidad (DFS)",
	}
	cp.AlgorithmRadio = widget.NewRadioGroup(algorithms, nil)
	cp.AlgorithmRadio.SetSelected(algorithms[0])

	cp.GetAlgorithm = func() search.Searcher {
		if cp.AlgorithmRadio.Selected == algorithms[1] {
			return search.NewDFS()
		}
		return search.NewBFS()
	}

	// Edit Mode selection (Radio Buttons)
	editModes := []string{
		"Pared / Libre",
		"Fijar Inicio",
		"Fijar Meta",
	}
	cp.EditModeRadio = widget.NewRadioGroup(editModes, nil)
	cp.EditModeRadio.SetSelected(editModes[0])

	cp.GetEditMode = func() EditMode {
		switch cp.EditModeRadio.Selected {
		case editModes[1]:
			return EditModeSetStart
		case editModes[2]:
			return EditModeSetGoal
		default:
			return EditModeToggleWall
		}
	}

	// Animation speed select
	speeds := []string{"Instantáneo", "Rápido (15ms)", "Normal (40ms)", "Lento (90ms)"}
	cp.SpeedSelect = widget.NewSelect(speeds, nil)
	cp.SpeedSelect.SetSelected("Normal (40ms)")

	cp.GetStepDelay = func() time.Duration {
		switch cp.SpeedSelect.Selected {
		case "Instantáneo":
			return 0
		case "Rápido (15ms)":
			return 15 * time.Millisecond
		case "Lento (90ms)":
			return 90 * time.Millisecond
		default:
			return 40 * time.Millisecond
		}
	}

	// Action buttons
	cp.ResolveButton = widget.NewButton("▶ Resolver", onResolve)
	cp.ResolveButton.Importance = widget.HighImportance

	cp.StopButton = widget.NewButton("⏹ Detener", onStop)
	cp.StopButton.Importance = widget.DangerImportance
	cp.StopButton.Disable() // Disabled by default until search starts

	cp.ResetButton = widget.NewButton("↺ Reiniciar Tablero", onReset)
	cp.ClearButton = widget.NewButton("⌧ Limpiar Tablero", onClear)

	buttonGroup := container.NewVBox(
		cp.ResolveButton,
		cp.StopButton,
		cp.ResetButton,
		cp.ClearButton,
	)

	legend := container.NewVBox(
		widget.NewLabelWithStyle("Leyenda de Colores:", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		widget.NewLabel("🟦 Inicio (Verde/Azulado)  |  🟥 Meta (Rojo)"),
		widget.NewLabel("⬛ Pared (Oscuro)         |  ⬜ Libre (Blanco)"),
		widget.NewLabel("🩵 Visitado (Celeste)     |  🟨 Camino (Dorado)"),
	)

	content := container.NewVBox(
		widget.NewLabelWithStyle("Laberintos Precreados", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		cp.MazeSelect,
		widget.NewSeparator(),
		widget.NewLabelWithStyle("Algoritmo de Búsqueda", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		cp.AlgorithmRadio,
		widget.NewSeparator(),
		widget.NewLabelWithStyle("Edición de Casillas (Clic)", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		cp.EditModeRadio,
		widget.NewSeparator(),
		widget.NewLabelWithStyle("Velocidad de Búsqueda", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		cp.SpeedSelect,
		widget.NewSeparator(),
		widget.NewLabelWithStyle("Acciones", fyne.TextAlignLeading, fyne.TextStyle{Bold: true}),
		buttonGroup,
		widget.NewSeparator(),
		legend,
	)

	cp.Container = container.NewPadded(content)
	return cp
}

// SetSearchingState updates button states while search is running or stopped.
func (cp *ControlPanel) SetSearchingState(searching bool) {
	if searching {
		cp.MazeSelect.Disable()
		cp.ResolveButton.Disable()
		cp.ResetButton.Disable()
		cp.ClearButton.Disable()
		cp.StopButton.Enable()
	} else {
		cp.MazeSelect.Enable()
		cp.ResolveButton.Enable()
		cp.ResetButton.Enable()
		cp.ClearButton.Enable()
		cp.StopButton.Disable()
	}
}

// MapEditModeToCellType returns the cell type corresponding to the active edit mode.
func MapEditModeToCellType(mode EditMode) board.CellType {
	switch mode {
	case EditModeSetStart:
		return board.CellStart
	case EditModeSetGoal:
		return board.CellGoal
	default:
		return board.CellWall
	}
}
