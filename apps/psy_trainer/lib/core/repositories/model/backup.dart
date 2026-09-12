import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup.freezed.dart';

/// One row of a user table, exactly as the backup format (US-074) carries
/// it: its primary key [id], its `updatedAt` (the merge watermark — see
/// `docs/ARCHITECTURE.md`, "Backup format"), and every column of the row
/// (including `id`/`createdAt`/`updatedAt` again) as plain JSON in [fields].
/// Carrying the whole row rather than a typed model keeps
/// [ProgressRepository.exportSnapshot] / `importSnapshot` decoupled from the
/// feature-facing domain models (`TrainingSession`, `Attempt`...), which do
/// not expose audit timestamps; the Drift-backed implementation reads
/// [fields] straight off the generated row's own `toJson()`/`fromJson()`.
@freezed
abstract class BackupRow with _$BackupRow {
  const factory BackupRow({
    required String id,
    required DateTime updatedAt,
    required Map<String, Object?> fields,
  }) = _BackupRow;
}

/// Every user row, table by table (US-074). Content tables (`items`,
/// `lessons`...) are never part of a backup: they are re-derived from the
/// bundled assets (US-013), never user-authored.
@freezed
abstract class BackupSnapshot with _$BackupSnapshot {
  const factory BackupSnapshot({
    required List<BackupRow> sessions,
    required List<BackupRow> attempts,
    required List<BackupRow> itemStats,
    required List<BackupRow> flashcardReviews,
    required List<BackupRow> lessonProgress,

    /// Null when onboarding has not created a profile yet.
    BackupRow? profile,
  }) = _BackupSnapshot;
}

/// What changed after [ProgressRepository.importSnapshot] merged a
/// [BackupSnapshot] into local storage.
@freezed
abstract class BackupImportSummary with _$BackupImportSummary {
  const factory BackupImportSummary({
    required int inserted,
    required int updated,
    required int skipped,
  }) = _BackupImportSummary;

  const BackupImportSummary._();

  int get total => inserted + updated + skipped;
}
