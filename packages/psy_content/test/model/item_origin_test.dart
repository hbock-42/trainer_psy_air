import 'package:psy_content/psy_content.dart';
import 'package:test/test.dart';

/// US-037: `ItemOrigin.runSeed`/`.index` are additive (optional, no
/// `schemaVersion` bump -- CONTRACT.md §5). `generatorId`/`seed` alone
/// must still round-trip exactly as before; adding `runSeed`/`index` must
/// not disturb that, and unknown/omitted keys stay ignorable either way.
void main() {
  group('ItemOrigin', () {
    test(
      'round-trips with only the required fields (no schemaVersion bump)',
      () {
        const origin = ItemOrigin(generatorId: GeneratorId.dominos, seed: 42);
        final json = origin.toJson();
        expect(json, {'generatorId': 'dominos', 'seed': 42});
        expect(ItemOrigin.fromJson(json), origin);
      },
    );

    test('round-trips with runSeed and index set', () {
      const origin = ItemOrigin(
        generatorId: GeneratorId.nback,
        seed: 1000,
        runSeed: 777,
        index: 5,
      );
      final json = origin.toJson();
      expect(json['runSeed'], 777);
      expect(json['index'], 5);
      expect(ItemOrigin.fromJson(json), origin);
    });

    test('decodes an older payload with no runSeed/index as null', () {
      final origin = ItemOrigin.fromJson(const {
        'generatorId': 'dominos',
        'seed': 42,
      });
      expect(origin.runSeed, isNull);
      expect(origin.index, isNull);
    });
  });
}
