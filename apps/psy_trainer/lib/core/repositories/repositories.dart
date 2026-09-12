/// Data access for features (US-012): repository interfaces, their domain
/// models, Riverpod providers and in-memory fakes. Pure Dart apart from the
/// providers; nothing here imports Drift.
library;

export 'content_repository.dart';
export 'in_memory/in_memory_content_repository.dart';
export 'in_memory/in_memory_progress_repository.dart';
export 'model/attempt.dart';
export 'model/backup.dart';
export 'model/learning.dart';
export 'model/session.dart';
export 'model/stats.dart';
export 'progress_repository.dart';
export 'repository_providers.dart';
