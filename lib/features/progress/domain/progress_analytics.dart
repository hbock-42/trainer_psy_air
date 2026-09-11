import '../../../core/content/model/exam_blueprint.dart';
import '../../../core/repositories/content_repository.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/model/stats.dart';
import '../../../core/repositories/progress_repository.dart';
import 'exam_summary.dart';
import 'family_progress.dart';
import 'progress_snapshot.dart';
import 'stats_service.dart';
import 'time_series.dart';

/// Fetches repository rows and hands them to [StatsService]: the async face
/// of the stats service, used by the providers. Every query is an SQL
/// aggregate (one row per session/family/section, per family, per item);
/// attempts themselves are never loaded.
class ProgressAnalytics {
  const ProgressAnalytics({
    required ProgressRepository progress,
    required ContentRepository content,
    required StatsService stats,
  }) : _progress = progress,
       _content = content,
       _stats = stats;

  final ProgressRepository _progress;
  final ContentRepository _content;
  final StatsService _stats;

  StatsService get stats => _stats;

  /// The dashboard snapshot: every content family (plus any family seen in
  /// attempts but not in content), readiness, weak areas, exam history.
  Future<ProgressSnapshot> snapshot() async {
    final contentFamilies = await _content.families();
    final lifetime = {
      for (final s in await _progress.familyStats()) s.familyId: s,
    };
    final rows = await _progress.sessionFamilyStats();

    final familyIds = <String>[
      for (final f in contentFamilies) f.id,
      ...(lifetime.keys.toSet()..removeAll(contentFamilies.map((f) => f.id)))
          .toList()
        ..sort(),
    ];
    final families = [
      for (final id in familyIds)
        _stats.familyProgress(
          familyId: id,
          lifetime: lifetime[id],
          series: _stats.timeSeries(familyId: id, rows: rows),
        ),
    ];

    final exams = await _examHistory(
      rows.where((r) => r.mode == SessionMode.exam),
    );

    final lessonsRead = (await _progress.lessonsRead()).length;
    final lessonsTotal = (await _content.lessons()).length;

    final readiness = _stats.readiness(
      families: families,
      lessonsRead: lessonsRead,
      lessonsTotal: lessonsTotal,
      exams: exams,
    );
    final weakAreas = _stats.weakAreas(
      families: families,
      tags: await _tagAccuracy(),
    );
    return ProgressSnapshot(
      computedAt: _stats.now,
      families: families,
      readiness: readiness,
      weakAreas: weakAreas,
      exams: exams,
    );
  }

  /// Chart series of one family over `[from, to]` (US-071), optionally for
  /// one session mode.
  Future<TimeSeries> familyTimeSeries(
    String familyId, {
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
  }) async {
    final rows = await _progress.sessionFamilyStats(
      from: from,
      to: to,
      mode: mode,
      familyId: familyId,
    );
    return _stats.timeSeries(
      familyId: familyId,
      rows: rows,
      from: from,
      to: to,
    );
  }

  /// One [FamilyProgress] without the rest of the snapshot.
  Future<FamilyProgress> familyProgress(String familyId) async {
    final lifetime = await _progress.familyStats();
    return _stats.familyProgress(
      familyId: familyId,
      lifetime: lifetime.where((s) => s.familyId == familyId).firstOrNull,
      series: await familyTimeSeries(familyId),
    );
  }

  /// Exam simulations, newest first, with deltas against the previous one.
  Future<List<ExamSummary>> examHistory() async =>
      _examHistory(await _progress.sessionFamilyStats(mode: SessionMode.exam));

  /// The summary of one exam session (null when unknown or not an exam).
  Future<ExamSummary?> examSummary(String sessionId) async {
    final history = await examHistory();
    return history.where((e) => e.sessionId == sessionId).firstOrNull;
  }

  Future<List<ExamSummary>> _examHistory(
    Iterable<SessionFamilyStats> examRows,
  ) async {
    final sessions = await _progress.sessions(mode: SessionMode.exam);
    final blueprintIds = {
      for (final s in sessions)
        if (s.blueprintId != null) s.blueprintId!,
    };
    final blueprints = <String, ExamBlueprint>{};
    for (final id in blueprintIds) {
      final blueprint = await _content.blueprintById(id);
      if (blueprint != null) blueprints[id] = blueprint;
    }
    return _stats.examHistory(
      sessions: sessions,
      rows: examRows,
      blueprints: blueprints,
    );
  }

  Future<Map<String, TagAccuracy>> _tagAccuracy() async {
    final itemStats = await _progress.itemStats();
    if (itemStats.isEmpty) return const {};
    final items = await _content.itemsByIds(itemStats.map((s) => s.itemId));
    return StatsService.tagAccuracy(
      itemStats: itemStats,
      tagsByItem: {for (final item in items) item.id: item.tags},
    );
  }
}
