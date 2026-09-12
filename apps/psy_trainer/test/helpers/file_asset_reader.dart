import 'dart:io';

import 'package:psy_trainer/core/db/seed/asset_reader.dart';

/// [AssetReader] over a directory on disk, so seeding tests run against the
/// real `assets/content/` bundle (or a temporary copy of it) without a
/// Flutter asset bundle.
///
/// [root] plays the role of the package root: asset keys
/// (`assets/content/manifest.json`) are resolved under it. Defaults to the
/// current directory, i.e. the repository root under `flutter test`.
class FileAssetReader implements AssetReader {
  FileAssetReader({String? root}) : root = root ?? Directory.current.path;

  final String root;

  @override
  Future<List<String>> listAssets({required String prefix}) async {
    final directory = Directory('$root/$prefix');
    if (!directory.existsSync()) return const [];
    return [
      for (final entity in directory.listSync(recursive: true))
        if (entity is File)
          entity.path.substring(root.length + 1).replaceAll('\\', '/'),
    ];
  }

  @override
  Future<String> readString(String path) => File('$root/$path').readAsString();
}
