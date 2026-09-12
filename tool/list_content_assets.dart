// Content asset registration helper (US-013).
//
//   dart run tool/list_content_assets.dart            # print the directory list
//   dart run tool/list_content_assets.dart --check    # exit 1 if pubspec.yaml is stale
//   dart run tool/list_content_assets.dart --write    # rewrite the list in pubspec.yaml
//
// Flutter registers assets per directory (not recursively), so every folder
// under assets/content/ that holds shipped files must be listed in the
// `flutter: assets:` section of pubspec.yaml. The list sits between the
// `# BEGIN content assets` and `# END content assets` markers; this script
// regenerates it. `assets/content/examples/` is never registered.

import 'dart:io';

import 'content_assets.dart';

const _usage = '''
Usage: dart run tool/list_content_assets.dart [--check | --write]

Prints the asset directories of the content bundle (assets/content/, one
entry per folder, examples/ excluded) in pubspec.yaml format.

  --check   Compare with pubspec.yaml; exit 1 when the list is stale.
  --write   Rewrite the list between the markers in pubspec.yaml.''';

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    stdout.writeln(_usage);
    return;
  }
  final root = Directory.current.path;
  final dirs = listContentAssetDirectories(root);
  final pubspec = File('$root/pubspec.yaml');

  if (args.contains('--check')) {
    final registered = registeredContentAssets(pubspec.readAsStringSync());
    final missing = dirs.where((d) => !registered.contains(d)).toList();
    final stale = registered.where((d) => !dirs.contains(d)).toList();
    if (missing.isEmpty && stale.isEmpty) {
      stdout.writeln('pubspec.yaml lists all ${dirs.length} content folders');
      return;
    }
    for (final d in missing) {
      stderr.writeln('missing from pubspec.yaml: $d');
    }
    for (final d in stale) {
      stderr.writeln('listed in pubspec.yaml but absent on disk: $d');
    }
    stderr.writeln('run: dart run tool/list_content_assets.dart --write');
    exitCode = 1;
    return;
  }

  if (args.contains('--write')) {
    pubspec.writeAsStringSync(
      replaceContentAssets(pubspec.readAsStringSync(), dirs),
    );
    stdout.writeln('pubspec.yaml updated (${dirs.length} folders)');
    return;
  }

  stdout.write(formatContentAssets(dirs));
}
