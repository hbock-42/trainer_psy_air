import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'content_manifest.freezed.dart';
part 'content_manifest.g.dart';

/// `assets/content/manifest.json`: the single place where the bundled content
/// is versioned (`manifest.schema.json`).
@freezed
abstract class ContentManifest with _$ContentManifest {
  const factory ContentManifest({
    required int schemaVersion,
    required int contentVersion,
    @DateOnlyConverter() required DateTime updatedAt,
    required List<ModuleId> modules,
    @Default(<ChangelogEntry>[]) List<ChangelogEntry> changelog,
  }) = _ContentManifest;

  factory ContentManifest.fromJson(Map<String, Object?> json) =>
      _$ContentManifestFromJson(json);
}

/// One line of the manifest changelog (newest first).
@freezed
abstract class ChangelogEntry with _$ChangelogEntry {
  const factory ChangelogEntry({
    required int contentVersion,
    @DateOnlyConverter() required DateTime date,
    required String summary,
  }) = _ChangelogEntry;

  factory ChangelogEntry.fromJson(Map<String, Object?> json) =>
      _$ChangelogEntryFromJson(json);
}
