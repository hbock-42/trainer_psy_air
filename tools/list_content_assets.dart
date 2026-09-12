// Content asset registration helper (US-013).
//
//   dart run tools/list_content_assets.dart            # print the directory list
//   dart run tools/list_content_assets.dart --check    # exit 1 if the app's pubspec.yaml is stale
//   dart run tools/list_content_assets.dart --write    # rewrite the list in the app's pubspec.yaml
//
// Flutter registers assets per directory (not recursively), so every folder
// under apps/psy_trainer/assets/content/ that holds shipped files must be
// listed in the `flutter: assets:` section of apps/psy_trainer/pubspec.yaml
// (US-007: the content bundle lives inside the app package, tools/ is
// repo-wide). The list sits between the `# BEGIN content assets` and
// `# END content assets` markers; this script regenerates it.
// `assets/content/examples/` is never registered.

import 'dart:io';

import 'content_assets.dart';

const _usage = '''
Usage: dart run tools/list_content_assets.dart [--check | --write]

Prints the asset directories of the content bundle
(apps/psy_trainer/assets/content/, one entry per folder, examples/ excluded)
in apps/psy_trainer/pubspec.yaml format.

  --check   Compare with apps/psy_trainer/pubspec.yaml; exit 1 when stale.
  --write   Rewrite the list between the markers in that pubspec.yaml.''';

/// The repository root, resolved from this script's own location so the
/// tool works regardless of the caller's working directory (`tools/` always
/// sits directly under the repo root).
String _repoRoot() => File(Platform.script.toFilePath()).parent.parent.path;

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    stdout.writeln(_usage);
    return;
  }
  final root = _repoRoot();
  final dirs = listContentAssetDirectories(root);
  final pubspec = File('$root/$contentAppDir/pubspec.yaml');

  if (args.contains('--check')) {
    final registered = registeredContentAssets(pubspec.readAsStringSync());
    final missing = dirs.where((d) => !registered.contains(d)).toList();
    final stale = registered.where((d) => !dirs.contains(d)).toList();
    if (missing.isEmpty && stale.isEmpty) {
      stdout.writeln(
        '${pubspec.path} lists all ${dirs.length} content folders',
      );
      return;
    }
    for (final d in missing) {
      stderr.writeln('missing from ${pubspec.path}: $d');
    }
    for (final d in stale) {
      stderr.writeln('listed in ${pubspec.path} but absent on disk: $d');
    }
    stderr.writeln('run: dart run tools/list_content_assets.dart --write');
    exitCode = 1;
    return;
  }

  if (args.contains('--write')) {
    pubspec.writeAsStringSync(
      replaceContentAssets(pubspec.readAsStringSync(), dirs),
    );
    stdout.writeln('${pubspec.path} updated (${dirs.length} folders)');
    return;
  }

  stdout.write(formatContentAssets(dirs));
}
