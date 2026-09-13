import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/reverse_span_engine.dart';

/// The widget half of `p1_wm_reverse_span` (US-106): the sequence is
/// revealed one digit at a time, then the candidate types it back in
/// reverse on a digit keypad.
///
/// **Digit-by-digit reveal, not the runtime's cadence.** `TimingPolicy`'s
/// `Cadence` shows a *single* stimulus phase then a *single* answer phase
/// per item (`docs/ARCHITECTURE.md#engine`); this family needs *n* stimulus
/// beats (one per digit, `n` varying 4..9 item to item) inside one item.
/// The family/blueprint content (US-101) also ships no `defaultCadence` at
/// all -- only a flat `defaultPerItemTimeSec`/`perItemTimeSec` -- so the
/// runtime never even offers a stimulus phase for this family (`render
/// .phase` is `answer` from the moment the item appears). Rather than fork
/// the shared cadence machinery for one family, this renderer paces its own
/// digit-by-digit reveal with a plain `Timer` chain (faked correctly by
/// `flutter_test`/`fakeAsync`, exactly like `SessionHost`'s own countdown
/// ticker) and only wires the keypad up once the reveal finishes; the
/// runtime's per-item deadline (`render.itemDeadline`, read from
/// `engineClockProvider` the same way `SessionHost`'s `_Countdowns` does)
/// still governs when the whole item times out regardless of how far the
/// reveal has got. [_revealMsPerDigit] gives the reveal a best-effort budget
/// within that deadline (leaving `params.answerWindowMs` for typing) so a
/// short per-item limit does not eat the whole reveal, but a family whose
/// `defaultPerItemTimeSec`/blueprint `perItemTimeSec` is shorter than
/// `reveal + answerWindowMs` will still legitimately time out before a
/// long span finishes recall -- flagged in the PR description as a
/// family-content gap (`defaultCadence` or a longer `defaultPerItemTimeSec`
/// would fix it, out of this story's "don't edit family/blueprint JSON"
/// scope).
class ReverseSpanRenderer extends ActivityRenderer {
  const ReverseSpanRenderer();

  @override
  String get familyId => 'p1_wm_reverse_span';

  static const Key digitKey = Key('reverse_span.stimulus_digit');
  static const Key typedFieldKey = Key('reverse_span.typed');
  static const Key backspaceKey = Key('reverse_span.backspace');
  static const Key validateKey = Key('reverse_span.validate');
  static Key keypadDigitKey(int digit) => Key('reverse_span.digit_$digit');

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _ReverseSpanView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _ReverseSpanExample();
}

class _ReverseSpanView extends ConsumerStatefulWidget {
  const _ReverseSpanView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  ConsumerState<_ReverseSpanView> createState() => _ReverseSpanViewState();
}

class _ReverseSpanViewState extends ConsumerState<_ReverseSpanView> {
  final FocusNode _focusNode = FocusNode();
  final List<Timer> _revealTimers = [];
  int _revealedCount = 0;
  bool _revealDone = false;
  final List<String> _typed = [];

  GeneratedItem get _item => widget.render.item as GeneratedItem;
  P1WmReverseSpanParams get _params => _item.params as P1WmReverseSpanParams;
  ReverseSpanSequence get _sequence => ReverseSpanEngine.sequenceOf(_item);

  @override
  void initState() {
    super.initState();
    _scheduleReveal();
  }

