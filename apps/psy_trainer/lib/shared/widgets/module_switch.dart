import 'package:flutter/widgets.dart';
import 'package:psy_content/psy_content.dart';

import '../../core/l10n/l10n_extensions.dart';
import 'segmented_choice.dart';

/// US-101: the PSY0/PSY1 segmented control shown at the top of the Learn,
/// Train and Exam homes. Overrides `activeModuleProvider` for the session;
/// each screen wires [selected]/[onSelected] to that provider.
///
/// Hidden when [available] has fewer than two entries (nothing to switch
/// between yet, e.g. before PSY1 was enabled for the profile).
class ModuleSwitch extends StatelessWidget {
  const ModuleSwitch({
    required this.available,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<ModuleId> available;
  final ModuleId selected;
  final ValueChanged<ModuleId> onSelected;

  static String _label(BuildContext context, ModuleId moduleId) =>
      switch (moduleId) {
        ModuleId.psy0 => context.l10n.moduleSwitchPsy0,
        ModuleId.psy1 => context.l10n.moduleSwitchPsy1,
        ModuleId.psy2 => context.l10n.moduleSwitchPsy2,
      };

  @override
  Widget build(BuildContext context) {
    if (available.length < 2) return const SizedBox.shrink();
    return SegmentedChoice<ModuleId>(
      key: const Key('module_switch'),
      semanticsLabel: context.l10n.moduleSwitchSemanticsLabel,
      selected: selected,
      onSelected: onSelected,
      options: [
        for (final moduleId in available)
          SegmentedOption(value: moduleId, label: _label(context, moduleId)),
      ],
    );
  }
}
