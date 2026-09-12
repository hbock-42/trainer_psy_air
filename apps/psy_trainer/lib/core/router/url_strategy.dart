// Web-only URL strategy behind a conditional import: `flutter_web_plugins`
// pulls in `dart:ui_web`, which does not exist on mobile/desktop, so the
// real implementation is only compiled for the web target.
export 'url_strategy_stub.dart'
    if (dart.library.js_interop) 'url_strategy_web.dart';
