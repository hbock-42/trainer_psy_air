import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/content/content.dart';
import '../../../../core/repositories/repository_providers.dart';

/// The PSY0 test families in real-test order (`TestFamily.order`), as seeded
/// in the content repository. Empty until the bundle is seeded (US-013).
final FutureProvider<List<TestFamily>> psy0FamiliesProvider =
    FutureProvider<List<TestFamily>>(
      (ref) => ref
          .watch(contentRepositoryProvider)
          .families(moduleId: ModuleId.psy0),
    );
