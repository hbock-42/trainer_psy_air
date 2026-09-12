import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/attention_parity_engine.dart';
import '../domain/parity_layout.dart';

/// Renders one `attention_parity` series (spec §2.4-D): a cloud of number
/// bubbles the candidate taps in the one order that alternates parity and
/// stays ascending within each. A wrong tap restarts the series in place
/// (US-020 live feedback, kept in exam mode: it is how the real test works)
/// and bumps the restart counter; completing the series answers once with
/// `Answer.raw` (see `AttentionParityEngine.score`).
///
/// Touch only ([InputRequirement.touch] in `family.json`): no keyboard map.
class AttentionParityRenderer extends ActivityRenderer {
  const AttentionParityRenderer();

  @override
  String get familyId => 'attention_parity';

  /// Key of one number bubble, for widget tests
  /// (`test/features/engines/attention_parity/`).
  static Key numberKey(int value) => Key('attentionParity.number.$value');

  /// Key of the restart counter caption.
  static const Key restartsKey = Key('attentionParity.restarts');

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    return _ParitySeries(
      key: ValueKey(item.id),
      layout: AttentionParityEngine.layoutOf(item),
      render: render,
    );
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    const layout = ParityLayout(
      numbers: [
        ParityNumber(value: 2, x: 0.2, y: 0.25),
        ParityNumber(value: 5, x: 0.7, y: 0.2),
        ParityNumber(value: 8, x: 0.35, y: 0.7),
        ParityNumber(value: 11, x: 0.8, y: 0.65),
      ],
      path: [2, 5, 8, 11],
    );
    return const IgnorePointer(
      child: _ParityBoard(layout: layout, progress: 0),
    );
  }
}

class _ParitySeries extends StatefulWidget {
  const _ParitySeries({required this.layout, required this.render, super.key});

  final ParityLayout layout;
  final ActivityRenderContext render;

  @override
  State<_ParitySeries> createState() => _ParitySeriesState();
}

class _ParitySeriesState extends State<_ParitySeries> {
  int _progress = 0;
  int _restarts = 0;
  int _totalTaps = 0;
  bool _completed = false;
  int? _lastWrongValue;

  void _onTap(int value) {
    if (!widget.render.acceptsInput || _completed) return;
    setState(() {
      _totalTaps++;
      _lastWrongValue = null;
      final expected = widget.layout.path[_progress];
      if (value == expected) {
        _progress++;
        if (_progress == widget.layout.path.length) {
          _completed = true;
          widget.render.onAnswer(
            Answer.raw({
              'path': widget.layout.pathTokens,
              'restarts': _restarts,
              'totalTaps': _totalTaps,
            }),
          );
        }
      } else {
        _restarts++;
        _progress = 0;
        _lastWrongValue = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.attentionParityRestartCount(_restarts),
          key: AttentionParityRenderer.restartsKey,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.sm),
        Expanded(
          child: _ParityBoard(
            layout: widget.layout,
            progress: _progress,
            wrongValue: _lastWrongValue,
            onTap: _onTap,
          ),
        ),
      ],
    );
  }
}

/// The scattered bubbles and the START/END labels, sized to the available
/// square.
class _ParityBoard extends StatelessWidget {
  const _ParityBoard({
    required this.layout,
    required this.progress,
    this.wrongValue,
    this.onTap,
  });

  final ParityLayout layout;

  /// Number of path steps already tapped correctly.
  final int progress;

  /// A value just tapped out of order, flashed as an error and cleared on
  /// the next tap.
  final int? wrongValue;

  final void Function(int value)? onTap;

  /// Bubble diameter, always at least the design system's minimum touch
  /// target.
  static const double bubbleSize = 48;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final number in layout.numbers) ...[
                  Positioned(
                    left: number.x * side - bubbleSize / 2,
                    top: number.y * side - bubbleSize / 2,
                    width: bubbleSize,
                    height: bubbleSize,
                    child: _NumberBubble(
                      number: number,
                      isDone: layout.path.indexOf(number.value) < progress,
                      isWrong: number.value == wrongValue,
                      onTap: onTap == null ? null : () => onTap!(number.value),
                    ),
                  ),
                  if (number.value == layout.startValue ||
                      number.value == layout.endValue)
                    Positioned(
                      left: number.x * side - bubbleSize,
                      top: number.y * side - bubbleSize / 2 - 18,
                      width: bubbleSize * 2,
                      child: Text(
                        number.value == layout.startValue
                            ? AppStrings.attentionParityStartLabel
                            : AppStrings.attentionParityEndLabel,
                        textAlign: TextAlign.center,
                        style: AppTheme.of(context).textStyles.caption,
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NumberBubble extends StatelessWidget {
  const _NumberBubble({
    required this.number,
    required this.isDone,
    required this.isWrong,
    required this.onTap,
  });

  final ParityNumber number;
  final bool isDone;
  final bool isWrong;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final fill = isWrong
        ? colors.errorSubtle
        : isDone
        ? colors.successSubtle
        : colors.surface;
    final border = isWrong
        ? colors.error
        : isDone
        ? colors.success
        : colors.borderStrong;
    return AppPressable(
      key: AttentionParityRenderer.numberKey(number.value),
      onPressed: onTap,
      semanticsLabel: AppStrings.attentionParityNumberSemantics(number.value),
      builder: (context, state) => DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 2),
        ),
        child: Center(
          child: Text('${number.value}', style: theme.textStyles.bodyStrong),
        ),
      ),
    );
  }
}
