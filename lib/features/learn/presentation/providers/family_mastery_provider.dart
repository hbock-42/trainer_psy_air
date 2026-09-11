import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Mastery of one family as a ratio in `[0, 1]`, or null when nothing is
/// known yet (no attempt, stats not computed).
///
/// Placeholder until the stats service exists: always null, which the family
/// card renders as "—". US-075 / US-070 override this provider with the real
/// computation (accuracy and speed over recent practice sessions) without
/// touching the learn screens; keep the value shape (nullable ratio) stable.
final FutureProviderFamily<double?, String> familyMasteryProvider =
    FutureProvider.family<double?, String>((ref, familyId) async => null);
