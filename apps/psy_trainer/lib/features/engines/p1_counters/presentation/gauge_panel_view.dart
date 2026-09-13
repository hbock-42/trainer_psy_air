import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';
import '../domain/gauge.dart';
import 'gauge_painter.dart';

/// Lays out 1-4 [Gauge]s side by side (`Wrap` so it still fits a narrow
/// phone width): the instrument panel `p1_counters` items ask about.
class GaugePanelView extends StatelessWidget {
  const GaugePanelView({required this.gauges, super.key});

  final List<Gauge> gauges;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: theme.spacing.md,
      runSpacing: theme.spacing.md,
      children: [
        for (final gauge in gauges)
          _GaugeTile(key: ValueKey(gauge.label), gauge: gauge),
      ],
    );
  }
}

class _GaugeTile extends StatelessWidget {
  const _GaugeTile({required this.gauge, super.key});

  final Gauge gauge;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final size = gauge.kind == GaugeKind.linear ? 88.0 : 96.0;

    return Semantics(
      label: 'Cadran ${gauge.label}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: GaugePainter(
                gauge: gauge,
                trackColor: colors.border,
                tickColor: colors.textMuted,
                majorTickColor: colors.textSecondary,
                needleColor: colors.accent,
                fineNeedleColor: colors.textPrimary,
                textColor: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: theme.spacing.xs),
          Text(gauge.label, style: theme.textStyles.label),
        ],
      ),
    );
  }
}
