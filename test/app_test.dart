import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';

import 'helpers/onboarding_fakes.dart';
import 'helpers/psy0_families.dart';

void main() {
  testWidgets('root is a WidgetsApp under a ProviderScope and shows a tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
          progressRepositoryOverride(),
        ],
        child: const PsyTrainerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(AppThemeScope), findsOneWidget);
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}
