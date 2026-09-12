import 'package:psy_content/psy_content.dart';
import 'answer.dart';
import 'item_result.dart';
import 'scorer.dart';

/// The pure-Dart half of an activity (EPIC-03): its generator and its scorer.
///
/// One engine per family id (`TestFamily.engineType`). The runtime
/// (`ActivitySession`) asks it to materialise generated items and to score
/// answers; the widget half is an `ActivityRenderer` registered next to it
/// in `features/train/presentation/engine/`. Engines are stateless: every
/// per-run value comes from `(params, seed, difficulty)`.
///
/// Bank-driven engines (culture, English) only need [familyId]; the default
/// [score] handles `McqItem` and `NumericItem`. Generator-driven engines
/// override [generatorId], [generate] and, when the answer is not an MCQ or
/// numeric value, [score].
abstract class ActivityEngine {
  const ActivityEngine();

  /// Registry key; equals the family id (`memory_nback`, `culture_aero`...).
  String get familyId;

  /// The generator this engine implements, or null for bank-only engines.
  GeneratorId? get generatorId => null;

  /// Builds the concrete item of the recipe `(params, seed, difficulty)`.
  ///
  /// Must be deterministic: same inputs, same item. The returned item's `id`
  /// is [generatedItemId] and its `origin` is `ItemOrigin(generatorId,
  /// seed)` so attempts can be replayed. Bank-only engines throw
  /// [UnsupportedError].
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
  }) => throw UnsupportedError('$familyId has no generator');

  /// Scores [answer] against [item]. Never called with a
  /// [TimeoutAnswer]: the runtime records timeouts itself.
  ///
  /// The default handles [McqItem] (choice / skip), [NumericItem] (numeric,
  /// tolerance) and [SequenceItem] (sequence, recall mode); anything else is
  /// wrong. Override for engine-specific items or partial metrics.
  ItemResult score(Item item, Answer answer) => Scorer.scoreItem(item, answer);

  /// Turns a bank [GeneratedItem] into the concrete item it describes;
  /// other items pass through.
  Item materialise(Item item) => switch (item) {
    GeneratedItem(:final params, :final seed, :final difficulty) => generate(
      params: params,
      seed: seed,
      difficulty: difficulty,
    ),
    _ => item,
  };

  /// `gen.<generatorId>.<seed>`: the id convention of materialised items
  /// (CONTRACT.md §2).
  static String generatedItemId(GeneratorId generatorId, int seed) =>
      'gen.${generatorId.jsonName}.$seed';
}

/// The snake_case name of a [GeneratorId] as written in JSON
/// (`stimulus_response`), used in item ids and `AttemptOrigin.generatorId`.
extension GeneratorIdJson on GeneratorId {
  String get jsonName =>
      ItemOrigin(generatorId: this, seed: 0).toJson()['generatorId']! as String;
}

/// Raised when a session asks for an engine nobody registered.
class EngineNotFoundError extends Error {
  EngineNotFoundError(this.key);

  /// The family id or generator id looked up.
  final Object key;

  @override
  String toString() => 'EngineNotFoundError: no engine registered for $key';
}

/// The engines available to the runtime, keyed by family id (and, for
/// generator-driven ones, by generator id).
///
/// The app builds one in `engineRegistryProvider`
/// (`features/train/presentation/engine/engine_registry_provider.dart`);
/// tests build one with a fake engine.
class EngineRegistry {
  EngineRegistry(Iterable<ActivityEngine> engines) {
    for (final engine in engines) {
      register(engine);
    }
  }

  final Map<String, ActivityEngine> _byFamily = {};
  final Map<GeneratorId, ActivityEngine> _byGenerator = {};

  /// Registered engines in registration order.
  List<ActivityEngine> get engines => List.unmodifiable(_byFamily.values);

  /// Adds [engine]; a second engine for the same family or generator is a
  /// programming error.
  void register(ActivityEngine engine) {
    if (_byFamily.containsKey(engine.familyId)) {
      throw ArgumentError.value(
        engine.familyId,
        'engine',
        'an engine is already registered for this family',
      );
    }
    final generatorId = engine.generatorId;
    if (generatorId != null && _byGenerator.containsKey(generatorId)) {
      throw ArgumentError.value(
        generatorId,
        'engine',
        'an engine is already registered for this generator',
      );
    }
    _byFamily[engine.familyId] = engine;
    if (generatorId != null) _byGenerator[generatorId] = engine;
  }

  bool hasFamily(String familyId) => _byFamily.containsKey(familyId);

  bool hasGenerator(GeneratorId generatorId) =>
      _byGenerator.containsKey(generatorId);

  /// Throws [EngineNotFoundError] when unknown.
  ActivityEngine byFamily(String familyId) =>
      _byFamily[familyId] ?? (throw EngineNotFoundError(familyId));

  /// Throws [EngineNotFoundError] when unknown.
  ActivityEngine byGenerator(GeneratorId generatorId) =>
      _byGenerator[generatorId] ?? (throw EngineNotFoundError(generatorId));
}
