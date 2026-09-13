// Content pre-bundling (US-125).
//
//   dart run tools/bundle_content.dart
//
// Reads the authored tree (`apps/psy_trainer/assets/content/`, the source of
// truth — this tool never writes to it) and emits one JSON document per
// module at `apps/psy_trainer/assets/content/bundles/<module>.json`:
// `{"files": {"<module>/module.json": "...raw json text...", "<module>/
// lessons/.../01-x.fr.md": "...raw markdown..."}}` — every `.json` and `.md`
// file under that module's folder, keyed exactly as `ContentBundleLoader`
// keys them today (path relative to `assets/content/`). `.md` lesson bodies
// are inlined as plain text, same as every other file: no extra parsing, the
// existing `ContentBundleLoader._Parser._inlineBody` step still resolves
// them from this same file map.
//
// One JSON request per module instead of one per file (~130 on the real
// bundle) is the whole point: `ContentBundleLoader.read` prefers this file
// over the authored tree when present, falling back to the tree otherwise
// (so a build that skips this step, or a test using `FileAssetReader`
// directly, keeps working unchanged).
//
// Output is generated, not authored: gitignored (`apps/psy_trainer/assets/
// content/bundles/`), rebuilt by `make content-assets` and in CI before
// `flutter build`/`flutter test`. The validator (`make content-check`) never
// looks at it — it validates the authored tree only.

import 'dart:convert';
import 'dart:io';

const String _contentAppDir = 'apps/psy_trainer';
const String _contentRoot = 'assets/content';

String _repoRoot() => File(Platform.script.toFilePath()).parent.parent.path;

void main(List<String> args) {
  final root = _repoRoot();
  final appRoot = '$root/$_contentAppDir';
  final contentDir = Directory('$appRoot/$_contentRoot');
  if (!contentDir.existsSync()) {
    stderr.writeln('${contentDir.path} not found');
    exitCode = 1;
    return;
  }

  final manifestFile = File('${contentDir.path}/manifest.json');
  if (!manifestFile.existsSync()) {
    stderr.writeln('${manifestFile.path} not found');
    exitCode = 1;
    return;
  }
  final manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final modules = (manifest['modules']! as List<Object?>).cast<String>();

  final bundlesDir = Directory('${contentDir.path}/bundles');
  bundlesDir.createSync(recursive: true);

  for (final module in modules) {
    final moduleDir = Directory('${contentDir.path}/$module');
    if (!moduleDir.existsSync()) {
      stderr.writeln(
        'module "$module" is declared in manifest.json but '
        '"${moduleDir.path}" does not exist',
      );
      exitCode = 1;
      continue;
    }
    final files = <String, String>{};
    for (final entity in moduleDir.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.json') && !entity.path.endsWith('.md')) {
        continue;
      }
      final relative = entity.path
          .substring(contentDir.path.length + 1)
          .replaceAll('\\', '/');
      files[relative] = entity.readAsStringSync();
    }
    final outFile = File('${bundlesDir.path}/$module.json');
    outFile.writeAsStringSync(jsonEncode({'files': files}));
    stdout.writeln(
      '${outFile.path}: ${files.length} files, '
      '${outFile.lengthSync()} bytes',
    );
  }
}
