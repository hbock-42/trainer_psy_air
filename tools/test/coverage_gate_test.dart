import 'dart:io';

import 'package:test/test.dart';

import '../coverage_gate.dart';

String fixture(String name) =>
    File('tools/test/fixtures/$name').readAsStringSync();

void main() {
  group('parseLcov', () {
    test('reads one record per SF block and counts DA lines', () {
      final files = parseLcov(fixture('lcov_mixed.info'));

      expect(files, hasLength(8));
      final stateMachine = files.first;
      expect(
        stateMachine.path,
        'lib/features/train/domain/session_state_machine.dart',
      );
      expect(stateMachine.linesFound, 4);
      expect(stateMachine.linesHit, 3);
    });

    test('recomputes totals from DA entries when LF/LH are absent', () {
      final files = parseLcov(fixture('lcov_mixed.info'));
      final dao = files.singleWhere(
        (f) => f.path == 'lib/features/train/data/session_dao.dart',
      );
      expect(dao.linesFound, 4);
      expect(dao.linesHit, 1);
    });

    test('normalises Windows path separators', () {
      final files = parseLcov(fixture('lcov_mixed.info'));
      expect(files.map((f) => f.path), contains('lib/app.dart'));
    });

    test('ignores malformed lines and tolerates a missing end_of_record', () {
      final files = parseLcov('SF:lib/core/a.dart\nDA:1\nDA:2,3\nfoo\n');
      expect(files, hasLength(1));
      expect(files.single.linesFound, 1);
      expect(files.single.linesHit, 1);
    });

    test('returns nothing for an empty file', () {
      expect(parseLcov(''), isEmpty);
    });
  });

  group('path policy', () {
    test('excludes generated files', () {
      expect(isExcluded('lib/core/db/app_database.g.dart'), isTrue);
      expect(isExcluded('lib/features/x/domain/a.freezed.dart'), isTrue);
      expect(isExcluded('lib/features/x/data/t.drift.dart'), isTrue);
      expect(isExcluded('lib/features/x/domain/a.dart'), isFalse);
      expect(isExcluded('lib/features/x/domain/a.dart.bak'), isFalse);
    });

    test('gates feature domain/data and core, not presentation or shared', () {
      expect(isGated('lib/features/train/domain/generator.dart'), isTrue);
      expect(isGated('lib/features/train/data/dao.dart'), isTrue);
      expect(isGated('lib/core/logging/logger.dart'), isTrue);
      expect(isGated('lib/features/train/presentation/screen.dart'), isFalse);
      expect(isGated('lib/shared/widgets/button.dart'), isFalse);
      expect(isGated('lib/app.dart'), isFalse);
      expect(isGated('lib/features/domain/a.dart'), isFalse);
    });
  });

  group('evaluateCoverage', () {
    test('aggregates overall and gated totals without generated files', () {
      final result = evaluateCoverage(parseLcov(fixture('lcov_mixed.info')));

      // domain 3/4 + data 1/4 + core 2/2 = 6/10; presentation 0/6 and
      // app.dart 2/2 count only overall; generated files never count.
      expect(result.gated.linesFound, 10);
      expect(result.gated.linesHit, 6);
      expect(result.overall.linesFound, 18);
      expect(result.overall.linesHit, 8);
      expect(result.gated.percent, closeTo(60, 1e-9));
    });

    test('fails when gated coverage is below the minimum', () {
      final result = evaluateCoverage(parseLcov(fixture('lcov_mixed.info')));
      expect(result.passed, isFalse);
      expect(result.exitCode, 1);
      expect(result.message, contains('below the minimum 70.0%'));
    });

    test('passes when gated coverage meets the minimum exactly', () {
      final result = evaluateCoverage(
        parseLcov(fixture('lcov_mixed.info')),
        minimum: 60,
      );
      expect(result.passed, isTrue);
      expect(result.exitCode, 0);
    });

    test('passes when gated coverage is above the minimum', () {
      final result = evaluateCoverage(
        parseLcov(fixture('lcov_mixed.info')),
        minimum: 50,
      );
      expect(result.passed, isTrue);
    });

    test('skips the gate with exit 0 when no gated lines are measured', () {
      final result = evaluateCoverage(
        parseLcov(fixture('lcov_presentation_only.info')),
      );
      expect(result.gated.hasLines, isFalse);
      expect(result.gated.percent, isNull);
      expect(result.overall.linesFound, 5);
      expect(result.passed, isTrue);
      expect(result.exitCode, 0);
      expect(result.message, contains('gate skipped'));
    });

    test('a generated-only gated path still counts as no measured lines', () {
      final result = evaluateCoverage(
        parseLcov('SF:lib/core/x.g.dart\nDA:1,0\nend_of_record\n'),
      );
      expect(result.gated.hasLines, isFalse);
      expect(result.passed, isTrue);
    });
  });

  group('formatReport', () {
    test('prints both totals, the minimum and a PASS/FAIL line', () {
      final report = formatReport(
        evaluateCoverage(parseLcov(fixture('lcov_mixed.info'))),
      );
      expect(report, contains('overall'));
      expect(report, contains('44.4% (8/18 lines)'));
      expect(report, contains('60.0% (6/10 lines)'));
      expect(report, contains('minimum (gated): 70.0%'));
      expect(report, contains('FAIL:'));
    });

    test('shows n/a when nothing was measured', () {
      final report = formatReport(evaluateCoverage(const []));
      expect(report, contains('n/a (0 lines measured)'));
      expect(report, contains('PASS:'));
    });
  });

  group('parseArgs', () {
    test('uses defaults when no arguments are given', () {
      final options = parseArgs(const []);
      expect(options.minimum, defaultMinimum);
      expect(options.file, defaultLcovPath);
    });

    test('accepts --min and --file in both spellings', () {
      final a = parseArgs(const ['--min', '80', '--file', 'x.info']);
      expect(a.minimum, 80);
      expect(a.file, 'x.info');

      final b = parseArgs(const ['--min=55.5', '--file=y.info']);
      expect(b.minimum, 55.5);
      expect(b.file, 'y.info');
    });

    test('rejects out-of-range, missing or unknown arguments', () {
      expect(() => parseArgs(const ['--min', '101']), throwsFormatException);
      expect(() => parseArgs(const ['--min', 'abc']), throwsFormatException);
      expect(() => parseArgs(const ['--min']), throwsFormatException);
      expect(() => parseArgs(const ['--bogus']), throwsFormatException);
    });
  });
}
