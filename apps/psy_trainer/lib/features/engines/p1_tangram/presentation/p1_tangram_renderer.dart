import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../../../train/presentation/renderers/numeric_renderer.dart';
import '../domain/p1_tangram_engine.dart';
import '../domain/tangram_board.dart';
import '../domain/tangram_geometry.dart';
import '../domain/tangram_piece.dart';
import 'tangram_painter.dart';

/// The widget half of `p1_tangram` (US-109, spec §2.3-2): `compose` mode
/// drags/rotates/flips the 7 pieces onto a workspace to reproduce the
/// target silhouette (auto-validates on exact cover); `count_occurrences`
/// mode shows the same kind of compound figure, read-only, above a numeric
/// keypad (reusing [NumericRenderer], the same composition
/// `MentalArithmeticRenderer` uses for its own numeric sub-mode).
class TangramRenderer extends ActivityRenderer {
  const TangramRenderer();

  static const _numericRenderer = NumericRenderer(
    familyId: 'p1_tangram',
    header: _countFigureHeader,
  );

  @override
  String get familyId => 'p1_tangram';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    return switch (render.item) {
      GeneratedItem() => _TangramComposeBoard(
        key: ValueKey(render.item.id),
        render: render,
      ),
      NumericItem() => _numericRenderer.build(context, render),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final mode = (run?.params as P1TangramParams?)?.mode ?? TangramMode.compose;
    return mode == TangramMode.countOccurrences
        ? _numericRenderer.buildExample(context, run)
        : const _TangramComposeExample();
  }

  static Widget _countFigureHeader(
    BuildContext context,
    ActivityRenderContext render,
    NumericItem item,
  ) {
    final board = TangramEngine.recipeBoardOf(item);
    return SizedBox(height: 180, child: _FigurePreview(board: board));
  }

  static Key trayPieceKey(int index) => Key('p1_tangram.tray.$index');
  static Key placedPieceKey(int index) => Key('p1_tangram.placed.$index');
  static const Key resetKey = Key('p1_tangram.reset');
  static final GlobalKey workspaceKey = GlobalKey();
}

