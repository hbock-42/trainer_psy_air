import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/domain/exam_realism_options.dart';
import 'package:psy_trainer/features/exam/domain/exam_section_planner.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import '../../../helpers/fake_engine.dart';

ExamSection generatedSection({
  String id = 's1',
  String familyId = 'fake_family',
  int itemCount = 3,
  GeneratorId generatorId = GeneratorId.dominos,
  int breakAfterSec = 0,
}) => ExamSection(
  id: id,
  familyId: familyId,
  itemCount: itemCount,
  itemSelection: ItemSelection.generated(
    generatorId: generatorId,
    difficulty: const DifficultyRange(min: 3, max: 3),
    params: GeneratorParams.defaultsFor(generatorId),
  ),
  confidence: Confidence.assumed,
  breakAfterSec: breakAfterSec,
);

ExamSection bankSection({
  String id = 'sb',
  String familyId = 'culture_aero',
  int itemCount = 2,
  List<String>? tags,
  List<String>? anyTags,
  String? balanceByTagPrefix,
  int avoidRecentSessions = 0,
}) => ExamSection(
  id: id,
  familyId: familyId,
  itemCount: itemCount,
  itemSelection: ItemSelection.bank(
    tags: tags,
    anyTags: anyTags,
    balanceByTagPrefix: balanceByTagPrefix,
    avoidRecentSessions: avoidRecentSessions,
  ),
  confidence: Confidence.assumed,
);

ExamBlueprint blueprintOf(List<ExamSection> sections) => ExamBlueprint(
  id: 'bp.test',
  version: 1,
  moduleId: ModuleId.psy0,
  name: const LocalizedText(fr: 'Test'),
  description: const LocalizedText(fr: 'Test'),
  confidence: Confidence.assumed,
  tags: const [],
  sections: sections,
);

McqItem item(String id, {List<String> tags = const []}) =>
    fakeMcq(id: id, familyId: 'culture_aero', stem: id).copyWith(tags: tags);

