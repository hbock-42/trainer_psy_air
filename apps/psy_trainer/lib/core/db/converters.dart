import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a JSON object in a `TEXT` column.
///
/// Used for every "blob" column (content mirrors, session config, attempt
/// answers/origins, profile settings) so the schema does not have to change
/// when the content contract (US-010/US-015) or an engine's answer shape does.
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) =>
      jsonDecode(fromDb) as Map<String, Object?>;

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}
