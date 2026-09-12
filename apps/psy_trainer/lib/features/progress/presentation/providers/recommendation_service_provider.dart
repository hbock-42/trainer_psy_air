import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/recommendation_service.dart';
import 'stats_service_provider.dart';

/// The pure recommendation service (US-072), sharing [statsConfigProvider]'s
/// config and [statsServiceProvider]'s clock, so both agree on "now" (tests
/// override [statsServiceProvider] with a fixed one).
final Provider<RecommendationService> recommendationServiceProvider =
    Provider<RecommendationService>(
      (ref) => RecommendationService(
        config: ref.watch(statsConfigProvider),
        now: () => ref.watch(statsServiceProvider).now,
      ),
    );
