import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../domain/onboarding_answers.dart';
import 'providers/onboarding_completed_provider.dart';
import 'widgets/onboarding_flow.dart';

/// First-run onboarding (US-090): disclaimer, exam date, target stage.
///
/// The router sends new users here (see `computeRedirect`). Submitting
/// persists the answers through [onboardingCompletedProvider] and lands on
/// the initial tab.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingFlow(
      onSubmit: (OnboardingAnswers answers) async {
        await ref.read(onboardingCompletedProvider.notifier).complete(answers);
        if (context.mounted) context.go(AppRoutes.initial);
      },
    );
  }
}
