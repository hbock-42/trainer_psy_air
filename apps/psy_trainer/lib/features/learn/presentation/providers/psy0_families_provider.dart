import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../home/presentation/providers/active_module_provider.dart';

/// The active module's test families in real-test order
/// (`TestFamily.order`), as seeded in the content repository. Empty until
/// the bundle is seeded (US-013). Filtered by `activeModuleProvider`
/// (US-101 module switch): PSY0 by default, PSY1 once selected.
final FutureProvider<List<TestFamily>> psy0FamiliesProvider =
    FutureProvider<List<TestFamily>>(
      (ref) => ref
          .watch(contentRepositoryProvider)
          .families(moduleId: ref.watch(activeModuleProvider).moduleId),
    );
