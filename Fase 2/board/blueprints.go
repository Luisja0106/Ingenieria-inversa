package board

// Blueprint defines a static specification for a pre-created maze board.
type Blueprint struct {
	Name   string
	Rows   int
	Cols   int
	Start  Position
	Goal   Position
	Matrix [][]CellType
}

// CreateBoard constructs a new, independent *Board from the blueprint.
func (bp Blueprint) CreateBoard() *Board {
	cells := make([][]CellType, bp.Rows)
	for r := 0; r < bp.Rows; r++ {
		cells[r] = make([]CellType, bp.Cols)
		copy(cells[r], bp.Matrix[r])
	}
	return &Board{
		Rows:  bp.Rows,
		Cols:  bp.Cols,
		Cells: cells,
		Start: bp.Start,
		Goal:  bp.Goal,
	}
}

// Predefined maze blueprints
var blueprints = map[string]Blueprint{
	// Laberinto 1
	"Laberinto 1": {
		Name:  "Laberinto 1",
		Rows:  10,
		Cols:  15,
		Start: Position{Row: 2, Col: 0},
		Goal:  Position{Row: 7, Col: 14},
		Matrix: [][]CellType{
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellStart, CellFree, CellFree, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellWall, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellFree, CellGoal},
			{CellWall, CellFree, CellWall, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
		},
	},

	// Laberinto 2
	"Laberinto 2": {
		Name:  "Laberinto 2",
		Rows:  10,
		Cols:  15,
		Start: Position{Row: 2, Col: 0},
		Goal:  Position{Row: 7, Col: 14},
		Matrix: [][]CellType{
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall},
			{CellStart, CellFree, CellWall, CellFree, CellWall, CellWall, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellWall, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellGoal},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
		},
	},

	// Laberinto 3
	"Laberinto 3": {
		Name:  "Laberinto 3",
		Rows:  10,
		Cols:  15,
		Start: Position{Row: 2, Col: 0},
		Goal:  Position{Row: 7, Col: 14},
		Matrix: [][]CellType{
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellStart, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellGoal},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
		},
	},

	// Laberinto 4
	"Laberinto 4": {
		Name:  "Laberinto 4",
		Rows:  10,
		Cols:  15,
		Start: Position{Row: 2, Col: 0},
		Goal:  Position{Row: 7, Col: 14},
		Matrix: [][]CellType{
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellWall},
			{CellStart, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellWall, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellWall, CellWall, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellWall, CellWall, CellFree, CellFree, CellWall, CellFree, CellFree, CellGoal},
			{CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
		},
	},

	// Laberinto 5
	"Laberinto 5": {
		Name:  "Laberinto 5",
		Rows:  10,
		Cols:  15,
		Start: Position{Row: 2, Col: 0},
		Goal:  Position{Row: 7, Col: 14},
		Matrix: [][]CellType{
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
			{CellWall, CellFree, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall},
			{CellStart, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellWall, CellWall},
			{CellWall, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellGoal},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
		},
	},

	// Laberinto 6
	"Laberinto 6": {
		Name:  "Laberinto 6",
		Rows:  10,
		Cols:  15,
		Start: Position{Row: 2, Col: 0},
		Goal:  Position{Row: 7, Col: 14},
		Matrix: [][]CellType{
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall},
			{CellStart, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall},
			{CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellWall, CellFree, CellGoal},
			{CellWall, CellFree, CellWall, CellFree, CellFree, CellFree, CellFree, CellFree, CellWall, CellFree, CellFree, CellFree, CellWall, CellFree, CellWall},
			{CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall, CellWall},
		},
	},
}

// BlueprintOrder gives the canonical display ordering for preset selection.
var BlueprintOrder = []string{
	"Laberinto 1",
	"Laberinto 2",
	"Laberinto 3",
	"Laberinto 4",
	"Laberinto 5",
	"Laberinto 6",
}

// GetBlueprint retrieves a blueprint by its name.
func GetBlueprint(name string) (Blueprint, bool) {
	bp, found := blueprints[name]
	return bp, found
}

// GetAllBlueprints returns a slice of all registered blueprints in display order.
func GetAllBlueprints() []Blueprint {
	list := make([]Blueprint, len(BlueprintOrder))
	for i, name := range BlueprintOrder {
		list[i] = blueprints[name]
	}
	return list
}

// GetBlueprintNames returns the list of names for all available blueprints.
func GetBlueprintNames() []string {
	names := make([]string, len(BlueprintOrder))
	copy(names, BlueprintOrder)
	return names
}
