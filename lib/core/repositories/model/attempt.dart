import 'package:freezed_annotation/freezed_annotation.dart';

part 'attempt.freezed.dart';
part 'attempt.g.dart';

/// Where a generated stimulus came from. Same `generatorId` + `seed` +
/// `params` reproduces the item, so an attempt can be replayed or reviewed
/// without storing the item itself.
@freezed
abstract class AttemptOrigin with _$AttemptOrigin {
  const factory AttemptOrigin({
    required String generatorId,
    required int seed,
    @Default(<String, Object?>{}) Map<String, Object?> params,
  }) = _AttemptOrigin;

  factory AttemptOrigin.fromJson(Map<String, Object?> json) =>
      _$AttemptOriginFromJson(json);
}

/// What an engine hands to the repository for each answered (or timed-out)
/// stimulus. Exactly one of [itemId] (bank item) or [origin] (generated item)
/// is set.
@freezed
abstract class NewAttempt with _$NewAttempt {
  @Assert(
    '(itemId == null) != (origin == null)',
    'exactly one of itemId/origin is set',
  )
  const factory NewAttempt({
    required String sessionId,
    required String familyId,
    required bool isCorrect,
    required int responseMs,

    /// 0-based rank of the stimulus within the session. Cadence-driven
    /// activities fire many attempts per second; this, not the timestamp,
    /// defines the order.
    required int position,
    String? itemId,
    AttemptOrigin? origin,

    /// Engine-specific answer payload; null when no answer was given.
    Map<String, Object?>? answer,

    /// Exam sessions: index of the blueprint section.
    int? sectionIndex,

    /// Defaults to "now" when omitted.
    DateTime? answeredAt,
  }) = _NewAttempt;
}

/// A stored attempt.
@freezed
abstract class Attempt with _$Attempt {
  const factory Attempt({
    required String id,
    required String sessionId,
    required String familyId,
    required bool isCorrect,
    required int responseMs,
    required int position,
    required DateTime answeredAt,
    String? itemId,
    AttemptOrigin? origin,
    Map<String, Object?>? answer,
    int? sectionIndex,
  }) = _Attempt;

  const Attempt._();

  bool get isGenerated => origin != null;
}
