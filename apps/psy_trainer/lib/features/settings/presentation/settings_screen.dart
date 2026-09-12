import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../onboarding/domain/onboarding_answers.dart';
import '../../onboarding/presentation/providers/onboarding_answers_provider.dart';

/// Placeholder for the Settings tab; replaced by US-091. Already offers the
/// "edit my profile" entry that reopens the onboarding answers (US-090).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final answers = ref.watch(onboardingAnswersProvider);

    return AppScaffold(
      title: context.l10n.tabSettings,
      bodyPadding: EdgeInsets.all(theme.spacing.lg),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileSummary(answers: answers.value),
          SizedBox(height: theme.spacing.md),
          SecondaryButton(
            label: context.l10n.settingsEditProfile,
            expand: true,
            onPressed: () => context.go(AppRoutes.settingsProfile),
          ),
        ],
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.answers});

  final OnboardingAnswers? answers;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final examDate = answers?.examDate;
    final stage = answers?.targetStage;
    final examDateText = examDate == null
        ? context.l10n.settingsProfileSummaryNoExamDate
        : context.l10n.formatLongDate(examDate);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.onboardingEditTitle, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.sm),
          Text('${context.l10n.settingsProfileSummaryExamDate}$examDateText'),
          if (stage != null) ...[
            SizedBox(height: theme.spacing.xs),
            Text(
              '${context.l10n.settingsProfileSummaryStage}'
              '${stage.key.toUpperCase()}',
            ),
          ],
        ],
      ),
    );
  }
}
