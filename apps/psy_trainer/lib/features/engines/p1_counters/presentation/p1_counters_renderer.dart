import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../../../train/presentation/renderers/mcq_renderer.dart';
import '../../../train/presentation/renderers/numeric_renderer.dart';
import '../domain/gauge.dart';
import '../domain/p1_counters_engine.dart';
import 'gauge_panel_view.dart';

/// The widget half of `p1_counters` (US-113): the question decides which
/// [Item] the engine generated ([NumericItem] for "value of gauge X"/"sum
/// or difference of gauges A and B", [McqItem] for "which gauge shows
/// ~X"), so this renderer composes -- never reimplements -- the two shared
/// renderers instead of drawing its own answer surface: a plain
/// [NumericRenderer] with a [header] (same pattern as `planning_tubes`'s
/// `TubesRenderer`) for the numeric questions, and the panel drawn above a
/// plain [McqRenderer] for the MCQ one. Either way the gauges themselves
/// (never stored on the materialised item) are recomputed from it by
/// [CountersEngine.recipeOf].
class CountersRenderer extends ActivityRenderer {
  const CountersRenderer();

  @override
  String get familyId => 'p1_counters';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item;
    if (item is McqItem) {
      return _McqWithPanel(key: ValueKey(item.id), item: item, render: render);
    }
    return const NumericRenderer(
      familyId: 'p1_counters',
      header: _header,
    ).build(context, render);
  }

  static Widget _header(
    BuildContext context,
    ActivityRenderContext render,
    NumericItem item,
  ) => GaugePanelView(
    key: ValueKey('${item.id}.panel'),
    gauges: CountersEngine.recipeOf(item).gauges,
  );

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _CountersExample();
}

/// Draws the gauge panel above a plain, unmodified [McqRenderer]: the panel
/// needs no answer state of its own, so a stateless wrapper is enough.
class _McqWithPanel extends StatelessWidget {
  const _McqWithPanel({required this.item, required this.render, super.key});

  final McqItem item;
  final ActivityRenderContext render;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GaugePanelView(gauges: CountersEngine.recipeOf(item).gauges),
        SizedBox(height: theme.spacing.lg),
        Expanded(
          child: const McqRenderer(
            familyId: 'p1_counters',
          ).build(context, render),
        ),
      ],
    );
  }
}

/// Static illustration for the briefing screen: a fixed 2-gauge panel,
/// disconnected from any real seed (like the other renderers' examples).
class _CountersExample extends StatelessWidget {
  const _CountersExample();

  static const _gauges = [
    Gauge(
      kind: GaugeKind.circular,
      label: 'A',
      rangeMin: 0,
      rangeMax: 100,
      majorStep: 20,
      minorPerMajor: 4,
      value: 63,
      unit: 'bar',
    ),
    Gauge(
      kind: GaugeKind.drum,
      label: 'B',
      rangeMin: 0,
      rangeMax: 999,
      majorStep: 1,
      minorPerMajor: 1,
      value: 452,
      digitCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GaugePanelView(gauges: _gauges),
        SizedBox(height: theme.spacing.md),
        Text(
          context.l10n.p1CountersExampleCaption,
          style: theme.textStyles.caption,
        ),
      ],
    );
  }
}
