import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../engine/engine_ui.dart';

/// [ActivityRenderer] for [NumericItem], reusable by every numeric-answer
/// family (`planning_tubes`, mental arithmetic drills) by registering
/// `NumericRenderer(familyId: '...')`.
///
/// A custom on-screen keypad (digits, `.`, `-`, backspace, Valider) — never
/// the system keyboard, so `EditableText`/`TextField` are not used (see
/// `docs/ARCHITECTURE.md`, "No Material, no Cupertino"). Also accepts
/// physical-keyboard digits and Enter. Tolerance is handled by the default
/// `Scorer.scoreItem`; the runtime measures response time.
class NumericRenderer extends ActivityRenderer {
  const NumericRenderer({required this.familyId});

  @override
  final String familyId;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    return _NumericView(
      key: ValueKey(render.item.id),
      item: render.item as NumericItem,
      render: render,
    );
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _NumericExample();
}

class _NumericView extends StatefulWidget {
  const _NumericView({required this.item, required this.render, super.key});

  final NumericItem item;
  final ActivityRenderContext render;

  @override
  State<_NumericView> createState() => _NumericViewState();
}

class _NumericViewState extends State<_NumericView> {
  final FocusNode _focusNode = FocusNode();
  String _input = '';

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _acceptsInput => widget.render.acceptsInput;
  bool get _answered => widget.render.feedback != null;
  num? get _value => num.tryParse(_input);

  bool get _allowsDecimal => widget.item.inputFormat != InputFormat.integer;

  void _tapDigit(String digit) {
    if (!_acceptsInput) return;
    setState(() => _input += digit);
  }

  void _tapDecimal() {
    if (!_acceptsInput || !_allowsDecimal || _input.contains('.')) return;
    setState(() => _input += _input.isEmpty ? '0.' : '.');
  }

  void _tapSign() {
    if (!_acceptsInput) return;
    setState(() {
      if (_input.startsWith('-')) {
        _input = _input.substring(1);
      } else {
        _input = '-$_input';
      }
    });
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
    final key = event.logicalKey;
    final digit = _digitFor(key);
    if (digit != null) {
      _tapDigit(digit);
      return;
    }
    if (key == LogicalKeyboardKey.period ||
        key == LogicalKeyboardKey.numpadDecimal) {
      _tapDecimal();
      return;
    }
    if (key == LogicalKeyboardKey.minus ||
        key == LogicalKeyboardKey.numpadSubtract) {
      _tapSign();
      return;
    }
    if (key == LogicalKeyboardKey.backspace) {
      _backspace();
      return;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _validate();
    }
  }

  String? _digitFor(LogicalKeyboardKey key) {
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
    if (byDigit != -1) return '$byDigit';
    final byNumpad = numpadKeys.indexOf(key);
    if (byNumpad != -1) return '$byNumpad';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final item = widget.item;
    const locale = AppStrings.locale;
    final canValidate = _acceptsInput && _value != null;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MarkdownView(item.stem.resolve(locale)),
                  SizedBox(height: theme.spacing.lg),
                  _AnswerField(
                    key: const ValueKey('numeric_answer_field'),
                    text: _input,
                    unit: item.unit,
                    highlight: _answered
                        ? (widget.render.feedback!.correct
                              ? _FieldHighlight.correct
                              : _FieldHighlight.wrong)
                        : _FieldHighlight.none,
                  ),
                  if (_answered) ...[
                    SizedBox(height: theme.spacing.lg),
                    _Explanation(
                      expected: item.expected,
                      unit: item.unit,
                      text: item.explanation.resolve(locale),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!_answered) ...[
            SizedBox(height: theme.spacing.lg),
            _Keypad(
              allowsDecimal: _allowsDecimal,
              enabled: _acceptsInput,
              canValidate: canValidate,
              onDigit: _tapDigit,
              onDecimal: _tapDecimal,
              onSign: _tapSign,
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
  const _AnswerField({
    required this.text,
    required this.unit,
    required this.highlight,
    super.key,
  });

  final String text;
  final String? unit;
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
    final label = unit == null ? display : '$display $unit';

    return Semantics(
      label: AppStrings.numericAnswerSemanticsLabel,
      value: display,
      child: Container(
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
          label,
          textAlign: TextAlign.center,
          style: theme.textStyles.display,
        ),
      ),
    );
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({
    required this.expected,
    required this.unit,
    required this.text,
  });

  final num expected;
  final String? unit;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final expectedLabel = unit == null ? '$expected' : '$expected $unit';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.activityExplanationTitle,
            style: theme.textStyles.label,
          ),
          SizedBox(height: theme.spacing.xs),
          Text(expectedLabel, style: theme.textStyles.bodyStrong),
          SizedBox(height: theme.spacing.xs),
          MarkdownView(text),
        ],
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.allowsDecimal,
    required this.enabled,
    required this.canValidate,
    required this.onDigit,
    required this.onDecimal,
    required this.onSign,
    required this.onBackspace,
    required this.onValidate,
  });

  final bool allowsDecimal;
  final bool enabled;
  final bool canValidate;
  final void Function(String digit) onDigit;
  final VoidCallback onDecimal;
  final VoidCallback onSign;
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
      key: ValueKey('numeric_key_$digit'),
      label: '$digit',
      onPressed: enabled ? () => onDigit('$digit') : null,
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
            key: const ValueKey('numeric_key_sign'),
            label: '-',
            semanticsLabel: '-',
            onPressed: enabled ? onSign : null,
          ),
          digitKey(0),
          AppKeypadButton(
            key: const ValueKey('numeric_key_decimal'),
            label: '.',
            semanticsLabel: '.',
            onPressed: enabled && allowsDecimal ? onDecimal : null,
          ),
        ]),
        SizedBox(height: theme.spacing.sm),
        row([
          AppKeypadButton(
            key: const ValueKey('numeric_key_backspace'),
            label: '⌫',
            semanticsLabel: AppStrings.numericBackspaceSemanticsLabel,
            onPressed: enabled ? onBackspace : null,
          ),
          AppKeypadButton(
            key: const ValueKey('numeric_key_validate'),
            label: AppStrings.activityValidate,
            emphasized: true,
            onPressed: canValidate ? onValidate : null,
          ),
        ]),
      ],
    );
  }
}

/// Static, non-interactive illustration for the briefing screen.
class _NumericExample extends StatelessWidget {
  const _NumericExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppStrings.numericExampleStem, style: theme.textStyles.body),
        SizedBox(height: theme.spacing.md),
        const _AnswerField(
          text: '48',
          unit: null,
          highlight: _FieldHighlight.none,
        ),
        SizedBox(height: theme.spacing.md),
        _Keypad(
          allowsDecimal: true,
          enabled: false,
          canValidate: false,
          onDigit: (_) {},
          onDecimal: () {},
          onSign: () {},
          onBackspace: () {},
          onValidate: () {},
        ),
      ],
    );
  }
}