  @override
  void dispose() {
    for (final timer in _revealTimers) {
      timer.cancel();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _scheduleReveal() {
    final digits = _sequence.digits;
    final perDigitMs = _revealMsPerDigit(digits.length);
    for (var i = 0; i < digits.length; i++) {
      _revealTimers.add(
        Timer(Duration(milliseconds: perDigitMs * (i + 1)), () {
          if (!mounted) return;
          setState(() => _revealedCount = i + 1);
        }),
      );
    }
    _revealTimers.add(
      Timer(Duration(milliseconds: perDigitMs * digits.length), () {
        if (!mounted) return;
        setState(() => _revealDone = true);
      }),
    );
  }

  /// Best-effort per-digit reveal pace: a comfortable fixed beat when the
  /// item is untimed, otherwise whatever is left of the item's deadline
  /// after reserving `params.answerWindowMs` for typing, spread evenly over
  /// the digits (floored so a long span is never revealed instantaneously).
  int _revealMsPerDigit(int digitCount) {
    const comfortableMs = 700;
    const floorMs = 250;
    if (digitCount == 0) return comfortableMs;
    final deadline = widget.render.itemDeadline;
    if (deadline == null) return comfortableMs;
    final now = ref.read(engineClockProvider).now();
    final available = deadline.difference(now);
    final revealBudget =
        available - Duration(milliseconds: _params.answerWindowMs);
    if (revealBudget.isNegative) return floorMs;
    final perDigit = revealBudget.inMilliseconds / digitCount;
    return perDigit.clamp(floorMs, comfortableMs).round();
  }

  bool get _acceptsKeypad => _revealDone && widget.render.acceptsInput;

  void _tapDigit(int digit) {
    if (!_acceptsKeypad || _typed.length >= _sequence.digits.length) return;
    setState(() => _typed.add('$digit'));
  }

  void _backspace() {
    if (!_acceptsKeypad || _typed.isEmpty) return;
    setState(_typed.removeLast);
  }

  void _validate() {
    if (!_acceptsKeypad || _typed.length != _sequence.digits.length) return;
    widget.render.onAnswer(Answer.sequence(List.of(_typed)));
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
    final digits = _sequence.digits;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: _revealDone
                  ? Semantics(
                      label: context.l10n.reverseSpanTypeInstructions,
                      child: _TypedField(
                        key: ReverseSpanRenderer.typedFieldKey,
                        length: digits.length,
                        typed: _typed,
                        highlight: widget.render.feedback == null
                            ? _FieldHighlight.none
                            : widget.render.feedback!.correct
                            ? _FieldHighlight.correct
                            : _FieldHighlight.wrong,
                      ),
                    )
                  : Semantics(
                      label: context.l10n.reverseSpanDigitSemantics(
                        _revealedCount,
                        digits.length,
                      ),
                      child: ExcludeSemantics(
                        child: _revealedCount == 0
                            ? const SizedBox.shrink()
                            : _DigitPatch(
                                key: ReverseSpanRenderer.digitKey,
                                digit: digits[_revealedCount - 1],
                              ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          if (_revealDone)
            _DigitKeypad(
              enabled: _acceptsKeypad,
              canValidate: _acceptsKeypad && _typed.length == digits.length,
              onDigit: _tapDigit,
              onBackspace: _backspace,
              onValidate: _validate,
            ),
        ],
      ),
    );
  }
}

enum _FieldHighlight { none, correct, wrong }

class _DigitPatch extends StatelessWidget {
  const _DigitPatch({required this.digit, super.key});

  final int digit;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: theme.radii.lgAll,
        border: Border.all(color: theme.colors.borderStrong, width: 2),
      ),
      child: SizedBox(
        width: 160,
        height: 160,
        child: Center(
          child: Text(
            '$digit',
            style: theme.textStyles.display.copyWith(
              fontSize: 80,
              color: theme.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _TypedField extends StatelessWidget {
  const _TypedField({
    required this.length,
    required this.typed,
    required this.highlight,
    super.key,
  });

  final int length;
  final List<String> typed;
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
    final slots = [
      for (var i = 0; i < length; i++) i < typed.length ? typed[i] : '_',
    ].join(' ');
    return Container(
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
        slots,
        textAlign: TextAlign.center,
        style: theme.textStyles.display,
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
      key: ReverseSpanRenderer.keypadDigitKey(digit),
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
            key: ReverseSpanRenderer.backspaceKey,
            label: '⌫',
            semanticsLabel: context.l10n.numericBackspaceSemanticsLabel,
            onPressed: enabled ? onBackspace : null,
          ),
          digitKey(0),
          AppKeypadButton(
            key: ReverseSpanRenderer.validateKey,
            label: context.l10n.activityValidate,
            emphasized: true,
            onPressed: canValidate ? onValidate : null,
          ),
        ]),
      ],
    );
  }
}

/// Static, non-interactive illustration for the briefing screen: a
/// three-digit sequence and its expected reversed answer.
class _ReverseSpanExample extends StatelessWidget {
  const _ReverseSpanExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.reverseSpanExampleShown,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.md),
        const _DigitPatch(digit: 4),
        SizedBox(height: theme.spacing.md),
        Text(
          context.l10n.reverseSpanExampleExpected,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.md),
        const _TypedField(
          length: 3,
          typed: ['9', '2', '7'],
          highlight: _FieldHighlight.none,
        ),
      ],
    );
  }
}
