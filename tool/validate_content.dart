// Content validator CLI (US-014).
//
//   dart run tool/validate_content.dart [options] [paths...]
//
// Validates every JSON file under the given paths (default: assets/content)
// against docs/content/schema/*.schema.json, the Dart models and the
// semantic rules of docs/content/AUTHORING.md. Exit code 1 when any error is
// found, 2 on bad usage. Used by authors (`make content-check`) and by CI.

import 'dart:convert';
import 'dart:io';

import 'content_validator/content_validator.dart';
import 'content_validator/format.dart';

const _usage = '''
Usage: dart run tool/validate_content.dart [options] [paths...]

Validates content JSON files (default path: assets/content).

Options:
  --quiet, -q          Only print errors and the final verdict.
  --json               Print a machine-readable JSON report instead of text.
  --schema-dir <dir>   Schema folder (default: docs/content/schema).
  --help, -h           Show this help.

Exit code: 0 when valid, 1 when errors were found, 2 on usage error.''';

void main(List<String> args) {
  var quiet = false;
  var json = false;
  var schemaDir = ContentValidator.defaultSchemaDir;
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
        schemaDir = args[++i];
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
    validator = ContentValidator.load(schemaDir: schemaDir);
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
