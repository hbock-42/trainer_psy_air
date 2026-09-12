import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../domain/nback_engine.dart';
import '../domain/nback_stimulus.dart';
import 'nback_glyphs.dart';

/// The widget half of `memory_nback` (US-026): a big colour patch or digit
/// during `ItemPhase.stimulus`, then Yes/No buttons (and Y/N or left/right
/// arrow keys) during `ItemPhase.answer`. Never runs its own timers — the
/// runtime's cadence drives `render.phase`; `SessionHost` draws the
/// countdown bars.
///
/// `family.json` sets `inputRequirement: touch` (unlike the keyboard-native
/// activities of `docs/ARCHITECTURE.md`'s "Platforms" section): the keyboard
/// map is an accelerator for desktop/exam use, not the only way to answer,
/// so it is not labelled "non-representative".
class NbackRenderer extends ActivityRenderer {
  const NbackRenderer();

  @override
  String get familyId => 'memory_nback';

  static const Key yesKey = Key('nback.yes');
  static const Key noKey = Key('nback.no');
  static const Key stimulusKey = Key('nback.stimulus');
  static const Key primerLabelKey = Key('nback.primerLabel');
  static const Key historyStripKey = Key('nback.historyStrip');

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _NbackView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _StimulusPatch(
        stimulusKind: NbackStimulusKind.colour,
        value: 0,
        size: 96,
      );
}

class _NbackView extends StatefulWidget {
  const _NbackView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_NbackView> createState() => _NbackViewState();
}

class _NbackViewState extends State<_NbackView> {
  final FocusNode _focusNode = FocusNode();

  GeneratedItem get _item => widget.render.item as GeneratedItem;
  NbackParams get _params => _item.params as NbackParams;
  NbackStimulus get _stimulus => NbackEngine.stimulusOf(_item);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _answer(bool yes) {
    if (!widget.render.acceptsInput) return;
    widget.render.onAnswer(yes ? NbackAnswer.yes : NbackAnswer.no);
  }

  void _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyY:
      case LogicalKeyboardKey.arrowRight:
        _answer(true);
      case LogicalKeyboardKey.keyN:
      case LogicalKeyboardKey.arrowLeft:
        _answer(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final stimulus = _stimulus;
    final phase = widget.render.phase;
    final showsAnswerControls =
        phase != ItemPhase.stimulus && widget.render.acceptsInput;
    final isPractice = !widget.render.isExam;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (stimulus.isPrimer)
            Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.sm),
              child: Text(
                AppStrings.nbackPrimerLabel,
                key: NbackRenderer.primerLabelKey,
                textAlign: TextAlign.center,
                style: theme.textStyles.caption,
              ),
            ),
          if (isPractice) ...[
            _HistoryStrip(
              stimulusKind: _params.stimulusKind,
              history: stimulus.history,
            ),
            SizedBox(height: theme.spacing.lg),
          ],
          Expanded(
            child: Center(
              child: Semantics(
                label: AppStrings.nbackStimulusSemantics(
                  widget.render.itemIndex + 1,
                ),
                child: ExcludeSemantics(
                  child: _StimulusPatch(
                    key: NbackRenderer.stimulusKey,
                    stimulusKind: _params.stimulusKind,
                    value: stimulus.value,
                    size: 160,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          Row(
            children: [
              Expanded(
                child: AnswerOptionTile(
                  key: NbackRenderer.noKey,
                  label: AppStrings.nbackNoSemantics('N'),
                  state: showsAnswerControls
                      ? AnswerOptionState.idle
                      : AnswerOptionState.disabled,
                  onPressed: showsAnswerControls ? () => _answer(false) : null,
                  child: const Text(AppStrings.nbackNo),
                ),
              ),
              SizedBox(width: theme.spacing.md),
              Expanded(
                child: AnswerOptionTile(
                  key: NbackRenderer.yesKey,
                  label: AppStrings.nbackYesSemantics('Y'),
                  state: showsAnswerControls
                      ? AnswerOptionState.idle
                      : AnswerOptionState.disabled,
                  onPressed: showsAnswerControls ? () => _answer(true) : null,
                  child: const Text(AppStrings.nbackYes),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Practice-only reference window: the `n` synthetic stimuli this item's
/// role was decided against, oldest first (`NbackStimulus.history`), so a
/// learner can see what "n steps earlier" means while building the habit.
/// Not shown in exam mode (spec: the real test gives no such aid).
class _HistoryStrip extends StatelessWidget {
  const _HistoryStrip({required this.stimulusKind, required this.history});

  final NbackStimulusKind stimulusKind;
  final List<int> history;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Semantics(
      container: true,
      label: AppStrings.nbackHistoryStripLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.nbackHistoryStripLabel,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.xs),
          Row(
            key: NbackRenderer.historyStripKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final value in history) ...[
                _StimulusPatch(
                  stimulusKind: stimulusKind,
                  value: value,
                  size: 36,
                ),
                SizedBox(width: theme.spacing.xs),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// The big stimulus: a colour patch with a colour-blind-safe glyph overlay,
/// or a digit/letter, at [size] logical pixels square.
class _StimulusPatch extends StatelessWidget {
  const _StimulusPatch({
    required this.stimulusKind,
    required this.value,
    required this.size,
    super.key,
  });

  final NbackStimulusKind stimulusKind;
  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (stimulusKind == NbackStimulusKind.colour) {
      final color = nbackPalette[value % nbackPalette.length];
      return DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: theme.radii.lgAll,
          border: Border.all(color: theme.colors.borderStrong, width: 2),
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: NbackGlyphPainter(
              glyph: nbackGlyphOf(value),
              color: theme.colors.onAccent,
            ),
          ),
        ),
      );
    }
    final label = stimulusKind == NbackStimulusKind.digit
        ? '${value + 1}'
        : String.fromCharCode('A'.codeUnitAt(0) + value);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: theme.radii.lgAll,
        border: Border.all(color: theme.colors.borderStrong, width: 2),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            label,
            style: theme.textStyles.display.copyWith(
              fontSize: size * 0.5,
              color: theme.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
