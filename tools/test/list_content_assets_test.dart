import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/content_assets.dart';

void main() {
  test('pubspec.yaml registers every content folder (examples excluded)', () {
    final dirs = listContentAssetDirectories(Directory.current.path);
    final registered = registeredContentAssets(
      File('pubspec.yaml').readAsStringSync(),
    );

    expect(dirs, contains('assets/content/'));
    expect(dirs, contains('assets/content/psy0/'));
    expect(dirs.where((d) => d.contains('/examples')), isEmpty);
    expect(
      registered,
      unorderedEquals(dirs),
      reason:
          'pubspec.yaml is out of sync with assets/content/: run '
          '`dart run tool/list_content_assets.dart --write`',
    );
  });

  test('replaceContentAssets rewrites the block between the markers', () {
    const pubspec =
        'flutter:\n'
        '  uses-material-design: false\n'
        '$contentAssetsBeginMarker\n'
        '  assets:\n'
        '    - assets/content/\n'
        '    - assets/content/old/\n'
        '$contentAssetsEndMarker\n'
        '  fonts: []\n';

    final updated = replaceContentAssets(pubspec, [
      'assets/content/',
      'assets/content/psy0/',
    ]);

    expect(
      updated,
      'flutter:\n'
      '  uses-material-design: false\n'
      '$contentAssetsBeginMarker\n'
      '  assets:\n'
      '    - assets/content/\n'
      '    - assets/content/psy0/\n'
      '$contentAssetsEndMarker\n'
      '  fonts: []\n',
    );
    expect(registeredContentAssets(updated), {
      'assets/content/',
      'assets/content/psy0/',
    });
  });

  test('replaceContentAssets throws without markers', () {
    expect(
      () => replaceContentAssets('flutter:\n  assets: []\n', const []),
      throwsStateError,
    );
  });
}
