import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:psy_content/psy_content.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'learn_screen.dart';
import 'providers/family_lesson_progress_provider.dart';
import 'providers/family_lessons_provider.dart';
import 'providers/family_mastery_provider.dart';
import 'providers/family_provider.dart';
import 'providers/flashcards_queue_provider.dart';
import 'providers/lesson_read_provider.dart';
import 'widgets/confidence_chip.dart';

/// Family page (`/learn/family/:familyId`): what the activity evaluates, its
/// format, mastery, quick actions and the list of its lessons (US-041 opens
/// them in the lesson viewer; US-044 shows the read/total ring; US-042 will
/// enable the flashcards action).
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({required this.familyId, super.key});

  final String familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final family = ref.watch(familyProvider(familyId));

    return AppScaffold(
      title: switch (family) {
        AsyncData(value: final f?) => f.name.resolve(context.l10n.localeName),
        _ => context.l10n.tabLearn,
      },
      onBack: context.pop,
      body: switch (family) {
        AsyncData(value: final f?) => _FamilyBody(family: f),
        AsyncData() || AsyncError() => Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: Text(context.l10n.familyNotFound),
        ),
        _ => Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: Text(context.l10n.familyLoading),
        ),
      },
    );
  }
}

class _FamilyBody extends ConsumerWidget {
  const _FamilyBody({required this.family});

  final TestFamily family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final lessons = ref.watch(familyLessonsProvider(family.id));
    final mastery = ref.watch(familyMasteryProvider(family.id));
    final hasDeck = ref.watch(
      flashcardsQueueProvider(
        family.id,
      ).select((a) => (a.value?.total ?? 0) > 0),
    );
    final masteryText = switch (mastery) {
      AsyncData(:final value?) => context.l10n.masteryPercentText(value),
      _ => context.l10n.familyMasteryUnknown,
    };
    final secondary = theme.textStyles.body.copyWith(
      color: theme.colors.textSecondary,
    );

    // Scroll view outermost, width cap inside: the margins of a wide window
    // scroll the page too.
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LearnScreen.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.familyEvaluatedLabel,
                style: theme.textStyles.caption,
              ),
              SizedBox(height: theme.spacing.xs),
              Text(family.description.resolve(context.l10n.localeName)),
              SizedBox(height: theme.spacing.lg),
              Wrap(
                spacing: theme.spacing.md,
                runSpacing: theme.spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ScoreCard(
                    title: context.l10n.familyFormatLabel,
                    value: context.l10n.familyFormat(
                      itemCount: family.defaultItemCount,
                      durationSec: family.defaultDurationSec,
                      perItemSec: family.defaultPerItemTimeSec,
                    ),
                  ),
                  ScoreCard(
                    title: context.l10n.familyMasteryLabel,
                    value: masteryText,
                  ),
                  ConfidenceChip(confidence: family.confidence),
                ],
              ),
              SizedBox(height: theme.spacing.lg),
              Wrap(
                spacing: theme.spacing.sm,
                runSpacing: theme.spacing.sm,
                children: [
                  PrimaryButton(
                    label: context.l10n.familyActionTrain,
                    icon: AppIconGlyph.target,
                    onPressed: () => context.go(AppRoutes.train),
                  ),
                  SecondaryButton(
                    label: context.l10n.familyActionCards,
                    onPressed: hasDeck
                        ? () => context.push(
                            AppRoutes.learnFamilyCards(family.id),
                          )
                        : null,
                  ),
                ],
              ),
              SizedBox(height: theme.spacing.xl),
              SectionHeader(
                title: context.l10n.familyLessonsTitle,
                trailing: _LessonProgressRing(familyId: family.id),
              ),
              SizedBox(height: theme.spacing.md),
              switch (lessons) {
                AsyncData(value: final list) when list.isEmpty => Text(
                  context.l10n.familyLessonsEmpty,
                  style: secondary,
                ),
                AsyncData(value: final list) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, lesson) in list.indexed) ...[
                      if (i > 0) SizedBox(height: theme.spacing.sm),
                      _LessonTile(familyId: family.id, lesson: lesson),
                    ],
                  ],
                ),
                AsyncError() => Text(
                  context.l10n.learnFamiliesError,
                  style: secondary,
                ),
                _ => Text(context.l10n.familyLoading, style: secondary),
              },
            ],
          ),
        ),
      ),
    );
  }
}

/// Read/total ring for the "Leçons" section header (US-044). Hidden while
/// the family has no lesson at all so an empty state stays uncluttered.
class _LessonProgressRing extends ConsumerWidget {
  const _LessonProgressRing({required this.familyId});

  final String familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(familyLessonProgressProvider(familyId));
    final (read, total) = switch (progress) {
      AsyncData(:final value) => (value.read, value.total),
      _ => (0, 0),
    };
    if (total == 0) return const SizedBox.shrink();
    final theme = AppTheme.of(context);
    return ArcGauge(
      value: read / total,
      color: theme.colors.accent,
      size: 40,
      semanticsLabel: context.l10n.familyLessonsTitle,
      semanticsValue: context.l10n.familyLessonsProgressSemantics(read, total),
      child: Text(
        context.l10n.familyLessonsProgress(read, total),
        style: theme.textStyles.caption,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// A lesson title with its summary, reading time and read state; opens the
/// lesson viewer (US-041).
class _LessonTile extends ConsumerWidget {
  const _LessonTile({required this.familyId, required this.lesson});

  final String familyId;
  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final summary = lesson.summary?.resolve(context.l10n.localeName);
    final minutes = lesson.estimatedReadMin;
    final title = lesson.title.resolve(context.l10n.localeName);
    final read = ref.watch(lessonReadProvider(lesson.id)).value ?? false;
    return AppCard(
      onPressed: () => context.go(AppRoutes.learnLesson(familyId, lesson.id)),
      semanticsLabel: title,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textStyles.bodyStrong),
                if (summary != null) ...[
                  SizedBox(height: theme.spacing.xs),
                  Text(
                    summary,
                    style: theme.textStyles.body.copyWith(
                      color: theme.colors.textSecondary,
                    ),
                  ),
                ],
                if (minutes != null) ...[
                  SizedBox(height: theme.spacing.xs),
                  Text(
                    context.l10n.lessonReadTime(minutes),
                    style: theme.textStyles.caption,
                  ),
                ],
              ],
            ),
          ),
          if (read) ...[
            SizedBox(width: theme.spacing.sm),
            AppIcon(
              AppIconGlyph.check,
              size: 18,
              color: theme.colors.success,
              semanticsLabel: context.l10n.lessonMarkedRead,
            ),
          ],
        ],
      ),
    );
  }
}
