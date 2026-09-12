import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../domain/viewpoint_explanation.dart';
import '../domain/viewpoint_geometry.dart';
import '../domain/viewpoint_scene.dart';
import 'viewpoint_scene_painter.dart';

/// The widget half of `spatial_viewpoint` (US-034): renders the scene from
/// its hidden azimuth with [ViewpointScenePainter] and answers with a
/// top-down map of the 8 numbered viewpoints. A tap answers directly in
/// practice (matching the real test); exam mode selects then requires
/// "Valider" (the runtime's practice/exam policy, see `McqRenderer`).
class ViewpointRenderer extends ActivityRenderer {
  const ViewpointRenderer();

  @override
  String get familyId => 'spatial_viewpoint';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _ViewpointView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      const _ViewpointExample();
}

class _ViewpointView extends StatefulWidget {
  const _ViewpointView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_ViewpointView> createState() => _ViewpointViewState();
}

class _ViewpointViewState extends State<_ViewpointView> {
  final FocusNode _focusNode = FocusNode();
  int? _selected;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  ViewpointScene get _scene {
    final item = widget.render.item as GeneratedItem;
    return buildViewpointScene(
      seed: item.seed,
      params: item.params as ViewpointParams,
      difficulty: item.difficulty,
    );
  }

  bool get _isExam => widget.render.isExam;
  bool get _answered => widget.render.feedback != null;
  bool get _acceptsInput => widget.render.acceptsInput;

  void _choose(int azimuth) {
    if (!_acceptsInput) return;
    setState(() => _selected = azimuth);
    if (!_isExam) {
      widget.render.onAnswer(Answer.choice(azimuth - 1));
    }
  }

  void _validate() {
    final selected = _selected;
    if (!_acceptsInput || selected == null) return;
    widget.render.onAnswer(Answer.choice(selected - 1));
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final azimuth = _azimuthOf(event.logicalKey);
    if (azimuth != null) {
      _choose(azimuth);
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _validate();
    }
  }

  static int? _azimuthOf(LogicalKeyboardKey key) {
    const digits = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
    ];
    final index = digits.indexOf(key);
    if (index != -1) return index + 1;
    const numpad = [
      LogicalKeyboardKey.numpad1,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpad3,
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.numpad6,
      LogicalKeyboardKey.numpad7,
      LogicalKeyboardKey.numpad8,
    ];
    final numpadIndex = numpad.indexOf(key);
    return numpadIndex == -1 ? null : numpadIndex + 1;
  }

  _MapPositionState _stateFor(int azimuth) {
    if (_answered) {
      final correct = _scene.correctAzimuth;
      if (azimuth == correct) return _MapPositionState.correct;
      if (azimuth == _selected) return _MapPositionState.wrong;
      return _MapPositionState.disabled;
    }
    return azimuth == _selected
        ? _MapPositionState.selected
        : _MapPositionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final scene = _scene;
    final answered = _answered;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 160,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colors.surfaceRaised,
                        borderRadius: theme.radii.mdAll,
                        border: Border.all(color: theme.colors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: theme.radii.mdAll,
                        child: CustomPaint(
                          painter: ViewpointScenePainter(
                            objects: scene.objects,
                            azimuth: scene.correctAzimuth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: theme.spacing.lg),
                  Center(
                    child: _ViewpointMap(
                      stateFor: _stateFor,
                      onSelect: _choose,
                      interactive: !answered,
                    ),
                  ),
                  if (answered) ...[
                    SizedBox(height: theme.spacing.lg),
                    _Explanation(text: explanationFor(scene)),
                  ],
                ],
              ),
            ),
          ),
          if (_isExam && !answered) ...[
            SizedBox(height: theme.spacing.md),
            PrimaryButton(
              key: const ValueKey('viewpoint_validate'),
              label: context.l10n.activityValidate,
              expand: true,
              onPressed: _selected == null ? null : _validate,
            ),
          ],
        ],
      ),
    );
  }
}

enum _MapPositionState { idle, selected, correct, wrong, disabled }

/// The top-down answer map: 8 positions on a circle, numbered 1 (north)
/// clockwise (lesson convention), around a small hub marking the scene.
class _ViewpointMap extends StatelessWidget {
  const _ViewpointMap({
    required this.stateFor,
    required this.onSelect,
    required this.interactive,
  });

