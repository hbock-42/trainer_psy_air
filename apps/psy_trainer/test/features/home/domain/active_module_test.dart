import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/model/learning.dart';
import 'package:psy_trainer/features/home/domain/active_module.dart';

void main() {
  group('ActiveModule.fromProfile', () {
    test('defaults to PSY0 for a missing profile', () {
      final active = ActiveModule.fromProfile(null);
      expect(active.moduleId, ModuleId.psy0);
      expect(active.available, [ModuleId.psy0, ModuleId.psy1]);
    });

    test('follows targetStage when no override is stored', () {
      const profile = UserProfile(locale: 'fr', targetStage: 'psy1');
      expect(ActiveModule.fromProfile(profile).moduleId, ModuleId.psy1);
    });

    test('PSY2 targetStage falls back to PSY0 (no PSY2 content yet)', () {
      const profile = UserProfile(locale: 'fr', targetStage: 'psy2');
      expect(ActiveModule.fromProfile(profile).moduleId, ModuleId.psy0);
    });

    test('a stored override wins over targetStage', () {
      const profile = UserProfile(
        locale: 'fr',
        targetStage: 'psy0',
        settings: {'module': 'psy1'},
      );
      expect(ActiveModule.fromProfile(profile).moduleId, ModuleId.psy1);
    });

    test('an unsupported override falls back to targetStage', () {
      const profile = UserProfile(
        locale: 'fr',
        targetStage: 'psy0',
        settings: {'module': 'psy2'},
      );
      expect(ActiveModule.fromProfile(profile).moduleId, ModuleId.psy0);
    });
  });

  group('ActiveModule.applyTo', () {
    test('creates a profile when none exists', () {
      final profile = ActiveModule.applyTo(null, ModuleId.psy1);
      expect(profile.settings['module'], 'psy1');
      expect(profile.locale, 'fr');
    });

    test('preserves every other field and setting', () {
      const existing = UserProfile(
        locale: 'en',
        targetStage: 'psy0',
        settings: {'goal': 'x'},
      );
      final updated = ActiveModule.applyTo(existing, ModuleId.psy1);
      expect(updated.locale, 'en');
      expect(updated.targetStage, 'psy0');
      expect(updated.settings['goal'], 'x');
      expect(updated.settings['module'], 'psy1');
    });
  });
}
