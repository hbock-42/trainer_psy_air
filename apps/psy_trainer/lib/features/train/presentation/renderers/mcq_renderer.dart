import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../engine/engine_ui.dart';

/// Looks up the [Passage] a bank [McqItem.passageId] refers to.
///
/// `SessionItem` (the runtime's per-item envelope) and `ContentRepository`
/// carry no passage at all: `ItemBank.passages` never reaches the running
/// session (see `docs/ARCHITECTURE.md` "Engine" and CONTRACT.md; this is a
/// gap in the current contract, not something this renderer can fix). A
/// family that uses passages (`english` reading) must build one of these —
/// typically a `Map<String, Passage>` assembled from the same bank the
/// session's items came from — and hand it to [McqRenderer]; without one the
/// renderer silently omits the passage panel.
typedef PassageResolver = Passage? Function(String passageId);

/// [ActivityRenderer] for [McqItem], reusable by every bank-driven MCQ family
/// (`culture_aero`, `english`, and generator-driven ones such as
/// `spatial_viewpoint`) by registering `McqRenderer(familyId: '...')`.
///
/// Stem + optional media + 2-6 [AnswerOptionTile]s, single select. Practice
/// answers on tap and shows the correct/wrong reveal plus the explanation;
/// exam mode selects then requires "Valider" (or times out, handled by the
/// runtime). `McqItem.allowSkip` adds a "Je ne sais pas" option that sends
/// [SkipAnswer]. Keyboard: digits 1-6 pick an option, Enter validates in exam
/// mode.
class McqRenderer extends ActivityRenderer {
  const McqRenderer({required this.familyId, this.passageResolver});

  @override
  final String familyId;

  /// See [PassageResolver]; null when this family never uses passages.
  final PassageResolver? passageResolver;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    return _McqView(
      key: ValueKey(render.item.id),
      item: render.item as McqItem,
      render: render,
      passageResolver: passageResolver,
    );
  }

  @override
  Widget? buildExample(BuildContext context) => const _McqExample();
}

/// -1 sentinel for the "je ne sais pas" option so it shares the same
/// selection state as a regular choice index.
const int _skipSelection = -1;

class _McqView extends StatefulWidget {
  const _McqView({
    required this.item,
    required this.render,
    required this.passageResolver,
    super.key,
  });

  final McqItem item;
  final ActivityRenderContext render;
  final PassageResolver? passageResolver;

  @override
  State<_McqView> createState() => _McqViewState();
}

class _McqViewState extends State<_McqView> {
  final FocusNode _focusNode = FocusNode();
  int? _selection;
  bool _passageExpanded = true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isExam => widget.render.isExam;
  bool get _answered => widget.render.feedback != null;
  bool get _acceptsInput => widget.render.acceptsInput;

  void _choose(int selection) {
    if (!_acceptsInput) return;
    setState(() => _selection = selection);
    if (!_isExam) {
      widget.render.onAnswer(
        selection == _skipSelection
            ? const Answer.skip()
            : Answer.choice(selection),
      );
    }
  }

  void _validate() {
    if (!_acceptsInput || _selection == null) return;
    final selection = _selection!;
    widget.render.onAnswer(
      selection == _skipSelection
          ? const Answer.skip()
          : Answer.choice(selection),
    );
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final index = _digitIndex(event.logicalKey);
    if (index != null && index < widget.item.options.length) {
      _choose(index);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _validate();
    }
  }

