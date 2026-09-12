import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/settings/presentation/widgets/backup_section.dart';
import 'package:psy_trainer/features/settings/presentation/widgets/plain_text_area.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  late InMemoryProgressRepository repository;
  late ProviderContainer container;

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'PSY Trainer',
      packageName: 'com.example.psy_trainer',
      version: '1.2.3',
      buildNumber: '42',
      buildSignature: '',
    );
    repository = InMemoryProgressRepository();
    container = ProviderContainer(
      overrides: [progressRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  Future<void> pumpSection(WidgetTester tester) async {
    await tester.pumpApp(
      UncontrolledProviderScope(
        container: container,
        child: const BackupSection(),
      ),
      align: false,
    );
  }

  testWidgets('shows an error when importing an empty field', (tester) async {
    await pumpSection(tester);

    await tester.tap(find.text(l10nFr.backupImportAction));
    await tester.pumpAndSettle();

    expect(find.text(l10nFr.backupImportEmpty), findsOneWidget);
  });

  testWidgets('rejects a pasted document that is not a valid backup', (
    tester,
  ) async {
    await pumpSection(tester);

    final field = tester.widget<PlainTextArea>(find.byType(PlainTextArea));
    field.controller.text = 'not a backup at all';
    await tester.pump();

    await tester.tap(find.text(l10nFr.backupImportAction));
    await tester.pumpAndSettle();

    expect(find.text(l10nFr.backupErrorInvalidJson), findsOneWidget);
  });

  testWidgets('imports a valid backup and reports the summary', (tester) async {
    await repository.saveProfile(const UserProfile(locale: 'fr'));
    await pumpSection(tester);

    final field = tester.widget<PlainTextArea>(find.byType(PlainTextArea));
    field.controller.text =
        '{"format":"psy-trainer-backup","version":1,'
        '"exportedAt":"2026-09-12T10:00:00.000Z","app":{"name":"x"},'
        '"data":{}}';
    await tester.pump();

    await tester.tap(find.text(l10nFr.backupImportAction));
    await tester.pumpAndSettle();

    expect(find.text(l10nFr.backupImportSuccess(0, 0, 0)), findsOneWidget);
  });
}
