// US-125: keeps `psy1FamilyIds` (the static list read *before* the
// `psy1` deferred library has loaded — see `engine_registry_provider.dart`)
// honest against what `psy1Engines()`/`psy1Renderers()` actually register,
// so the two never drift apart.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/train/presentation/engine/deferred/psy1_engines.dart';

final _rendererFamilyIdsProvider = Provider<Set<String>>(
  (ref) => psy1Renderers(ref).map((r) => r.familyId).toSet(),
);

void main() {
  test('psy1FamilyIds matches psy1Engines() and psy1Renderers() exactly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final engineFamilyIds = psy1Engines().map((e) => e.familyId).toSet();
    final rendererFamilyIds = container.read(_rendererFamilyIdsProvider);

    expect(engineFamilyIds, psy1FamilyIds.toSet());
    expect(rendererFamilyIds, psy1FamilyIds.toSet());
    expect(
      psy1FamilyIds.toSet(),
      hasLength(psy1FamilyIds.length),
      reason: 'no duplicate family id',
    );
  });
}
