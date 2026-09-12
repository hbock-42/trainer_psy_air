import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

import 'app.dart';
import 'core/errors/error_logger.dart';
import 'core/router/url_strategy.dart';

void main() {
  // Everything (including the binding initialisation) runs inside the guarded
  // zone so asynchronous errors thrown from any callback are logged instead of
  // silently killing the isolate.
  runZonedGuarded<void>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    installGlobalErrorHandlers();
    // US-124: hash URL strategy on the web (see core/router/url_strategy.dart).
    configureUrlStrategy();
    // Loads `intl`'s date symbols/patterns for every supported locale
    // (US-091: `l10n_extensions.dart`'s `DateFormat` calls need this for
    // 'fr', not bundled by default like 'en').
    await initializeDateFormatting();
    runApp(const ProviderScope(child: PsyTrainerApp()));
  }, (Object error, StackTrace stack) => logError(error, stack, context: 'zone'));
}
