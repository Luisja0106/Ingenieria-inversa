package gui

import (
	"image/color"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/canvas"
	"fyne.io/fyne/v2/widget"

	"maze-solver/board"
)

// Cell colors
var (
	ColorFree    = color.NRGBA{R: 245, G: 245, B: 245, A: 255} // Light off-white
	ColorWall    = color.NRGBA{R: 40, G: 44, B: 52, A: 255}    // Dark charcoal
	ColorStart   = color.NRGBA{R: 46, G: 196, B: 182, A: 255}  // Teal / Cyan
	ColorGoal    = color.NRGBA{R: 230, G: 57, B: 70, A: 255}   // Crimson Red
	ColorVisited = color.NRGBA{R: 168, G: 218, B: 220, A: 255} // Soft Pastel Blue
	ColorPath    = color.NRGBA{R: 255, G: 183, B: 3, A: 255}   // Golden Yellow
	ColorAgent   = color.NRGBA{R: 142, G: 68, B: 173, A: 255}  // Purple
	ColorBorder  = color.NRGBA{R: 200, G: 200, B: 200, A: 255} // Border line
)

func getColorForCellType(t board.CellType) color.Color {
	switch t {
	case board.CellFree:
		return ColorFree
	case board.CellWall:
		return ColorWall
	case board.CellStart:
		return ColorStart
	case board.CellGoal:
		return ColorGoal
	case board.CellVisited:
		return ColorVisited
	case board.CellPath:
		return ColorPath
	case board.CellAgent:
		return ColorAgent
	default:
		return ColorFree
	}
}

// CellWidget is an interactive Fyne widget representing one cell on the board.
type CellWidget struct {
	widget.BaseWidget
	pos   board.Position
	b     *board.Board
	rect  *canvas.Rectangle
	onTap func(pos board.Position)
	size  fyne.Size
}

// NewCellWidget creates an interactive cell tied to a position on the board.
func NewCellWidget(pos board.Position, b *board.Board, size fyne.Size, onTap func(pos board.Position)) *CellWidget {
	cw := &CellWidget{
		pos:   pos,
		b:     b,
		size:  size,
		onTap: onTap,
	}

	cellType, _ := b.GetCell(pos)
	cw.rect = canvas.NewRectangle(getColorForCellType(cellType))
	cw.rect.StrokeColor = ColorBorder
	cw.rect.StrokeWidth = 1.0

	cw.ExtendBaseWidget(cw)
	return cw
}

func (cw *CellWidget) UpdateColor() {
	cellType, _ := cw.b.GetCell(cw.pos)
	cw.rect.FillColor = getColorForCellType(cellType)
	cw.rect.Refresh()
}

func (cw *CellWidget) Tapped(_ *fyne.PointEvent) {
	if cw.onTap != nil {
		cw.onTap(cw.pos)
	}
}

func (cw *CellWidget) CreateRenderer() fyne.WidgetRenderer {
	return &cellWidgetRenderer{
		widget: cw,
		rect:   cw.rect,
	}
}

type cellWidgetRenderer struct {
	widget *CellWidget
	rect   *canvas.Rectangle
}

func (r *cellWidgetRenderer) Layout(size fyne.Size) {
	r.rect.Resize(size)
}

func (r *cellWidgetRenderer) MinSize() fyne.Size {
	if r.widget.size.Width > 0 && r.widget.size.Height > 0 {
		return r.widget.size
	}
	return fyne.NewSize(28, 28)
}

func (r *cellWidgetRenderer) Refresh() {
	r.widget.UpdateColor()
}

func (r *cellWidgetRenderer) Objects() []fyne.CanvasObject {
	return []fyne.CanvasObject{r.rect}
}

func (r *cellWidgetRenderer) Destroy() {}
