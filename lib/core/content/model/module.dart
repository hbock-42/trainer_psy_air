import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'module.freezed.dart';
part 'module.g.dart';

/// A selection stage (`psy0`, `psy1`, `psy2`). File:
/// `assets/content/<module>/module.json` (`family.schema.json#/$defs/Module`).
@freezed
abstract class Module with _$Module {
  const factory Module({
    required ModuleId id,
    required int version,
    required int order,
    required LocalizedText name,
    required LocalizedText description,
    required List<String> familyIds,
    String? defaultBlueprintId,
    @Default(ContentStatus.published) ContentStatus status,
  }) = _Module;

  factory Module.fromJson(Map<String, Object?> json) => _$ModuleFromJson(json);
}
