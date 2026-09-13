import 'package:flutter/services.dart'
    show KeyDownEvent, KeyEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/angle_board.dart';
import '../domain/p1_angles_engine.dart';
import 'angles_painter.dart';

/// The widget half of `p1_angles` ("Angles à saisir", US-114, spec §2.3 row
/// 5): the board of drawn angles above 9 selectable candidate values (reuses
/// `arithmetic_grid`'s multi-select pattern, spec §4.1 row 5), a "Valider"
/// button, and keyboard input: digits 1..9 toggle a candidate, Enter
/// validates.
class P1AnglesRenderer extends ActivityRenderer {
  const P1AnglesRenderer();

  @override
  String get familyId => 'p1_angles';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _AnglesBoard(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _AnglesExample();

  /// `Key` of the candidate tile at [index] (0-based).
  static Key candidateKey(int index) => Key('p1_angles.candidate.$index');

  static const Key validateKey = Key('p1_angles.validate');
}

class _AnglesBoard extends StatefulWidget {
  const _AnglesBoard({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_AnglesBoard> createState() => _AnglesBoardState();
}

class _AnglesBoardState extends State<_AnglesBoard> {
  final FocusNode _focusNode = FocusNode();
  final Set<int> _selected = {};

  AngleBoard get _board =>
      P1AnglesEngine.boardOf(widget.render.item as GeneratedItem);

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
      if (index < _board.candidates.length) _toggle(index);
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
    final board = _board;
    final showsFeedback = render.showsFeedback && render.isAnswered;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 140, child: AnglesPainterBox(angles: board.angles)),
          SizedBox(height: theme.spacing.lg),
          Expanded(
            child: _CandidateGrid(
              candidates: board.candidates,
              correctIndices: board.correctIndices,
              angles: board.angles,
              selected: _selected,
              acceptsInput: render.acceptsInput,
              showsFeedback: showsFeedback,
              onToggle: _toggle,
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          PrimaryButton(
            key: P1AnglesRenderer.validateKey,
            label: context.l10n.activityValidate,
            expand: true,
            onPressed: render.acceptsInput ? _submit : null,
          ),
        ],
      ),
    );
  }
}

/// The board's `CustomPaint`, coloured with the current theme (kept apart
/// from [AnglesPainter] itself, which is theme-agnostic).
class AnglesPainterBox extends StatelessWidget {
  const AnglesPainterBox({required this.angles, super.key});

  final List<DrawnAngle> angles;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.surfaceRaised,
        borderRadius: theme.radii.mdAll,
        border: Border.all(color: theme.colors.border),
      ),
      child: ClipRRect(
        borderRadius: theme.radii.mdAll,
        child: CustomPaint(
          painter: AnglesPainter(
            angles: angles,
            rayColor: theme.colors.textPrimary,
            arcColor: theme.colors.accent,
            labelColor: theme.colors.textPrimary,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _CandidateGrid extends StatelessWidget {
  const _CandidateGrid({
    required this.candidates,
    required this.correctIndices,
    required this.angles,
    required this.selected,
    required this.acceptsInput,
    required this.showsFeedback,
    required this.onToggle,
  });

  final List<int> candidates;
  final Set<int> correctIndices;
  final List<DrawnAngle> angles;
  final Set<int> selected;
  final bool acceptsInput;
  final bool showsFeedback;
  final void Function(int index) onToggle;

  /// The label (A, B, C...) of the drawn angle whose true value this
  /// candidate matches, or null when the candidate is a distractor.
  String? _matchLabelFor(int candidateIndex) {
    if (!correctIndices.contains(candidateIndex)) return null;
    final value = candidates[candidateIndex];
    for (final angle in angles) {
      if (angle.sweepDeg == value) return angle.label;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.6,
      ),
      itemCount: candidates.length,
      itemBuilder: (context, index) {
        final value = candidates[index];
        final isCorrect = correctIndices.contains(index);
        final isSelected = selected.contains(index);
        final matchLabel = showsFeedback ? _matchLabelFor(index) : null;

        AnswerOptionState state;
        if (showsFeedback) {
          final decisionRight = isSelected == isCorrect;
          state = decisionRight
              ? (isCorrect
                    ? AnswerOptionState.correct
                    : AnswerOptionState.disabled)
              : AnswerOptionState.wrong;
        } else {
          state = isSelected
              ? AnswerOptionState.selected
              : AnswerOptionState.idle;
        }

        return AnswerOptionTile(
          key: P1AnglesRenderer.candidateKey(index),
          label: context.l10n.p1AnglesCandidateSemantics(index + 1, value),
          state: state,
          onPressed: acceptsInput ? () => onToggle(index) : null,
          child: Text(
            matchLabel == null ? '$value°' : '$value° ($matchLabel)',
            textAlign: TextAlign.center,
            style: theme.textStyles.numeric,
          ),
        );
      },
    );
  }
}

/// A worked example for the briefing screen: two fixed angles and their 9
/// candidates, no interaction.
class _AnglesExample extends StatelessWidget {
  const _AnglesExample();

  static const _angles = [
    DrawnAngle(label: 'A', startRad: 0, sweepDeg: 45),
    DrawnAngle(label: 'B', startRad: 1.2, sweepDeg: 120),
  ];
  static const _candidates = [15, 30, 45, 60, 80, 100, 120, 140, 160];
  static const _correct = {2, 6};

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.p1AnglesExampleCaption, style: theme.textStyles.body),
        SizedBox(height: theme.spacing.md),
        const SizedBox(height: 120, child: AnglesPainterBox(angles: _angles)),
        SizedBox(height: theme.spacing.md),
        Wrap(
          spacing: theme.spacing.sm,
          runSpacing: theme.spacing.sm,
          children: [
            for (var i = 0; i < _candidates.length; i++)
              _ExampleChip(
                value: _candidates[i],
                isCorrect: _correct.contains(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _ExampleChip extends StatelessWidget {
  const _ExampleChip({required this.value, required this.isCorrect});

  final int value;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCorrect ? colors.successSubtle : colors.surface,
        border: Border.all(color: isCorrect ? colors.success : colors.border),
        borderRadius: theme.radii.smAll,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        ),
        child: Text('$value°', style: theme.textStyles.caption),
      ),
    );
  }
}
