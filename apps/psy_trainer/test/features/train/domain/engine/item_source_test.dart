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

  test('a bank source round-trips through JSON', () {
    final source = ItemSource.bank(fakeBank(2));
    expect(ItemSource.fromJson(source.toJson()), source);
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
