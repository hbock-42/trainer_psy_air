import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../domain/matrix_board.dart';
import '../domain/matrix_figure.dart';
import '../domain/raven_matrices_engine.dart';
import 'matrix_explanation.dart';
import 'matrix_painter.dart';

/// The widget half of `p1_raven_matrices` (US-107, spec §2.3 row 11): a 3x3
/// figure matrix with the bottom-right tile hidden, answered by picking one
/// of 8 candidate tiles. Practice answers on tap; exam mode selects then
/// requires "Valider" (mirrors `McqRenderer`'s `_choose`/`_validate` split).
/// Touch (tap) or keyboard (digits 1-8) both answer directly in practice.
class RavenMatricesRenderer extends ActivityRenderer {
  const RavenMatricesRenderer();

  @override
  String get familyId => 'p1_raven_matrices';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _RavenMatricesView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _RavenMatricesExample();

  static Key candidateKey(int index) => Key('raven_matrices.candidate.$index');
}

class _RavenMatricesView extends StatefulWidget {
  const _RavenMatricesView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_RavenMatricesView> createState() => _RavenMatricesViewState();
}

class _RavenMatricesViewState extends State<_RavenMatricesView> {
  final FocusNode _focusNode = FocusNode();
  int? _selection;

  MatrixBoard get _board =>
      RavenMatricesEngine.boardOf(widget.render.item as GeneratedItem);

  bool get _isExam => widget.render.isExam;
  bool get _answered => widget.render.feedback != null;
  bool get _acceptsInput => widget.render.acceptsInput;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _choose(int index) {
    if (!_acceptsInput) return;
    setState(() => _selection = index);
    if (!_isExam) {
      widget.render.onAnswer(Answer.choice(index));
    }
  }

  void _validate() {
    if (!_acceptsInput || _selection == null) return;
    widget.render.onAnswer(Answer.choice(_selection!));
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final index = _digitIndex(event.logicalKey);
    if (index != null && index < _board.candidates.length) {
      _choose(index);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _validate();
    }
  }

  static int? _digitIndex(LogicalKeyboardKey key) {
    const digits = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
    ];
    const numpad = [
      LogicalKeyboardKey.numpad1,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpad3,
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.numpad6,
      LogicalKeyboardKey.numpad7,
      LogicalKeyboardKey.numpad8,
    ];
    final byDigit = digits.indexOf(key);
    if (byDigit != -1) return byDigit;
    final byNumpad = numpad.indexOf(key);
    if (byNumpad != -1) return byNumpad;
    return null;
  }

  AnswerOptionState _stateFor(int index) {
    if (_answered) {
      if (index == _board.correctIndex) return AnswerOptionState.correct;
      if (index == _selection) return AnswerOptionState.wrong;
      return AnswerOptionState.disabled;
    }
    if (_isExam) {
      return index == _selection
          ? AnswerOptionState.selected
          : AnswerOptionState.idle;
    }
    return AnswerOptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final board = _board;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  // Capped so the matrix (aspect ratio 1, otherwise as wide
                  // as the screen) and the 2x4 candidate grid both fit a
                  // small phone viewport without either one growing as tall
                  // as it is wide on a wide screen.
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MatrixGrid(board: board, revealAnswer: _answered),
                      SizedBox(height: theme.spacing.lg),
                      _CandidateGrid(
                        board: board,
                        stateFor: _stateFor,
                        onSelect: _choose,
                      ),
                      if (_answered) ...[
                        SizedBox(height: theme.spacing.lg),
                        _Explanation(board: board),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isExam && !_answered) ...[
            SizedBox(height: theme.spacing.md),
            PrimaryButton(
              key: const ValueKey('raven_matrices_validate'),
              label: context.l10n.activityValidate,
              expand: true,
              onPressed: _selection == null ? null : _validate,
            ),
          ],
        ],
      ),
    );
  }
}

/// The 3x3 matrix; the bottom-right cell shows a "?" until [revealAnswer].
class _MatrixGrid extends StatelessWidget {
  const _MatrixGrid({required this.board, required this.revealAnswer});