void main() {
  late InMemoryContentRepository content;
  late InMemoryProgressRepository progress;
  late EngineRegistry engines;

  setUp(() {
    content = InMemoryContentRepository();
    progress = InMemoryProgressRepository(clock: () => DateTime.utc(2026, 9));
    engines = EngineRegistry([FakeEngine()]);
  });

  test('skips sections whose family has no registered engine', () async {
    final blueprint = blueprintOf([
      generatedSection(),
      generatedSection(id: 's2', familyId: 'missing_family'),
    ]);
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: engines,
      content: content,
      progress: progress,
      sessionId: 'session-1',
    );
    expect(planned, hasLength(1));
    expect(planned.single.sectionIndex, 0);
    expect(planned.single.config.familyId, 'fake_family');
  });

  test(
    'generated sections attach sessionId, mode, timing and offsets',
    () async {
      final blueprint = blueprintOf([
        generatedSection(),
        generatedSection(id: 's2', familyId: 'fake_family2', itemCount: 2),
      ]);
      final twoEngines = EngineRegistry([
        FakeEngine(),
        FakeEngine(familyId: 'fake_family2', generatorId: GeneratorId.tubes),
      ]);
      final planned = await planExamSections(
        blueprint: blueprint,
        engines: twoEngines,
        content: content,
        progress: progress,
        sessionId: 'session-1',
      );
      expect(planned, hasLength(2));
      expect(planned[0].config.sessionId, 'session-1');
      expect(planned[0].config.mode, SessionMode.exam);
      expect(planned[0].config.ownsSession, isFalse);
      expect(planned[0].config.positionOffset, 0);
      expect(planned[0].config.sectionIndex, 0);
      expect(planned[1].config.positionOffset, 3);
      expect(planned[1].config.sectionIndex, 1);
    },
  );

  test('bank sections filter by tags and balance a tag prefix', () async {
    content.addItems([
      item('a', tags: ['culture.geo']),
      item('b', tags: ['culture.geo']),
      item('c', tags: ['culture.history']),
      item('d', tags: ['culture.history']),
    ]);
    final blueprint = blueprintOf([bankSection(balanceByTagPrefix: 'culture')]);
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: EngineRegistry([FakeEngine(familyId: 'culture_aero')]),
      content: content,
      progress: progress,
      sessionId: 's',
    );
    final source = planned.single.config.source as BankSource;
    expect(source.items, hasLength(2));
    // Round-robin over the two culture.* buckets: one from each.
    final tags = source.items.map((i) => i.tags.first).toSet();
    expect(tags, {'culture.geo', 'culture.history'});
  });

  test('bank sections respect an explicit tags filter', () async {
    content.addItems([
      item('a', tags: ['english.reading']),
      item('b', tags: ['english.listening']),
    ]);
    final blueprint = blueprintOf([
      bankSection(itemCount: 5, tags: ['english.listening']),
    ]);
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: EngineRegistry([FakeEngine(familyId: 'culture_aero')]),
      content: content,
      progress: progress,
      sessionId: 's',
    );
    final source = planned.single.config.source as BankSource;
    expect(source.items.map((i) => i.id), ['b']);
  });

  test('bank sections exclude items from recent sessions', () async {
    content.addItems([item('a'), item('b')]);
    final session = await progress.startSession(
      mode: SessionMode.practice,
      familyId: 'culture_aero',
    );
    await progress.recordAttempt(
      NewAttempt(
        sessionId: session.id,
        familyId: 'culture_aero',
        isCorrect: true,
        responseMs: 100,
        position: 0,
        itemId: 'a',
      ),
    );
    final blueprint = blueprintOf([
      bankSection(itemCount: 5, avoidRecentSessions: 3),
    ]);
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: EngineRegistry([FakeEngine(familyId: 'culture_aero')]),
      content: content,
      progress: progress,
      sessionId: 's',
    );
    final source = planned.single.config.source as BankSource;
    expect(source.items.map((i) => i.id), ['b']);
  });

  test('US-063: negativeMarkingCulture overrides the culture section scoring '
      'policy and every item allowSkip', () async {
    content.addItems([item('a'), item('b')]);
    final blueprint = blueprintOf([bankSection(itemCount: 5)]);
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: EngineRegistry([FakeEngine(familyId: 'culture_aero')]),
      content: content,
      progress: progress,
      sessionId: 's',
      options: const ExamRealismOptions(negativeMarkingCulture: true),
    );
    final config = planned.single.config;
    expect(config.scoringPolicy, negativeMarkingScoringPolicy);
    expect(config.scoringPolicy.correct, 3);
    expect(config.scoringPolicy.wrong, -1);
    final source = config.source as BankSource;
    expect(source.items, isNotEmpty);
    expect(source.items.every((i) => (i as McqItem).allowSkip), isTrue);
  });

  test('US-063: negativeMarkingCulture leaves every other family untouched, '
      'even when on', () async {
    final blueprint = blueprintOf([generatedSection()]);
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: engines,
      content: content,
      progress: progress,
      sessionId: 's',
      options: const ExamRealismOptions(negativeMarkingCulture: true),
    );
    expect(planned.single.config.scoringPolicy, const ScoringPolicy());
  });

  test(
    'US-063: randomizeGenerated off fixes the seed to the canonical value',
    () async {
      final blueprint = blueprintOf([generatedSection()]);
      final planned = await planExamSections(
        blueprint: blueprint,
        engines: engines,
        content: content,
        progress: progress,
        sessionId: 's',
        random: Random(1),
        options: const ExamRealismOptions(randomizeGenerated: false),
      );
      final source = planned.single.config.source as GeneratorSource;
      expect(source.seed, ExamRealismOptions.canonicalSeed);
    },
  );

  test(
    'US-063: randomizeGenerated on (default) draws from the given random',
    () async {
      final blueprint = blueprintOf([generatedSection()]);
      final expectedSeed = Random(1).nextInt(1 << 31);
      final planned = await planExamSections(
        blueprint: blueprint,
        engines: engines,
        content: content,
        progress: progress,
        sessionId: 's',
        random: Random(1),
      );
      final source = planned.single.config.source as GeneratorSource;
      expect(source.seed, expectedSeed);
      expect(source.seed, isNot(ExamRealismOptions.canonicalSeed));
    },
  );
}
