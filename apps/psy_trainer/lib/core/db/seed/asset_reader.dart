import 'package:flutter/services.dart';

/// Read access to the files of the content bundle, abstracted so the seeder
/// can be driven by `rootBundle` in the app and by the repository's
/// `assets/content/` folder on disk in tests (`FileAssetReader` in
/// `test/helpers/`).
///
/// Paths are asset keys as written in `pubspec.yaml`
/// (`assets/content/psy0/module.json`), always with `/` separators.
abstract interface class AssetReader {
  /// Every asset key starting with [prefix], in no particular order.
  Future<List<String>> listAssets({required String prefix});

  /// The UTF-8 content of the asset at [path]. Throws when it is missing.
  Future<String> readString(String path);
}

/// [AssetReader] over the Flutter asset bundle: the list comes from the
/// generated `AssetManifest` (every file under the directories registered in
/// `pubspec.yaml`), the files from `rootBundle.loadString`.
class RootBundleAssetReader implements AssetReader {
  const RootBundleAssetReader({AssetBundle? bundle}) : _bundle = bundle;

  final AssetBundle? _bundle;

  AssetBundle get bundle => _bundle ?? rootBundle;

  @override
  Future<List<String>> listAssets({required String prefix}) async {
    final manifest = await AssetManifest.loadFromAssetBundle(bundle);
    return [
      for (final key in manifest.listAssets())
        if (key.startsWith(prefix)) key,
    ];
  }

  @override
  Future<String> readString(String path) =>
      // Skip the cache: each file is read once per seeding, and the bundle
      // would otherwise keep ~1 MB of JSON text alive for the app's lifetime.
      bundle.loadString(path, cache: false);
}
