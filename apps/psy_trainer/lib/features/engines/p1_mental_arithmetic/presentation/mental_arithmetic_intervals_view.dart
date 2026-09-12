import 'package:flutter/services.dart'
    show KeyDownEvent, KeyEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/mental_arithmetic.dart';
import '../domain/mental_arithmetic_engine.dart';

/// The `allIntervals` mode's widget: a calculation, then 5-6 interval
/// tiles the candidate multi-selects (every one that contains the true
/// value) and a "Valider" button, plus keyboard 1-6 to toggle a tile and
/// Enter to validate -- the same multi-select pattern as
/// `arithmetic_grid_renderer.dart`'s grid, over a list of interval tiles
/// instead of a grid of equalities.
class MentalArithmeticIntervalsView extends StatefulWidget {
  const MentalArithmeticIntervalsView({required this.render, super.key});

  final ActivityRenderContext render;

  /// `Key` of the tile at [index] (0-based).
  static Key tileKey(int index) => Key('mental_arithmetic.interval.$index');

  static const Key validateKey = Key('mental_arithmetic.validate');

  @override
  State<MentalArithmeticIntervalsView> createState() =>
      _MentalArithmeticIntervalsViewState();
}

class _MentalArithmeticIntervalsViewState
    extends State<MentalArithmeticIntervalsView> {
  final FocusNode _focusNode = FocusNode();
  final Set<int> _selected = {};

  MentalArithmeticProblem get _problem =>
      MentalArithmeticEngine.problemOf(widget.render.item as GeneratedItem);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggle(int index) {
    if (!widget.render.acceptsInput) return;
    setState(() {
      if (!_selected.remove(index)) _selected.add(index);
    });
  }

  void _submit() {
    if (!widget.render.acceptsInput) return;
    final indices = _selected.toList()..sort();
    widget.render.onAnswer(Answer.multiSelect(indices));
  }

  static final Map<LogicalKeyboardKey, int> _digitKeys = {
    LogicalKeyboardKey.digit1: 1,
    LogicalKeyboardKey.numpad1: 1,
    LogicalKeyboardKey.digit2: 2,
    LogicalKeyboardKey.numpad2: 2,
    LogicalKeyboardKey.digit3: 3,
    LogicalKeyboardKey.numpad3: 3,
    LogicalKeyboardKey.digit4: 4,
    LogicalKeyboardKey.numpad4: 4,
    LogicalKeyboardKey.digit5: 5,
    LogicalKeyboardKey.numpad5: 5,
    LogicalKeyboardKey.digit6: 6,
    LogicalKeyboardKey.numpad6: 6,
  };

  void _onKeyEvent(KeyEvent event, int optionCount) {
    if (event is! KeyDownEvent) return;
    final digit = _digitKeys[event.logicalKey];
    if (digit != null) {
      final index = digit - 1;
      if (index < optionCount) _toggle(index);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final problem = _problem;
    final showsFeedback = render.showsFeedback && render.isAnswered;
    final containing = showsFeedback
        ? problem.containingIndices
        : const <int>{};

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) => _onKeyEvent(event, problem.intervals.length),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${problem.expression} = ?',
                    style: theme.textStyles.display,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: theme.spacing.sm),
                  Text(
                    context.l10n.mentalArithmeticAllIntervalsPrompt,
                    style: theme.textStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: theme.spacing.lg),
                  for (final (index, interval) in problem.intervals.indexed)
                    Padding(
                      padding: EdgeInsets.only(bottom: theme.spacing.sm),
                      child: _IntervalTile(
                        index: index,
                        interval: interval,
                        isSelected: _selected.contains(index),
                        acceptsInput: render.acceptsInput,
                        showsFeedback: showsFeedback,
                        isCorrectOption: containing.contains(index),
                        onToggle: _toggle,
                      ),
                    ),
                  if (showsFeedback) ...[
                    SizedBox(height: theme.spacing.sm),
                    Text(
                      context.l10n.mentalArithmeticTrueValue(problem.trueValue),
                      style: theme.textStyles.caption,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          PrimaryButton(
            key: MentalArithmeticIntervalsView.validateKey,
            label: context.l10n.activityValidate,
            expand: true,
            onPressed: render.acceptsInput ? _submit : null,
          ),
        ],
      ),
    );
  }
}

class _IntervalTile extends StatelessWidget {
  const _IntervalTile({
    required this.index,
    required this.interval,
    required this.isSelected,
    required this.acceptsInput,
    required this.showsFeedback,
    required this.isCorrectOption,
    required this.onToggle,
  });

  final int index;
  final MentalArithmeticInterval interval;
  final bool isSelected;
  final bool acceptsInput;
  final bool showsFeedback;
  final bool isCorrectOption;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    final decisionRight = isSelected == isCorrectOption;
    Color background;
    Color border;
    if (showsFeedback) {
      background = decisionRight ? colors.successSubtle : colors.errorSubtle;
      border = decisionRight ? colors.success : colors.error;
    } else if (isSelected) {
      background = colors.accentSubtle;
      border = colors.accent;
    } else {
      background = colors.surface;
      border = colors.border;
    }

    return AppPressable(
      key: MentalArithmeticIntervalsView.tileKey(index),
      onPressed: acceptsInput ? () => onToggle(index) : null,
      semanticsLabel: context.l10n.mentalArithmeticIntervalSemantics(
        index + 1,
        interval.label,
      ),
      selected: isSelected,
      excludeSemantics: true,
      builder: (context, pressable) => AppFocusRing(
        visible: pressable.focused,
        borderRadius: theme.radii.mdAll,
        child: AnimatedContainer(
          duration: theme.durations.normal,
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border, width: 2),
            borderRadius: theme.radii.mdAll,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.md,
            vertical: theme.spacing.sm,
          ),
          child: Text(
            interval.label,
            textAlign: TextAlign.center,
            style: theme.textStyles.numeric.copyWith(color: colors.textPrimary),
          ),
        ),
      ),
    );
  }
}
