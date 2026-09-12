import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import '../../../../helpers/fake_engine.dart';

class _BankOnlyEngine extends ActivityEngine {
  const _BankOnlyEngine();

  @override
  String get familyId => 'culture_aero';
}

void main() {
  group('ActivityEngine defaults', () {
    test('a bank-only engine has no generator and cannot generate', () {
      const engine = _BankOnlyEngine();
      expect(engine.generatorId, isNull);
      expect(
        () => engine.generate(
          params: const GeneratorParams.dominos(),
          seed: 1,
          difficulty: 3,
        ),
        throwsUnsupportedError,
      );
    });

    test('scores bank items with the default scorer', () {
      const engine = _BankOnlyEngine();
      final item = fakeMcq(id: 'c1', correctIndex: 2);
      expect(engine.score(item, const Answer.choice(2)), ItemResult.right);
      expect(engine.score(item, const Answer.choice(0)), ItemResult.wrong);
    });

    test('materialise passes non-generated items through', () {
      final item = fakeMcq(id: 'c1');
      expect(const _BankOnlyEngine().materialise(item), same(item));
    });

    test('generatedItemId follows the gen.<generator>.<seed> convention', () {
      expect(
        ActivityEngine.generatedItemId(GeneratorId.stimulusResponse, 12),
        'gen.stimulus_response.12',
      );
      expect(GeneratorId.arithmeticGrid.jsonName, 'arithmetic_grid');
    });
  });

  group('EngineRegistry', () {
    test('finds engines by family and by generator', () {
      final fake = FakeEngine();
      final registry = EngineRegistry([fake, const _BankOnlyEngine()]);
      expect(registry.engines, hasLength(2));
      expect(registry.byFamily('fake_family'), same(fake));
      expect(registry.byGenerator(GeneratorId.dominos), same(fake));
      expect(registry.hasFamily('culture_aero'), isTrue);
      expect(registry.hasFamily('nope'), isFalse);
      expect(registry.hasGenerator(GeneratorId.nback), isFalse);
    });

    test('throws EngineNotFoundError for unknown keys', () {
      final registry = EngineRegistry(const []);
      expect(
        () => registry.byFamily('memory_nback'),
        throwsA(
          isA<EngineNotFoundError>().having(
            (e) => e.toString(),
            'message',
            contains('memory_nback'),
          ),
        ),
      );
      expect(
        () => registry.byGenerator(GeneratorId.nback),
        throwsA(isA<EngineNotFoundError>()),
      );
    });

    test('rejects a second engine for the same family or generator', () {
      final registry = EngineRegistry([FakeEngine()]);
      expect(
        () => registry.register(FakeEngine(generatorId: GeneratorId.nback)),
        throwsArgumentError,
      );
      expect(
        () => registry.register(FakeEngine(familyId: 'other')),
        throwsArgumentError,
      );
      expect(registry.engines, hasLength(1));
    });
  });
}
