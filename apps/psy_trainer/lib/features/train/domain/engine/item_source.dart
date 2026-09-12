import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/model/attempt.dart';
import 'activity_engine.dart';

part 'item_source.freezed.dart';
part 'item_source.g.dart';

/// Where a session's items come from: a fixed list of bank items or a
/// generator recipe. JSON-serialisable so it can be stored in the
/// `TrainingSession.config` and rebuilt on resume.
@Freezed(unionKey: 'kind')
sealed class ItemSource with _$ItemSource {
  const ItemSource._();

  /// Play [items] in order. A [GeneratedItem] in the list is materialised
  /// by the engine; every other item is played as is.
  @FreezedUnionValue('bank')
  const factory ItemSource.bank(List<Item> items) = BankSource;

  /// Generate [count] items from `generatorId` with [params]. One seed per
  /// item and one difficulty within [difficulty] are drawn from
  /// `Random(seed)`, so the whole section is reproducible from [seed].
  @FreezedUnionValue('generator')
  const factory ItemSource.generator({
    required GeneratorId generatorId,
    required int seed,
    @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)
    required GeneratorParams params,
    required int count,
    @Default(DifficultyRange(min: 3, max: 3)) DifficultyRange difficulty,
  }) = GeneratorSource;

  factory ItemSource.fromJson(Map<String, Object?> json) =>
      _$ItemSourceFromJson(json);

  /// Number of items the session will play.
  int get itemCount => switch (this) {
    BankSource(:final items) => items.length,
    GeneratorSource(:final count) => count,
  };

  /// Builds the concrete items with [engine]. Deterministic.
  List<SessionItem> materialise(ActivityEngine engine) => switch (this) {
    BankSource(:final items) => [
      for (final item in items) SessionItem.of(engine.materialise(item), item),
    ],
    GeneratorSource(
      :final generatorId,
      :final seed,
      :final params,
      :final count,
      :final difficulty,
    ) =>
      _generate(engine, generatorId, seed, params, count, difficulty),
  };

  static List<SessionItem> _generate(
    ActivityEngine engine,
    GeneratorId generatorId,
    int seed,
    GeneratorParams params,
    int count,
    DifficultyRange difficulty,
  ) {
    final rng = Random(seed);
    final span = difficulty.max - difficulty.min + 1;
    return [
      for (var i = 0; i < count; i++)
        () {
          final itemSeed = rng.nextInt(1 << 31);
          final level = difficulty.min + rng.nextInt(span);
          final item = engine.generate(
            params: params,
            seed: itemSeed,
            difficulty: level,
          );
          return SessionItem(
            item: item,
            origin: AttemptOrigin(
              generatorId: generatorId.jsonName,
              seed: itemSeed,
              params: generatorParamsToJson(params),
            ),
          );
        }(),
    ];
  }
}

/// A concrete item ready to play plus what an attempt on it must store:
/// the bank `itemId` for bank items or the [AttemptOrigin] for generated
/// ones (exactly one is set, as `NewAttempt` requires).
class SessionItem {
  const SessionItem({required this.item, this.itemId, this.origin})
    : assert(
        (itemId == null) != (origin == null),
        'exactly one of itemId/origin is set',
      );

  /// Pairs a materialised [item] with the bank entry it came from
  /// ([source]): a recipe yields an origin, anything else its bank id.
  factory SessionItem.of(Item item, Item source) => switch (source) {
    GeneratedItem(:final generatorId, :final seed, :final params) =>
      SessionItem(
        item: item,
        origin: AttemptOrigin(
          generatorId: generatorId.jsonName,
          seed: seed,
          params: generatorParamsToJson(params),
        ),
      ),
    _ => SessionItem(item: item, itemId: source.id),
  };

  final Item item;
  final String? itemId;
  final AttemptOrigin? origin;

  bool get isGenerated => origin != null;
}
