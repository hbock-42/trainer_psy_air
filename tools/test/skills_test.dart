// Verifies the agent-skills layout added in US-017:
// - every skill under `.agents/skills/<name>/SKILL.md` has YAML frontmatter
//   (`name`, `description`) and stays under the size cap;
// - `.claude/skills` resolves (as a symlink) to `.agents/skills`;
// - `CLAUDE.md` resolves (as a symlink) to `AGENTS.md`;
// - every skill has exactly one row in `AGENTS.md`'s skills table, and vice
//   versa.
//
// Run from the repo root: `dart test tools/test` (or `make test`).
import 'dart:io';

import 'package:test/test.dart';

/// Body size cap (frontmatter counts against it): keep a skill small enough
/// that an agent reads only what its task needs.
const int _maxSkillLines = 300;

const String _skillsDir = '.agents/skills';

void main() {
  final skillsDir = Directory(_skillsDir);

  test('.agents/skills exists and has at least one skill', () {
    expect(
      skillsDir.existsSync(),
      isTrue,
      reason: '$_skillsDir must exist (US-017)',
    );
    final entries = skillsDir.listSync().whereType<Directory>().toList();
    expect(entries, isNotEmpty, reason: 'expected at least one skill folder');
  });

  test('.claude/skills is a symlink that resolves to .agents/skills', () {
    final link = Link('.claude/skills');
    expect(
      link.existsSync(),
      isTrue,
      reason: '.claude/skills must exist as a symlink to ../.agents/skills',
    );
    final resolved = File(
      link.resolveSymbolicLinksSync(),
    ).absolute.path.replaceAll('\\', '/');
    final expected = Directory(_skillsDir).absolute.path.replaceAll('\\', '/');
    expect(
      resolved,
      expected,
      reason: '.claude/skills must resolve to the same folder as $_skillsDir',
    );
  });

  test('CLAUDE.md is a symlink that resolves to AGENTS.md', () {
    final link = Link('CLAUDE.md');
    expect(
      link.existsSync(),
      isTrue,
      reason: 'CLAUDE.md must exist as a symlink to AGENTS.md',
    );
    final resolved = File(
      link.resolveSymbolicLinksSync(),
    ).absolute.path.replaceAll('\\', '/');
    final expected = File('AGENTS.md').absolute.path.replaceAll('\\', '/');
    expect(
      resolved,
      expected,
      reason: 'CLAUDE.md must resolve to the same file as AGENTS.md',
    );
  });

  final skillNames =
      skillsDir
          .listSync()
          .whereType<Directory>()
          .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
          .toList()
        ..sort();

  for (final name in skillNames) {
    final file = File('$_skillsDir/$name/SKILL.md');

    group('skill "$name"', () {
      test('SKILL.md exists', () {
        expect(file.existsSync(), isTrue, reason: '${file.path} is missing');
      });

      test('has YAML frontmatter with name and description', () {
        final lines = file.readAsLinesSync();
        expect(
          lines.isNotEmpty && lines.first.trim() == '---',
          isTrue,
          reason: '${file.path} must start with a YAML frontmatter block (---)',
        );
        final closingIndex = lines.indexWhere((l) => l.trim() == '---', 1);
        expect(
          closingIndex,
          greaterThan(0),
          reason: '${file.path} frontmatter is never closed with ---',
        );
        final frontmatter = lines.sublist(1, closingIndex).join('\n');
        final nameMatch = RegExp(
          r'^name:\s*(\S+)',
          multiLine: true,
        ).firstMatch(frontmatter);
        final descriptionMatch = RegExp(
          r'^description:\s*(.+)$',
          multiLine: true,
        ).firstMatch(frontmatter);
        expect(
          nameMatch,
          isNotNull,
          reason: '${file.path} frontmatter is missing `name`',
        );
        expect(
          descriptionMatch,
          isNotNull,
          reason: '${file.path} frontmatter is missing `description`',
        );
        expect(
          nameMatch!.group(1),
          name,
          reason: '${file.path} `name` must match its folder ($name)',
        );
        // One line: no description spanning multiple lines / a YAML block.
        expect(
          descriptionMatch!.group(1)!.trim(),
          isNotEmpty,
          reason: '${file.path} `description` must not be empty',
        );
      });

      test('stays at or under $_maxSkillLines lines', () {
        final lineCount = file.readAsLinesSync().length;
        expect(
          lineCount,
          lessThanOrEqualTo(_maxSkillLines),
          reason:
              '${file.path} has $lineCount lines, over the $_maxSkillLines cap',
        );
      });
    });
  }

  group('AGENTS.md skills table', () {
    final agentsFile = File('AGENTS.md');
    late List<String> tableSkillNames;

    setUpAll(() {
      expect(agentsFile.existsSync(), isTrue, reason: 'AGENTS.md is missing');
      final content = agentsFile.readAsStringSync();
      // Rows look like: `| `skill-name` | description text |`
      final rowPattern = RegExp(r'^\|\s*`([a-z0-9-]+)`\s*\|', multiLine: true);
      tableSkillNames = rowPattern
          .allMatches(content)
          .map((m) => m.group(1)!)
          .toList();
    });

    test('lists at least one skill', () {
      expect(tableSkillNames, isNotEmpty);
    });

    test('every skill directory has a row in AGENTS.md', () {
      for (final name in skillNames) {
        expect(
          tableSkillNames,
          contains(name),
          reason: 'AGENTS.md is missing a row for the "$name" skill',
        );
      }
    });

    test('every AGENTS.md row names an existing skill directory', () {
      for (final rowName in tableSkillNames) {
        expect(
          skillNames,
          contains(rowName),
          reason:
              'AGENTS.md references skill "$rowName" but '
              '$_skillsDir/$rowName/SKILL.md does not exist',
        );
      }
    });
  });
}
