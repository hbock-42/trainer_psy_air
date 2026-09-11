import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/router/app_redirect.dart';
import 'package:psy_trainer/core/router/app_routes.dart';

void main() {
  group('computeRedirect', () {
    test('sends any tab to /onboarding while onboarding is not done', () {
      for (final tab in AppRoutes.tabs) {
        expect(
          computeRedirect(onboardingDone: false, location: tab),
          AppRoutes.onboarding,
          reason: tab,
        );
      }
    });

    test('sends nested routes to /onboarding while onboarding is not done', () {
      expect(
        computeRedirect(
          onboardingDone: false,
          location: AppRoutes.trainSession('abc'),
        ),
        AppRoutes.onboarding,
      );
    });

    test('does not loop when already on /onboarding', () {
      expect(
        computeRedirect(onboardingDone: false, location: AppRoutes.onboarding),
        isNull,
      );
    });

    test('leaves tabs alone once onboarding is done', () {
      for (final tab in AppRoutes.tabs) {
        expect(
          computeRedirect(onboardingDone: true, location: tab),
          isNull,
          reason: tab,
        );
      }
    });

    test('bounces /onboarding to the initial tab once onboarding is done', () {
      expect(
        computeRedirect(onboardingDone: true, location: AppRoutes.onboarding),
        AppRoutes.initial,
      );
    });
  });
}
