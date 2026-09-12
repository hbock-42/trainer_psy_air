import 'package:flutter/services.dart'
    show KeyDownEvent, KeyEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/arithmetic_grid.dart';
import '../domain/arithmetic_grid_engine.dart';

/// The widget half of `arithmetic_grid` (US-023, spec §2.4-J): a tappable
/// 3×3 grid of equalities, a "Valider" button, and (touch fallback aside)
/// the keyboard input the real test needs: digits 1..9 toggle a cell,
/// Enter validates.
class ArithmeticGridRenderer extends ActivityRenderer {
  const ArithmeticGridRenderer();

  @override
  String get familyId => 'arithmetic_grid';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _ArithmeticGridBoard(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _ArithmeticGridExample();

  /// `Key` of the cell at row-major [index] (0-based).
  static Key cellKey(int index) => Key('arithmetic_grid.cell.$index');

  static const Key validateKey = Key('arithmetic_grid.validate');
}

class _ArithmeticGridBoard extends StatefulWidget {
  const _ArithmeticGridBoard({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_ArithmeticGridBoard> createState() => _ArithmeticGridBoardState();
}

class _ArithmeticGridBoardState extends State<_ArithmeticGridBoard> {
  final FocusNode _focusNode = FocusNode();
  final Set<int> _selected = {};

  ArithmeticGrid get _grid =>
      ArithmeticGridEngine.gridOf(widget.render.item as GeneratedItem);

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
    LogicalKeyboardKey.digit7: 7,
    LogicalKeyboardKey.numpad7: 7,
    LogicalKeyboardKey.digit8: 8,
    LogicalKeyboardKey.numpad8: 8,
    LogicalKeyboardKey.digit9: 9,
    LogicalKeyboardKey.numpad9: 9,
  };

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final digit = _digitKeys[event.logicalKey];
    if (digit != null) {
      final index = digit - 1;
      if (index < _grid.cells.length) _toggle(index);
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
    final grid = _grid;
    final showsFeedback = render.showsFeedback && render.isAnswered;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Grid(
              grid: grid,
              selected: _selected,
              acceptsInput: render.acceptsInput,
              showsFeedback: showsFeedback,
              onToggle: _toggle,
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          PrimaryButton(
            key: ArithmeticGridRenderer.validateKey,
            label: context.l10n.arithmeticGridValidate,
            expand: true,
            onPressed: render.acceptsInput ? _submit : null,
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.grid,
    required this.selected,
    required this.acceptsInput,
    required this.showsFeedback,
    required this.onToggle,
  });

  final ArithmeticGrid grid;
  final Set<int> selected;
  final bool acceptsInput;
  final bool showsFeedback;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final rows = grid.size.rows;
    final cols = grid.size.cols;

    return Column(
      children: [
        for (var r = 0; r < rows; r++) ...[
          if (r > 0) SizedBox(height: theme.spacing.sm),
          Expanded(
            child: Row(
              children: [
                for (var c = 0; c < cols; c++) ...[
                  if (c > 0) SizedBox(width: theme.spacing.sm),
                  Expanded(
                    child: _Cell(
                      index: r * cols + c,
                      cell: grid.cells[r * cols + c],
                      isSelected: selected.contains(r * cols + c),
                      acceptsInput: acceptsInput,
                      showsFeedback: showsFeedback,
                      onToggle: onToggle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.index,
    required this.cell,
    required this.isSelected,
    required this.acceptsInput,
    required this.showsFeedback,
    required this.onToggle,
  });

  final int index;
  final ArithmeticGridCell cell;
  final bool isSelected;
  final bool acceptsInput;
  final bool showsFeedback;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    // Once answered, colour by whether the tap decision (selected or not)
    // matched the truth (wrong or not) rather than by the truth alone: the
    // correct value in the caption below explains *why*.
    final decisionRight = isSelected == cell.isWrong;
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
      key: ArithmeticGridRenderer.cellKey(index),
      onPressed: acceptsInput ? () => onToggle(index) : null,
      semanticsLabel: context.l10n.arithmeticGridCellSemantics(
        index + 1,
        cell.label,
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
          padding: EdgeInsets.all(theme.spacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cell.label,
                textAlign: TextAlign.center,
                style: theme.textStyles.numeric.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (showsFeedback && cell.isWrong) ...[
                SizedBox(height: theme.spacing.xs),
                Text(
                  context.l10n.arithmeticGridCorrectValue(cell.correctValue),
                  textAlign: TextAlign.center,
                  style: theme.textStyles.caption.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A worked example for the briefing screen: a fixed 3×3 grid with one
/// wrong equality highlighted.
class _ArithmeticGridExample extends StatelessWidget {
  const _ArithmeticGridExample();

  static final ArithmeticGrid _grid = ArithmeticGridGenerator.build(
    params: const ArithmeticGridParams(
      wrongMin: 1,
      wrongMax: 1,
      operations: [ArithmeticOperation.mul, ArithmeticOperation.add],
    ),
    seed: 1,
    difficulty: 3,
  );

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final wrong = _grid.wrongIndices;
    final cols = _grid.size.cols;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var r = 0; r < _grid.size.rows; r++)
          Padding(
            padding: EdgeInsets.only(
              bottom: r == _grid.size.rows - 1 ? 0 : theme.spacing.xs,
            ),
            child: Row(
              children: [
                for (var c = 0; c < cols; c++) ...[
                  if (c > 0) SizedBox(width: theme.spacing.xs),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final index = r * cols + c;
                        final cell = _grid.cells[index];
                        final isWrong = wrong.contains(index);
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: isWrong
                                ? theme.colors.errorSubtle
                                : theme.colors.surface,
                            border: Border.all(
                              color: isWrong
                                  ? theme.colors.error
                                  : theme.colors.border,
                            ),
                            borderRadius: theme.radii.smAll,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: theme.spacing.sm,
                            ),
                            child: Text(
                              cell.label,
                              textAlign: TextAlign.center,
                              style: theme.textStyles.caption,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        SizedBox(height: theme.spacing.sm),
        Text(
          context.l10n.arithmeticGridExampleCaption,
          style: theme.textStyles.caption,
        ),
      ],
    );
  }
}
