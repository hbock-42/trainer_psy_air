import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../../../core/content/content.dart';
import '../../../../core/repositories/repository_providers.dart';

/// Published lessons of one family, in bundle order. The family page lists
/// their titles; US-041 opens them in the lesson viewer.
final FutureProviderFamily<List<Lesson>, String> familyLessonsProvider =
    FutureProvider.family<List<Lesson>, String>(
      (ref, familyId) =>
          ref.watch(contentRepositoryProvider).lessons(familyId: familyId),
    );