  int? _digitIndex(LogicalKeyboardKey key) {
    const digits = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
    ];
    const numpad = [
      LogicalKeyboardKey.numpad1,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpad3,
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.numpad6,
    ];
    final byDigit = digits.indexOf(key);
    if (byDigit != -1) return byDigit;
    final byNumpad = numpad.indexOf(key);
    if (byNumpad != -1) return byNumpad;
    return null;
  }

  AnswerOptionState _stateFor(int index) {
    if (_answered) {
      if (index == widget.item.correctIndex) {
        return AnswerOptionState.correct;
      }
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
    final item = widget.item;
    const locale = AppStrings.locale;

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
                  if (item.passageId != null) ...[
                    _PassagePanel(
                      passage: widget.passageResolver?.call(item.passageId!),
                      expanded: _passageExpanded,
                      onToggle: () =>
                          setState(() => _passageExpanded = !_passageExpanded),
                    ),
                    SizedBox(height: theme.spacing.lg),
                  ],
                  MarkdownView(item.stem.resolve(locale)),
                  if (item.media != null) ...[
                    SizedBox(height: theme.spacing.md),
                    _MediaPlaceholder(media: item.media!),
                  ],
                  SizedBox(height: theme.spacing.lg),
                  for (final (index, option) in item.options.indexed) ...[
                    if (index > 0) SizedBox(height: theme.spacing.sm),
                    AnswerOptionTile(
                      key: ValueKey('mcq_option_$index'),
                      index: index + 1,
                      label: option.text?.resolve(locale) ?? '',
                      state: _stateFor(index),
                      onPressed: () => _choose(index),
                    ),
                  ],
                  if (item.allowSkip) ...[
                    SizedBox(height: theme.spacing.sm),
                    AnswerOptionTile(
                      key: const ValueKey('mcq_option_skip'),
                      label: AppStrings.mcqSkipOption,
                      state: _answered
                          ? AnswerOptionState.disabled
                          : (_isExam && _selection == _skipSelection
                                ? AnswerOptionState.selected
                                : AnswerOptionState.idle),
                      onPressed: () => _choose(_skipSelection),
                    ),
                  ],
                  if (_answered) ...[
                    SizedBox(height: theme.spacing.lg),
                    _Explanation(text: item.explanation.resolve(locale)),
                  ],
                ],
              ),
            ),
          ),
          if (_isExam && !_answered) ...[
            SizedBox(height: theme.spacing.md),
            PrimaryButton(
              key: const ValueKey('mcq_validate'),
              label: AppStrings.activityValidate,
              expand: true,
              onPressed: _selection == null ? null : _validate,
            ),
          ],
        ],
      ),
    );
  }
}

class _PassagePanel extends StatelessWidget {
  const _PassagePanel({
    required this.passage,
    required this.expanded,
    required this.onToggle,
  });

  final Passage? passage;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final passage = this.passage;
    if (passage == null) return const SizedBox.shrink();
    final theme = AppTheme.of(context);
    const locale = AppStrings.locale;
    final title =
        passage.title?.resolve(locale) ?? AppStrings.mcqPassageDefaultTitle;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: theme.textStyles.bodyStrong)),
              SecondaryButton(
                label: expanded
                    ? AppStrings.mcqPassageHide
                    : AppStrings.mcqPassageShow,
                onPressed: onToggle,
              ),
            ],
          ),
          if (expanded) ...[
            SizedBox(height: theme.spacing.sm),
            MarkdownView(passage.body.resolve(locale)),
          ],
        ],
      ),
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  const _MediaPlaceholder({required this.media});

  final MediaRef media;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final label =
        media.alt?.resolve(AppStrings.locale) ??
        AppStrings.lessonImagePlaceholder;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        color: theme.colors.surfaceRaised,
        borderRadius: theme.radii.mdAll,
        border: Border.all(color: theme.colors.border),
      ),
      alignment: Alignment.center,
      child: Text(label, style: theme.textStyles.caption),
    );
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.activityExplanationTitle,
            style: theme.textStyles.label,
          ),
          SizedBox(height: theme.spacing.xs),
          MarkdownView(text),
        ],
      ),
    );
  }
}

/// Static, non-interactive illustration for the briefing screen.
class _McqExample extends StatelessWidget {
  const _McqExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppStrings.mcqExampleStem, style: theme.textStyles.body),
        SizedBox(height: theme.spacing.md),
        const AnswerOptionTile(
          index: 1,
          label: AppStrings.mcqExampleOptionCorrect,
          state: AnswerOptionState.correct,
        ),
        SizedBox(height: theme.spacing.sm),
        const AnswerOptionTile(
          index: 2,
          label: AppStrings.mcqExampleOptionWrong1,
          state: AnswerOptionState.disabled,
        ),
        SizedBox(height: theme.spacing.sm),
        const AnswerOptionTile(
          index: 3,
          label: AppStrings.mcqExampleOptionWrong2,
          state: AnswerOptionState.disabled,
        ),
      ],
    );
  }
}
