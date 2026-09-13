// US-125: the startup budget test. The first frame (the router shell) must
// not be blocked by seeding modules the user isn't looking at — only the
// *active* module gates `contentReadyProvider`; the others seed lazily
// through `moduleSeedProvider`, well after the shell is shown.
//
// A plain `test()` (not `testWidgets()`), like
// `content_ready_provider_test.dart`: real `dart:io` file reads (the actual
// content tree, through `FileAssetReader`) don't resolve inside a
// `testWidgets()`'s fake-async zone, only inside a genuine `test()`. The
// substantive claim — the shell-gating provider resolves without the
// inactive modules — is fully exercised at the provider level; a widget
// pump would only add pixels, not additional guarantees, since
// `StartupGate` (see `startup_gate_test.dart`) already has direct coverage
// of "shows the child once `contentReadyProvider` resolves".
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/db/app_database_provider.dart';
import 'package:psy_trainer/core/db/seed/asset_reader.dart';
import 'package:psy_trainer/core/db/seed/content_ready_provider.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../../helpers/file_asset_reader.dart';
import '../../helpers/onboarding_fakes.dart';
import '../db/example_content.dart';

/// Delegates to [inner], except reads under `assets/content/<module>/...`
/// (or its pre-bundled `bundles/<module>.json`) for a module in
/// [gatedModules], which block until [release] completes. Lets the test pin
/// down "the active module is seeded before the others" deterministically,
/// without racing real asset IO.
class _GatingAssetReader implements AssetReader {
  _GatingAssetReader(this.inner, {required this.gatedModules});

  final AssetReader inner;
  final Set<String> gatedModules;
  final Completer<void> release = Completer<void>();

  bool _isGated(String path) => gatedModules.any(
    (m) =>
        path.startsWith('assets/content/$m/') ||
        path == 'assets/content/bundles/$m.json',
  );

  @override
  Future<List<String>> listAssets({required String prefix}) =>
      inner.listAssets(prefix: prefix);

  @override
  Future<String> readString(String path) async {
    if (_isGated(path)) await release.future;
    return inner.readString(path);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('contentReadyProvider (the shell gate) resolves once the active module '
      'is seeded, before the others', () async {
    final db = openTestDatabase();
    addTearDown(db.close);
    final gate = _GatingAssetReader(
      FileAssetReader(),
      gatedModules: {'psy1', 'psy2'},
    );
    final container = ProviderContainer(
      overrides: [
        progressRepositoryOverride(), // targetStage psy0 -> active = psy0
        appDatabaseProvider.overrideWithValue(db),
        assetReaderProvider.overrideWithValue(gate),
      ],
    );
    addTearDown(container.dispose);

    // The shell gate resolves: psy0 (ungated) was seeded on its own,
    // without waiting on psy1/psy2 (still gated at this point).
    final result = await container.read(contentReadyProvider.future);
    expect(result.seeded, isTrue);

    final content = container.read(contentRepositoryProvider);
    expect(await content.families(moduleId: ModuleId.psy0), isNotEmpty);
    expect(
      await content.families(moduleId: ModuleId.psy1),
      isEmpty,
      reason:
          'psy1 has not been (lazily) seeded yet — proves the shell '
          'gate did not wait on it',
    );
    expect(await content.families(moduleId: ModuleId.psy2), isEmpty);

    // Release the gate and let the background seeding finish.
    gate.release.complete();
    await container.read(moduleSeedProvider(ModuleId.psy1).future);
    await container.read(moduleSeedProvider(ModuleId.psy2).future);

    expect(await content.families(moduleId: ModuleId.psy1), isNotEmpty);
    expect(await content.families(moduleId: ModuleId.psy2), isNotEmpty);
  });
}