  final _MapPositionState Function(int azimuth) stateFor;
  final ValueChanged<int> onSelect;
  final bool interactive;

  static const double _mapSize = 180;
  static const double _markerSize = 36;
  static const double _radius = _mapSize / 2 - _markerSize / 2;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Semantics(
      label: context.l10n.viewpointMapSemanticsLabel,
      child: SizedBox(
        width: _mapSize,
        height: _mapSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _mapSize - _markerSize,
              height: _mapSize - _markerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colors.surface,
                border: Border.all(color: theme.colors.border),
              ),
            ),
            for (var azimuth = 1; azimuth <= 8; azimuth++) _positioned(azimuth),
          ],
        ),
      ),
    );
  }

  Widget _positioned(int azimuth) {
    final theta = azimuthAngleRad(azimuth);
    final dx = _radius * math.sin(theta);
    final dy = -_radius * math.cos(theta);
    return Positioned(
      left: _mapSize / 2 + dx - _markerSize / 2,
      top: _mapSize / 2 + dy - _markerSize / 2,
      width: _markerSize,
      height: _markerSize,
      child: _MapPositionMarker(
        azimuth: azimuth,
        state: stateFor(azimuth),
        onPressed: interactive ? () => onSelect(azimuth) : null,
      ),
    );
  }
}

/// One numbered, tappable position of [_ViewpointMap].
class _MapPositionMarker extends StatelessWidget {
  const _MapPositionMarker({
    required this.azimuth,
    required this.state,
    required this.onPressed,
  });

  final int azimuth;
  final _MapPositionState state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final (background, border, foreground) = switch (state) {
      _MapPositionState.idle => (
        colors.surface,
        colors.borderStrong,
        colors.textPrimary,
      ),
      _MapPositionState.selected => (
        colors.accentSubtle,
        colors.accent,
        colors.textPrimary,
      ),
      _MapPositionState.correct => (
        colors.successSubtle,
        colors.success,
        colors.textPrimary,
      ),
      _MapPositionState.wrong => (
        colors.errorSubtle,
        colors.error,
        colors.textPrimary,
      ),
      _MapPositionState.disabled => (
        colors.surface.disabledOn(theme),
        colors.border,
        colors.textMuted,
      ),
    };

    return AppPressable(
      key: ValueKey('viewpoint_position_$azimuth'),
      onPressed: onPressed,
      semanticsLabel: context.l10n.viewpointPositionSemantics(azimuth),
      excludeSemantics: true,
      selected: state == _MapPositionState.selected,
      minSize: 40,
      builder: (context, pressState) {
        var fill = background;
        final edge = border;
        if (pressState.pressed) fill = colors.accentSubtle;
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill,
            border: Border.all(color: edge, width: 2),
          ),
          child: Center(
            child: Text(
              '$azimuth',
              style: theme.textStyles.label.copyWith(color: foreground),
            ),
          ),
        );
      },
    );
  }
}

class _Explanation extends StatelessWidget {
  const _Explanation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.activityExplanationTitle,
            style: theme.textStyles.label,
          ),
          SizedBox(height: theme.spacing.xs),
          Text(text, style: theme.textStyles.body),
        ],
      ),
    );
  }
}

/// Static, non-interactive illustration for the briefing screen.
class _ViewpointExample extends StatelessWidget {
  const _ViewpointExample();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.viewpointExampleCaption,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.md),
        const SizedBox(
          height: 120,
          child: CustomPaint(
            painter: ViewpointScenePainter(
              objects: [
                ViewpointObject(
                  gx: 1,
                  gy: 1,
                  kind: SolidKind.cube,
                  colorIndex: 0,
                ),
                ViewpointObject(
                  gx: -1,
                  gy: -1,
                  kind: SolidKind.cylinder,
                  colorIndex: 1,
                ),
                ViewpointObject(
                  gx: 0,
                  gy: -2,
                  kind: SolidKind.cone,
                  colorIndex: 2,
                ),
              ],
              azimuth: 3,
            ),
          ),
        ),
      ],
    );
  }
}
