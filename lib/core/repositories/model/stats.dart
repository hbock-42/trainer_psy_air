import 'package:freezed_annotation/freezed_annotation.dart';

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
