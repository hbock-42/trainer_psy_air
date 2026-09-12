import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/widgets.dart';
import '../../onboarding/domain/onboarding_answers.dart';
import '../../onboarding/presentation/providers/onboarding_answers_provider.dart';
import '../../onboarding/presentation/providers/onboarding_completed_provider.dart';
import '../../onboarding/presentation/widgets/onboarding_flow.dart';

/// "Edit my profile" (US-090): replays the onboarding flow prefilled with the
/// stored answers, inside the Settings tab (`/settings/profile`).
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  static void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.settings);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(onboardingAnswersProvider);
    if (answers.isLoading) {
      return const AppScaffold(body: SizedBox.shrink());
    }
    return OnboardingFlow(
      // A profile without stored answers (never onboarded, legacy row)
      // simply replays the first run.
      initial: answers.value,
      onExit: () => _leave(context),
      onSubmit: (OnboardingAnswers submitted) async {
        await ref
            .read(onboardingCompletedProvider.notifier)
            .complete(submitted);
        if (context.mounted) _leave(context);
      },
    );
  }
}
