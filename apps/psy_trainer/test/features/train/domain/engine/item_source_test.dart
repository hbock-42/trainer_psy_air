import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import '../../../../helpers/fake_engine.dart';

void main() {
  final engine = FakeEngine();

  group('BankSource', () {
    test('plays bank items as they are, with their bank id', () {
      final source = ItemSource.bank(fakeBank(3));
      expect(source.itemCount, 3);
      final items = source.materialise(engine);
      expect(items.map((s) => s.item.id), ['q1', 'q2', 'q3']);
      expect(items.map((s) => s.itemId), ['q1', 'q2', 'q3']);
      expect(items.every((s) => !s.isGenerated), isTrue);
    });

    test('materialises a generated recipe found in a bank', () {
      const recipe = GeneratedItem(
        id: 'bank-recipe',
        version: 1,
        familyId: 'fake_family',
        difficulty: 4,
        tags: ['fake'],
        generatorId: GeneratorId.dominos,
        seed: 42,
        params: GeneratorParams.dominos(length: 5),
      );
      final [entry] = const ItemSource.bank([recipe]).materialise(engine);
      expect(entry.isGenerated, isTrue);
      expect(entry.itemId, isNull);
      expect(entry.item.id, 'gen.dominos.42');
      expect(entry.item.difficulty, 4);
      expect(
        entry.item.origin,
        const ItemOrigin(generatorId: GeneratorId.dominos, seed: 42),
      );
      expect(
        entry.origin,
        AttemptOrigin(
          generatorId: 'dominos',
          seed: 42,
          params: generatorParamsToJson(
            const GeneratorParams.dominos(length: 5),
          ),
          difficulty: 4,
        ),
      );
    });
  });

  group('GeneratorSource', () {
    const source = GeneratorSource(
      generatorId: GeneratorId.dominos,
      seed: 2026,
      params: GeneratorParams.dominos(),
      count: 5,
      difficulty: DifficultyRange(min: 2, max: 4),
    );

    test('yields count items with origins carrying the params', () {
      final items = source.materialise(engine);
      expect(source.itemCount, 5);
      expect(items, hasLength(5));
      for (final entry in items) {
        expect(entry.isGenerated, isTrue);
        expect(entry.origin!.generatorId, 'dominos');
        expect(entry.origin!.params, generatorParamsToJson(source.params));
        expect(entry.item.id, 'gen.dominos.${entry.origin!.seed}');
        expect(entry.item.difficulty, inInclusiveRange(2, 4));
      }
    });

    test('the same seed reproduces the same items, another seed does not', () {
      final a = source.materialise(engine).map((s) => s.item).toList();
      final b = source.materialise(engine).map((s) => s.item).toList();
      expect(a, b);
      final c = source.copyWith(seed: 7).materialise(engine).map((s) => s.item);
      expect(c, isNot(equals(a)));
    });

    test('item seeds are distinct within a run', () {
      final seeds = source.materialise(engine).map((s) => s.origin!.seed);
      expect(seeds.toSet(), hasLength(5));
    });

    test('a fixed difficulty range pins every item', () {
      final items = source
          .copyWith(difficulty: const DifficultyRange(min: 5, max: 5))
          .materialise(engine);
      expect(items.every((s) => s.item.difficulty == 5), isTrue);
    });

    test('round-trips through JSON with typed params', () {
      final json = source.toJson();
      expect(json['kind'], 'generator');
      expect(json['generatorId'], 'dominos');
      expect(json['params'], isNot(contains('generatorId')));
      expect(ItemSource.fromJson(json), source);
    });
  });

  group('AdaptiveSource', () {
    const source = AdaptiveSource(
      generatorId: GeneratorId.dominos,
      runSeed: 2026,
      params: GeneratorParams.dominos(),
      count: 5,
      initialDifficulty: 3,
    );

    test('itemCount is count; materialise throws (no fixed item list)', () {
      expect(source.itemCount, 5);
      expect(source.isAdaptive, isTrue);
      expect(() => source.materialise(engine), throwsUnsupportedError);
    });

    test(
      'materialiseAdaptive at a given index/difficulty is deterministic',
      () {
        final a = source.materialiseAdaptive(engine, 2, 4);
        final b = source.materialiseAdaptive(engine, 2, 4);
        expect(a.item, b.item);
        expect(a.origin, b.origin);
        expect(a.origin!.difficulty, 4);
      },
    );

    test('the same index always draws the same seed, whatever order '
        'indices are materialised in', () {
      // Index 3 materialised right away...
      final direct = source.materialiseAdaptive(engine, 3, 2);
      // ...or only after 0, 1 and 2 were: same result either way (US-053's
      // "materialises item k at the time it is shown" must not depend on
      // call order, since a resumed session re-derives earlier items from
      // their stored attempts, not by replaying every index in sequence).
      source.materialiseAdaptive(engine, 0, 1);
      source.materialiseAdaptive(engine, 1, 1);
      source.materialiseAdaptive(engine, 2, 1);
      final afterOthers = source.materialiseAdaptive(engine, 3, 2);
      expect(afterOthers.origin!.seed, direct.origin!.seed);
      expect(afterOthers.item, direct.item);
    });

    test('different indices draw different seeds', () {
      final seeds = [
        for (var i = 0; i < 5; i++)
          source.materialiseAdaptive(engine, i, 3).origin!.seed,
      ];
      expect(seeds.toSet(), hasLength(5));
    });

    test('a different runSeed draws different items at the same index', () {
      final a = source.materialiseAdaptive(engine, 0, 3);
      final b = source.copyWith(runSeed: 7).materialiseAdaptive(engine, 0, 3);
      expect(a.item, isNot(equals(b.item)));
    });

    test('difficulty changes the item without changing its seed', () {
      final low = source.materialiseAdaptive(engine, 0, 1);
      final high = source.materialiseAdaptive(engine, 0, 5);
      expect(low.origin!.seed, high.origin!.seed);
      expect(low.item.difficulty, 1);
      expect(high.item.difficulty, 5);
    });

    test('rejects an engine for the wrong generator via itemFromOrigin', () {
      const origin = AttemptOrigin(generatorId: 'nback', seed: 1);
      expect(
        () => ItemSource.itemFromOrigin(engine, origin),
        throwsArgumentError,
      );
    });

    test('itemFromOrigin reproduces an item materialiseAdaptive produced', () {
      final produced = source.materialiseAdaptive(engine, 1, 4);
      final rebuilt = ItemSource.itemFromOrigin(
        engine,
        produced.origin!,
        index: 1,
        runSeed: source.runSeed,
      );
      expect(rebuilt, produced.item);
    });

    test('round-trips through JSON with typed params', () {
      final json = source.toJson();
      expect(json['kind'], 'adaptive');
      expect(json['generatorId'], 'dominos');
      expect(ItemSource.fromJson(json), source);
    });
  });

  test('a bank source round-trips through JSON', () {
    final source = ItemSource.bank(fakeBank(2));
    expect(ItemSource.fromJson(source.toJson()), source);
  });

  group('ReplaySource', () {
    test('reproduces the same item as the original generation', () {
      final generated = const ItemSource.generator(
        generatorId: GeneratorId.dominos,
        seed: 99,
        params: GeneratorParams.dominos(),
        count: 3,
        difficulty: DifficultyRange(min: 2, max: 4),
      ).materialise(engine);

      final origins = [for (final s in generated) s.origin!];
      final replayed = ItemSource.replay(origins).materialise(engine);

      expect(replayed.map((s) => s.item), generated.map((s) => s.item));
      expect(replayed.map((s) => s.origin), origins);
      expect(replayed.every((s) => s.isGenerated), isTrue);
    });

    test('itemCount is the number of origins', () {
      const source = ItemSource.replay([
        AttemptOrigin(generatorId: 'dominos', seed: 1),
        AttemptOrigin(generatorId: 'dominos', seed: 2),
      ]);
      expect(source.itemCount, 2);
    });

    test('rejects an origin for a different generator', () {
      const source = ItemSource.replay([
        AttemptOrigin(generatorId: 'nback', seed: 1),
      ]);
      expect(() => source.materialise(engine), throwsArgumentError);
    });
  });

  test('SessionItem requires exactly one of itemId / origin', () {
    final item = fakeMcq(id: 'x');
    expect(() => SessionItem(item: item), throwsA(isA<AssertionError>()));
    expect(
      () => SessionItem(
        item: item,
        itemId: 'x',
        origin: const AttemptOrigin(generatorId: 'g', seed: 1),
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
