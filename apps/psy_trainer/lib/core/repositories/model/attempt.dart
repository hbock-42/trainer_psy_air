import 'package:freezed_annotation/freezed_annotation.dart';

part 'attempt.freezed.dart';
part 'attempt.g.dart';

/// Where a generated stimulus came from. Same `generatorId` + `seed` +
/// `params` + `difficulty` reproduces the item (`ActivityEngine.generate`
/// takes `difficulty` too, and some generators use it to shape the content,
/// not just to tag it), so an attempt can be replayed or reviewed without
/// storing the item itself (US-054 "retry my mistakes").
///
/// [difficulty] defaults to 3 (the mid-range level) for attempts recorded
/// before this field existed; a handful of pre-US-054 rows may therefore
/// replay at a slightly different difficulty than the one originally drawn.
@freezed
abstract class AttemptOrigin with _$AttemptOrigin {
  const factory AttemptOrigin({
    required String generatorId,
    required int seed,
    @Default(<String, Object?>{}) Map<String, Object?> params,
    @Default(3) int difficulty,
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
