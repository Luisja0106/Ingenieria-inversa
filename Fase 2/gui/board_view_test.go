package gui

import (
	"testing"

	"fyne.io/fyne/v2/test"

	"maze-solver/board"
)

func TestBoardViewSingleSourceOfTruth(t *testing.T) {
	_ = test.NewApp() // initializes test Fyne driver

	// 1. Initial 10x15 board
	b1 := board.NewBoard(10, 15)
	bv := NewBoardView(b1, nil)

	if len(bv.CellWidgets) != 10 {
		t.Fatalf("expected 10 rows of widgets, got %d", len(bv.CellWidgets))
	}
	if len(bv.CellWidgets[0]) != 15 {
		t.Fatalf("expected 15 cols of widgets, got %d", len(bv.CellWidgets[0]))
	}
	if len(bv.Container.Objects) != 150 {
		t.Fatalf("expected 150 container objects, got %d", len(bv.Container.Objects))
	}

	// 2. Dynamically re-bind to a 6x20 board
	b2 := board.NewBoard(6, 20)
	bv.LoadBoard(b2)

	if len(bv.CellWidgets) != 6 {
		t.Fatalf("expected 6 rows after re-binding, got %d", len(bv.CellWidgets))
	}
	if len(bv.CellWidgets[0]) != 20 {
		t.Fatalf("expected 20 cols after re-binding, got %d", len(bv.CellWidgets[0]))
	}
	if len(bv.Container.Objects) != 120 {
		t.Fatalf("expected 120 container objects, got %d", len(bv.Container.Objects))
	}

	// 3. Dynamically re-bind to a 30x8 board
	b3 := board.NewBoard(30, 8)
	bv.LoadBoard(b3)

	if len(bv.CellWidgets) != 30 {
		t.Fatalf("expected 30 rows after re-binding, got %d", len(bv.CellWidgets))
	}
	if len(bv.CellWidgets[0]) != 8 {
		t.Fatalf("expected 8 cols after re-binding, got %d", len(bv.CellWidgets[0]))
	}
	if len(bv.Container.Objects) != 240 {
		t.Fatalf("expected 240 container objects, got %d", len(bv.Container.Objects))
	}
}

func TestAppSessionPersistence(t *testing.T) {
	testApp := test.NewApp()
	a := NewAppWithFyne(testApp)
	if a.currentMaze != "Laberinto 1" {
		t.Fatalf("expected initial maze to be Laberinto 1, got %s", a.currentMaze)
	}

	// 1. Mutate cell (2, 1) in Laberinto 1 (initially Free) to Wall
	testPos := board.Position{Row: 2, Col: 1}
	if a.Board.Cells[testPos.Row][testPos.Col] != board.CellFree {
		t.Fatalf("expected cell (2, 1) to be initial Free")
	}
	_ = a.Board.SetCell(testPos, board.CellWall)

	// 2. Switch to Laberinto 2
	a.handleSelectMaze("Laberinto 2")
	if a.currentMaze != "Laberinto 2" {
		t.Fatalf("expected current maze to be Laberinto 2")
	}

	// 3. Switch back to Laberinto 1 and verify changes persisted
	a.handleSelectMaze("Laberinto 1")
	if a.currentMaze != "Laberinto 1" {
		t.Fatalf("expected current maze to be Laberinto 1")
	}
	if a.Board.Cells[testPos.Row][testPos.Col] != board.CellWall {
		t.Errorf("expected modified cell (2, 1) to remain CellWall across maze switch")
	}

	// 4. Reset current maze and verify it restores to blueprint Free
	a.handleReset()
	if a.Board.Cells[testPos.Row][testPos.Col] != board.CellFree {
		t.Errorf("expected reset to restore cell (2, 1) to CellFree")
	}
}
