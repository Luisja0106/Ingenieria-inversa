package gui

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"

	"maze-solver/board"
)

// BoardView encapsulates the visual grid of the maze.
// It is purely reactive: all dimensions, bounds, and states are driven by the underlying board.
type BoardView struct {
	Board       *board.Board
	Container   *fyne.Container
	CellWidgets [][]*CellWidget
	OnCellClick func(pos board.Position)
}

// NewBoardView initializes a dynamic grid visualizer for the board.
func NewBoardView(b *board.Board, onCellClick func(pos board.Position)) *BoardView {
	bv := &BoardView{
		OnCellClick: onCellClick,
		Container:   container.NewWithoutLayout(),
	}
	bv.LoadBoard(b)
	return bv
}

// LoadBoard rebuilds the visual grid to match the given board model as the Single Source of Truth.
func (bv *BoardView) LoadBoard(b *board.Board) {
	bv.Board = b
	bv.CellWidgets = make([][]*CellWidget, b.Rows)

	// Calculate responsive cell dimensions based on row/column count
	cellDim := calculateCellDimension(b.Rows, b.Cols)
	cellSize := fyne.NewSize(cellDim, cellDim)

	var objects []fyne.CanvasObject
	for r := 0; r < b.Rows; r++ {
		bv.CellWidgets[r] = make([]*CellWidget, b.Cols)
		for c := 0; c < b.Cols; c++ {
			pos := board.Position{Row: r, Col: c}
			cw := NewCellWidget(pos, b, cellSize, func(p board.Position) {
				if bv.OnCellClick != nil {
					bv.OnCellClick(p)
				}
			})
			bv.CellWidgets[r][c] = cw
			objects = append(objects, cw)
		}
	}

	bv.Container.Layout = layout.NewGridLayoutWithColumns(b.Cols)
	bv.Container.Objects = objects
	bv.Container.Refresh()
}

// calculateCellDimension determines responsive cell pixel size according to board dimensions.
func calculateCellDimension(rows, cols int) float32 {
	maxDim := cols
	if rows > maxDim {
		maxDim = rows
	}
	if maxDim <= 0 {
		return 28
	}

	dim := float32(450 / maxDim)
	if dim < 14 {
		return 14
	}
	if dim > 36 {
		return 36
	}
	return dim
}

// RefreshCell updates a single cell's visual state.
func (bv *BoardView) RefreshCell(pos board.Position) {
	if bv.Board != nil && bv.Board.InBounds(pos) {
		bv.CellWidgets[pos.Row][pos.Col].Refresh()
	}
}

// RefreshAll updates all cells on the board.
func (bv *BoardView) RefreshAll() {
	if bv.Board == nil {
		return
	}
	for r := 0; r < bv.Board.Rows; r++ {
		for c := 0; c < bv.Board.Cols; c++ {
			bv.CellWidgets[r][c].Refresh()
		}
	}
}

// HighlightCell marks a cell with a specific type and immediately refreshes it.
func (bv *BoardView) HighlightCell(pos board.Position, t board.CellType) {
	if bv.Board != nil && bv.Board.InBounds(pos) {
		// Do not overwrite Start or Goal colors
		if !pos.Equals(bv.Board.Start) && !pos.Equals(bv.Board.Goal) {
			bv.Board.Cells[pos.Row][pos.Col] = t
		}
		bv.RefreshCell(pos)
	}
}
