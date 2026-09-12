import 'dart:convert';

import '../../../core/repositories/model/backup.dart';
import '../../../core/repositories/progress_repository.dart';

/// Why [BackupService.parseSnapshot] rejected a document. The presentation
/// layer maps each reason to a localized message (never a literal string in
/// `domain/`).
enum BackupErrorReason {
  invalidJson,
  notAnObject,
  wrongFormat,
  unsupportedVersion,
  missingData,
  invalidRow,
}

/// Thrown by [BackupService.parseSnapshot] / [BackupService.importJson] when
/// the document is not a valid backup.
class BackupFormatException implements Exception {
  const BackupFormatException(this.reason, {this.detail});

  final BackupErrorReason reason;

  /// Extra, non-localized detail for logs (e.g. the JSON parser's message);
  /// never shown to the user directly.
  final String? detail;

  @override
  String toString() =>
      'BackupFormatException(${reason.name}${detail == null ? '' : ': $detail'})';
}

/// Export/import of the user's whole progress as a single versioned JSON
/// document (US-074) — see `docs/ARCHITECTURE.md`, "Backup format", for the
/// exact shape (this is also the contract a future remote sync, EPIC-13,
/// must carry). Pure Dart: [ProgressRepository] does the actual reading and
/// writing (and the merge-by-id semantics), this class only shapes and
/// validates the envelope.
class BackupService {
  BackupService(
    this._repository, {
    required this.appName,
    required this.appVersion,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// `data.format`: identifies the document as ours (rejects an unrelated
  /// JSON file dropped into the import field).
  static const String format = 'psy-trainer-backup';

  /// Current envelope version. A document with a higher version is refused
  /// (an older app cannot know what it means); a lower version is accepted
  /// as-is — nothing has changed shape yet.
  static const int version = 1;

  final ProgressRepository _repository;
  final DateTime Function() _clock;
  final String appName;
  final String appVersion;

  /// The full backup, pretty-printed JSON.
  Future<String> exportJson() async {
    final snapshot = await _repository.exportSnapshot();
    final doc = <String, Object?>{
      'format': format,
      'version': version,
      'exportedAt': _clock().toUtc().toIso8601String(),
      'app': {'name': appName, 'version': appVersion},
      'data': {
        'sessions': [for (final r in snapshot.sessions) _rowToJson(r)],
        'attempts': [for (final r in snapshot.attempts) _rowToJson(r)],
        'itemStats': [for (final r in snapshot.itemStats) _rowToJson(r)],
        'flashcardReviews': [
          for (final r in snapshot.flashcardReviews) _rowToJson(r),
        ],
        'lessonProgress': [
          for (final r in snapshot.lessonProgress) _rowToJson(r),
        ],
        'profile': snapshot.profile == null
            ? null
            : _rowToJson(snapshot.profile!),
      },
    };
    return const JsonEncoder.withIndent('  ').convert(doc);
  }

  /// Parses, validates and merges [raw] into local storage. Throws
  /// [BackupFormatException] before touching anything when the document is
  /// not a valid backup.
  Future<BackupImportSummary> importJson(String raw) =>
      _repository.importSnapshot(parseSnapshot(raw));

  /// Parses and validates [raw] without importing it (used to fail fast, or
  /// to preview, before the merge runs).
  static BackupSnapshot parseSnapshot(String raw) {
    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (e) {
      throw BackupFormatException(
        BackupErrorReason.invalidJson,
        detail: e.message,
      );
    }
    if (decoded is! Map) {
      throw const BackupFormatException(BackupErrorReason.notAnObject);
    }
    final map = decoded.cast<String, Object?>();
    if (map['format'] != format) {
      throw const BackupFormatException(BackupErrorReason.wrongFormat);
    }
    final docVersion = map['version'];
    if (docVersion is! int || docVersion > version || docVersion < 1) {
      throw const BackupFormatException(BackupErrorReason.unsupportedVersion);
    }
    final data = map['data'];
    if (data is! Map) {
      throw const BackupFormatException(BackupErrorReason.missingData);
    }
    final d = data.cast<String, Object?>();
    return BackupSnapshot(
      sessions: _rows(d['sessions']),
      attempts: _rows(d['attempts']),
      itemStats: _rows(d['itemStats']),
      flashcardReviews: _rows(d['flashcardReviews']),
      lessonProgress: _rows(d['lessonProgress']),
      profile: d['profile'] == null ? null : _row(d['profile']),
    );
  }

  static Map<String, Object?> _rowToJson(BackupRow row) => {
    'id': row.id,
    'updatedAt': row.updatedAt.toIso8601String(),
    'fields': row.fields,
  };

  static List<BackupRow> _rows(Object? raw) {
    if (raw == null) return const [];
    if (raw is! List) {
      throw const BackupFormatException(BackupErrorReason.invalidRow);
    }
    return [for (final item in raw) _row(item)];
  }

  static BackupRow _row(Object? raw) {
    if (raw is! Map) {
      throw const BackupFormatException(BackupErrorReason.invalidRow);
    }
    final map = raw.cast<String, Object?>();
    final id = map['id'];
    final updatedAt = map['updatedAt'];
    final fields = map['fields'];
    if (id is! String || updatedAt is! String || fields is! Map) {
      throw const BackupFormatException(BackupErrorReason.invalidRow);
    }
    DateTime parsedUpdatedAt;
    try {
      parsedUpdatedAt = DateTime.parse(updatedAt);
    } on FormatException {
      throw const BackupFormatException(BackupErrorReason.invalidRow);
    }
    return BackupRow(
      id: id,
      updatedAt: parsedUpdatedAt,
      fields: fields.cast<String, Object?>(),
    );
  }
}
