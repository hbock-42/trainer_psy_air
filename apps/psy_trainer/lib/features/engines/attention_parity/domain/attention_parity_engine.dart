import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'parity_layout.dart';

/// `attention_parity` (spec §2.4-D, US-031): "Pair / impair". A cloud of
/// numbers; from START, tap alternately the next ascending even then the
/// next ascending odd number until END; a wrong tap restarts the series
/// (US-020 `liveFeedback`/`restartOnError`, kept in exam mode: it is how the
/// real test works, not a practice-only affordance).
///
/// The generated item stays a plain [GeneratedItem] (no engine-specific
/// fields added to it): its numbers and its one valid path are
/// [ParityLayout], recomputed from `(seed, params, difficulty)` by
/// [layoutOf] wherever they are needed (here, in the renderer). Same
/// inputs, same layout.
class AttentionParityEngine extends ActivityEngine {
  const AttentionParityEngine();

  @override
  String get familyId => 'attention_parity';

  @override
  GeneratorId? get generatorId => GeneratorId.paritySequence;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as ParitySequenceParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.paritySequence, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['attention', 'parity'],
      generatorId: GeneratorId.paritySequence,
      seed: seed,
      params: typed,
      origin: ItemOrigin(generatorId: GeneratorId.paritySequence, seed: seed),
    );
  }

  /// The numbers and the expected path of a materialised `GeneratedItem`
  /// of this family; used by the renderer (and by [score], through
  /// [expectedPath]).
  static ParityLayout layoutOf(GeneratedItem item) => ParityLayout.build(
    params: item.params as ParitySequenceParams,
    seed: item.seed,
    difficulty: item.difficulty,
  );

  /// The candidate answers with `Answer.raw({'path': [...], 'restarts':
  /// n, 'totalTaps': m})`: a plain `SequenceAnswer` only carries the tapped
  /// path and this activity also reports live-feedback metrics (how many
  /// times a wrong tap restarted the series, and how many taps it took in
  /// total) that the runtime's `Answer` union has no field for. `path` is
  /// the ordered list of number tokens of the one completed run (the
  /// candidate cannot submit until it matches the series length: earlier
  /// wrong taps are restarts, not part of the answer).
  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final expected = layoutOf(generated).pathTokens;
    if (answer is! RawAnswer) return ItemResult.wrong;
    final payload = answer.payload;
    final path = (payload['path'] as List?)?.cast<String>() ?? const [];
    final restarts = (payload['restarts'] as num?)?.toInt() ?? 0;
    final totalTaps = (payload['totalTaps'] as num?)?.toInt() ?? path.length;
    final correct = _sameOrder(path, expected);
    return ItemResult(
      correct: correct,
      metrics: {'restarts': restarts, 'totalTaps': totalTaps},
    );
  }

  static bool _sameOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
