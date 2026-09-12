import 'package:flutter_riverpod/misc.dart';
import 'package:psy_trainer/core/db/seed/content_ready_provider.dart';
import 'package:psy_trainer/core/db/seed/content_seeder.dart';

/// Riverpod override resolving [contentReadyProvider] immediately, for tests
/// that pump the whole app over in-memory repositories (no database, no
/// asset bundle to seed from). Pair it with `progressRepositoryOverride()`.
Override contentReadyOverride({int contentVersion = 1}) => contentReadyProvider
    .overrideWith((ref) async => SeedResult.upToDate(contentVersion));
