import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/features/train/domain/engine/timing_policy.dart';

void main() {
  const cadence = Cadence(stimulusMs: 1000, answerWindowMs: 1500);

  ExamSection section({int? perItem, int? sectionTime, Cadence? cadence}) =>
      ExamSection(
        id: 's1',
        familyId: 'memory_nback',
        itemCount: 42,
        itemSelection: const ItemSelection.bank(),
        confidence: Confidence.reported,
        perItemTimeSec: perItem,
        sectionTimeSec: sectionTime,
        cadence: cadence,
      );

  TestFamily family({int? perItem, Cadence? cadence}) => TestFamily(
    id: 'f',
    moduleId: ModuleId.psy0,
    version: 1,
    order: 1,
    name: const LocalizedText(fr: 'F'),
    description: const LocalizedText(fr: 'F'),
    engineType: EngineType.memoryNback,
    answerFormat: AnswerFormat.mcq,
    defaultDurationSec: 60,
    defaultItemCount: 10,
    defaultPerItemTimeSec: perItem,
    defaultCadence: cadence,
    confidence: Confidence.reported,
  );

  group('TimingPolicy', () {
    test('none is untimed with no item limit', () {
      expect(TimingPolicy.none.isUntimed, isTrue);
      expect(TimingPolicy.none.itemLimit, isNull);
      expect(TimingPolicy.none.stimulus, isNull);
      expect(TimingPolicy.none.perItem, isNull);
      expect(TimingPolicy.none.section, isNull);
    });

    test('fromSection converts seconds and keeps the cadence', () {
      final policy = TimingPolicy.fromSection(
        section(perItem: 18, sectionTime: 900, cadence: cadence),
      );
      expect(policy.perItem, const Duration(seconds: 18));
      expect(policy.section, const Duration(minutes: 15));
      expect(policy.cadence, cadence);
      expect(policy.isCadence, isTrue);
      expect(policy.isUntimed, isFalse);
    });

    test('fromSection leaves absent limits null', () {
      final policy = TimingPolicy.fromSection(section(sectionTime: 60));
      expect(policy.perItem, isNull);
      expect(policy.cadence, isNull);
      expect(policy.itemLimit, isNull);
      expect(policy.section, const Duration(minutes: 1));
    });

    test('the cadence window wins over the per-item limit', () {
      final policy = TimingPolicy.fromSection(
        section(perItem: 30, cadence: cadence),
      );
      expect(policy.itemLimit, const Duration(milliseconds: 2500));
      expect(policy.stimulus, const Duration(seconds: 1));
    });

    test('forPractice uses the family defaults', () {
      final timed = TimingPolicy.forPractice(family(perItem: 45));
      expect(timed.perItem, const Duration(seconds: 45));
      expect(timed.itemLimit, const Duration(seconds: 45));
      expect(timed.section, isNull);

      final untimed = TimingPolicy.forPractice(
        family(perItem: 45),
        timed: false,
      );
      expect(untimed.isUntimed, isTrue);
    });

    test('forPractice keeps the cadence even when untimed', () {
      final policy = TimingPolicy.forPractice(
        family(cadence: cadence),
        timed: false,
      );
      expect(policy.cadence, cadence);
      expect(policy.itemLimit, const Duration(milliseconds: 2500));
    });

    test('round-trips through JSON', () {
      const policy = TimingPolicy(perItemMs: 18000, cadence: cadence);
      expect(TimingPolicy.fromJson(policy.toJson()), policy);
      expect(policy.toJson(), {
        'perItemMs': 18000,
        'cadence': {'stimulusMs': 1000, 'answerWindowMs': 1500},
      });
    });
  });
}
