import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'
    show HashUrlStrategy, setUrlStrategy;
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

import 'app.dart';
import 'core/errors/error_logger.dart';

void main() {
  // Everything (including the binding initialisation) runs inside the guarded
  // zone so asynchronous errors thrown from any callback are logged instead of
  // silently killing the isolate.
  runZonedGuarded<void>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      installGlobalErrorHandlers();
      // US-124: hash URL strategy so deep links survive a reload when the
      // web build is served from a GitHub Pages sub-path with no
      // server-side SPA rewrite. No-op on non-web platforms.
      setUrlStrategy(const HashUrlStrategy());
      // Loads `intl`'s date symbols/patterns for every supported locale
      // (US-091: `l10n_extensions.dart`'s `DateFormat` calls need this for
      // 'fr', not bundled by default like 'en').
      await initializeDateFormatting();
      runApp(const ProviderScope(child: PsyTrainerApp()));
    },
    (Object error, StackTrace stack) => logError(error, stack, context: 'zone'),
  );
}
