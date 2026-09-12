/// The widget half of the activity runtime (US-020): renderer contract and
/// registry, the Riverpod controller and the `SessionHost` widget. The
/// practice screen (US-051), the exam runner (US-061) and every engine's
/// renderer import this barrel; the pure-Dart half is
/// `features/train/domain/engine/engine.dart`.
library;

export '../../domain/engine/engine.dart';
export 'activity_renderer.dart';
export 'activity_session_controller.dart';
export 'engine_registry_provider.dart';
export 'session_host.dart';
