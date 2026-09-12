import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repository_providers.dart';

/// One test family by id, or null when the id is unknown (bad deep link,
/// content not seeded yet).
final FutureProviderFamily<TestFamily?, String> familyProvider =
    FutureProvider.family<TestFamily?, String>(
      (ref, familyId) =>
          ref.watch(contentRepositoryProvider).familyById(familyId),
    );
