import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../engine/engine_ui.dart';
import '../providers/train_families_provider.dart';
import 'resume_session_provider.dart';

/// "Reprendre la session" (US-051): shown on the Train home above the
/// family list when [resumeSessionProvider] finds a practice session
/// younger than 24h still `inProgress` (a crash, or the app being killed,
/// left it behind). Tapping rebuilds it with
/// `ActivitySessionRequest.resume`. Renders nothing while loading, on error,
/// or when there is nothing to resume.
class ResumeSessionCard extends ConsumerWidget {
  const ResumeSessionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(resumeSessionProvider);
    if (async is! AsyncData<ResumeCandidate?>) return const SizedBox.shrink();
    final candidate = async.value;
    if (candidate == null) return const SizedBox.shrink();

    final theme = AppTheme.of(context);
    final familyId = candidate.session.familyId;
    final families = ref.watch(trainFamiliesProvider);
    final name = switch (families) {
      AsyncData(value: final entries) => _nameOf(context, entries, familyId),
      _ => familyId,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.lg),
      child: AppCard(
        semanticsLabel: context.l10n.sessionResumeCardAction,
        onPressed: () => _resume(context, candidate),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.sessionResumeCardTitle,
                    style: theme.textStyles.bodyStrong,
                  ),
                  SizedBox(height: theme.spacing.xs),
                  Text(
                    context.l10n.sessionResumeCardSubtitle(name ?? ''),
                    style: theme.textStyles.caption,
                  ),
                ],
              ),
            ),
            SizedBox(width: theme.spacing.sm),
            PrimaryButton(
              label: context.l10n.sessionResumeCardAction,
              onPressed: () => _resume(context, candidate),
            ),
          ],
        ),
      ),
    );
  }

  static String? _nameOf(
    BuildContext context,
    List<TrainFamilyEntry> entries,
    String? familyId,
  ) {
    for (final entry in entries) {
      if (entry.family.id == familyId) {
        return entry.family.name.resolve(context.l10n.localeName);
      }
    }
    return familyId;
  }

  void _resume(BuildContext context, ResumeCandidate candidate) {
    unawaited(
      context.push(
        AppRoutes.trainSession('resume'),
        extra: ActivitySessionRequest.resume(
          session: candidate.session,
          attempts: candidate.attempts,
        ),
      ),
    );
  }
}
