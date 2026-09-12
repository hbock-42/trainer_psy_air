import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../../../train/presentation/renderers/mcq_renderer.dart';
import '../../../train/presentation/renderers/numeric_renderer.dart';
import 'mental_arithmetic_intervals_view.dart';

/// [ActivityRenderer] for `p1_mental_arithmetic` (US-105): the family plays
/// through one of four item shapes depending on which of the four answer
/// modes the current item is (`MentalArithmeticEngine.generate` decides
/// the mode from `index`, see `mental_arithmetic.dart`), so this renderer
/// composes the three existing generic renderers by item type — a single
/// `RendererRegistry` entry per family id — rather than duplicating their
/// widgets:
///
/// - `freeNumeric` / `equation` -> `NumericItem` -> [NumericRenderer]
/// - `smallestInterval` -> `McqItem` -> [McqRenderer]
/// - `allIntervals` -> `GeneratedItem` -> [MentalArithmeticIntervalsView]
///   (multi-select tiles, the same pattern as `arithmetic_grid_renderer`)
class MentalArithmeticRenderer extends ActivityRenderer {
  const MentalArithmeticRenderer();

  static const _numericRenderer = NumericRenderer(
    familyId: 'p1_mental_arithmetic',
  );
  static const _mcqRenderer = McqRenderer(familyId: 'p1_mental_arithmetic');

  @override
  String get familyId => 'p1_mental_arithmetic';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    return switch (render.item) {
      NumericItem() => _numericRenderer.build(context, render),
      McqItem() => _mcqRenderer.build(context, render),
      GeneratedItem() => MentalArithmeticIntervalsView(
        key: ValueKey(render.item.id),
        render: render,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final mode =
        (run?.params as P1MentalArithmeticParams?)?.answerMode ??
        MentalArithmeticAnswerMode.freeNumeric;
    return switch (mode) {
      MentalArithmeticAnswerMode.freeNumeric ||
      MentalArithmeticAnswerMode.equation => _numericRenderer.buildExample(
        context,
        run,
      ),
      MentalArithmeticAnswerMode.smallestInterval => _mcqRenderer.buildExample(
        context,
        run,
      ),
      MentalArithmeticAnswerMode.allIntervals => const _AllIntervalsExample(),
    };
  }
}

/// Static, non-interactive illustration of the `allIntervals` mode for the
/// briefing screen.
class _AllIntervalsExample extends StatelessWidget {
  const _AllIntervalsExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.mentalArithmeticAllIntervalsExampleCaption,
          style: theme.textStyles.body,
        ),
      ],
    );
  }
}
