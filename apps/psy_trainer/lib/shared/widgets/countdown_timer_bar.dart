import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';

/// Horizontal bar showing the time left in a question or a test.
///
/// Pure presentational: it holds no timer. The caller ticks and rebuilds with
/// a new [remaining]. The fill uses the accent colour and turns to the error
/// colour once less than [warningThreshold] of [total] is left.
class CountdownTimerBar extends StatelessWidget {
  const CountdownTimerBar({
    required this.remaining,
    required this.total,
    this.showLabel = true,
    this.warningThreshold = 0.2,
    super.key,
  });

  final Duration remaining;
  final Duration total;

  /// Shows a `m:ss` label next to the bar.
  final bool showLabel;

  /// Fraction of [total] under which the bar switches to the error colour.
  final double warningThreshold;

  /// 0..1 fraction of time left.
  double get fraction {
    assert(total > Duration.zero, 'total must be positive');
    final value = remaining.inMilliseconds / total.inMilliseconds;
    return value.clamp(0.0, 1.0);
  }

  bool get isWarning => fraction < warningThreshold;

  /// `m:ss` (or `h:mm:ss` above an hour).
  static String format(Duration duration) {
    final clamped = duration.isNegative ? Duration.zero : duration;
    final hours = clamped.inHours;
    final minutes = clamped.inMinutes.remainder(60);
    final seconds = clamped.inSeconds.remainder(60);
    final mm = hours > 0 ? minutes.toString().padLeft(2, '0') : '$minutes';
    final ss = seconds.toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final fill = isWarning ? colors.error : colors.accent;

    final bar = Semantics(
      label: 'Time remaining',
      value: '${format(remaining)} of ${format(total)}',
      child: ClipRRect(
        borderRadius: theme.radii.fullAll,
        child: SizedBox(
          height: 8,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: colors.border),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionallySizedBox(
                  widthFactor: fraction,
                  child: AnimatedContainer(
                    duration: theme.durations.normal,
                    color: fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!showLabel) return bar;

    return Row(
      children: [
        Expanded(child: bar),
        SizedBox(width: theme.spacing.md),
        ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                AppIconGlyph.clock,
                size: 18,
                color: isWarning ? colors.error : colors.textSecondary,
              ),
              SizedBox(width: theme.spacing.xs),
              Text(
                format(remaining),
                style: theme.textStyles.numeric.copyWith(
                  fontSize: 16,
                  color: isWarning ? colors.error : colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
