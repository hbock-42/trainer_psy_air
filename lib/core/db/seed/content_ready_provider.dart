import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_database_provider.dart';
import 'asset_reader.dart';
import 'content_seeder.dart';

/// Where the seeder reads the bundle from; tests override it with a
/// `FileAssetReader` (or a fake) instead of `rootBundle`.
final Provider<AssetReader> assetReaderProvider = Provider<AssetReader>(
  (ref) => const RootBundleAssetReader(),
);

final Provider<ContentSeeder> contentSeederProvider = Provider<ContentSeeder>(
  (ref) => ContentSeeder(
    database: ref.watch(appDatabaseProvider),
    assets: ref.watch(assetReaderProvider),
  ),
);

/// Resolves once the database mirrors the bundled content (seeding it on
/// first launch or after a `contentVersion` bump). The startup gate
/// (`core/router/startup_gate.dart`) shows a splash until then and an error
/// screen with a retry (`ref.invalidate(contentReadyProvider)`) on failure.
///
/// Widget tests that pump the whole app with in-memory repositories override
/// it with `contentReadyOverride()` (`test/helpers/content_ready_fakes.dart`).
final FutureProvider<SeedResult> contentReadyProvider =
    FutureProvider<SeedResult>((ref) async {
      final result = await ref.watch(contentSeederProvider).seedIfNeeded();
      developer.log('$result', name: 'psy_trainer.content');
      return result;
    });
