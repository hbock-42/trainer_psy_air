import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The app's own version (`AboutScreen`, US-091). `package_info_plus` reads
/// platform metadata (`pubspec.yaml`'s `version`, the build number) through
/// a plain platform channel, no Material/Cupertino dependency.
final FutureProvider<PackageInfo> packageInfoProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());
