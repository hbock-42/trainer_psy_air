import 'package:test/test.dart';

import '../bump_version.dart';

const sample = '''
name: psy_trainer
description: "Unofficial trainer."
publish_to: 'none'

version: 1.2.3+7

environment:
  sdk: ^3.11.4
''';

void main() {
  group('parseVersion', () {
    test('reads major.minor.patch+build', () {
      final v = parseVersion(sample);
      expect(v.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 3);
      expect(v.build, 7);
    });

    test('throws when there is no version line', () {
      expect(
        () => parseVersion('name: psy_trainer\n'),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws when the version has no build number', () {
      expect(
        () => parseVersion('version: 1.2.3\n'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('SemVer.bump', () {
    const v = SemVer(major: 1, minor: 2, patch: 3, build: 7);

    test('patch increments patch and build, keeps major/minor', () {
      final next = v.bump(BumpKind.patch);
      expect(next.toString(), '1.2.4+8');
    });

    test('minor increments minor and build, resets patch', () {
      final next = v.bump(BumpKind.minor);
      expect(next.toString(), '1.3.0+8');
    });

    test('major increments major and build, resets minor and patch', () {
      final next = v.bump(BumpKind.major);
      expect(next.toString(), '2.0.0+8');
    });
  });

  group('replaceVersion', () {
    test('rewrites only the version line', () {
      final next = const SemVer(major: 1, minor: 2, patch: 4, build: 8);
      final result = replaceVersion(sample, next);

      expect(result, contains('version: 1.2.4+8'));
      expect(result, isNot(contains('1.2.3+7')));
      // Every other line survives untouched.
      expect(result, contains('name: psy_trainer'));
      expect(result, contains('sdk: ^3.11.4'));
    });

    test('throws when there is no version line to replace', () {
      expect(
        () => replaceVersion(
          'name: x\n',
          const SemVer(major: 1, minor: 0, patch: 0, build: 1),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('parseArgs', () {
    test('accepts exactly one bump flag', () {
      expect(parseArgs(['--patch']).kind, BumpKind.patch);
      expect(parseArgs(['--minor']).kind, BumpKind.minor);
      expect(parseArgs(['--major']).kind, BumpKind.major);
    });

    test('accepts a --file override', () {
      final options = parseArgs(['--patch', '--file', 'foo/pubspec.yaml']);
      expect(options.pubspecPath, 'foo/pubspec.yaml');
      final options2 = parseArgs(['--file=bar/pubspec.yaml', '--minor']);
      expect(options2.pubspecPath, 'bar/pubspec.yaml');
    });

    test('rejects zero bump flags', () {
      expect(() => parseArgs([]), throwsA(isA<FormatException>()));
    });

    test('rejects more than one bump flag', () {
      expect(
        () => parseArgs(['--patch', '--minor']),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects an unknown argument', () {
      expect(
        () => parseArgs(['--patch', '--bogus']),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
