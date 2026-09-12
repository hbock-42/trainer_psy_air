import 'package:freezed_annotation/freezed_annotation.dart';

import 'exam_summary.dart';
import 'family_progress.dart';
import 'readiness_score.dart';
import 'weak_area.dart';

part 'progress_snapshot.freezed.dart';

/// Everything the dashboard (US-070) needs, computed in one pass at
/// [computedAt]: one [FamilyProgress] per content family (content order,
/// then families only seen in attempts), the readiness score, weak areas
/// and exam history (newest first).
@freezed
abstract class ProgressSnapshot with _$ProgressSnapshot {
  const factory ProgressSnapshot({
    required DateTime computedAt,
    required List<FamilyProgress> families,
    required ReadinessScore readiness,
    required List<WeakArea> weakAreas,
    required List<ExamSummary> exams,
  }) = _ProgressSnapshot;

  const ProgressSnapshot._();

  bool get isEmpty => !readiness.hasAnyData;

  FamilyProgress? family(String familyId) {
    for (final f in families) {
      if (f.familyId == familyId) return f;
    }
    return null;
  }

  ExamSummary? get latestExam => exams.isEmpty ? null : exams.first;
}