  final MatrixBoard board;
  final bool revealAnswer;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.borderStrong, width: 2),
          borderRadius: theme.radii.smAll,
        ),
        child: Column(
          children: [
            for (var r = 0; r < 3; r++)
              Expanded(
                child: Row(
                  children: [
                    for (var c = 0; c < 3; c++)
                      Expanded(
                        child: _MatrixCell(
                          figure: (r == 2 && c == 2 && !revealAnswer)
                              ? null
                              : board.cells[r][c],
                          isMissing: r == 2 && c == 2,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MatrixCell extends StatelessWidget {
  const _MatrixCell({required this.figure, required this.isMissing});

  /// Null while the bottom-right cell is still hidden.
  final MatrixFigure? figure;
  final bool isMissing;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final figure = this.figure;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.border),
        color: isMissing && figure == null ? theme.colors.surfaceRaised : null,
      ),
      child: figure == null
          ? Semantics(
              label: context.l10n.matrixMissingSemantics,
              child: Center(
                child: Text(
                  context.l10n.matrixQuestionMark,
                  style: theme.textStyles.title,
                ),
              ),
            )
          : CustomPaint(painter: MatrixFigurePainter(figure: figure, color: theme.colors.textPrimary)),
    );
  }
}

/// The 8 candidates, laid out 2 rows x 4 columns.
class _CandidateGrid extends StatelessWidget {
  const _CandidateGrid({
    required this.board,
    required this.stateFor,
    required this.onSelect,
  });

  final MatrixBoard board;
  final AnswerOptionState Function(int index) stateFor;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: theme.spacing.sm,
      crossAxisSpacing: theme.spacing.sm,
      children: [
        for (var i = 0; i < board.candidates.length; i++)
          _CandidateTile(
            key: RavenMatricesRenderer.candidateKey(i),
            index: i,
            figure: board.candidates[i],
            state: stateFor(i),
            onPressed: () => onSelect(i),
          ),
      ],
    );
  }
}

class _CandidateTile extends StatelessWidget {
  const _CandidateTile({
    required this.index,
    required this.figure,
    required this.state,
    required this.onPressed,
    super.key,
  });

  final int index;
  final MatrixFigure figure;
  final AnswerOptionState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final look = _lookFor(theme, state);
    return AppPressable(
      onPressed: state.isInteractive ? onPressed : null,
      semanticsLabel: context.l10n.matrixCandidateSemantics(index + 1),
      selected: state == AnswerOptionState.selected,
      minSize: theme.spacing.minTouchTarget,
      builder: (context, pressable) => AppFocusRing(
        visible: pressable.focused,
        borderRadius: theme.radii.smAll,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: look.background,
            border: Border.all(color: look.border, width: 2),
            borderRadius: theme.radii.smAll,
          ),
          child: CustomPaint(painter: MatrixFigurePainter(figure: figure, color: theme.colors.textPrimary)),
        ),
      ),
    );
  }

  _TileLook _lookFor(AppTheme theme, AnswerOptionState state) {
    final colors = theme.colors;
    return switch (state) {
      AnswerOptionState.idle => _TileLook(background: colors.surface, border: colors.border),
      AnswerOptionState.selected =>
        _TileLook(background: colors.accentSubtle, border: colors.accent),
      AnswerOptionState.correct =>
        _TileLook(background: colors.successSubtle, border: colors.success),
      AnswerOptionState.wrong =>
        _TileLook(background: colors.errorSubtle, border: colors.error),
      AnswerOptionState.disabled =>
        _TileLook(background: colors.surface.disabledOn(theme), border: colors.border),
    };
  }
}

class _TileLook {
  const _TileLook({required this.background, required this.border});
  final Color background;
  final Color border;
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.board});

  final MatrixBoard board;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.activityExplanationTitle, style: theme.textStyles.label),
          SizedBox(height: theme.spacing.xs),
          Text(
            matrixExplanationFor(context, board.activeRules),
            style: theme.textStyles.body,
          ),
        ],
      ),
    );
  }
}

/// Static, non-interactive illustration for the briefing screen.
class _RavenMatricesExample extends StatelessWidget {
  const _RavenMatricesExample();

  static final MatrixBoard _board = buildMatrixBoard(
    seed: 1,
    params: const P1RavenMatricesParams(),
    difficulty: 1,
  );

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 140,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: IgnorePointer(child: _MatrixGrid(board: _board, revealAnswer: false)),
            ),
          ),
        ),
        SizedBox(height: theme.spacing.sm),
        Text(context.l10n.matrixExampleCaption, style: theme.textStyles.caption),
      ],
    );
  }
}
