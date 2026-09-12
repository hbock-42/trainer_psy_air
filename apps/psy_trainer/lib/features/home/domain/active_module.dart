import 'package:psy_content/psy_content.dart';

import '../../../core/repositories/model/learning.dart';
import '../../onboarding/domain/target_stage.dart';

/// Which module (PSY0/PSY1, US-101) the Learn/Train/Exam homes and the
/// dashboard currently show.
///
/// Defaults to the profile's `targetStage` (set in onboarding or "edit my
/// profile"); the `ModuleSwitch` segmented control
/// (`shared/widgets/module_switch.dart`) can override it for the app session
/// and persists that override in `UserProfile.settings['module']` (see
/// `docs/ARCHITECTURE.md`, "Data layer") so it survives a restart. PSY2 has
/// no content yet (EPIC-11): it is never a supported module here even if
/// stored as `targetStage`, and the switch/dashboard fall back to PSY0.
class ActiveModule {
  const ActiveModule({required this.moduleId, required this.available});

  /// The module every family/blueprint/dashboard query should filter by.
  final ModuleId moduleId;

  /// Modules the switch offers, in display order.
  final List<ModuleId> available;

  /// `UserProfile.settings` key of the session override.
  static const String settingsKey = 'module';

  /// Modules the app currently has content/trainer for, in display order.
  static const List<ModuleId> supportedModules = [ModuleId.psy0, ModuleId.psy1];

  static const ActiveModule defaults = ActiveModule(
    moduleId: ModuleId.psy0,
    available: supportedModules,
  );

  static ModuleId? _moduleOf(TargetStage stage) => switch (stage) {
    TargetStage.psy0 => ModuleId.psy0,
    TargetStage.psy1 => ModuleId.psy1,
    TargetStage.psy2 => null,
  };

  /// Reads the active module: the stored override in
  /// `settings['module']` when it names a supported module, otherwise the
  /// module of the profile's `targetStage`, otherwise PSY0. [defaults] for a
  /// missing profile.
  factory ActiveModule.fromProfile(UserProfile? profile) {
    final raw = profile?.settings[settingsKey];
    if (raw is String) {
      final override = ModuleId.values.where((m) => m.name == raw).firstOrNull;
      if (override != null && supportedModules.contains(override)) {
        return ActiveModule(moduleId: override, available: supportedModules);
      }
    }
    final stage = TargetStage.fromKey(
      profile?.targetStage,
      fallback: TargetStage.defaultStage,
    )!;
    final fromStage = _moduleOf(stage);
    final moduleId = fromStage != null && supportedModules.contains(fromStage)
        ? fromStage
        : ModuleId.psy0;
    return ActiveModule(moduleId: moduleId, available: supportedModules);
  }

  /// The profile to save: [existing] (if any) with [moduleId] stored as the
  /// session override. Other `settings` entries and profile fields are
  /// preserved.
  static UserProfile applyTo(UserProfile? existing, ModuleId moduleId) {
    if (existing == null) {
      return UserProfile(locale: 'fr', settings: {settingsKey: moduleId.name});
    }
    return existing.copyWith(
      settings: {...existing.settings, settingsKey: moduleId.name},
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ActiveModule &&
      other.moduleId == moduleId &&
      other.available.length == available.length &&
      other.available.every(available.contains);

  @override
  int get hashCode => Object.hash(moduleId, Object.hashAll(available));

  @override
  String toString() =>
      'ActiveModule(moduleId: $moduleId, available: $available)';
}
