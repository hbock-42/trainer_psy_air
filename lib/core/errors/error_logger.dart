import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Central sink for uncaught errors.
///
/// Every global hook in `main.dart` (framework errors, platform dispatcher
/// errors, uncaught zone errors) ends up here so that swapping the backend
/// later (crash reporting, file logging) is a one-line change.
///
/// Uses `dart:developer` `log` rather than `print`: it carries the error and
/// stack trace as structured fields and shows up in DevTools / `flutter run`
/// output without polluting release stdout.
void logError(
  Object error,
  StackTrace? stackTrace, {
  String context = 'uncaught',
}) {
  developer.log(
    'Unhandled error ($context): $error',
    name: 'psy_trainer',
    level: 1000, // SEVERE
    error: error,
    stackTrace: stackTrace,
  );
}

/// Wires the global error hooks.
///
/// - [FlutterError.onError]: errors caught by the framework (build, layout,
///   paint, gesture callbacks). The previous handler is kept so the red screen
///   and console dump still show up in debug builds.
/// - [PlatformDispatcher.onError]: errors escaping to the engine (asynchronous
///   errors outside a zone). Returning `true` marks them as handled.
///
/// Zone errors are caught by `runZonedGuarded` in `main.dart`, which also
/// calls [logError].
void installGlobalErrorHandlers() {
  final FlutterExceptionHandler? previous = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    previous?.call(details);
    logError(details.exception, details.stack, context: 'flutter');
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logError(error, stack, context: 'platform');
    return true;
  };
}
