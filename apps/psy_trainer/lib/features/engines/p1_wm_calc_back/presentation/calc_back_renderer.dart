import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/calc_back_engine.dart';

/// The widget half of `p1_wm_calc_back` (US-106): shows one chained
/// calculation ("7 + ?") and a numeric keypad; "?" is the result the
/// candidate must recall from `stage` calculations earlier -- never shown
/// again, so the recall is the whole point.
///
/// Cadence-free, like most numeric-answer families: `render.phase` never
/// leaves `answer` (no `defaultCadence` on this family either), so the
/// keypad is available for the whole per-item window `SessionHost` already
/// draws from `render.itemDeadline`. No renderer-owned timers.
class CalcBackRenderer extends ActivityRenderer {
  const CalcBackRenderer();

  @override
  String get familyId => 'p1_wm_calc_back';

  static const Key stemKey = Key('calc_back.stem');
  static const Key stageKey = Key('calc_back.stage');
  static const Key answerFieldKey = Key('calc_back.answer');
  static const Key backspaceKey = Key('calc_back.backspace');
  static const Key validateKey = Key('calc_back.validate');
  static Key keypadDigitKey(int digit) => Key('calc_back.digit_$digit');

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _CalcBackView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _CalcBackExample();
}

class _CalcBackView extends StatefulWidget {
  const _CalcBackView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_CalcBackView> createState() => _CalcBackViewState();
}

class _CalcBackViewState extends State<_CalcBackView> {
  final FocusNode _focusNode = FocusNode();
  String _input = '';

  GeneratedItem get _item => widget.render.item as GeneratedItem;
  P1WmCalcBackParams get _params => _item.params as P1WmCalcBackParams;
  CalcBackStep get _step => CalcBackEngine.stepOf(_item);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _acceptsInput => widget.render.acceptsInput;
  int? get _value => int.tryParse(_input);

  void _tapDigit(int digit) {
    if (!_acceptsInput) return;
    setState(() => _input += '$digit');
  }

  void _backspace() {
    if (!_acceptsInput || _input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _validate() {
    if (!_acceptsInput) return;
    final value = _value;
    if (value == null) return;
    widget.render.onAnswer(Answer.numeric(value));
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final digit = _digitFor(event.logicalKey);
    if (digit != null) {
      _tapDigit(digit);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      _backspace();
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _validate();
    }
  }

  static int? _digitFor(LogicalKeyboardKey key) {
    const digitKeys = [
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
    ];
    const numpadKeys = [
      LogicalKeyboardKey.numpad0,
      LogicalKeyboardKey.numpad1,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpad3,
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.numpad6,
      LogicalKeyboardKey.numpad7,
      LogicalKeyboardKey.numpad8,
      LogicalKeyboardKey.numpad9,
    ];
    final byDigit = digitKeys.indexOf(key);
    if (byDigit != -1) return byDigit;
    final byNumpad = numpadKeys.indexOf(key);
    if (byNumpad != -1) return byNumpad;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final step = _step;
    final answered = widget.render.feedback != null;
    final canValidate = _acceptsInput && _value != null;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.calcBackStageLabel(step.stage, _params.stageCount),
            key: CalcBackRenderer.stageKey,
            textAlign: TextAlign.center,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.sm),
          Expanded(
            child: Center(
              child: Semantics(
                label: context.l10n.calcBackStemSemantics(step.stage),
                child: Text(
                  '${step.operand} ${step.op.symbol} ?',
                  key: CalcBackRenderer.stemKey,
                  style: theme.textStyles.display,
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          _AnswerField(
            text: _input,
            highlight: !answered
                ? _FieldHighlight.none
                : widget.render.feedback!.correct
                ? _FieldHighlight.correct
                : _FieldHighlight.wrong,
          ),
          if (!answered) ...[
            SizedBox(height: theme.spacing.lg),
            _DigitKeypad(
              enabled: _acceptsInput,
              canValidate: canValidate,
              onDigit: _tapDigit,
              onBackspace: _backspace,
              onValidate: _validate,
            ),
          ],
        ],
      ),
    );
  }
}

enum _FieldHighlight { none, correct, wrong }

class _AnswerField extends StatelessWidget {
  const _AnswerField({required this.text, required this.highlight});

  final String text;
  final _FieldHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final (background, border) = switch (highlight) {
      _FieldHighlight.none => (colors.surface, colors.border),
      _FieldHighlight.correct => (colors.successSubtle, colors.success),
      _FieldHighlight.wrong => (colors.errorSubtle, colors.error),
    };
    final display = text.isEmpty ? '—' : text;
    return Semantics(
      label: context.l10n.numericAnswerSemanticsLabel,
      value: display,
      child: Container(
        key: CalcBackRenderer.answerFieldKey,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.lg,
          vertical: theme.spacing.md,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: theme.radii.mdAll,
          border: Border.all(color: border, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          display,
          textAlign: TextAlign.center,
          style: theme.textStyles.display,
        ),
      ),
    );
  }
}

class _DigitKeypad extends StatelessWidget {
  const _DigitKeypad({
    required this.enabled,
    required this.canValidate,
    required this.onDigit,
    required this.onBackspace,
    required this.onValidate,
  });

  final bool enabled;
  final bool canValidate;
  final void Function(int digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    Widget row(List<Widget> children) => Row(
      children: [
        for (final (i, child) in children.indexed) ...[
          if (i > 0) SizedBox(width: theme.spacing.sm),
          Expanded(child: child),
        ],
      ],
    );

    Widget digitKey(int digit) => AppKeypadButton(
      key: CalcBackRenderer.keypadDigitKey(digit),
      label: '$digit',
      onPressed: enabled ? () => onDigit(digit) : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row([digitKey(7), digitKey(8), digitKey(9)]),
        SizedBox(height: theme.spacing.sm),
        row([digitKey(4), digitKey(5), digitKey(6)]),
        SizedBox(height: theme.spacing.sm),
        row([digitKey(1), digitKey(2), digitKey(3)]),
        SizedBox(height: theme.spacing.sm),
        row([
          AppKeypadButton(
            key: CalcBackRenderer.backspaceKey,
            label: '⌫',
            semanticsLabel: context.l10n.numericBackspaceSemanticsLabel,
            onPressed: enabled ? onBackspace : null,
          ),
          digitKey(0),
          AppKeypadButton(
            key: CalcBackRenderer.validateKey,
            label: context.l10n.activityValidate,
            emphasized: true,
            onPressed: canValidate ? onValidate : null,
          ),
        ]),
      ],
    );
  }
}

/// Static, non-interactive illustration for the briefing screen.
class _CalcBackExample extends StatelessWidget {
  const _CalcBackExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.calcBackExampleStage,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.sm),
        Text('7 + ?', style: theme.textStyles.display),
        SizedBox(height: theme.spacing.md),
        const _AnswerField(text: '12', highlight: _FieldHighlight.none),
      ],
    );
  }
}
