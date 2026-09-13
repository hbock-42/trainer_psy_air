import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'word_problems.dart';

/// `p1_math_word_problems` ("Mathématiques", spec §2.3-1/§4.1 row 1,
/// US-104): 30 multi-step FR word problems in ~35 min, harder than PSY0's
/// `arithmetic_grid`; scratch paper is allowed on the real test.
///
/// Templates: speed/time/distance, fuel burn/endurance, proportionality
/// ("règle de trois"), percentages (discount/increase/share), unit
/// conversions (ft/m, NM/km, kt/km-h, lb/kg), averages and time-zone
/// arithmetic (see `word_problems.dart`). Difficulty 1..5 scales both the
/// operand magnitude (`arithmeticOperandCap`, the same helper
/// `p1_mental_arithmetic`/`arithmetic_grid` use) and the number of chained
/// steps (`MathWordProblemsGenerator.stepsFor`, 1 at difficulty 1 up to
/// `maxSteps` at difficulty 5).
///
/// [P1MathWordProblemsParams.answerMode] picks the item shape: `numeric`
/// returns a plain `NumericItem` with an FR explanation of the method;
/// `mcq` returns an `McqItem` with the same stem/explanation plus three
/// plausible distractors (spec row 1: "MCQ or free numeric"). The contract
/// itself already defaults `answerMode` to `mcq` (`generator.dart`'s
/// `P1MathWordProblemsParams`, matching `family.json`'s
/// `"answerFormat": "mcq"`) -- a real run plays MCQ unless a blueprint
/// section opts into `numeric` through `params`; this engine does not
/// change that default, only implements both shapes. Both are concrete,
/// self-scoring items, so the default [Scorer.scoreItem] handles them and
/// this engine never overrides [score].
///
/// US-103 authored 65 hand-written items under
/// `assets/content/psy1/p1_math_word_problems/items/` before this story
/// landed; the family stays generator-driven (its `family.json`/blueprint
/// are unchanged) and that bank is kept as a curated reserve -- a
/// hand-picked set usable directly, or as a source of held-out fixtures --
/// not the section's live item source.
class MathWordProblemsEngine extends ActivityEngine {
  const MathWordProblemsEngine();

  @override
  String get familyId => 'p1_math_word_problems';

  @override
  GeneratorId? get generatorId => GeneratorId.p1MathWordProblems;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1MathWordProblemsParams;
    final problem = MathWordProblemsGenerator.build(
      params: typed,
      seed: seed,
      difficulty: difficulty,
    );
    final origin = ItemOrigin(
      generatorId: GeneratorId.p1MathWordProblems,
      seed: seed,
      runSeed: runSeed ?? seed,
      index: index,
    );
    final id = ActivityEngine.generatedItemId(
      GeneratorId.p1MathWordProblems,
      seed,
    );

    return typed.answerMode == P1AnswerMode.mcq
        ? _mcqItem(
            id: id,
            difficulty: difficulty,
            problem: problem,
            origin: origin,
          )
        : _numericItem(
            id: id,
            difficulty: difficulty,
            problem: problem,
            origin: origin,
          );
  }

  Item _numericItem({
    required String id,
    required int difficulty,
    required MathWordProblem problem,
    required ItemOrigin origin,
  }) {
    final text = LocalizedText(fr: problem.stemFr, en: problem.stemFr);
    final explanation = LocalizedText(
      fr: problem.explanationFr,
      en: problem.explanationFr,
    );
    return Item.numeric(
      id: id,
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: [
        'p1_math_word_problems',
        'p1_math_word_problems.${problem.template.name}',
      ],
      stem: text,
      expected: problem.expected,
      explanation: explanation,
      origin: origin,
      unit: problem.unit,
      decimals: 1,
      tolerance: const Tolerance(mode: ToleranceMode.absolute, value: 0.05),
    );
  }

  Item _mcqItem({
    required String id,
    required int difficulty,
    required MathWordProblem problem,
    required ItemOrigin origin,
  }) {
    final options = [
      for (final value in problem.mcqOptions)
        McqOption(
          text: LocalizedText(
            fr: problem.unit == null
                ? _label(value)
                : '${_label(value)} ${problem.unit}',
            en: problem.unit == null
                ? _label(value)
                : '${_label(value)} ${problem.unit}',
          ),
        ),
    ];
    return Item.mcq(
      id: id,
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: [
        'p1_math_word_problems',
        'p1_math_word_problems.${problem.template.name}',
      ],
      stem: LocalizedText(fr: problem.stemFr, en: problem.stemFr),
      options: options,
      correctIndex: problem.correctOptionIndex!,
      explanation: LocalizedText(
        fr: problem.explanationFr,
        en: problem.explanationFr,
      ),
      origin: origin,
      shuffleOptions: false,
    );
  }

  static String _label(num value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();
}
