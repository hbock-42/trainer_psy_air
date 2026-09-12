import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/fake_engine.dart';
import '../../../../helpers/fake_renderer.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  ActivityRenderContext context({
    ItemPhase phase = ItemPhase.answer,
    SessionMode mode = SessionMode.practice,
    ItemResult? feedback,
  }) => ActivityRenderContext(
    item: fakeMcq(id: 'q1'),
    mode: mode,
    phase: phase,
    timing: TimingPolicy.none,
    itemIndex: 0,
    itemCount: 1,
    showsFeedback: mode == SessionMode.practice,
    feedback: feedback,
    onAnswer: (_) {},
  );

  group('ActivityRenderContext', () {
    test('exposes the phase and mode as flags', () {
      final open = context();
      expect(open.isAnswered, isFalse);
      expect(open.acceptsInput, isTrue);
      expect(open.isExam, isFalse);
      final done = context(
        phase: ItemPhase.answered,
        mode: SessionMode.exam,
        feedback: ItemResult.right,
      );
      expect(done.isAnswered, isTrue);
      expect(done.acceptsInput, isFalse);
      expect(done.isExam, isTrue);
      expect(done.feedback, ItemResult.right);
    });
  });

  group('FunctionRenderer', () {
    testWidgets('delegates build and the optional example', (tester) async {
      final renderer = FunctionRenderer(
        familyId: 'fn',
        builder: (context, render) => Text('item ${render.item.id}'),
        example: (context) => const Text('example!'),
      );
      expect(renderer.familyId, 'fn');
      await tester.pumpApp(
        Builder(
          builder: (ctx) => Column(
            children: [
              renderer.build(ctx, context()),
              renderer.buildExample(ctx)!,
            ],
          ),
        ),
      );
      expect(find.text('item q1'), findsOneWidget);
      expect(find.text('example!'), findsOneWidget);
    });

    testWidgets('has no example by default', (tester) async {
      const renderer = FunctionRenderer(familyId: 'fn', builder: _emptyBuilder);
      await tester.pumpApp(
        Builder(
          builder: (ctx) => renderer.buildExample(ctx) ?? const Text('none'),
        ),
      );
      expect(find.text('none'), findsOneWidget);
    });
  });

  group('RendererRegistry', () {
    test('finds renderers by family and rejects duplicates', () {
      const fake = FakeRenderer();
      final registry = RendererRegistry(const [fake]);
      expect(registry.byFamily('fake_family'), same(fake));
      expect(registry.hasFamily('fake_family'), isTrue);
      expect(registry.hasFamily('other'), isFalse);
      expect(
        () => registry.register(const FakeRenderer()),
        throwsArgumentError,
      );
    });

    test('throws RendererNotFoundError for unknown families', () {
      final registry = RendererRegistry(const []);
      expect(
        () => registry.byFamily('memory_nback'),
        throwsA(
          isA<RendererNotFoundError>().having(
            (e) => e.toString(),
            'message',
            contains('memory_nback'),
          ),
        ),
      );
    });
  });
}

Widget _emptyBuilder(BuildContext context, ActivityRenderContext render) =>
    const SizedBox.shrink();
