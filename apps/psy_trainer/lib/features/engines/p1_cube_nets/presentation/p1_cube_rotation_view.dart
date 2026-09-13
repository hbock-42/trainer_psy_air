import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../../spatial_cubes/domain/cube_face.dart';
import '../../spatial_cubes/domain/cube_net_puzzle.dart' show CubeNetCellFace;
import '../domain/p1_cube_rotation_puzzle.dart';
import 'p1_cube_isometric_painter.dart';

/// The rotation-matching half of `p1_cube_nets` (spec §2.3/§4.1 row 8b): a
/// reference cube and one candidate, both drawn isometrically
/// ([P1CubeIsometricPainter]); the candidate answers "Même cube, tourné"
/// ([Answer.choice] `1`) or "Modifié" ([Answer.choice] `0`) -- see
/// `p1_cube_nets_engine.dart`'s doc comment for why one item is one
/// candidate judgement rather than a whole set behind one
/// `MultiSelectAnswer`.
class P1CubeRotationView extends StatelessWidget {
  const P1CubeRotationView({
    required this.render,
    required this.puzzle,
    super.key,
  });

  final ActivityRenderContext render;
  final CubeRotationPuzzle puzzle;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final answered = render.isAnswered;

    Widget cube(String label, Map<CubeFace, CubeNetCellFace> faces) => Column(
      children: [
        Text(label, style: theme.textStyles.label),
        SizedBox(height: theme.spacing.xs),
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: P1CubeIsometricPainter(
              faces: faces,
              edgeColor: theme.colors.border,
              topFill: theme.colors.surfaceRaised,
              frontFill: theme.colors.surface,
              rightFill: theme.colors.accentSubtle,
              glyphColor: theme.colors.textPrimary,
            ),
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cube(
                context.l10n.p1CubeRotationReferenceLabel,
                puzzle.referenceVisible,
              ),
              cube(
                context.l10n.p1CubeRotationCandidateLabel,
                puzzle.candidateVisible,
              ),
            ],
          ),
          SizedBox(height: theme.spacing.lg),
          Text(
            context.l10n.p1CubeRotationQuestion,
            style: theme.textStyles.bodyStrong,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: theme.spacing.md),
          if (!answered) ...[
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    key: const Key('p1_cube_rotation.altered'),
                    label: context.l10n.p1CubeRotationAlteredAnswer,
                    onPressed: render.acceptsInput
                        ? () => render.onAnswer(const Answer.choice(0))
                        : null,
                  ),
                ),
                SizedBox(width: theme.spacing.md),
                Expanded(
                  child: PrimaryButton(
                    key: const Key('p1_cube_rotation.same'),
                    label: context.l10n.p1CubeRotationSameAnswer,
                    onPressed: render.acceptsInput
                        ? () => render.onAnswer(const Answer.choice(1))
                        : null,
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: theme.spacing.sm),
            Text(
              puzzle.isSameCube
                  ? context.l10n.p1CubeRotationExplanationSame
                  : context.l10n.p1CubeRotationExplanationAltered,
              style: theme.textStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
