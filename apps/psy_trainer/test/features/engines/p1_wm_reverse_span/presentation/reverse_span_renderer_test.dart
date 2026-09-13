import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_wm_reverse_span/domain/reverse_span_engine.dart';
import 'package:psy_trainer/features/engines/p1_wm_reverse_span/presentation/reverse_span_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  const engine = ReverseSpanEngine();
  final start = DateTime.utc(2026, 9, 5, 9);

  // minDigits == maxDigits: a fixed, small span so the digit-reveal timer
  // chain is short and predictable in a widget test, whatever difficulty
  // is drawn.
  const params = P1WmReverseSpanParams(
    count: 1,
    minDigits: 3,
    maxDigits: 3,
    answerWindowMs: 2000,
  );
  const seed = 11;

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  // A `bank` source of one already-materialised `GeneratedItem`: unlike
  // `ItemSource.generator` (which draws its own per-item seed from
  // `Random(seed)`, see `ItemSource._generate`), this pins the exact item
  // the test types against, engine.generate(seed:, difficulty:) with
  // no surprises.
  GeneratedItem theItem() =>
      engine.generate(params: params, seed: seed, difficulty: 3)
          as GeneratedItem;

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    TimingPolicy timing = TimingPolicy.none,
  }) => ActivitySessionConfig(
    familyId: 'p1_wm_reverse_span',
    mode: mode,
    source: ItemSource.bank([theItem()]),
    timing: timing,
  );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionConfig sessionConfig,
  ) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(sessionConfig),
      onFinished: finished.add,
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(EngineRegistry(const [engine])),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [ReverseSpanRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  /// The digit sequence this run's single item actually shows (decoded the
  /// same way the engine/renderer do), so the test can type the correct
  /// reverse without hard-coding a seed-dependent sequence.
  List<int> shownDigits() => ReverseSpanEngine.sequenceOf(theItem()).digits;

  /// Advances past the digit-by-digit reveal (untimed item: a fixed 700 ms
  /// per digit, see `_ReverseSpanViewState._revealMsPerDigit`).
  Future<void> revealAll(WidgetTester tester, int digitCount) async {
    for (var i = 0; i < digitCount; i++) {
      await tester.pump(const Duration(milliseconds: 700));
    }
  }

  testWidgets('reveals digits one at a time before the keypad appears', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    // Nothing typed-in yet; keypad not shown during the reveal.
    expect(find.byKey(ReverseSpanRenderer.typedFieldKey), findsNothing);
    expect(find.byKey(ReverseSpanRenderer.digitKey), findsNothing);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byKey(ReverseSpanRenderer.digitKey), findsOneWidget);
    expect(find.byKey(ReverseSpanRenderer.typedFieldKey), findsNothing);

    await revealAll(tester, shownDigits().length);
    expect(find.byKey(ReverseSpanRenderer.typedFieldKey), findsOneWidget);
  });

  testWidgets('typing the exact reverse on the keypad scores correct', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await revealAll(tester, shownDigits().length);

    final reversed = shownDigits().reversed.toList();
    for (final digit in reversed) {
      await tester.tap(find.byKey(ReverseSpanRenderer.keypadDigitKey(digit)));
      await tester.pump();
    }
    await tester.tap(find.byKey(ReverseSpanRenderer.validateKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('backspace removes the last typed digit', (tester) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await revealAll(tester, shownDigits().length);

    await tester.tap(find.byKey(ReverseSpanRenderer.keypadDigitKey(1)));
    await tester.pump();
    await tester.tap(find.byKey(ReverseSpanRenderer.backspaceKey));
    await tester.pump();

    // Validate stays disabled: the typed length no longer matches the
    // sequence length after the backspace.
    final validate = tester.widget<AppKeypadButton>(
      find.byKey(ReverseSpanRenderer.validateKey),
    );
    expect(validate.onPressed, isNull);
  });

  testWidgets('the digit keyboard keys type, exactly like the buttons', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await revealAll(tester, shownDigits().length);

    final reversed = shownDigits().reversed.toList();
    const digitKeys = [
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
    ];
    for (final digit in reversed) {
      await tester.sendKeyEvent(digitKeys[digit]);
      await tester.pump();
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('exam mode shows no live feedback', (tester) async {
    await pumpHost(tester, config(mode: SessionMode.exam));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await revealAll(tester, shownDigits().length);

    final reversed = shownDigits().reversed.toList();
    for (final digit in reversed) {
      await tester.tap(find.byKey(ReverseSpanRenderer.keypadDigitKey(digit)));
      await tester.pump();
    }
    await tester.tap(find.byKey(ReverseSpanRenderer.validateKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
    expect(finished.single.section.correct, 1);
  });
}
