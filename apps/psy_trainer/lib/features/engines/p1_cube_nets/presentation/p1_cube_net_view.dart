import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../../spatial_cubes/domain/cube_net.dart';
import '../../spatial_cubes/domain/cube_net_puzzle.dart'
    show CubeFaceTile, CubeNetPuzzle;
import 'p1_cube_face_tile_painter.dart';
import 'p1_cube_isometric_painter.dart';

const double _cellSize = 56;
const double _cellGap = 4;

/// Owns a persistent `Overlay` for [P1CubeNetView]'s whole lifetime, so
/// `Draggable`'s drag feedback always has an `Overlay` ancestor even when
/// the host embedding this renderer (a test, a future non-router screen)
/// has none of its own -- same reasoning and shape as `spatial_cubes`'s
/// own `CubeNetRenderer._OverlayHost` (re-implemented here rather than
/// imported since that one is private to another engine's `presentation/`
/// file).
class P1CubeNetOverlayHost extends StatefulWidget {
  const P1CubeNetOverlayHost({
    required this.itemKey,
    required this.render,
    required this.puzzle,
    super.key,
  });

  final Key itemKey;
  final ActivityRenderContext render;
  final CubeNetPuzzle puzzle;

  @override
  State<P1CubeNetOverlayHost> createState() => _P1CubeNetOverlayHostState();
}

class _P1CubeNetOverlayHostState extends State<P1CubeNetOverlayHost> {
  late final OverlayEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = OverlayEntry(
      builder: (context) => P1CubeNetView(
        key: widget.itemKey,
        render: widget.render,
        puzzle: widget.puzzle,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant P1CubeNetOverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);
}

/// The net-folding half of `p1_cube_nets` (spec §2.3/§4.1 row 8a): same
/// drag-a-tile-onto-a-slot interaction as PSY0's `spatial_cubes`
/// (`family.json`'s `answerFormat: "drag"`), rebuilt in this family's own
/// `presentation/` since `CubeNetRenderer` lives under `spatial_cubes`
/// (`docs/ARCHITECTURE.md`'s per-story file boundary) -- painters differ
/// (rune-capable), the puzzle type is [CubeNetPuzzle] built by
/// `buildP1CubeNetPuzzle`, everything else follows the same choreography.
class P1CubeNetView extends StatefulWidget {
  const P1CubeNetView({required this.render, required this.puzzle, super.key});

  final ActivityRenderContext render;
  final CubeNetPuzzle puzzle;

  @override
  State<P1CubeNetView> createState() => _P1CubeNetViewState();
}

class _P1CubeNetViewState extends State<P1CubeNetView> {
  late Map<int, int?> _placedTileIndex;
  late Map<int, int> _tileRotation;
  late Set<int> _usedTileIndices;

  @override
  void initState() {
    super.initState();
    _placedTileIndex = {
      for (final slot in widget.puzzle.missingCellIndices) slot: null,
    };
    _tileRotation = {
      for (var i = 0; i < widget.puzzle.trayTiles.length; i++)
        i: widget.puzzle.trayTiles[i].initialRotation,
    };
    _usedTileIndices = {};
  }

  bool get _acceptsInput => widget.render.acceptsInput;

  void _rotateTile(int tileIndex) {
    if (!_acceptsInput) return;
    setState(
      () => _tileRotation[tileIndex] = (_tileRotation[tileIndex]! + 90) % 360,
    );
  }

  void _place(int slot, int tileIndex) {
    if (!_acceptsInput) return;
    setState(() {
      final previous = _placedTileIndex[slot];
      if (previous != null) _usedTileIndices.remove(previous);
      for (final entry in _placedTileIndex.entries.toList()) {
        if (entry.value == tileIndex) _placedTileIndex[entry.key] = null;
      }
      _placedTileIndex[slot] = tileIndex;
      _usedTileIndices.add(tileIndex);
    });
  }

  void _unplace(int slot) {
    if (!_acceptsInput) return;
    setState(() {
      final tileIndex = _placedTileIndex[slot];
      if (tileIndex != null) {
        _usedTileIndices.remove(tileIndex);
        _placedTileIndex[slot] = null;
      }
    });
  }

  bool get _allFilled => _placedTileIndex.values.every((v) => v != null);

