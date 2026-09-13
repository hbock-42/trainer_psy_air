import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/psy2/presentation/psy2_how_it_works_screen.dart';

import '../../../helpers/psy2_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('renders the module-level "how PSY2 works" lesson', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const Psy2HowItWorksScreen(),
      overrides: [
        contentRepositoryProvider.overrideWithValue(psy2ContentRepository()),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Comment se passe le PSY2'), findsWidgets);
  });
}
