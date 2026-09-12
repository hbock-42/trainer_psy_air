import 'package:freezed_annotation/freezed_annotation.dart';

import 'family_progress.dart';

part 'weak_area.freezed.dart';

/// What a [WeakArea] points at.
enum WeakAreaKind { family, tag }

/// Why it was flagged.
enum WeakAreaReason { lowAccuracy, negativeTrend }

/// A family or item tag the candidate should work on: accuracy below the
/// configured threshold (with enough attempts) and/or a negative 30-day
/// trend. Ordered by the service from weakest to strongest.
@freezed
abstract class WeakArea with _$WeakArea {
  const factory WeakArea({
    required WeakAreaKind kind,
    required String id,
    required Set<WeakAreaReason> reasons,
    required double accuracy,
    required int attempts,

    /// The 30-day trend for families; null for tags.
    Trend? trend,
  }) = _WeakArea;

  const WeakArea._();

  bool get isFamily => kind == WeakAreaKind.family;
}
