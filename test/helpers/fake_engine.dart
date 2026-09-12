import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

/// A minimal [ActivityEngine] for runtime, controller and widget tests.
///
/// `generate` yields a 3-option `McqItem` whose stem is `Q<seed>` and whose
/// correct option is [correctIndex]; `score` is the default MCQ scorer plus
/// a `calls` log. Registered under [familyId] / [generatorId].
class FakeEngine extends ActivityEngine {
  FakeEngine({
    this.familyId = 'fake_family',
    this.generatorId = GeneratorId.dominos,
    this.correctIndex = 0,
  });

  @override
  final String familyId;

  @override
  final GeneratorId? generatorId;

  final int correctIndex;

  /// `(item id, answer)` of every `score` call.
  final List<(String, Answer)> calls = [];

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
  }) => fakeMcq(
    id: ActivityEngine.generatedItemId(generatorId!, seed),
    familyId: familyId,
    stem: 'Q$seed',
    correctIndex: correctIndex,
    difficulty: difficulty,
    origin: ItemOrigin(generatorId: generatorId!, seed: seed),
  );

  @override
  ItemResult score(Item item, Answer answer) {
    calls.add((item.id, answer));
    return super.score(item, answer);
  }
}

/// A 3-option MCQ bank item.
McqItem fakeMcq({
  required String id,
  String familyId = 'fake_family',
  String stem = 'Question',
  int correctIndex = 0,
  int difficulty = 3,
  ItemOrigin? origin,
  bool allowSkip = false,
}) => McqItem(
  id: id,
  version: 1,
  familyId: familyId,
  difficulty: difficulty,
  tags: const ['fake'],
  stem: LocalizedText(fr: stem),
  options: const [
    McqOption(text: LocalizedText(fr: 'A')),
    McqOption(text: LocalizedText(fr: 'B')),
    McqOption(text: LocalizedText(fr: 'C')),
  ],
  correctIndex: correctIndex,
  explanation: const LocalizedText(fr: 'Parce que.'),
  origin: origin,
  allowSkip: allowSkip,
);

/// `count` bank items `q1..qN`, all with correct option 0.
List<Item> fakeBank(int count, {String familyId = 'fake_family'}) => [
  for (var i = 1; i <= count; i++)
    fakeMcq(id: 'q$i', familyId: familyId, stem: 'Question $i'),
];