  void _submit() {
    final payload = <String, Object?>{};
    for (final entry in _placedTileIndex.entries) {
      final tileIndex = entry.value;
      if (tileIndex == null) continue;
      final tile = widget.puzzle.trayTiles[tileIndex];
      payload['slot_${entry.key}'] = {
        'face': tile.face.name,
        'mirrored': tile.mirrored,
        'rotation': _tileRotation[tileIndex],
      };
    }
    widget.render.onAnswer(Answer.raw(payload));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final puzzle = widget.puzzle;
    final answered = render.isAnswered;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.cubeNetReferenceLabel,
            style: theme.textStyles.label,
          ),
          SizedBox(height: theme.spacing.xs),
          Center(
            child: _NetGrid(
              net: puzzle.referenceNet,
              cellBuilder: (index) {
                final face = puzzle.referenceCells[index]!;
                return CustomPaint(
                  painter: P1CubeFaceTilePainter(
                    value: face.value,
                    rotation: face.rotation,
                    mirrored: false,
                    background: theme.colors.surface,
                    border: theme.colors.border,
                    foreground: theme.colors.textPrimary,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          Text(context.l10n.cubeNetTargetLabel, style: theme.textStyles.label),
          SizedBox(height: theme.spacing.xs),
          Center(
            child: _NetGrid(
              net: puzzle.targetNet,
              cellBuilder: (index) => _buildTargetCell(theme, index, answered),
            ),
          ),
          if (!answered) ...[
            SizedBox(height: theme.spacing.lg),
            Text(context.l10n.cubeNetTrayLabel, style: theme.textStyles.label),
            SizedBox(height: theme.spacing.xs),
            Text(
              context.l10n.cubeNetTapToRotateHint,
              style: theme.textStyles.caption,
            ),
            SizedBox(height: theme.spacing.xs),
            _Tray(
              tiles: puzzle.trayTiles,
              usedIndices: _usedTileIndices,
              rotationOf: (i) => _tileRotation[i]!,
              onTap: _rotateTile,
              onUnplace: _placedTileIndex.entries
                  .where((e) => e.value != null)
                  .map((e) => e.key)
                  .toList(),
              unplaceSlot: _unplace,
              theme: theme,
            ),
            SizedBox(height: theme.spacing.md),
            PrimaryButton(
              key: const Key('p1_cube_net.validate'),
              label: context.l10n.actionValidate,
              onPressed: _allFilled ? _submit : null,
            ),
          ] else ...[
            SizedBox(height: theme.spacing.lg),
            Text(
              context.l10n.cubeNetCorrectFaces(
                render.feedback?.metrics['correctFaces']?.toInt() ?? 0,
                puzzle.missingCellIndices.length,
              ),
              style: theme.textStyles.bodyStrong,
            ),
            SizedBox(height: theme.spacing.sm),
            Text(
              context.l10n.cubeNetExplanationTitle,
              style: theme.textStyles.label,
            ),
            SizedBox(height: theme.spacing.xs),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: P1CubeIsometricPainter(
                    faces: {
                      for (final face in puzzle.referenceCells.values)
                        face.face: face,
                    },
                    edgeColor: theme.colors.border,
                    topFill: theme.colors.surfaceRaised,
                    frontFill: theme.colors.surface,
                    rightFill: theme.colors.accentSubtle,
                    glyphColor: theme.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTargetCell(AppTheme theme, int index, bool answered) {
    final given = widget.puzzle.targetGiven[index];
    if (given != null) {
      return CustomPaint(
        painter: P1CubeFaceTilePainter(
          value: given.value,
          rotation: given.rotation,
          mirrored: false,
          background: theme.colors.surfaceRaised,
          border: theme.colors.border,
          foreground: theme.colors.textPrimary,
        ),
      );
    }

    final placedTileIndex = _placedTileIndex[index];
    Widget slotContent({required bool highlighted}) {
      if (placedTileIndex == null) {
        return CustomPaint(
          painter: P1CubeFaceTilePainter(
            value: '',
            rotation: 0,
            mirrored: false,
            background: highlighted
                ? theme.colors.accentSubtle
                : theme.colors.background,
            border: highlighted
                ? theme.colors.accent
                : theme.colors.borderStrong,
            foreground: theme.colors.textPrimary,
            empty: true,
          ),
        );
      }
      final tile = widget.puzzle.trayTiles[placedTileIndex];
      final rotation = _tileRotation[placedTileIndex]!;
      final content = Semantics(
        button: true,
        label: context.l10n.cubeNetSlotFilledSemantics(index, tile.value),
        child: GestureDetector(
          onTap: () => _rotateTile(placedTileIndex),
          child: CustomPaint(
            painter: P1CubeFaceTilePainter(
              value: tile.value,
              rotation: rotation,
              mirrored: tile.mirrored,
              background: theme.colors.accentSubtle,
              border: theme.colors.accent,
              foreground: theme.colors.textPrimary,
            ),
          ),
        ),
      );
      if (answered || !_acceptsInput) return content;
      return Draggable<int>(
        data: placedTileIndex,
        feedback: SizedBox(
          width: _cellSize,
          height: _cellSize,
          child: CustomPaint(
            painter: P1CubeFaceTilePainter(
              value: tile.value,
              rotation: rotation,
              mirrored: tile.mirrored,
              background: theme.colors.accentSubtle,
              border: theme.colors.accent,
              foreground: theme.colors.textPrimary,
            ),
          ),
        ),
        childWhenDragging: const SizedBox.shrink(),
        onDragCompleted: () {},
        child: content,
      );
    }

    return DragTarget<int>(
      key: ValueKey('p1_cube_net.slot.$index'),
      onWillAcceptWithDetails: (details) => _acceptsInput && !answered,
      onAcceptWithDetails: (details) => _place(index, details.data),
      builder: (context, candidates, rejected) => Semantics(
        label: placedTileIndex == null
            ? context.l10n.cubeNetSlotEmptySemantics(index)
            : null,
        child: slotContent(highlighted: candidates.isNotEmpty),
      ),
    );
  }
}

class _Tray extends StatelessWidget {
  const _Tray({
    required this.tiles,
    required this.usedIndices,
    required this.rotationOf,
    required this.onTap,
    required this.onUnplace,
    required this.unplaceSlot,
    required this.theme,
  });

  final List<CubeFaceTile> tiles;
  final Set<int> usedIndices;
  final int Function(int tileIndex) rotationOf;
  final ValueChanged<int> onTap;
  final List<int> onUnplace;
  final ValueChanged<int> unplaceSlot;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => usedIndices.contains(details.data),
      onAcceptWithDetails: (details) {
        for (final slot in onUnplace) {
          unplaceSlot(slot);
        }
      },
      builder: (context, candidates, rejected) => Wrap(
        spacing: theme.spacing.sm,
        runSpacing: theme.spacing.sm,
        children: [
          for (var i = 0; i < tiles.length; i++)
            if (!usedIndices.contains(i)) _trayTile(context, i),
        ],
      ),
    );
  }

  Widget _trayTile(BuildContext context, int index) {
    final tile = tiles[index];
    final rotation = rotationOf(index);
    final content = Semantics(
      button: true,
      label: context.l10n.cubeNetTileSemantics(tile.value, rotation),
      child: GestureDetector(
        key: ValueKey('p1_cube_net.tray.$index'),
        onTap: () => onTap(index),
        child: SizedBox(
          width: _cellSize,
          height: _cellSize,
          child: CustomPaint(
            painter: P1CubeFaceTilePainter(
              value: tile.value,
              rotation: rotation,
              mirrored: tile.mirrored,
              background: theme.colors.surface,
              border: theme.colors.borderStrong,
              foreground: theme.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
    return Draggable<int>(
      data: index,
      feedback: SizedBox(
        width: _cellSize,
        height: _cellSize,
        child: CustomPaint(
          painter: P1CubeFaceTilePainter(
            value: tile.value,
            rotation: rotation,
            mirrored: tile.mirrored,
            background: theme.colors.surface,
            border: theme.colors.accent,
            foreground: theme.colors.textPrimary,
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: content),
      child: content,
    );
  }
}

/// Lays out [net]'s 6 cells on a grid, each `_cellSize` square with
/// `_cellGap` between them.
class _NetGrid extends StatelessWidget {
  const _NetGrid({required this.net, required this.cellBuilder});

  final CubeNet net;
  final Widget Function(int cellIndex) cellBuilder;

  @override
  Widget build(BuildContext context) {
    const step = _cellSize + _cellGap;
    return SizedBox(
      width: net.width * step - _cellGap,
      height: net.height * step - _cellGap,
      child: Stack(
        children: [
          for (var i = 0; i < net.cells.length; i++)
            Positioned(
              left: net.cells[i].col * step,
              top: net.cells[i].row * step,
              width: _cellSize,
              height: _cellSize,
              child: cellBuilder(i),
            ),
        ],
      ),
    );
  }
}
