import 'package:drift/drift.dart';

/// Columns shared by every table: a text primary key (a uuid v4 for user data,
/// the content id for content mirrors) and audit timestamps. `updatedAt` is
/// the future sync watermark (EPIC-13); nothing reads it today.
///
/// Datetimes are stored as ISO-8601 text (see `AppDatabase.options`) and are
/// always written in UTC so that string comparison in SQL orders correctly.
mixin AuditedTable on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
