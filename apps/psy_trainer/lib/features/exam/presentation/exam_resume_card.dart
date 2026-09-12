import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/exam_resume_provider.dart';

/// "Reprendre la simulation" (US-064): shown on the Exam home above the
/// blueprint list when [examResumeProvider] finds an exam session still
/// `inProgress` within 10 minutes of its last attempt (a crash, or the app
/// being killed, left it behind). Tapping re-enters `/exam/run/:blueprintId`
/// for that blueprint; `ExamRunController` finds the same session again and
/// resumes it at the section it was on, with the remaining section time.
/// Renders nothing while loading, on error, or when there is nothing to
/// resume.
class ExamResumeCard extends ConsumerWidget {
  const ExamResumeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(examResumeProvider);
    if (async is! AsyncData<ExamResumeEntry?>) return const SizedBox.shrink();
    final entry = async.value;
    if (entry == null) return const SizedBox.shrink();

    final theme = AppTheme.of(context);
    final name =
        entry.blueprintName ?? entry.candidate.session.blueprintId ?? '';

    return Padding(
      key: const Key('exam_home.resume'),
      padding: EdgeInsets.only(bottom: theme.spacing.lg),
      child: AppCard(
        semanticsLabel: AppStrings.examResumeCardAction,
        onPressed: () => _resume(context, entry),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.examResumeCardTitle,
                    style: theme.textStyles.bodyStrong,
                  ),
                  SizedBox(height: theme.spacing.xs),
                  Text(
                    AppStrings.examResumeCardSubtitle(name),
                    style: theme.textStyles.caption,
                  ),
                ],
              ),
            ),
            SizedBox(width: theme.spacing.sm),
            PrimaryButton(
              label: AppStrings.examResumeCardAction,
              onPressed: () => _resume(context, entry),
            ),
          ],
        ),
      ),
    );
  }

  void _resume(BuildContext context, ExamResumeEntry entry) {
    final blueprintId = entry.candidate.session.blueprintId;
    if (blueprintId == null) return;
    unawaited(context.push(AppRoutes.examRun(blueprintId)));
  }
}
