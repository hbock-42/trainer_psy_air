import 'app_routes.dart';

/// Top-level go_router redirect, kept as a pure function so it can be unit
/// tested without a widget tree.
///
/// Rules:
/// - onboarding not completed and not already on `/onboarding` -> `/onboarding`
/// - onboarding completed but currently on `/onboarding` -> initial tab
/// - otherwise no redirect (`null`).
///
/// `location` is the path being navigated to (go_router's
/// `state.matchedLocation`, i.e. without query parameters).
String? computeRedirect({
  required bool onboardingDone,
  required String location,
}) {
  final bool onOnboarding = location == AppRoutes.onboarding;
  if (!onboardingDone) {
    return onOnboarding ? null : AppRoutes.onboarding;
  }
  return onOnboarding ? AppRoutes.initial : null;
}
