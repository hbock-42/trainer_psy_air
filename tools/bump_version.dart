// Version bump script (US-122).
//
// Bumps the `version:` line in apps/psy_trainer/pubspec.yaml
// (`major.minor.patch+build`), incrementing the build number every time so
// Android's versionCode / iOS's CFBundleVersion always go up, even across a
// patch release.
//
// Usage (from the repo root):
//   dart run tools/bump_version.dart --patch   # 1.0.0+1 -> 1.0.1+2
//   dart run tools/bump_version.dart --minor   # 1.0.1+2 -> 1.1.0+3
//   dart run tools/bump_version.dart --major   # 1.1.0+3 -> 2.0.0+4
//
// Exactly one of --patch/--minor/--major is required. Prints the old and
// new version and exits non-zero on a malformed pubspec or bad arguments.
//
// Pure Dart on purpose (only `dart:io`), like tools/coverage_gate.dart: the
// parsing/bump policy live in top-level functions so
// tools/test/bump_version_test.dart can exercise them without touching the
// real pubspec.yaml.

import 'dart:io';

/// Default pubspec.yaml the script bumps.
const String defaultPubspecPath = 'apps/psy_trainer/pubspec.yaml';

/// The three supported bump kinds.
enum BumpKind { major, minor, patch }

/// A parsed `major.minor.patch+build` version.
class SemVer {
  const SemVer({
    required this.major,
    required this.minor,
    required this.patch,
    required this.build,
  });

  final int major;
  final int minor;
  final int patch;
  final int build;

  @override
  String toString() => '$major.$minor.$patch+$build';

  SemVer bump(BumpKind kind) => switch (kind) {
    BumpKind.major => SemVer(
      major: major + 1,
      minor: 0,
      patch: 0,
      build: build + 1,
    ),
    BumpKind.minor => SemVer(
      major: major,
      minor: minor + 1,
      patch: 0,
      build: build + 1,
    ),
    BumpKind.patch => SemVer(
      major: major,
      minor: minor,
      patch: patch + 1,
      build: build + 1,
    ),
  };
}

/// Matches a `version: 1.2.3+4` line (the exact format `flutter create`
/// emits; a version without a build number is not supported since Android
/// versionCode / iOS CFBundleVersion both need one).
final RegExp _versionLine = RegExp(
  r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$',
  multiLine: true,
);

/// Parses the `version:` line out of a pubspec.yaml's content.
///
/// Throws a [FormatException] when no line matches, so the caller can print
/// a clear error instead of a null-check crash.
SemVer parseVersion(String pubspecContent) {
  final match = _versionLine.firstMatch(pubspecContent);
  if (match == null) {
    throw const FormatException(
      'No "version: X.Y.Z+B" line found in pubspec.yaml',
    );
  }
  return SemVer(
    major: int.parse(match.group(1)!),
    minor: int.parse(match.group(2)!),
    patch: int.parse(match.group(3)!),
    build: int.parse(match.group(4)!),
  );
}

/// Replaces the `version:` line in [pubspecContent] with [newVersion],
/// leaving every other line untouched.
String replaceVersion(String pubspecContent, SemVer newVersion) {
  if (!_versionLine.hasMatch(pubspecContent)) {
    throw const FormatException(
      'No "version: X.Y.Z+B" line found in pubspec.yaml',
    );
  }
  return pubspecContent.replaceFirst(_versionLine, 'version: $newVersion');
}

/// Parsed command-line options: exactly one bump kind, an optional pubspec
/// path override (used by tests).
class BumpOptions {
  const BumpOptions({required this.kind, required this.pubspecPath});

  final BumpKind kind;
  final String pubspecPath;
}

BumpOptions parseArgs(List<String> args) {
  BumpKind? kind;
  var pubspecPath = defaultPubspecPath;

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--major':
        if (kind != null) {
          throw const FormatException(
            'Pass exactly one of --major, --minor, --patch',
          );
        }
        kind = BumpKind.major;
      case '--minor':
        if (kind != null) {
          throw const FormatException(
            'Pass exactly one of --major, --minor, --patch',
          );
        }
        kind = BumpKind.minor;
      case '--patch':
        if (kind != null) {
          throw const FormatException(
            'Pass exactly one of --major, --minor, --patch',
          );
        }
        kind = BumpKind.patch;
      case '--file':
        if (i + 1 >= args.length) {
          throw const FormatException('--file requires a value');
        }
        pubspecPath = args[++i];
      default:
        if (args[i].startsWith('--file=')) {
          pubspecPath = args[i].substring('--file='.length);
        } else {
          throw FormatException('Unknown argument: ${args[i]}');
        }
    }
  }

  if (kind == null) {
    throw const FormatException(
      'Pass exactly one of --major, --minor, --patch',
    );
  }

  return BumpOptions(kind: kind, pubspecPath: pubspecPath);
}

void main(List<String> args) {
  const usage =
      'Usage: dart run tools/bump_version.dart --major|--minor|--patch '
      '[--file <pubspec path>]';

  final BumpOptions options;
  try {
    options = parseArgs(args);
  } on FormatException catch (e) {
    stderr
      ..writeln(e.message)
      ..writeln(usage);
    exitCode = 2;
    return;
  }

  final file = File(options.pubspecPath);
  if (!file.existsSync()) {
    stderr.writeln('pubspec.yaml not found: ${options.pubspecPath}');
    exitCode = 2;
    return;
  }

  final content = file.readAsStringSync();
  final SemVer current;
  try {
    current = parseVersion(content);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    exitCode = 2;
    return;
  }

  final next = current.bump(options.kind);
  file.writeAsStringSync(replaceVersion(content, next));

  stdout.writeln('$current -> $next (${options.pubspecPath})');
}