class _TangramComposeBoard extends StatefulWidget {
  const _TangramComposeBoard({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_TangramComposeBoard> createState() => _TangramComposeBoardState();
}

class _TangramComposeBoardState extends State<_TangramComposeBoard> {
  late final TangramBoard _board = TangramEngine.boardOf(
    widget.render.item as GeneratedItem,
  );
  late final List<int> _rotationSteps = List.filled(_board.pieces.length, 0);
  late final List<bool> _flipped = List.filled(_board.pieces.length, false);
  late List<PlacedPiece?> _placements = List.filled(_board.pieces.length, null);
  bool _answered = false;

  /// Every vertex of the generator's own solution -- the fixed set of
  /// points a dropped piece snaps to (see class doc / `p1_tangram_engine
  /// .dart`'s "engine-owned data" note: any placement set that rasterises
  /// to the same target counts, but this snap set only ever offers the
  /// canonical solution's own corners, which is always one such
  /// placement).
  late final List<Point2> _snapVertices = [
    for (var i = 0; i < _board.pieces.length; i++)
      ..._board.solutionPlacements[i].absoluteVertices(_board.pieces[i]),
  ];

  void _rotate(int index) {
    if (_answered || !widget.render.acceptsInput) return;
    setState(() {
      _rotationSteps[index] = (_rotationSteps[index] + 1) % 8;
      _placements[index] = null;
    });
  }

  void _flip(int index) {
    if (_answered || !widget.render.acceptsInput) return;
    if (!_board.pieces[index].canFlip) return;
    setState(() {
      _flipped[index] = !_flipped[index];
      _placements[index] = null;
    });
  }

  void _returnToTray(int index) {
    if (_answered || !widget.render.acceptsInput) return;
    setState(() => _placements[index] = null);
  }

  void _reset() {
    if (_answered || !widget.render.acceptsInput) return;
    setState(() {
      _placements = List.filled(_board.pieces.length, null);
    });
  }

  /// Converts a drop point (board coordinates) into a placement: the
  /// piece's own vertex-0, at its current [_rotationSteps]/[_flipped]
  /// orientation, "lattice-snaps" to whichever [_snapVertices] point is
  /// closest to the naive drop -- exactly reproducing the (possibly
  /// irrational, since a 45° rotation never lands on a plain grid) offset
  /// a correct placement needs, without re-deriving it through
  /// floating-point trig at drop time.
  void _drop(int index, double dropX, double dropY) {
    if (_answered || !widget.render.acceptsInput) return;
    final piece = _board.pieces[index];
    final oriented = transformPolygon(
      piece.vertices,
      dx: 0,
      dy: 0,
      rotationSteps: _rotationSteps[index],
      flipped: _flipped[index],
    );
    final anchor = oriented.first;
    var bestDx = dropX - anchor.$1;
    var bestDy = dropY - anchor.$2;
    var bestDistSq = double.infinity;
    for (final (vx, vy) in oriented) {
      for (final (tx, ty) in _snapVertices) {
        final candDx = tx - vx;
        final candDy = ty - vy;
        final landX = anchor.$1 + candDx;
        final landY = anchor.$2 + candDy;
        final distSq =
            (landX - dropX) * (landX - dropX) +
            (landY - dropY) * (landY - dropY);
        if (distSq < bestDistSq) {
          bestDistSq = distSq;
          bestDx = candDx;
          bestDy = candDy;
        }
      }
    }
    const snapRadiusSq = 0.6 * 0.6;
    if (bestDistSq > snapRadiusSq) {
      bestDx = dropX - anchor.$1;
      bestDy = dropY - anchor.$2;
    }
    setState(() {
      _placements[index] = PlacedPiece(
        dx: bestDx,
        dy: bestDy,
        rotationSteps: _rotationSteps[index],
        flipped: _flipped[index],
      );
    });
    _checkSolved();
  }

  void _checkSolved() {
    if (_placements.any((p) => p == null)) return;
    final cellSets = [
      for (var i = 0; i < _board.pieces.length; i++)
        rasterisePolygon(_placements[i]!.absoluteVertices(_board.pieces[i])),
    ];
    for (var i = 0; i < cellSets.length; i++) {
      for (var j = i + 1; j < cellSets.length; j++) {
        if (cellSets[i].intersection(cellSets[j]).isNotEmpty) return;
      }
    }
    final union = <CellIndex>{for (final c in cellSets) ...c};
    if (union.length != _board.targetCells.length) return;
    if (union.difference(_board.targetCells).isNotEmpty) return;
    _answered = true;
    widget.render.onAnswer(
      Answer.raw({
        'placements': [
          for (final p in _placements)
            p == null
                ? null
                : {
                    'dx': p.dx,
                    'dy': p.dy,
                    'rotationSteps': p.rotationSteps,
                    'flipped': p.flipped,
                  },
        ],
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final showsSolution = render.showsFeedback && render.isAnswered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.tangramTargetLabel, style: theme.textStyles.caption),
        SizedBox(height: theme.spacing.xs),
        SizedBox(height: 120, child: _TargetPreview(board: _board)),
        SizedBox(height: theme.spacing.md),
        Text(
          showsSolution
              ? context.l10n.tangramSolutionCaption
              : context.l10n.tangramWorkspaceLabel,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.xs),
        Expanded(
          child: showsSolution
              ? _SolutionView(board: _board)
              : _Workspace(
                  board: _board,
                  placements: _placements,
                  acceptsInput: render.acceptsInput,
                  onDrop: _drop,
                  onTapPlaced: _returnToTray,
                ),
        ),
        if (!showsSolution) ...[
          SizedBox(height: theme.spacing.md),
          Text(context.l10n.tangramTrayLabel, style: theme.textStyles.caption),
          SizedBox(height: theme.spacing.xs),
          _Tray(
            board: _board,
            placements: _placements,
            rotationSteps: _rotationSteps,
            flipped: _flipped,
            acceptsInput: render.acceptsInput,
            onRotate: _rotate,
            onFlip: _flip,
          ),
          SizedBox(height: theme.spacing.md),
          SecondaryButton(
            key: TangramRenderer.resetKey,
            label: context.l10n.tangramResetAction,
            onPressed: render.acceptsInput ? _reset : null,
          ),
        ],
      ],
    );
  }
}

/// The interactive workspace: a [DragTarget] the whole area accepts tray
/// piece indices onto, converting the drop's global offset into board
/// coordinates through [TangramRenderer.workspaceKey]'s render box (same
/// technique as `spatial_overlay`'s `_GridArea._cellOfGlobalOffset`).
class _Workspace extends StatelessWidget {
  const _Workspace({
    required this.board,
    required this.placements,
    required this.acceptsInput,
    required this.onDrop,
    required this.onTapPlaced,
  });

  final TangramBoard board;
  final List<PlacedPiece?> placements;
  final bool acceptsInput;
  final void Function(int index, double boardX, double boardY) onDrop;
  final void Function(int index) onTapPlaced;

  /// A half-unit margin around the figure's own bounding box: without it, a
  /// piece whose solution placement sits exactly on the figure's extreme
  /// edge maps to a drop point exactly on the workspace box's own
  /// boundary, which floating-point rounding can push a hair outside the
  /// render box (missing the `DragTarget` entirely). The margin keeps
  /// every legal drop point strictly inside.
  static const double _margin = 0.5;

  double get _originX => board.minX - _margin;
  double get _originY => board.minY - _margin;

  (double, double)? _boardPointOfGlobal(Offset global, double scale) {
    final box = TangramRenderer.workspaceKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached) return null;
    final local = box.globalToLocal(global);
    return (local.dx / scale + _originX, local.dy / scale + _originY);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final widthUnits = math.max(board.maxX - board.minX + 2 * _margin, 1.0);
    final heightUnits = math.max(board.maxY - board.minY + 2 * _margin, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(
          constraints.maxWidth / widthUnits,
          constraints.maxHeight / heightUnits,
        );
        return Center(
          child: SizedBox(
            width: widthUnits * scale,
            height: heightUnits * scale,
            child: DragTarget<int>(
              onWillAcceptWithDetails: (_) => acceptsInput,
              onAcceptWithDetails: (details) {
                final point = _boardPointOfGlobal(details.offset, scale);
                if (point != null) onDrop(details.data, point.$1, point.$2);
              },
              builder: (context, candidateData, rejectedData) => DecoratedBox(
                key: TangramRenderer.workspaceKey,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colors.borderStrong,
                    width: 2,
                  ),
                  borderRadius: theme.radii.smAll,
                  color: theme.colors.surface,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (var i = 0; i < board.pieces.length; i++)
                      if (placements[i] != null)
                        _PlacedPieceBox(
                          key: TangramRenderer.placedPieceKey(i),
                          piece: board.pieces[i],
                          placement: placements[i]!,
                          origin: (_originX, _originY),
                          scale: scale,
                          acceptsInput: acceptsInput,
                          onTap: () => onTapPlaced(i),
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

class _PlacedPieceBox extends StatelessWidget {
  const _PlacedPieceBox({
    required this.piece,
    required this.placement,
    required this.origin,
    required this.scale,
    required this.acceptsInput,
    required this.onTap,
    super.key,
  });

  final TangramPiece piece;
  final PlacedPiece placement;
  final (double, double) origin;
  final double scale;
  final bool acceptsInput;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vertices = placement.absoluteVertices(piece);
    final minX = vertices.map((v) => v.$1).reduce(math.min);
    final maxX = vertices.map((v) => v.$1).reduce(math.max);
    final minY = vertices.map((v) => v.$2).reduce(math.min);
    final maxY = vertices.map((v) => v.$2).reduce(math.max);
    return Positioned(
      left: (minX - origin.$1) * scale,
      top: (minY - origin.$2) * scale,
      width: (maxX - minX) * scale,
      height: (maxY - minY) * scale,
      child: GestureDetector(
        onTap: acceptsInput ? onTap : null,
        child: CustomPaint(
          painter: TangramPiecePainter(
            vertices: vertices,
            color: TangramColours.of(piece.kind),
            pixelsPerUnit: scale,
            originX: minX,
            originY: minY,
          ),
        ),
      ),
    );
  }
}

/// The tray of pieces not yet placed on the workspace: tap rotates 45°,
/// double-tap (or long-press) flips the parallelogram, drag onto the
/// workspace to place it.
class _Tray extends StatelessWidget {
  const _Tray({
    required this.board,
    required this.placements,
    required this.rotationSteps,
    required this.flipped,
    required this.acceptsInput,
    required this.onRotate,
    required this.onFlip,
  });

  final TangramBoard board;
  final List<PlacedPiece?> placements;
  final List<int> rotationSteps;
  final List<bool> flipped;
  final bool acceptsInput;
  final void Function(int index) onRotate;
  final void Function(int index) onFlip;

  static const double _trayUnit = 22;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      height: _trayUnit * 3 + theme.spacing.sm * 2,
      child: Wrap(
        spacing: theme.spacing.md,
        runSpacing: theme.spacing.sm,
        children: [
          for (var i = 0; i < board.pieces.length; i++)
            if (placements[i] == null)
              Padding(
                padding: EdgeInsets.all(theme.spacing.xs),
                child: _TrayPiece(
                  key: TangramRenderer.trayPieceKey(i),
                  piece: board.pieces[i],
                  index: i,
                  rotationSteps: rotationSteps[i],
                  flipped: flipped[i],
                  acceptsInput: acceptsInput,
                  onRotate: onRotate,
                  onFlip: onFlip,
                ),
              ),
        ],
      ),
    );
  }
}

class _TrayPiece extends StatelessWidget {
  const _TrayPiece({
    required this.piece,
    required this.index,
    required this.rotationSteps,
    required this.flipped,
    required this.acceptsInput,
    required this.onRotate,
    required this.onFlip,
    super.key,
  });

  final TangramPiece piece;
  final int index;
  final int rotationSteps;
  final bool flipped;
  final bool acceptsInput;
  final void Function(int index) onRotate;
  final void Function(int index) onFlip;

  static const double _unit = _Tray._trayUnit;

  @override
  Widget build(BuildContext context) {
    final oriented = transformPolygon(
      piece.vertices,
      dx: 0,
      dy: 0,
      rotationSteps: rotationSteps,
      flipped: flipped,
    );
    final minX = oriented.map((v) => v.$1).reduce(math.min);
    final maxX = oriented.map((v) => v.$1).reduce(math.max);
    final minY = oriented.map((v) => v.$2).reduce(math.min);
    final maxY = oriented.map((v) => v.$2).reduce(math.max);
    final visual = SizedBox(
      width: math.max((maxX - minX) * _unit, 4),
      height: math.max((maxY - minY) * _unit, 4),
      child: CustomPaint(
        painter: TangramPiecePainter(
          vertices: oriented,
          color: TangramColours.of(piece.kind),
          pixelsPerUnit: _unit,
          originX: minX,
          originY: minY,
        ),
      ),
    );
    if (!acceptsInput) return visual;
    // The rotate/flip taps live on a `GestureDetector` wrapping the
    // `Draggable`, not competing with it: `Draggable`'s own pan recogniser
    // claims the gesture arena as soon as the pointer moves past the touch
    // slop, so a real drag always wins over the outer tap/double-tap/
    // long-press recognisers, which only resolve on release with (near)
    // zero movement.
    return GestureDetector(
      onTap: () => onRotate(index),
      onDoubleTap: piece.canFlip ? () => onFlip(index) : null,
      onLongPress: piece.canFlip ? () => onFlip(index) : null,
      child: Draggable<int>(
        data: index,
        // The default anchor (`childDragAnchorStrategy`) follows wherever
        // within the piece the drag started, so `DragTargetDetails.offset`
        // would be that grab point's own offset from the piece's corner --
        // not a stable, reproducible board coordinate. Anchoring to the
        // pointer itself means a drop's `details.offset` is exactly the
        // pointer's position, matching `_drop`'s "wherever you drop it is
        // the piece's vertex-0" convention (see `_boardPointOfGlobal`).
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: Opacity(opacity: 0.85, child: visual),
        childWhenDragging: Opacity(opacity: 0.25, child: visual),
        child: Semantics(
          button: true,
          label: context.l10n.tangramPieceSemantics(index + 1),
          child: visual,
        ),
      ),
    );
  }
}

/// The fixed, non-interactive target silhouette; internal piece seams are
/// drawn as a hint unless [TangramBoard.hideInternalEdges].
class _TargetPreview extends StatelessWidget {
  const _TargetPreview({required this.board});

  final TangramBoard board;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderStrong, width: 2),
        borderRadius: theme.radii.smAll,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widthUnits = math.max(board.maxX - board.minX, 1.0);
          final heightUnits = math.max(board.maxY - board.minY, 1.0);
          final scale = math.min(
            constraints.maxWidth / widthUnits,
            constraints.maxHeight / heightUnits,
          );
          return Center(
            child: SizedBox(
              width: widthUnits * scale,
              height: heightUnits * scale,
              child: CustomPaint(
                painter: TangramFigurePainter(
                  cells: board.targetCells,
                  cellSize: defaultCellSize,
                  pixelsPerUnit: scale,
                  originX: board.minX,
                  originY: board.minY,
                  fillColor: TangramColours.silhouette,
                  pieces: board.pieces,
                  placements: board.solutionPlacements,
                  showPieceEdges: !board.hideInternalEdges,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The read-only solution view shown once feedback reveals it (practice).
class _SolutionView extends StatelessWidget {
  const _SolutionView({required this.board});

  final TangramBoard board;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widthUnits = math.max(board.maxX - board.minX, 1.0);
        final heightUnits = math.max(board.maxY - board.minY, 1.0);
        final scale = math.min(
          constraints.maxWidth / widthUnits,
          constraints.maxHeight / heightUnits,
        );
        return Center(
          child: SizedBox(
            width: widthUnits * scale,
            height: heightUnits * scale,
            child: Stack(
              children: [
                for (var i = 0; i < board.pieces.length; i++)
                  _PlacedPieceBox(
                    piece: board.pieces[i],
                    placement: board.solutionPlacements[i],
                    origin: (board.minX, board.minY),
                    scale: scale,
                    acceptsInput: false,
                    onTap: () {},
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The static figure `count_occurrences` mode asks about, drawn above the
/// numeric keypad (via [NumericRenderer]'s `header`).
class _FigurePreview extends StatelessWidget {
  const _FigurePreview({required this.board});

  final TangramBoard board;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.radii.smAll,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widthUnits = math.max(board.maxX - board.minX, 1.0);
          final heightUnits = math.max(board.maxY - board.minY, 1.0);
          final scale = math.min(
            constraints.maxWidth / widthUnits,
            constraints.maxHeight / heightUnits,
          );
          return Center(
            child: SizedBox(
              width: widthUnits * scale,
              height: heightUnits * scale,
              child: CustomPaint(
                painter: TangramFigurePainter(
                  cells: board.targetCells,
                  cellSize: defaultCellSize,
                  pixelsPerUnit: scale,
                  originX: board.minX,
                  originY: board.minY,
                  fillColor: TangramColours.silhouette,
                  pieces: board.pieces,
                  placements: board.solutionPlacements,
                  showPieceEdges: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A fixed, non-interactive example figure for the briefing screen
/// (`compose` mode).
class _TangramComposeExample extends StatelessWidget {
  const _TangramComposeExample();

  static final TangramBoard _board = buildTangramBoard(
    seed: 1,
    params: const P1TangramParams(pieceCount: 3),
    difficulty: 1,
  );

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 120,
          child: IgnorePointer(child: _TargetPreview(board: _board)),
        ),
        SizedBox(height: theme.spacing.sm),
        Text(
          context.l10n.tangramExampleCaption,
          style: theme.textStyles.caption,
        ),
      ],
    );
  }
}
