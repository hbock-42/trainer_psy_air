// Content validator CLI (US-014).
//
//   dart run psy_content:validate_content [options] [paths...]
//
// Validates every JSON file under the given paths (default: assets/content,
// relative to the current directory) against packages/psy_content/schema/
// *.schema.json, the Dart models and the semantic rules of
// docs/content/AUTHORING.md. Exit code 1 when any error is found, 2 on bad
// usage. Used by authors (`make content-check`) and by CI.

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:psy_content/src/validator/content_validator.dart';
import 'package:psy_content/src/validator/format.dart';

const _usage = '''
Usage: dart run psy_content:validate_content [options] [paths...]

Validates content JSON files (default path: assets/content).

Options:
  --quiet, -q          Only print errors and the final verdict.
  --json               Print a machine-readable JSON report instead of text.
  --schema-dir <dir>   Schema folder (default: this package's schema/
                       folder, resolved through the package config so it
                       works from any working directory, including
                       `dart run psy_content:validate_content` which runs a
                       compiled snapshot, not this source file).
  --help, -h           Show this help.

Exit code: 0 when valid, 1 when errors were found, 2 on usage error.''';

/// `schema/` at the root of the `psy_content` package, wherever it is
/// checked out, resolved through the running program's package config
/// rather than this script's own (possibly compiled-snapshot) location.
Future<String> _defaultSchemaDir() async {
  final packageUri = await Isolate.resolvePackageUri(
    Uri.parse('package:psy_content/'),
  );
  if (packageUri == null) {
    throw StateError(
      'cannot resolve package:psy_content; run `dart pub get` at the '
      'workspace root first',
    );
  }
  return p.normalize(p.join(packageUri.toFilePath(), '..', 'schema'));
}

Future<void> main(List<String> args) async {
  var quiet = false;
  var json = false;
  String? schemaDirArg;
  final paths = <String>[];

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    switch (arg) {
      case '--quiet' || '-q':
        quiet = true;
      case '--json':
        json = true;
      case '--help' || '-h':
        stdout.writeln(_usage);
        return;
      case '--schema-dir':
        if (i + 1 >= args.length) {
          stderr.writeln('--schema-dir needs a value\n\n$_usage');
          exitCode = 2;
          return;
        }
        schemaDirArg = args[++i];
      default:
        if (arg.startsWith('-')) {
          stderr.writeln('unknown option $arg\n\n$_usage');
          exitCode = 2;
          return;
        }
        paths.add(arg);
    }
  }
  if (paths.isEmpty) paths.add(ContentValidator.defaultContentDir);

  final ContentValidator validator;
  try {
    validator = ContentValidator.load(
      schemaDir: schemaDirArg ?? await _defaultSchemaDir(),
    );
  } on StateError catch (e) {
    stderr.writeln('cannot load schemas: ${e.message}');
    exitCode = 2;
    return;
  }

  final report = validator.validate(paths);
  if (json) {
    stdout.writeln(const JsonEncoder.withIndent('  ').convert(report.toJson()));
  } else {
    stdout.writeln(formatReport(report, quiet: quiet));
  }
  exitCode = report.ok ? 0 : 1;
}
