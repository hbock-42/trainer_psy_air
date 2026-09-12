import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../domain/domino_board.dart';
import '../domain/domino_explanation.dart';
import 'domino_painter.dart';

/// The widget half of `logic_dominos` (US-024): draws the series/arrangement
/// with [DominoPainter] and answers with two 0-6 selectors (the real-test
/// `DominoAnswerMode.pick`; `mcq` is not implemented by this story, see the
/// PR report).
class DominosRenderer extends ActivityRenderer {
  const DominosRenderer();

  @override
  String get familyId => 'logic_dominos';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _DominosView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _DominoTile(top: 3, bottom: 5, size: 72);
}

class _DominosView extends StatefulWidget {
  const _DominosView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_DominosView> createState() => _DominosViewState();
}

class _DominosViewState extends State<_DominosView> {
  int? _top;
  int? _bottom;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  DominoBoard get _board {
    final item = widget.render.item as GeneratedItem;
    return buildDominoBoard(
      seed: item.seed,
      params: item.params as DominosParams,
      difficulty: item.difficulty,
    );
  }

  void _pick(String half, int value) {
    if (!widget.render.acceptsInput) return;
    setState(() {
      if (half == 'top') {
        _top = value;
      } else {
        _bottom = value;
      }
    });
  }

  void _submit() {
    if (_top == null || _bottom == null) return;
    widget.render.onAnswer(Answer.sequence(['$_top', '$_bottom']));
  }

  void _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final digit = _digitOf(event.logicalKey);
    if (digit != null) {
      if (_top == null) {
        _pick('top', digit);
      } else if (_bottom == null) {
        _pick('bottom', digit);
      } else {
        // A third digit restarts the pair (top first).
        setState(() {
          _top = digit;
          _bottom = null;
        });
      }
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
    }
  }

  static int? _digitOf(LogicalKeyboardKey key) {
    const digits = [
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
    ];
    final index = digits.indexOf(key);
    return index == -1 ? null : index;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final board = _board;
    final answered = widget.render.isAnswered;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DominoSeries(
            board: board,
            revealAnswer: answered,
            pendingTop: _top,
            pendingBottom: _bottom,
          ),
          SizedBox(height: theme.spacing.lg),
          if (!answered) ...[
            _HalfSelector(
              label: AppStrings.dominoTopLabel,
              half: 'top',
              value: _top,
              onSelect: (v) => _pick('top', v),
            ),
            SizedBox(height: theme.spacing.sm),
            _HalfSelector(
              label: AppStrings.dominoBottomLabel,
              half: 'bottom',
              value: _bottom,
              onSelect: (v) => _pick('bottom', v),
            ),
            SizedBox(height: theme.spacing.md),
            PrimaryButton(
              label: AppStrings.actionValidate,
              onPressed: (_top != null && _bottom != null) ? _submit : null,
            ),
          ] else ...[
            Text(
              AppStrings.dominoAnswerSummary(
                board.answer.top,
                board.answer.bottom,
              ),
              style: theme.textStyles.bodyStrong,
            ),
            SizedBox(height: theme.spacing.xs),
            Text(explanationFor(board.ruleKinds), style: theme.textStyles.body),
          ],
        ],
      ),
    );
  }
}

class _HalfSelector extends StatelessWidget {
  const _HalfSelector({
    required this.label,
    required this.half,
    required this.value,
    required this.onSelect,
  });

  final String label;
  final String half;
  final int? value;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      children: [
        SizedBox(width: 48, child: Text(label, style: theme.textStyles.label)),
        SizedBox(width: theme.spacing.sm),
        Expanded(
          child: Row(
            children: [
              for (var v = 0; v <= 6; v++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.xs / 2,
                    ),
                    child: AppKeypadButton(
                      key: ValueKey('domino-$half-$v'),
                      label: '$v',
                      emphasized: value == v,
                      semanticsLabel: AppStrings.dominoSelectorSemantics(
                        label,
                        v,
                      ),
                      onPressed: () => onSelect(v),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The series/arrangement: [DominoLayout.row] wraps, [DominoLayout.grid]
/// lays out a fixed number of columns, [DominoLayout.spiral] places each
/// tile along a spiral. The missing domino is blank until [revealAnswer].
class _DominoSeries extends StatelessWidget {
  const _DominoSeries({
    required this.board,
    required this.revealAnswer,
    required this.pendingTop,
    required this.pendingBottom,
  });

  final DominoBoard board;
  final bool revealAnswer;
  final int? pendingTop;
  final int? pendingBottom;

  static const double _tileWidth = 56;
  static const double _tileHeight = 96;
  static const double _spacing = 10;

  @override
  Widget build(BuildContext context) {
    final tiles = [for (var i = 0; i < board.dominoes.length; i++) _tileAt(i)];
    switch (board.layout) {
      case DominoLayout.row:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(spacing: _spacing, runSpacing: _spacing, children: tiles),
        );
      case DominoLayout.grid:
        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (var i = 0; i < tiles.length; i++)
              SizedBox(width: _tileWidth, child: tiles[i]),
          ],
        );
      case DominoLayout.spiral:
        return _SpiralLayout(
          tileSize: const Size(_tileWidth, _tileHeight),
          spacing: _spacing,
          children: tiles,
        );
    }
  }

  Widget _tileAt(int index) {
    final isMissing = index == board.missingIndex;
    if (!isMissing) {
      final domino = board.dominoes[index];
      return _DominoTile(top: domino.top, bottom: domino.bottom);
    }
    if (revealAnswer) {
      return _DominoTile(top: board.answer.top, bottom: board.answer.bottom);
    }
    return Semantics(
      label: AppStrings.dominoMissingSemantics,
      child: _DominoTile(top: pendingTop, bottom: pendingBottom, missing: true),
    );
  }
}

/// Positions its children along an Archimedean spiral, columns-per-turn kept
/// small so the board stays legible on a phone screen.
class _SpiralLayout extends StatelessWidget {
  const _SpiralLayout({
    required this.tileSize,
    required this.spacing,
    required this.children,
  });

  final Size tileSize;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final step = tileSize.width + spacing;
    final positions = <Offset>[];
    var angle = 0.0;
    var radius = 0.0;
    const angleStep = 0.9;
    for (var i = 0; i < children.length; i++) {
      positions.add(Offset(radius * math.cos(angle), radius * math.sin(angle)));
      angle += angleStep;
      radius += step / (2 * math.pi / angleStep);
    }
    final maxRadius = positions.fold<double>(
      0,
      (m, p) => math.max(m, p.distance),
    );
    final side = (maxRadius + step) * 2;
    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        children: [
          for (var i = 0; i < children.length; i++)
            Positioned(
              left: side / 2 + positions[i].dx - tileSize.width / 2,
              top: side / 2 + positions[i].dy - tileSize.height / 2,
              width: tileSize.width,
              height: tileSize.height,
              child: children[i],
            ),
        ],
      ),
    );
  }
}

class _DominoTile extends StatelessWidget {
  const _DominoTile({
    required this.top,
    required this.bottom,
    this.missing = false,
    this.size = 56,
  });

  final int? top;
  final int? bottom;
  final bool missing;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: size,
      height: size * 1.7,
      child: CustomPaint(
        painter: DominoPainter(
          top: top,
          bottom: bottom,
          faceColor: missing
              ? theme.colors.surfaceRaised
              : theme.colors.surface,
          borderColor: missing ? theme.colors.accent : theme.colors.border,
          pipColor: theme.colors.textPrimary,
          missingColor: theme.colors.accentSubtle,
        ),
      ),
    );
  }
}
