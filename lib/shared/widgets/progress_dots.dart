import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// Position inside a sequence ("question 3 of 10") as a row of dots.
///
/// [current] is 1-based. Dots before it are filled, the current one is
/// enlarged, the rest are hollow. Above [maxDots] the widget falls back to a
/// segmented bar so long tests stay readable.
class ProgressDots extends StatelessWidget {
  const ProgressDots({
    required this.current,
    required this.total,
    this.maxDots = 20,
    super.key,
  }) : assert(total >= 1, 'total must be at least 1'),
       assert(
         current >= 1 && current <= total,
         'current must be between 1 and total',
       );

  final int current;
  final int total;
  final int maxDots;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    return Semantics(
      label: 'Progress',
      value: '$current of $total',
      child: ExcludeSemantics(
        child: total > maxDots
            ? _SegmentedBar(fraction: current / total)
            : Wrap(
                spacing: theme.spacing.sm,
                runSpacing: theme.spacing.sm,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (var i = 1; i <= total; i++)
                    AnimatedContainer(
                      duration: theme.durations.normal,
                      width: i == current ? 12 : 8,
                      height: i == current ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= current
                            ? colors.accent
                            : const Color(0x00000000),
                        border: i > current
                            ? Border.all(color: colors.borderStrong, width: 1.5)
                            : null,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _SegmentedBar extends StatelessWidget {
  const _SegmentedBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return ClipRRect(
      borderRadius: theme.radii.fullAll,
      child: SizedBox(
        height: 6,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: theme.colors.border),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: fraction.clamp(0.0, 1.0),
                child: ColoredBox(color: theme.colors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
