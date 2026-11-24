package gui

import (
	"time"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"

	"maze-solver/board"
	"maze-solver/search"
	"maze-solver/solver"
)

// App orchestrates the entire desktop GUI application.
type App struct {
	FyneApp      fyne.App
	MainWindow   fyne.Window
	Board        *board.Board
	Runner       *solver.Runner
	BoardView    *BoardView
	ControlPanel *ControlPanel
	MetricsPanel *MetricsPanel
}

// NewApp initializes all components of the maze application.
func NewApp() *App {
	a := &App{
		FyneApp: app.NewWithID("com.mazesolver.ai"),
		Board:   board.DefaultBoard(),
	}

	a.MainWindow = a.FyneApp.NewWindow("Solucionador de Laberintos - IA")
	a.Runner = solver.NewRunner(a.Board)

	// Board view click callback
	a.BoardView = NewBoardView(a.Board, a.handleCellClick)

	// Controls
	a.ControlPanel = NewControlPanel(
		a.handleResolve,
		a.handleStop,
		a.handleReset,
		a.handleClear,
	)

	// Metrics display
	a.MetricsPanel = NewMetricsPanel()

	// Assemble layout
	// Left: Board Grid inside padded container
	boardContainer := container.NewCenter(a.BoardView.Container)

	// Right: Controls on top, Metrics on bottom
	sidebar := container.NewVScroll(
		container.NewVBox(
			a.ControlPanel.Container,
			widget.NewSeparator(),
			a.MetricsPanel.Container,
		),
	)
	sidebar.SetMinSize(fyne.NewSize(320, 600))

	split := container.NewHSplit(boardContainer, sidebar)
	split.SetOffset(0.65) // 65% board, 35% sidebar

	a.MainWindow.SetContent(split)
	a.MainWindow.Resize(fyne.NewSize(960, 640))

	return a
}

// Run starts the Fyne application event loop.
func (a *App) Run() {
	a.MainWindow.ShowAndRun()
}

func (a *App) handleCellClick(pos board.Position) {
	if a.Runner.GetStatus() == solver.StatusSearching {
		return // Do not mutate board during active search
	}

	// Remove visual traces of prior search when user modifies board
	a.Board.ClearSearchVisuals()

	mode := a.ControlPanel.GetEditMode()
	switch mode {
	case EditModeSetStart:
		_ = a.Board.SetCell(pos, board.CellStart)
	case EditModeSetGoal:
		_ = a.Board.SetCell(pos, board.CellGoal)
	default:
		a.Board.CycleCellType(pos)
	}

	a.BoardView.RefreshAll()
}

func (a *App) handleResolve() {
	if a.Runner.GetStatus() == solver.StatusSearching {
		return
	}

	// Clear previous search visualization
	a.Board.ClearSearchVisuals()
	a.BoardView.RefreshAll()

	a.ControlPanel.SetSearchingState(true)
	a.MetricsPanel.SetStatus("Buscando solución...")

	algo := a.ControlPanel.GetAlgorithm()
	delay := a.ControlPanel.GetStepDelay()

	err := a.Runner.SolveAsync(
		algo,
		delay,
		func(e search.StepEvent) {
			// Live progress update from search goroutine
			fyne.Do(func() {
				if e.Type == search.StepNodeVisiting {
					a.BoardView.HighlightCell(e.Position, board.CellVisited)
				}
				a.MetricsPanel.UpdateLiveMetrics(e.Metrics)
			})
		},
		func(res *search.Result, err error) {
			// Completion callback
			fyne.Do(func() {
				a.ControlPanel.SetSearchingState(false)

				if err != nil {
					a.MetricsPanel.SetStatus("Búsqueda detenida por el usuario")
					if res != nil {
						a.MetricsPanel.DisplayResult(res)
					}
					return
				}

				if res != nil && res.Metrics.SolutionFound {
					// Draw solution path
					for _, p := range res.PathPositions {
						if !p.Equals(a.Board.Start) && !p.Equals(a.Board.Goal) {
							a.Board.Cells[p.Row][p.Col] = board.CellPath
						}
					}
					a.BoardView.RefreshAll()

					// Animate agent along path if delay was selected
					if delay > 0 {
						go a.animateAgentPath(res.PathPositions, delay)
					}
				}

				a.MetricsPanel.DisplayResult(res)
			})
		},
	)

	if err != nil {
		a.ControlPanel.SetSearchingState(false)
		a.MetricsPanel.SetStatus("Error al iniciar búsqueda")
	}
}

func (a *App) animateAgentPath(positions []board.Position, delay time.Duration) {
	for _, pos := range positions {
		if a.Runner.GetStatus() == solver.StatusSearching {
			return
		}

		fyne.Do(func() {
			if !pos.Equals(a.Board.Start) && !pos.Equals(a.Board.Goal) {
				a.Board.Cells[pos.Row][pos.Col] = board.CellAgent
				a.BoardView.RefreshCell(pos)
			}
		})

		time.Sleep(delay + 20*time.Millisecond)

		fyne.Do(func() {
			if !pos.Equals(a.Board.Start) && !pos.Equals(a.Board.Goal) {
				a.Board.Cells[pos.Row][pos.Col] = board.CellPath
				a.BoardView.RefreshCell(pos)
			}
		})
	}
}

func (a *App) handleStop() {
	a.Runner.Stop()
	a.ControlPanel.SetSearchingState(false)
	a.MetricsPanel.SetStatus("Detenido")
}

func (a *App) handleReset() {
	a.Runner.Stop()
	defaultB := board.DefaultBoard()
	a.Board.Rows = defaultB.Rows
	a.Board.Cols = defaultB.Cols
	a.Board.Start = defaultB.Start
	a.Board.Goal = defaultB.Goal
	a.Board.Cells = defaultB.Cells

	a.BoardView.RefreshAll()
	a.ControlPanel.SetSearchingState(false)
	a.MetricsPanel.Reset()
}

func (a *App) handleClear() {
	a.Runner.Stop()
	a.Board.Clear()
	a.BoardView.RefreshAll()
	a.ControlPanel.SetSearchingState(false)
	a.MetricsPanel.Reset()
}
