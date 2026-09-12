import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
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
    // Taller than the default test surface: the extra storage row (US-016)
    // pushed the last source item past the default viewport + cache extent,
    // where `find.text` cannot see it.
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpApp(
      tester,
      const AboutScreen(),
      overrides: [
        storageInfoProvider.overrideWith(
          (ref) async =>
              const StorageInfo(kind: StorageKind.native, persistent: true),
        ),
      ],
    );
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
    expect(
      find.textContaining(
        '${l10nFr.aboutStorageLabel}: ${l10nFr.aboutStorageLocalFile}',
      ),
      findsOneWidget,
    );
    expect(find.text(l10nFr.aboutStorageNotPersistentWarning), findsNothing);
  });

  testWidgets('shows a warning when the storage is not persistent (US-016)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpApp(
      tester,
      const AboutScreen(),
      overrides: [
        storageInfoProvider.overrideWith(
          (ref) async =>
              const StorageInfo(kind: StorageKind.inMemory, persistent: false),
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        '${l10nFr.aboutStorageLabel}: ${l10nFr.aboutStorageMemory}',
      ),
      findsOneWidget,
    );
    expect(find.text(l10nFr.aboutStorageNotPersistentWarning), findsOneWidget);
  });
}
