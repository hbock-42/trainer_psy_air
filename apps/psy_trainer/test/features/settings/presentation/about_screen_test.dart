import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/features/settings/presentation/about_screen.dart';

import '../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'PSY Trainer',
      packageName: 'com.example.psy_trainer',
      version: '1.2.3',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  testWidgets('shows the app version, the disclaimer and a source list', (
    tester,
  ) async {
    await pumpApp(tester, const AboutScreen());
    await tester.pumpAndSettle();

    expect(find.textContaining('1.2.3'), findsOneWidget);
    expect(find.text(l10nFr.disclaimerParagraph1), findsOneWidget);
    expect(find.text(l10nFr.disclaimerParagraph2), findsOneWidget);
    expect(
      find.textContaining(l10nFr.aboutSourceAirFranceCorporate),
      findsOneWidget,
    );
    expect(
      find.textContaining(l10nFr.aboutSourceAirFranceRecruitment),
      findsOneWidget,
    );
  });
}
