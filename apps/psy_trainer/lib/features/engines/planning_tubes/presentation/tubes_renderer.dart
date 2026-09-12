import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../../../train/presentation/renderers/numeric_renderer.dart';
import '../domain/tubes_engine.dart';
import '../domain/tubes_puzzle.dart';
import 'tubes_painter.dart';

/// The widget half of `planning_tubes` (US-035): a plain [NumericRenderer]
/// (numeric keypad, default numeric scoring) whose [header] draws the
/// start/target tube diagrams above the stem, and, once answered, a "Voir
/// la solution" reveal that steps through one optimal move sequence,
/// redrawing the tubes at each step.
class TubesRenderer extends NumericRenderer {
  const TubesRenderer() : super(familyId: 'planning_tubes', header: _header);

  static Widget _header(
    BuildContext context,
    ActivityRenderContext render,
    NumericItem item,
  ) => _TubesHeader(key: ValueKey(item.id), item: item, render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _TubesExample();
}

class _TubesHeader extends StatefulWidget {
  const _TubesHeader({required this.item, required this.render, super.key});

  final NumericItem item;
  final ActivityRenderContext render;

  @override
  State<_TubesHeader> createState() => _TubesHeaderState();
}

class _TubesHeaderState extends State<_TubesHeader> {
  bool _showSolution = false;
  int _step = 0;

  // `TubesRenderer._header` keys this widget by `item.id`, so a new item
  // always creates a fresh state (and re-runs `initState`): computing the
  // (BFS-solved) puzzle once here, rather than in `build`, avoids re-solving
  // it on every rebuild of the same item (feedback, step changes).
  late final TubesPuzzle _puzzle = TubesEngine.puzzleOf(widget.item);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final puzzle = _puzzle;
    final answered = widget.render.isAnswered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _TubesDiagram(
                label: context.l10n.tubesStartLabel,
                tubes: puzzle.start.tubes,
                capacities: puzzle.capacities,
              ),
            ),
            SizedBox(width: theme.spacing.lg),
            Expanded(
              child: _TubesDiagram(
                label: context.l10n.tubesTargetLabel,
                tubes: puzzle.target.tubes,
                capacities: puzzle.capacities,
              ),
            ),
          ],
        ),
        if (answered) ...[
          SizedBox(height: theme.spacing.lg),
          if (!_showSolution)
            SecondaryButton(
              label: context.l10n.tubesShowSolutionAction,
              onPressed: () => setState(() {
                _showSolution = true;
                _step = 0;
              }),
            )
          else
            _SolutionStepper(
              puzzle: puzzle,
              step: _step,
              onStepChanged: (step) => setState(() => _step = step),
              onHide: () => setState(() => _showSolution = false),
            ),
        ],
      ],
    );
  }
}

class _SolutionStepper extends StatelessWidget {
  const _SolutionStepper({
    required this.puzzle,
    required this.step,
    required this.onStepChanged,
    required this.onHide,
  });

  final TubesPuzzle puzzle;
  final int step;
  final ValueChanged<int> onStepChanged;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final states = puzzle.states;
    final moves = puzzle.moves;
    final total = moves.length;
    final clampedStep = step.clamp(0, total);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.tubesSolutionStepLabel(clampedStep, total),
            style: theme.textStyles.bodyStrong,
          ),
          SizedBox(height: theme.spacing.xs),
          if (clampedStep > 0)
            Text(
              context.l10n.tubesSolutionMoveLabel(
                _tubeLetter(moves[clampedStep - 1].from),
                _tubeLetter(moves[clampedStep - 1].to),
              ),
              style: theme.textStyles.body,
            ),
          SizedBox(height: theme.spacing.md),
          _TubesDiagram(
            label: null,
            tubes: states[clampedStep].tubes,
            capacities: puzzle.capacities,
          ),
          SizedBox(height: theme.spacing.md),
          Row(
            children: [
              AppIconButton(
                key: const ValueKey('tubes_solution_previous_step'),
                glyph: AppIconGlyph.chevronLeft,
                semanticsLabel: context.l10n.tubesSolutionPreviousStep,
                onPressed: clampedStep > 0
                    ? () => onStepChanged(clampedStep - 1)
                    : null,
              ),
              const Spacer(),
              AppIconButton(
                key: const ValueKey('tubes_solution_next_step'),
                glyph: AppIconGlyph.chevronRight,
                semanticsLabel: context.l10n.tubesSolutionNextStep,
                onPressed: clampedStep < total
                    ? () => onStepChanged(clampedStep + 1)
                    : null,
              ),
            ],
          ),
          SizedBox(height: theme.spacing.sm),
          SecondaryButton(
            label: context.l10n.tubesHideSolutionAction,
            onPressed: onHide,
          ),
        ],
      ),
    );
  }

  static String _tubeLetter(int index) =>
      String.fromCharCode('A'.codeUnitAt(0) + index);
}

class _TubesDiagram extends StatelessWidget {
  const _TubesDiagram({
    required this.label,
    required this.tubes,
    required this.capacities,
  });

  final String? label;
  final List<List<int>> tubes;
  final List<int> capacities;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Text(
            label!,
            textAlign: TextAlign.center,
            style: theme.textStyles.label,
          ),
          SizedBox(height: theme.spacing.xs),
        ],
        SizedBox(
          height: 120,
          child: CustomPaint(
            painter: TubesPainter(
              tubes: tubes,
              capacities: capacities,
              wallColor: theme.colors.border,
              emptySlotColor: theme.colors.surfaceRaised,
            ),
          ),
        ),
      ],
    );
  }
}

/// Static illustration for the briefing screen: a fixed 3-tube example,
/// disconnected from any real seed (like the other renderers' examples).
class _TubesExample extends StatelessWidget {
  const _TubesExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: _TubesDiagram(
            label: context.l10n.tubesStartLabel,
            tubes: const [
              [0, 1],
              [],
              [2],
            ],
            capacities: const [3, 2, 3],
          ),
        ),
        SizedBox(width: theme.spacing.lg),
        Expanded(
          child: _TubesDiagram(
            label: context.l10n.tubesTargetLabel,
            tubes: const [
              [1],
              [],
              [2, 0],
            ],
            capacities: const [3, 2, 3],
          ),
        ),
      ],
    );
  }
}
