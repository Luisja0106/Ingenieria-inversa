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

	// In-memory runtime persistence
	activeBoards map[string]*board.Board
	currentMaze  string
}

// NewApp initializes all components of the maze application with default Fyne runtime.
func NewApp() *App {
	return NewAppWithFyne(app.NewWithID("com.mazesolver.ai"))
}

// NewAppWithFyne initializes the maze application with a specific fyne.App (useful for tests).
func NewAppWithFyne(fyneApp fyne.App) *App {
	initialMaze := "Laberinto 1"
	defaultBoard := board.DefaultBoard()

	a := &App{
		FyneApp:      fyneApp,
		Board:        defaultBoard,
		activeBoards: make(map[string]*board.Board),
		currentMaze:  initialMaze,
	}

	a.activeBoards[initialMaze] = defaultBoard

	a.MainWindow = a.FyneApp.NewWindow("Solucionador de Laberintos - IA")
	a.Runner = solver.NewRunner(a.Board)

	// Board view click callback
	a.BoardView = NewBoardView(a.Board, a.handleCellClick)

	// Controls
	a.ControlPanel = NewControlPanel(
		a.handleSelectMaze,
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

func (a *App) handleSelectMaze(name string) {
	if a.Runner.GetStatus() == solver.StatusSearching {
		return
	}
	if name == a.currentMaze && a.Board != nil {
		return
	}

	a.Runner.Stop()
	a.currentMaze = name

	// Retrieve existing modified board or instantiate from blueprint
	b, exists := a.activeBoards[name]
	if !exists {
		bp, found := board.GetBlueprint(name)
		if found {
			b = bp.CreateBoard()
		} else {
			b = board.DefaultBoard()
		}
		a.activeBoards[name] = b
	}

	a.Board = b
	a.Runner.SetBoard(a.Board)
	a.BoardView.LoadBoard(a.Board)
	a.ControlPanel.SetSearchingState(false)
	a.MetricsPanel.Reset()
}

func (a *App) handleStop() {
	a.Runner.Stop()
	a.ControlPanel.SetSearchingState(false)
	a.MetricsPanel.SetStatus("Detenido")
}

func (a *App) handleReset() {
	a.Runner.Stop()
	// Reset the active board for current maze back to its pristine blueprint
	bp, found := board.GetBlueprint(a.currentMaze)
	if found {
		a.Board = bp.CreateBoard()
	} else {
		a.Board = board.DefaultBoard()
	}
	a.activeBoards[a.currentMaze] = a.Board

	a.Runner.SetBoard(a.Board)
	a.BoardView.LoadBoard(a.Board)
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
