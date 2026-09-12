import 'package:freezed_annotation/freezed_annotation.dart';

import 'session.dart';

part 'stats.freezed.dart';

/// Lifetime counters of one bank item. Only bank items (with a content id)
/// have stats; generated items are aggregated per family instead.
@freezed
abstract class ItemStat with _$ItemStat {
  const factory ItemStat({
    required String itemId,
    required String familyId,
    required int seen,
    required int correct,
    required int totalResponseMs,
    required bool lastCorrect,
    required DateTime lastSeenAt,
  }) = _ItemStat;

  const ItemStat._();

  double get accuracy => seen == 0 ? 0 : correct / seen;

  double get meanResponseMs => seen == 0 ? 0 : totalResponseMs / seen;
}

/// Accuracy and response-time aggregates of one family over a set of
/// attempts, computed in SQL.
@freezed
abstract class FamilyStats with _$FamilyStats {
  const factory FamilyStats({
    required String familyId,
    required int attempts,
    required int correct,
    required double meanResponseMs,
    required double medianResponseMs,
  }) = _FamilyStats;

  const FamilyStats._();

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

/// Accuracy and response-time aggregates of one family within one session
/// (and, for exams, one blueprint section): one point of a score-over-time
/// series (US-071) or one section of an exam summary, computed in SQL so
/// neither ever loads the attempts themselves.
///
/// [unanswered] counts attempts stored without an answer payload (timeouts
/// and skips); they are included in [attempts] and count as wrong.
/// [sectionIndex] is null for practice sessions.
@freezed
abstract class SessionFamilyStats with _$SessionFamilyStats {
  const factory SessionFamilyStats({
    required String sessionId,
    required String familyId,
    required SessionMode mode,
    required DateTime startedAt,
    required int attempts,
    required int correct,
    required int unanswered,
    required double meanResponseMs,
    required double medianResponseMs,
    int? sectionIndex,
  }) = _SessionFamilyStats;

  const SessionFamilyStats._();

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}
