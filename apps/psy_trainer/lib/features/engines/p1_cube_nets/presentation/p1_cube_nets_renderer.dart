import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../../spatial_cubes/domain/cube_face.dart';
import '../../spatial_cubes/domain/cube_net_puzzle.dart' show CubeNetCellFace;
import '../domain/p1_cube_net_puzzle.dart';
import '../domain/p1_cube_nets_engine.dart';
import '../domain/p1_cube_rotation_puzzle.dart';
import 'p1_cube_isometric_painter.dart';
import 'p1_cube_net_view.dart';
import 'p1_cube_rotation_view.dart';

/// The widget half of `p1_cube_nets` (US-108): dispatches to
/// [P1CubeNetView] or [P1CubeRotationView] depending on [P1CubePhase.of]
/// resolved from the item's own `origin.index` -- same recipe the engine
/// itself replays to score the answer, so renderer and scorer can never
/// disagree on which puzzle an item is.
class P1CubeNetsRenderer extends ActivityRenderer {
  const P1CubeNetsRenderer();

  @override
  String get familyId => 'p1_cube_nets';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    final params = item.params as P1CubeNetsParams;
    final index = item.origin?.index ?? 0;
    final phase = P1CubePhase.of(params, index);

    switch (phase.mode) {
      case P1CubeMode.net:
        final puzzle = buildP1CubeNetPuzzle(
          seed: item.seed,
          alphabet: phase.alphabet,
          missingFaces: params.missingFaces,
        );
        return P1CubeNetOverlayHost(
          itemKey: ValueKey(item.id),
          render: render,
          puzzle: puzzle,
        );
      case P1CubeMode.rotation:
        final puzzle = buildP1CubeRotationPuzzle(
          seed: item.seed,
          alphabet: phase.alphabet,
        );
        return P1CubeRotationView(
          key: ValueKey(item.id),
          render: render,
          puzzle: puzzle,
        );
    }
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: 96,
      height: 96,
      child: CustomPaint(
        painter: P1CubeIsometricPainter(
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
          glyphColor: theme.colors.textPrimary,
        ),
      ),
    );
  }
}
