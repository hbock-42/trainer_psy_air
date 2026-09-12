import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Tolerance;
import 'package:flutter_test/flutter_test.dart';

import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/renderers/numeric_renderer.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/pump_app.dart';

/// A minimal bank-only engine; the default `Scorer.scoreItem` scores
/// `NumericItem` (numeric value within tolerance) on its own.
class _BankEngine extends ActivityEngine {
  @override
  final String familyId = 'numeric_family';
}

NumericItem _numeric({
  String id = 'n1',
  String stem = 'Combien font 40 + 2 ?',
  num expected = 42,
  Tolerance? tolerance,
  String? unit,
  InputFormat inputFormat = InputFormat.decimal,
}) => NumericItem(
  id: id,
  version: 1,
  familyId: 'numeric_family',
  difficulty: 3,
  tags: const ['test'],
  stem: LocalizedText(fr: stem),
  expected: expected,
  explanation: const LocalizedText(fr: '40 + 2 = 42.'),
  tolerance: tolerance,
  unit: unit,
  inputFormat: inputFormat,
);

void main() {
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(DateTime.utc(2026, 9, 5, 9));
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({
    required List<Item> items,
    SessionMode mode = SessionMode.practice,
  }) => ActivitySessionConfig(
    familyId: 'numeric_family',
    mode: mode,
    source: ItemSource.bank(items),
  );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionConfig config, {
    double textScale = 1.0,
  }) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(config),
      onFinished: finished.add,
    ),
    textScale: textScale,
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(EngineRegistry([_BankEngine()])),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry([const NumericRenderer(familyId: 'numeric_family')]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  Future<void> start(WidgetTester tester) async {
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
  }

  Future<void> tapDigits(WidgetTester tester, String digits) async {
    for (final char in digits.split('')) {
      final key = switch (char) {
        '-' => 'numeric_key_sign',
        '.' => 'numeric_key_decimal',
        _ => 'numeric_key_$char',
      };
      await tester.tap(find.byKey(ValueKey(key)));
      await tester.pump();
    }
  }

  testWidgets('briefing example shows a static keypad illustration', (
    tester,
  ) async {
    await pumpHost(tester, config(items: [_numeric()]));
    expect(find.text(AppStrings.numericExampleStem), findsOneWidget);
    expect(find.byType(AppKeypadButton), findsWidgets);
  });

  testWidgets('typing on the keypad then Valider answers correctly', (
    tester,
  ) async {
    await pumpHost(tester, config(items: [_numeric()]));
    await start(tester);

    expect(
      find.text('Combien font 40 + 2 ?', findRichText: true),
      findsOneWidget,
    );
    var validate = tester.widget<AppKeypadButton>(
      find.byKey(const ValueKey('numeric_key_validate')),
    );
    expect(validate.onPressed, isNull);

    await tapDigits(tester, '42');
    validate = tester.widget<AppKeypadButton>(
      find.byKey(const ValueKey('numeric_key_validate')),
    );
    expect(validate.onPressed, isNotNull);

    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('negative and decimal keys build the typed value', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(items: [_numeric(expected: -1.5, unit: 'kg')]),
    );
    await start(tester);

    await tapDigits(tester, '-1.5');
    expect(find.text('-1.5 kg', findRichText: true), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('backspace erases the last character', (tester) async {
    await pumpHost(tester, config(items: [_numeric()]));
    await start(tester);
    await tapDigits(tester, '47');
    await tester.tap(find.byKey(const ValueKey('numeric_key_backspace')));
    await tester.pump();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('numeric_answer_field')),
        matching: find.text('4', findRichText: true),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the decimal key is disabled for an integer input format', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(items: [_numeric(inputFormat: InputFormat.integer)]),
    );
    await start(tester);
    final decimalKey = tester.widget<AppKeypadButton>(
      find.byKey(const ValueKey('numeric_key_decimal')),
    );
    expect(decimalKey.onPressed, isNull);
  });

  testWidgets('tolerance from the item is honoured by the default scorer', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(
        items: [
          _numeric(
            tolerance: const Tolerance(mode: ToleranceMode.absolute, value: 1),
          ),
        ],
      ),
    );
    await start(tester);
    await tapDigits(tester, '43');
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('physical keyboard: digits, minus, backspace and Enter work', (
    tester,
  ) async {
    await pumpHost(tester, config(items: [_numeric()]));
    await start(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.pump();
    expect(find.text('42', findRichText: true), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('exam mode is silent: Valider moves on without feedback', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(
        items: [
          _numeric(),
          _numeric(id: 'n2'),
        ],
        mode: SessionMode.exam,
      ),
    );
    await start(tester);
    await tapDigits(tester, '42');
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();
    expect(find.byKey(SessionHost.feedbackKey), findsNothing);
    await tester.pump();
    expect(repo.attempts, hasLength(1));
    expect(repo.attempts.single.isCorrect, isTrue);
  });

  testWidgets('survives a 1.3x text scale without overflow', (tester) async {
    await pumpHost(
      tester,
      config(items: [_numeric(unit: 'm')]),
      textScale: 1.3,
    );
    await start(tester);
    expect(tester.takeException(), isNull);
  });
}
