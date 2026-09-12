import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/strings.dart';
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
      title: AppStrings.tabSettings,
      bodyPadding: EdgeInsets.all(theme.spacing.lg),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileSummary(answers: answers.value),
          SizedBox(height: theme.spacing.md),
          SecondaryButton(
            label: AppStrings.settingsEditProfile,
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
        ? AppStrings.settingsProfileSummaryNoExamDate
        : AppStrings.formatLongDate(examDate);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.onboardingEditTitle, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.sm),
          Text('${AppStrings.settingsProfileSummaryExamDate}$examDateText'),
          if (stage != null) ...[
            SizedBox(height: theme.spacing.xs),
            Text(
              '${AppStrings.settingsProfileSummaryStage}'
              '${stage.key.toUpperCase()}',
            ),
          ],
        ],
      ),
    );
  }
}
