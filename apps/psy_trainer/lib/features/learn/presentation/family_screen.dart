import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:psy_content/psy_content.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'learn_screen.dart';
import 'providers/family_lessons_provider.dart';
import 'providers/family_mastery_provider.dart';
import 'providers/family_provider.dart';
import 'widgets/confidence_chip.dart';

/// Family page (`/learn/family/:familyId`): what the activity evaluates, its
/// format, mastery, quick actions and the list of its lessons.
///
/// Placeholder scope for US-040: lessons are listed by title only; US-041
/// makes them open in the lesson viewer, US-042 enables the flashcards
/// action.
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({required this.familyId, super.key});

  final String familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final family = ref.watch(familyProvider(familyId));

    return AppScaffold(
      title: switch (family) {
        AsyncData(value: final f?) => f.name.resolve(AppStrings.locale),
        _ => AppStrings.tabLearn,
      },
      onBack: context.pop,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LearnScreen.maxContentWidth,
          ),
          child: switch (family) {
            AsyncData(value: final f?) => _FamilyBody(family: f),
            AsyncData() || AsyncError() => Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: const Text(AppStrings.familyNotFound),
            ),
            _ => Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: const Text(AppStrings.familyLoading),
            ),
          },
        ),
      ),
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
    final masteryText = switch (mastery) {
      AsyncData(:final value?) => AppStrings.masteryPercent(value),
      _ => AppStrings.familyMasteryUnknown,
    };
    final secondary = theme.textStyles.body.copyWith(
      color: theme.colors.textSecondary,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.familyEvaluatedLabel,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.xs),
          Text(family.description.resolve(AppStrings.locale)),
          SizedBox(height: theme.spacing.lg),
          Wrap(
            spacing: theme.spacing.md,
            runSpacing: theme.spacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ScoreCard(
                title: AppStrings.familyFormatLabel,
                value: AppStrings.familyFormat(
                  itemCount: family.defaultItemCount,
                  durationSec: family.defaultDurationSec,
                  perItemSec: family.defaultPerItemTimeSec,
                ),
              ),
              ScoreCard(
                title: AppStrings.familyMasteryLabel,
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
                label: AppStrings.familyActionTrain,
                icon: AppIconGlyph.target,
                onPressed: () => context.go(AppRoutes.train),
              ),
              const SecondaryButton(label: AppStrings.familyActionCards),
            ],
          ),
          SizedBox(height: theme.spacing.xl),
          const SectionHeader(title: AppStrings.familyLessonsTitle),
          SizedBox(height: theme.spacing.md),
          switch (lessons) {
            AsyncData(value: final list) when list.isEmpty => Text(
              AppStrings.familyLessonsEmpty,
              style: secondary,
            ),
            AsyncData(value: final list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, lesson) in list.indexed) ...[
                  if (i > 0) SizedBox(height: theme.spacing.sm),
                  _LessonTile(lesson: lesson),
                ],
              ],
            ),
            AsyncError() => Text(
              AppStrings.learnFamiliesError,
              style: secondary,
            ),
            _ => Text(AppStrings.familyLoading, style: secondary),
          },
        ],
      ),
    );
  }
}

/// A lesson title with its summary and reading time (not tappable yet, see
/// US-041).
class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final summary = lesson.summary?.resolve(AppStrings.locale);
    final minutes = lesson.estimatedReadMin;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.title.resolve(AppStrings.locale),
            style: theme.textStyles.bodyStrong,
          ),
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
              AppStrings.lessonReadTime(minutes),
              style: theme.textStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
}
