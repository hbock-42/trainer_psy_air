import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repositories.dart';
import '../../domain/backup_service.dart';
import 'package_info_provider.dart';

/// The backup export/import service (US-074), stamped with the app's own
/// version (`package_info_plus`, same source as the About screen).
final Provider<BackupService> backupServiceProvider = Provider<BackupService>((
  ref,
) {
  final version = ref.watch(packageInfoProvider).value?.version;
  return BackupService(
    ref.watch(progressRepositoryProvider),
    appName: 'psy_trainer',
    appVersion: version ?? 'unknown',
  );
});
