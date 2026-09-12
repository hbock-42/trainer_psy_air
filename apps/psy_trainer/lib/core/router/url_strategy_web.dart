import 'package:flutter_web_plugins/url_strategy.dart';

/// Hash URLs (`/#/learn/…`) so deep links survive a reload when the build
/// is served from a GitHub Pages sub-path with no server-side SPA rewrite
/// (US-124).
void configureUrlStrategy() => setUrlStrategy(const HashUrlStrategy());
