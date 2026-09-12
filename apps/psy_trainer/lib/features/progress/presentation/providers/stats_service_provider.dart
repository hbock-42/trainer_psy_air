import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stats_config.dart';
import '../../domain/stats_service.dart';

/// The single [StatsConfig] of the app; override in tests to tune weights.
final Provider<StatsConfig> statsConfigProvider = Provider<StatsConfig>(
  (ref) => const StatsConfig(),
);

/// The pure stats service, with the real clock. Tests override it with a
/// fixed `now`.
final Provider<StatsService> statsServiceProvider = Provider<StatsService>(
  (ref) => StatsService(config: ref.watch(statsConfigProvider)),
);
