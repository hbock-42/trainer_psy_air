import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/overlay_algebra.dart';
import '../domain/overlay_board.dart';
import '../domain/overlay_grid_engine.dart';
import '../domain/overlay_tile.dart';

/// The colours the domain algebra ([CellColour]) is painted with. Not part
/// of the design system: they are the activity's own semantics ("navy" and
/// "grey" are the rule names in the spec and the lesson), so they stay
/// fixed regardless of light/dark theme -- like the dominoes' pip colour.
class _OverlayColours {
  static const Color navy = Color(0xFF1B2A4A);
  static const Color grey = Color(0xFF9AA1AC);
  static const Color black = Color(0xFF14161A);

  static Color of(CellColour colour) => switch (colour) {
    CellColour.navy => navy,
    CellColour.grey => grey,
    CellColour.none => const Color(0x00000000),
  };
}

/// The widget half of `spatial_overlay` (US-033, spec §2.4-E): drag 3-4
/// tile-shapes from the tray onto the central grid so that, under the
/// overlay rules, it reproduces the target grid. Touch only
/// ([InputRequirement.touch] in `family.json`, `answerFormat: drag`): no
/// keyboard map.
class OverlayGridRenderer extends ActivityRenderer {
  const OverlayGridRenderer();

  @override
  String get familyId => 'spatial_overlay';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _OverlayGridBoard(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _OverlayGridExample();

  /// `Key` of the tray tile at [tileIndex] (only present while it is still
  /// in the tray).
  static Key trayTileKey(int tileIndex) => Key('overlay_grid.tray.$tileIndex');

  /// `Key` of the tile once placed on the grid, at [tileIndex].
  static Key placedTileKey(int tileIndex) =>
      Key('overlay_grid.placed.$tileIndex');

  static const Key resetKey = Key('overlay_grid.reset');

  /// A `GlobalKey`, not a plain `ValueKey`: [_GridArea] reads its own
  /// render box back through this key to convert a drop's global offset
  /// into a grid cell (see `_cellOfGlobalOffset`).
  static final GlobalKey gridKey = GlobalKey();
}

class _OverlayGridBoard extends StatefulWidget {
  const _OverlayGridBoard({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_OverlayGridBoard> createState() => _OverlayGridBoardState();
}

class _OverlayGridBoardState extends State<_OverlayGridBoard> {
  late final OverlayBoard _board = OverlayGridEngine.boardOf(
    widget.render.item as GeneratedItem,
  );
  late List<(int, int)?> _positions = List<(int, int)?>.filled(
    _board.tiles.length,
    null,
  );
  int _moves = 0;
  bool _answered = false;

  void _reset() {
    if (_answered || !widget.render.acceptsInput) return;
    setState(() {
      _positions = List<(int, int)?>.filled(_board.tiles.length, null);
    });
  }

  void _drop(int tileIndex, int row, int col) {
    if (_answered || !widget.render.acceptsInput) return;
    final tile = _board.tiles[tileIndex];
    final maxRow = _board.gridRows - tile.rows;
    final maxCol = _board.gridCols - tile.cols;
    if (maxRow < 0 || maxCol < 0) return;
    final clampedRow = row < 0 ? 0 : (row > maxRow ? maxRow : row);
    final clampedCol = col < 0 ? 0 : (col > maxCol ? maxCol : col);
    setState(() {
      _positions[tileIndex] = (clampedRow, clampedCol);
      _moves++;
    });
    _checkSolved();
  }

  void _unplace(int tileIndex) {
    if (_answered || !widget.render.acceptsInput) return;
    if (_positions[tileIndex] == null) return;
    setState(() {
      _positions[tileIndex] = null;
      _moves++;
    });
  }

  void _checkSolved() {
    final working = computeWorkingGrid(
      gridRows: _board.gridRows,
      gridCols: _board.gridCols,
      tiles: _board.tiles,
      positions: _positions,
    );
    if (matchesTarget(working, _board.target)) {
      _answered = true;
      widget.render.onAnswer(
        Answer.raw({
          'tilePositions': [
            for (final p in _positions)
              if (p == null) null else [p.$1, p.$2],
          ],
          'moves': _moves,
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final showsSolution = render.showsFeedback && render.isAnswered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.overlayGridTargetLabel,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.xs),
        // A small, height-bounded preview -- unlike the working grid below
        // (in an `Expanded`), this must not compete for the column's
        // vertical space: an unbounded `AspectRatio` here would happily
        // claim the whole available height before the tray and the reset
        // button get to lay out.
        SizedBox(
          height: 110,
          child: Center(
            child: AspectRatio(
              aspectRatio: _board.gridCols / _board.gridRows,
              child: _TargetPreview(board: _board),
            ),
          ),
        ),
        SizedBox(height: theme.spacing.md),
        Text(
          showsSolution
              ? AppStrings.overlayGridSolutionCaption
              : AppStrings.overlayGridWorkingLabel,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.xs),
        Expanded(
          child: _GridArea(
            board: _board,
            positions: showsSolution
                ? [for (final p in _board.solutionPositions) p]
                : _positions,
            acceptsInput: render.acceptsInput && !showsSolution,
            onDrop: _drop,
            onUnplaceTap: showsSolution ? null : _unplace,
          ),
        ),
        if (!showsSolution) ...[
          SizedBox(height: theme.spacing.md),
          Text(
            AppStrings.overlayGridTrayLabel,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.xs),
          _Tray(
            board: _board,
            positions: _positions,
            acceptsInput: render.acceptsInput,
          ),
          SizedBox(height: theme.spacing.md),
          SecondaryButton(
            key: OverlayGridRenderer.resetKey,
            label: AppStrings.overlayGridResetAction,
            onPressed: render.acceptsInput ? _reset : null,
          ),
        ],
      ],
    );
  }
}

/// The interactive grid: a [DragTarget] the whole grid area accepts tile
/// indices onto, snapping the drop point to the nearest cell.
class _GridArea extends StatefulWidget {
  const _GridArea({
    required this.board,
    required this.positions,
    required this.acceptsInput,
    required this.onDrop,
    required this.onUnplaceTap,
  });

  final OverlayBoard board;
  final List<(int, int)?> positions;
  final bool acceptsInput;
  final void Function(int tileIndex, int row, int col) onDrop;

  /// Tapping a placed tile sends it back to the tray; null when read-only
  /// (the practice solution view).
  final void Function(int tileIndex)? onUnplaceTap;

  @override
  State<_GridArea> createState() => _GridAreaState();
}

class _GridAreaState extends State<_GridArea> {
  (int, int)? _cellOfGlobalOffset(Offset globalOffset, double cellSize) {
    final box = OverlayGridRenderer.gridKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached) return null;
    final local = box.globalToLocal(globalOffset);
    final row = (local.dy / cellSize).floor();
    final col = (local.dx / cellSize).floor();
    if (row < 0 ||
        col < 0 ||
        row >= widget.board.gridRows ||
        col >= widget.board.gridCols) {
      return null;
    }
    return (row, col);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final board = widget.board;
    return LayoutBuilder(
      builder: (context, constraints) {
        // A `Column`/`Expanded` pair gives this widget *tight* constraints
        // on both axes, so an `AspectRatio` here would just fill that
        // (possibly non-square) box instead of enforcing 1:1 -- the cell
        // size is computed from both dimensions instead, and the resulting
        // square is centred in whatever rectangle the layout gives us.
        final cellSize = math.min(
          constraints.maxWidth / board.gridCols,
          constraints.maxHeight / board.gridRows,
        );
        return Center(
          child: SizedBox(
            width: cellSize * board.gridCols,
            height: cellSize * board.gridRows,
            child: DragTarget<int>(
              onWillAcceptWithDetails: (_) => widget.acceptsInput,
              onAcceptWithDetails: (details) {
                final cell = _cellOfGlobalOffset(details.offset, cellSize);
                if (cell != null) {
                  widget.onDrop(details.data, cell.$1, cell.$2);
                }
              },
              builder: (context, candidateData, rejectedData) => DecoratedBox(
                key: OverlayGridRenderer.gridKey,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colors.borderStrong,
                    width: 2,
                  ),
                  borderRadius: theme.radii.smAll,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _CellGridLines(rows: board.gridRows, cols: board.gridCols),
                    // The *live overlay preview*: the actual navy/grey a
                    // cell shows right now, computed by the same algebra
                    // the scorer uses -- not just "whichever tile is drawn
                    // last", which would misrepresent an overlap (e.g.
                    // grey+grey=navy) as plain grey.
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WorkingGridPainter(
                          working: computeWorkingGrid(
                            gridRows: board.gridRows,
                            gridCols: board.gridCols,
                            tiles: board.tiles,
                            positions: widget.positions,
                          ),
                          gridRows: board.gridRows,
                          gridCols: board.gridCols,
                          cellSize: cellSize,
                        ),
                      ),
                    ),
                    for (var i = 0; i < board.tiles.length; i++)
                      if (widget.positions[i] != null)
                        Positioned(
                          key: OverlayGridRenderer.placedTileKey(i),
                          top: widget.positions[i]!.$1 * cellSize,
                          left: widget.positions[i]!.$2 * cellSize,
                          width: board.tiles[i].cols * cellSize,
                          height: board.tiles[i].rows * cellSize,
                          child: _DraggableTileVisual(
                            tile: board.tiles[i],
                            tileIndex: i,
                            cellSize: cellSize,
                            acceptsInput: widget.acceptsInput,
                            onTap: widget.onUnplaceTap == null
                                ? null
                                : () => widget.onUnplaceTap!(i),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Faint cell outlines behind the placed tiles, so the grid reads as a
/// grid even where nothing is dropped yet.
class _CellGridLines extends StatelessWidget {
  const _CellGridLines({required this.rows, required this.cols});

  final int rows;
  final int cols;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      children: [
        for (var r = 0; r < rows; r++)
          Expanded(
            child: Row(
              children: [
                for (var c = 0; c < cols; c++)
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colors.border),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One placed tile: its shape drawn cell by cell, draggable to move it
/// (still onto the same [_GridArea]'s `DragTarget`) and tappable to send it
/// back to the tray.
class _DraggableTileVisual extends StatelessWidget {
  const _DraggableTileVisual({
    required this.tile,
    required this.tileIndex,
    required this.cellSize,
    required this.acceptsInput,
    required this.onTap,
  });

  final TileShape tile;
  final int tileIndex;
  final double cellSize;
  final bool acceptsInput;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Resting on the grid, the tile draws as an outline only: its *fill*
    // colour would just be whichever tile happens to be drawn last, hiding
    // an overlap's true combined colour (the live preview painted behind
    // it, see `_GridAreaState.build`). Dragging shows the tile's own
    // colours (an opaque `feedback`/dimmed `childWhenDragging`), since a
    // tile in flight isn't part of the grid's current overlay yet.
    final resting = _TileShapeVisual(
      tile: tile,
      cellSize: cellSize,
      outlineOnly: true,
    );
    if (!acceptsInput) return resting;
    final dragVisual = _TileShapeVisual(tile: tile, cellSize: cellSize);
    return GestureDetector(
      onTap: onTap,
      child: Draggable<int>(
        data: tileIndex,
        feedback: Opacity(opacity: 0.85, child: dragVisual),
        childWhenDragging: Opacity(opacity: 0.25, child: dragVisual),
        child: Semantics(
          label: AppStrings.overlayGridTileSemantics(tileIndex),
          child: resting,
        ),
      ),
    );
  }
}

/// The tile's cells painted at [cellSize], transparent where the tile's
/// bounding box has no cell. A single `CustomPaint` leaf (ARCHITECTURE.md:
/// "Vector drawing with CustomPainter; no image assets") rather than a grid
/// of nested `Row`/`Column`/`Padding` widgets -- besides being the
/// project's convention, a deeply nested `Column` of `Row`s of
/// padded cells sitting inside a `Draggable` was found (in widget tests) to
/// occasionally leave that subtree unreachable by hit-testing, even though
/// it laid out and painted correctly; a flat leaf sidesteps the question
/// entirely.
class _TileShapeVisual extends StatelessWidget {
  const _TileShapeVisual({
    required this.tile,
    required this.cellSize,
    this.outlineOnly = false,
    super.key,
  });

  final TileShape tile;
  final double cellSize;

  /// Draw only each cell's border, no fill -- used for a tile resting on
  /// the grid, so whatever is painted *behind* it (the live overlay
  /// preview) stays the visible colour.
  final bool outlineOnly;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tile.cols * cellSize,
      height: tile.rows * cellSize,
      child: CustomPaint(
        painter: _TileShapePainter(
          tile: tile,
          cellSize: cellSize,
          outlineOnly: outlineOnly,
        ),
      ),
    );
  }
}

class _TileShapePainter extends CustomPainter {
  const _TileShapePainter({
    required this.tile,
    required this.cellSize,
    this.outlineOnly = false,
  });

  final TileShape tile;
  final double cellSize;
  final bool outlineOnly;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (row, col, colour) in tile.offsets) {
      final rect = Rect.fromLTWH(
        col * cellSize + 1,
        row * cellSize + 1,
        cellSize - 2,
        cellSize - 2,
      );
      if (outlineOnly) {
        canvas.drawRect(
          rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = _OverlayColours.of(colour),
        );
      } else {
        canvas.drawRect(rect, Paint()..color = _OverlayColours.of(colour));
      }
    }
  }

  @override
  bool shouldRepaint(_TileShapePainter oldDelegate) =>
      oldDelegate.tile != tile ||
      oldDelegate.cellSize != cellSize ||
      oldDelegate.outlineOnly != outlineOnly;
}

/// The grid's live overlay preview: the actual combined colour
/// [computeWorkingGrid] gives each cell right now, painted full-bleed
/// (no per-cell gap) so it reads as one continuous surface behind the
/// tiles' outlines.
class _WorkingGridPainter extends CustomPainter {
  const _WorkingGridPainter({
    required this.working,
    required this.gridRows,
    required this.gridCols,
    required this.cellSize,
  });

  final List<CellColour> working;
  final int gridRows;
  final int gridCols;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var r = 0; r < gridRows; r++) {
      for (var c = 0; c < gridCols; c++) {
        final colour = working[r * gridCols + c];
        if (colour == CellColour.none) continue;
        paint.color = _OverlayColours.of(colour);
        canvas.drawRect(
          Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WorkingGridPainter oldDelegate) =>
      oldDelegate.working != working ||
      oldDelegate.gridRows != gridRows ||
      oldDelegate.gridCols != gridCols ||
      oldDelegate.cellSize != cellSize;
}

/// The tray of tiles not yet placed on the grid.
class _Tray extends StatelessWidget {
  const _Tray({
    required this.board,
    required this.positions,
    required this.acceptsInput,
  });

  final OverlayBoard board;
  final List<(int, int)?> positions;
  final bool acceptsInput;

  static const double _trayCellSize = 20;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      height: _trayCellSize * 3 + theme.spacing.sm * 2,
      child: Wrap(
        spacing: theme.spacing.md,
        runSpacing: theme.spacing.sm,
        children: [
          for (var i = 0; i < board.tiles.length; i++)
            if (positions[i] == null)
              Padding(
                padding: EdgeInsets.all(theme.spacing.xs),
                child: acceptsInput
                    ? Draggable<int>(
                        key: OverlayGridRenderer.trayTileKey(i),
                        data: i,
                        feedback: Opacity(
                          opacity: 0.85,
                          child: _TileShapeVisual(
                            tile: board.tiles[i],
                            cellSize: _trayCellSize,
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.25,
                          child: _TileShapeVisual(
                            tile: board.tiles[i],
                            cellSize: _trayCellSize,
                          ),
                        ),
                        child: Semantics(
                          label: AppStrings.overlayGridTileSemantics(i),
                          child: _TileShapeVisual(
                            tile: board.tiles[i],
                            cellSize: _trayCellSize,
                          ),
                        ),
                      )
                    : _TileShapeVisual(
                        key: OverlayGridRenderer.trayTileKey(i),
                        tile: board.tiles[i],
                        cellSize: _trayCellSize,
                      ),
              ),
        ],
      ),
    );
  }
}

/// The read-only target grid shown above the working grid.
class _TargetPreview extends StatelessWidget {
  const _TargetPreview({required this.board});

  final OverlayBoard board;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderStrong, width: 2),
        borderRadius: theme.radii.smAll,
      ),
      child: Column(
        children: [
          for (var r = 0; r < board.gridRows; r++)
            Expanded(
              child: Row(
                children: [
                  for (var c = 0; c < board.gridCols; c++)
                    Expanded(
                      child: _TargetCellView(
                        cell: board.target[r * board.gridCols + c],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TargetCellView extends StatelessWidget {
  const _TargetCellView({required this.cell});

  final TargetCell cell;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final color = switch (cell) {
      TargetCell.navy => _OverlayColours.navy,
      TargetCell.grey => _OverlayColours.grey,
      TargetCell.black => _OverlayColours.black,
      TargetCell.empty => theme.colors.surface,
    };
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: theme.colors.border),
      ),
    );
  }
}

/// A worked example for the briefing screen: a fixed, non-interactive small
/// board (the lesson's first guided example).
class _OverlayGridExample extends StatelessWidget {
  const _OverlayGridExample();

  static final OverlayBoard _board = buildOverlayBoard(
    seed: 1,
    params: const OverlayGridParams(
      grid: GridSize(rows: 2, cols: 2),
      tileCount: 2,
      blackCells: false,
    ),
    difficulty: 2,
  );

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: IgnorePointer(child: _TargetPreview(board: _board)),
        ),
        SizedBox(height: theme.spacing.sm),
        Text(
          AppStrings.overlayGridExampleCaption,
          style: theme.textStyles.caption,
        ),
      ],
    );
  }
}
