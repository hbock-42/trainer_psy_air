import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../../../core/repositories/repository_providers.dart';
import '../../../progress/presentation/providers/progress_version_provider.dart';

/// Whether one lesson has been marked read (US-044): scrolled to the end,
/// after 20 s on a short lesson, or through the lesson screen's manual
/// toggle.
///
/// Watches [progressVersionProvider] so marking a lesson read recomputes
/// this (and every other lesson-progress provider) once.
final FutureProviderFamily<bool, String> lessonReadProvider =
    FutureProvider.family<bool, String>((ref, lessonId) async {
      ref.watch(progressVersionProvider);
      final reads = await ref.read(progressRepositoryProvider).lessonsRead();
      return reads.any((r) => r.lessonId == lessonId);
    });
