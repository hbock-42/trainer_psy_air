import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/errors/error_logger.dart';

void main() {
  // Everything (including the binding initialisation) runs inside the guarded
  // zone so asynchronous errors thrown from any callback are logged instead of
  // silently killing the isolate.
  runZonedGuarded<void>(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      installGlobalErrorHandlers();
      runApp(const ProviderScope(child: PsyTrainerApp()));
    },
    (Object error, StackTrace stack) => logError(error, stack, context: 'zone'),
  );
}
