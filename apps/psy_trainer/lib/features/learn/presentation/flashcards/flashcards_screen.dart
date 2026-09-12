import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/leitner_scheduler.dart';
import '../learn_screen.dart';
import '../providers/flashcards_queue_provider.dart';
import '../providers/flashcards_session_provider.dart';
import 'widgets/flip_card.dart';

/// Flashcards screen (US-042): `/learn/family/:familyId/cards` reviews one
/// family's deck; `/learn/cards` (no [familyId]) reviews every due card,
/// the Learn home's "À réviser aujourd'hui" entry.
///
/// Three phases, driven by [flashcardsSessionProvider]: the deck summary
/// ("12 à réviser · 48 au total") with a start button, the card-by-card
/// review (flip animation, Again/Hard/Good, keyboard 1/2/3 and Space), then
/// an end-of-session summary.
class FlashcardsScreen extends ConsumerWidget {
  const FlashcardsScreen({this.familyId, super.key});

  final String? familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(flashcardsQueueProvider(familyId));
    return AppScaffold(
      title: context.l10n.flashcardsTitle,
      onBack: context.pop,
      bodyPadding: EdgeInsets.all(AppTheme.of(context).spacing.lg),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LearnScreen.maxContentWidth,
          ),
          child: switch (queue) {
            AsyncData(value: final q) => _FlashcardsBody(
              familyId: familyId,
              total: q.total,
            ),
            AsyncError() => Center(child: Text(context.l10n.flashcardsError)),
            _ => Center(child: Text(context.l10n.flashcardsLoading)),
          },
        ),
      ),
    );
  }
}

class _FlashcardsBody extends ConsumerStatefulWidget {
  const _FlashcardsBody({required this.familyId, required this.total});

  final String? familyId;
  final int total;

  @override
  ConsumerState<_FlashcardsBody> createState() => _FlashcardsBodyState();
}

class _FlashcardsBodyState extends ConsumerState<_FlashcardsBody> {
  bool _started = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final notifier = ref.read(
      flashcardsSessionProvider(widget.familyId).notifier,
    );
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        notifier.flip();
      case LogicalKeyboardKey.digit1:
      case LogicalKeyboardKey.numpad1:
        notifier.grade(FlashcardGrade.again);
      case LogicalKeyboardKey.digit2:
      case LogicalKeyboardKey.numpad2:
        notifier.grade(FlashcardGrade.hard);
      case LogicalKeyboardKey.digit3:
      case LogicalKeyboardKey.numpad3:
        notifier.grade(FlashcardGrade.good);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return _DeckSummary(
        due: ref.watch(
          flashcardsQueueProvider(
            widget.familyId,
          ).select((a) => a.value?.due.length ?? 0),
        ),
        total: widget.total,
        onStart: () => setState(() => _started = true),
      );
    }

    final session = ref.watch(flashcardsSessionProvider(widget.familyId));
    if (session.isLoading) {
      return Center(child: Text(context.l10n.flashcardsLoading));
    }
    if (session.isDone) {
      return _SessionSummary(
        again: session.again,
        hard: session.hard,
        good: session.good,
        onDone: () => context.pop(),
      );
    }

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: _CardReview(familyId: widget.familyId, session: session),
    );
  }
}

/// "N à réviser · M au total" with a start button.
class _DeckSummary extends StatelessWidget {
  const _DeckSummary({
    required this.due,
    required this.total,
    required this.onStart,
  });

  final int due;
  final int total;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.flashcardsDeckSummary(due, total),
                style: theme.textStyles.title,
              ),
              if (due == 0) ...[
                SizedBox(height: theme.spacing.sm),
                Text(
                  context.l10n.flashcardsEmptyBody,
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: theme.spacing.lg),
        if (due > 0)
          PrimaryButton(label: context.l10n.flashcardsStart, onPressed: onStart)
        else
          Text(
            context.l10n.flashcardsEmptyTitle,
            style: theme.textStyles.body.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
      ],
    );
  }
}

/// The card-by-card review: flip animation, progress, grading buttons.
class _CardReview extends ConsumerWidget {
  const _CardReview({required this.familyId, required this.session});

  final String? familyId;
  final FlashcardsSessionState session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final entry = session.current!;
    final notifier = ref.read(flashcardsSessionProvider(familyId).notifier);
    final locale = context.l10n.localeName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.flashcardsProgress(
            session.index + 1,
            session.queue.length,
          ),
          style: theme.textStyles.caption,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: theme.spacing.lg),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: notifier.flip,
              child: FlipCard(
                flipped: session.flipped,
                front: _CardFace(
                  text: entry.card.front.resolve(locale),
                  hint: context.l10n.flashcardsFlipHint,
                ),
                back: _CardFace(text: entry.card.back.resolve(locale)),
              ),
            ),
          ),
        ),
        SizedBox(height: theme.spacing.lg),
        if (session.flipped)
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.flashcardsAgain,
                  onPressed: () => notifier.grade(FlashcardGrade.again),
                ),
              ),
              SizedBox(width: theme.spacing.sm),
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.flashcardsHard,
                  onPressed: () => notifier.grade(FlashcardGrade.hard),
                ),
              ),
              SizedBox(width: theme.spacing.sm),
              Expanded(
                child: PrimaryButton(
                  label: context.l10n.flashcardsGood,
                  onPressed: () => notifier.grade(FlashcardGrade.good),
                ),
              ),
            ],
          )
        else
          SecondaryButton(
            label: context.l10n.flashcardsFlipHint,
            onPressed: notifier.flip,
            expand: true,
          ),
      ],
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({required this.text, this.hint});

  final String text;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 220, minWidth: 280),
      child: AppCard(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textStyles.title,
              ),
              if (hint != null) ...[
                SizedBox(height: theme.spacing.md),
                Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: theme.textStyles.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionSummary extends StatelessWidget {
  const _SessionSummary({
    required this.again,
    required this.hard,
    required this.good,
    required this.onDone,
  });

  final int again;
  final int hard;
  final int good;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.flashcardsSummaryTitle,
          style: theme.textStyles.headline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: theme.spacing.sm),
        Text(
          context.l10n.flashcardsSummaryBody(
            again: again,
            hard: hard,
            good: good,
          ),
          style: theme.textStyles.body.copyWith(
            color: theme.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: theme.spacing.xl),
        PrimaryButton(
          label: context.l10n.flashcardsSummaryDone,
          onPressed: onDone,
        ),
      ],
    );
  }
}
