package gui

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/container"

	"maze-solver/board"
)

// BoardView encapsulates the visual grid of the maze.
type BoardView struct {
	Board       *board.Board
	Container   *fyne.Container
	CellWidgets [][]*CellWidget
	OnCellClick func(pos board.Position)
}

// NewBoardView initializes a new grid visualizer for the board.
func NewBoardView(b *board.Board, onCellClick func(pos board.Position)) *BoardView {
	bv := &BoardView{
		Board:       b,
		OnCellClick: onCellClick,
		CellWidgets: make([][]*CellWidget, b.Rows),
	}

	var objects []fyne.CanvasObject
	for r := 0; r < b.Rows; r++ {
		bv.CellWidgets[r] = make([]*CellWidget, b.Cols)
		for c := 0; c < b.Cols; c++ {
			pos := board.Position{Row: r, Col: c}
			cw := NewCellWidget(pos, b, func(p board.Position) {
				if bv.OnCellClick != nil {
					bv.OnCellClick(p)
				}
			})
			bv.CellWidgets[r][c] = cw
			objects = append(objects, cw)
		}
	}

	bv.Container = container.NewGridWithColumns(b.Cols, objects...)
	return bv
}

// RefreshCell updates a single cell's visual state.
func (bv *BoardView) RefreshCell(pos board.Position) {
	if bv.Board.InBounds(pos) {
		bv.CellWidgets[pos.Row][pos.Col].Refresh()
	}
}

// RefreshAll updates all cells on the board.
func (bv *BoardView) RefreshAll() {
	for r := 0; r < bv.Board.Rows; r++ {
		for c := 0; c < bv.Board.Cols; c++ {
			bv.CellWidgets[r][c].Refresh()
		}
	}
}

// HighlightCell marks a cell with a specific type and immediately refreshes it.
func (bv *BoardView) HighlightCell(pos board.Position, t board.CellType) {
	if bv.Board.InBounds(pos) {
		// Do not overwrite Start or Goal colors
		if !pos.Equals(bv.Board.Start) && !pos.Equals(bv.Board.Goal) {
			bv.Board.Cells[pos.Row][pos.Col] = t
		}
		bv.RefreshCell(pos)
	}
}
