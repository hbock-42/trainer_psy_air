import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/errors/error_logger.dart';

void main() {
  test('installGlobalErrorHandlers chains the previous FlutterError handler '
      'and marks platform errors as handled', () {
    final FlutterExceptionHandler? original = FlutterError.onError;
    final originalPlatform = PlatformDispatcher.instance.onError;
    addTearDown(() {
      FlutterError.onError = original;
      PlatformDispatcher.instance.onError = originalPlatform;
    });

    final List<FlutterErrorDetails> received = [];
    FlutterError.onError = received.add;

    installGlobalErrorHandlers();

    final FlutterErrorDetails details = FlutterErrorDetails(
      exception: StateError('boom'),
    );
    FlutterError.onError!(details);
    expect(received, [details]);

    expect(
      PlatformDispatcher.instance.onError!(
        StateError('async boom'),
        StackTrace.current,
      ),
      isTrue,
    );
  });
}
