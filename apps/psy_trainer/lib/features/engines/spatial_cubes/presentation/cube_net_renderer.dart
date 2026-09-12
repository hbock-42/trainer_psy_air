import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../domain/cube_face.dart';
import '../domain/cube_net.dart';
import '../domain/cube_net_puzzle.dart';
import 'cube_isometric_painter.dart';
import 'cube_net_painter.dart';

const double _cellSize = 56;
const double _cellGap = 4;

/// The widget half of `spatial_cubes` (US-025): draws the reference net
/// (fully filled, left) and the target net (right, some cells empty),
/// with a tray of draggable face tiles below. Dragging a tray tile onto an
/// empty target cell places it; tapping any tile (in the tray or already
/// placed) rotates it 90°. "Valider" is enabled once every empty cell has
/// a tile.
class CubeNetRenderer extends ActivityRenderer {
  const CubeNetRenderer();

  @override
  String get familyId => 'spatial_cubes';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    final params = item.params as CubeNetParams;
    final puzzle = buildCubeNetPuzzle(
      seed: item.seed,
      params: params,
      difficulty: item.difficulty,
    );
    // `Draggable`'s drag feedback needs an `Overlay` ancestor. The real app
    // always has one (the router's `Navigator`), but a renderer must not
    // assume its host does -- so it brings its own, exactly as a screen
    // with its own `Navigator` would.
    return _OverlayHost(
      itemKey: ValueKey(item.id),
      render: render,
      puzzle: puzzle,
    );
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: 96,
      height: 96,
      child: CustomPaint(
        painter: CubeIsometricPainter(
          faces: const {
            CubeFace.top: CubeNetCellFace(
              face: CubeFace.top,
              value: 'F',
              rotation: 0,
            ),
            CubeFace.front: CubeNetCellFace(
              face: CubeFace.front,
              value: 'L',
              rotation: 0,
            ),
            CubeFace.right: CubeNetCellFace(
              face: CubeFace.right,
              value: 'P',
              rotation: 0,
            ),
          },
          edgeColor: theme.colors.border,
          topFill: theme.colors.surfaceRaised,
          frontFill: theme.colors.surface,
          rightFill: theme.colors.accentSubtle,
          textColor: theme.colors.textPrimary,
        ),
      ),
    );
  }
}

/// Owns a single, persistent `Overlay` for the activity's whole lifetime.
///
/// `Overlay.initialEntries` is read only once, at the `OverlayState`'s own
/// creation -- rebuilding the `Overlay` widget with a *different* entries
/// list (as a plain `Overlay(initialEntries: [...])` built fresh on every
/// `ActivityRenderer.build` call would do) does not replace the mounted
/// entry, so the very first `render`/`puzzle` this widget ever saw would
/// stay frozen forever (no feedback, no re-scoring) while `_CubeNetView`
/// itself kept working (its own `setState` calls still apply -- only the
/// `render` it reads back is stale). Creating the `OverlayEntry` once, in
/// [State.initState], and calling [OverlayEntry.markNeedsBuild] from
/// [State.didUpdateWidget] keeps it in sync: its builder reads `widget`,
/// which the framework always keeps current on this [State].
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({
    required this.itemKey,
    required this.render,
    required this.puzzle,
  });

  final Key itemKey;
  final ActivityRenderContext render;
  final CubeNetPuzzle puzzle;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = OverlayEntry(
      builder: (context) => _CubeNetView(
        key: widget.itemKey,
        render: widget.render,
        puzzle: widget.puzzle,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  // No `dispose` override: the `Overlay`'s own `OverlayState` removes and
  // disposes the entries it was given when it is itself unmounted;
  // disposing `_entry` again here would double-dispose it.

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);
}

class _CubeNetView extends StatefulWidget {
  const _CubeNetView({required this.render, required this.puzzle, super.key});

  final ActivityRenderContext render;
  final CubeNetPuzzle puzzle;

  @override
  State<_CubeNetView> createState() => _CubeNetViewState();
}

class _CubeNetViewState extends State<_CubeNetView> {
  late Map<int, int?> _placedTileIndex; // slot cellIndex -> tray index
  late Map<int, int> _tileRotation; // tray index -> current rotation
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
                  painter: CubeFaceTilePainter(
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
              key: const Key('cube_net.validate'),
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
                  painter: CubeIsometricPainter(
                    faces: {
                      for (final face in puzzle.referenceCells.values)
                        face.face: face,
                    },
                    edgeColor: theme.colors.border,
                    topFill: theme.colors.surfaceRaised,
                    frontFill: theme.colors.surface,
                    rightFill: theme.colors.accentSubtle,
                    textColor: theme.colors.textPrimary,
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
        painter: CubeFaceTilePainter(
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
          painter: CubeFaceTilePainter(
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
            painter: CubeFaceTilePainter(
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
            painter: CubeFaceTilePainter(
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
      key: ValueKey('cube_net.slot.$index'),
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
        key: ValueKey('cube_net.tray.$index'),
        onTap: () => onTap(index),
        child: SizedBox(
          width: _cellSize,
          height: _cellSize,
          child: CustomPaint(
            painter: CubeFaceTilePainter(
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
          painter: CubeFaceTilePainter(
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
/// `_cellGap` between them, built from [cellBuilder].
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
