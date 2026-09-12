import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/verbal_boxes/domain/word_box_series.dart';
import 'package:psy_trainer/features/engines/verbal_boxes/domain/word_boxes_engine.dart';
import 'package:psy_trainer/features/engines/verbal_boxes/presentation/word_boxes_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// `ItemSource.generator` draws one seed per item from `Random(sessionSeed)`
/// (see `item_source.dart`); replicated so the test knows the exact series
/// (and so the exact right answers) a session with
/// `sessionSeed`/`difficulty` will show as its first item.
int _firstItemSeed(int sessionSeed) => Random(sessionSeed).nextInt(1 << 31);

LexicalField _field(String id, {required List<String> words}) => LexicalField(
  id: id,
  version: 1,
  familyId: 'verbal_boxes',
  name: LocalizedText(fr: id),
  difficulty: 1,
  tags: const [],
  words: words,
);

final _catalogue = [
  for (final letter in ['a', 'b', 'c', 'd', 'e', 'f'])
    _field(letter, words: [for (var i = 0; i < 20; i++) '$letter-$i']),
];

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const sessionSeed = 1;
  const difficulty = 1;
  const params = WordBoxesParams(boxCount: 4, wordCount: 8);
  final itemSeed = _firstItemSeed(sessionSeed);
  final series = WordBoxSeries.build(
    catalogue: _catalogue,
    params: params,
    seed: itemSeed,
    difficulty: difficulty,
  );

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config() => const ActivitySessionConfig(
    familyId: 'verbal_boxes',
    mode: SessionMode.practice,
    source: ItemSource.generator(
      generatorId: GeneratorId.wordBoxes,
      seed: sessionSeed,
      params: params,
      count: 1,
      difficulty: DifficultyRange(min: difficulty, max: difficulty),
    ),
  );

  Future<void> pumpHost(WidgetTester tester) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(config()),
      onFinished: finished.add,
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(
        EngineRegistry([WordBoxesEngine(FixedLexicalFieldSource(_catalogue))]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry([
          WordBoxesRenderer(FixedLexicalFieldSource(_catalogue)),
        ]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  testWidgets('placing every word correctly scores the series correct', (
    tester,
  ) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    for (final event in series.events) {
      await tester.tap(find.byKey(ValueKey('word-box-${event.fieldIndex}')));
      await tester.pump();
    }

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
    expect(
      find.text(AppStrings.wordBoxesResultSummary(0, series.events.length)),
      findsOneWidget,
    );

    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
    expect(finished, hasLength(1));
    expect(finished.single.section.correct, 1);
  });

  testWidgets('one wrong box scores the series wrong and counts one error', (
    tester,
  ) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    for (final (i, event) in series.events.indexed) {
      final wrongBox = (event.fieldIndex + 1) % series.fields.length;
      final box = i == 0 ? wrongBox : event.fieldIndex;
      await tester.tap(find.byKey(ValueKey('word-box-$box')));
      await tester.pump();
    }

    expect(find.text(AppStrings.sessionFeedbackWrong), findsOneWidget);
    expect(
      find.text(AppStrings.wordBoxesResultSummary(1, series.events.length)),
      findsOneWidget,
    );
    expect(find.text(AppStrings.wordBoxesMissedTitle), findsOneWidget);
  });
}
