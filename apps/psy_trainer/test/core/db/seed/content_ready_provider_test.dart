import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/app_database_provider.dart';
import 'package:psy_trainer/core/db/seed/asset_reader.dart';
import 'package:psy_trainer/core/db/seed/content_ready_provider.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../../../helpers/file_asset_reader.dart';
import '../example_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RootBundleAssetReader', () {
    // `flutter test` serves the assets declared in pubspec.yaml through
    // rootBundle, so this checks the registration end to end.
    const reader = RootBundleAssetReader();

    test('lists the registered content files and reads them', () async {
      final keys = await reader.listAssets(prefix: 'assets/content/');

      expect(keys, contains('assets/content/manifest.json'));
      expect(keys, contains('assets/content/psy0/module.json'));
      expect(keys, contains('assets/content/psy0/english/family.json'));
      expect(
        keys,
        contains('assets/content/psy0/lessons/memory_nback/01-n-back.fr.md'),
      );
      expect(keys.where((k) => k.contains('/examples/')), isEmpty);

      final onDisk = await FileAssetReader().listAssets(
        prefix: 'assets/content/',
      );
      expect(
        keys,
        unorderedEquals(onDisk.where((k) => !k.contains('/examples/'))),
        reason: 'every content file on disk must be bundled (pubspec.yaml)',
      );

      final manifest = await reader.readString('assets/content/manifest.json');
      expect(manifest, contains('"contentVersion"'));
    });

    test('lists nothing outside the prefix', () async {
      expect(await reader.listAssets(prefix: 'assets/nope/'), isEmpty);
    });
  });

  group('contentReadyProvider', () {
    late AppDatabase db;

    setUp(() => db = openTestDatabase());
    tearDown(() => db.close());

    test('seeds the bundle into the database the repositories read', () async {
      final container = ProviderContainer.test(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          assetReaderProvider.overrideWithValue(FileAssetReader()),
        ],
      );

      final result = await container.read(contentReadyProvider.future);

      expect(result.seeded, isTrue);
      final content = container.read(contentRepositoryProvider);
      expect(
        (await content.contentInfo())?.contentVersion,
        greaterThanOrEqualTo(3),
      );
      expect(await content.families(moduleId: ModuleId.psy0), hasLength(16));

      // A second resolution (e.g. after invalidate) is a no-op.
      container.invalidate(contentReadyProvider);
      final again = await container.read(contentReadyProvider.future);
      expect(again.seeded, isFalse);
    });

    test('reports a corrupt bundle as an error, without retrying', () async {
      var reads = 0;
      final container = ProviderContainer.test(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          assetReaderProvider.overrideWithValue(
            _CorruptAssetReader(onRead: () => reads++),
          ),
        ],
      );

      await expectLater(
        container.read(contentReadyProvider.future),
        throwsA(isA<ContentParseException>()),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(reads, 1, reason: 'no automatic retry');
    });
  });
}

class _CorruptAssetReader implements AssetReader {
  _CorruptAssetReader({required this.onRead});

  final void Function() onRead;

  @override
  Future<List<String>> listAssets({required String prefix}) async => const [];

  @override
  Future<String> readString(String path) async {
    onRead();
    return '{';
  }
}
