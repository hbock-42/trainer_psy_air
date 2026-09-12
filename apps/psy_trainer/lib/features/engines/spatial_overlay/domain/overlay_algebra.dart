/// The colour a grid cell shows once its covering tile-cells are combined
/// (spec §2.4-E; the algebra is documented, not just assumed, by the lesson
/// `assets/content/psy0/lessons/spatial_overlay/01-formes-glissees.fr.md`):
/// navy is neutral (navy+navy=navy, navy alone=navy) and grey inverts
/// (grey+grey=navy) -- reading it as parity, a covered cell is grey iff an
/// odd number of its covering tile-cells are grey, navy otherwise. A cell no
/// tile covers is [none] (the background).
enum CellColour { none, navy, grey }

/// What one cell of the *target* grid asks for.
///
/// [empty] and [black] both require [CellColour.none] underneath (no tile
/// may cover them); they are kept as separate values only because the real
/// test -- and our simulation, per the lesson's [!estimé] note -- paints a
/// black cell differently from a plain empty one, and difficulty counts
/// black cells separately from "just empty" (US-033 acceptance criteria:
/// "difficulty = tile count / overlap amount / black cells").
enum TargetCell { navy, grey, empty, black }

extension TargetCellRule on TargetCell {
  /// Whether [actual] (the colour a working grid computes for this cell)
  /// satisfies this target cell.
  bool matches(CellColour actual) => switch (this) {
    TargetCell.navy => actual == CellColour.navy,
    TargetCell.grey => actual == CellColour.grey,
    TargetCell.empty => actual == CellColour.none,
    TargetCell.black => actual == CellColour.none,
  };

  /// Whether nothing may be dragged onto this cell.
  bool get mustStayUncovered =>
      this == TargetCell.empty || this == TargetCell.black;
}

/// Combines the tiles covering one cell into the colour it shows:
/// uncovered ([coverCount] == 0) is [CellColour.none]; otherwise grey iff
/// [greyCount] is odd (see the enum doc above -- navy is the identity,
/// grey is its own inverse).
CellColour combineCoverage({required int coverCount, required int greyCount}) {
  if (coverCount == 0) return CellColour.none;
  return greyCount.isOdd ? CellColour.grey : CellColour.navy;
}
