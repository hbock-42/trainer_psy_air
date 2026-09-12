import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:psy_content/psy_content.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../domain/airways_engine.dart';
import '../domain/airways_simulation.dart';
import 'airways_painter.dart';

/// Airways renderer (spec §2.4-H, US-032): one item is one ~30 s series.
///
/// The scene is driven by a widget-layer `Ticker` (created once per item,
/// via `_AirwaysViewState`), not by the runtime's cadence: it advances the
/// engine-owned [AirwaysSimulation] every frame and submits
/// `Answer.raw({violations, reroutes, survivedMs})` itself the instant the
/// simulation clock reaches `AirwaysParams.durationSec` -- the runtime's own
/// per-item timer (`family.json`/blueprint `perItemTimeSec: 30`, exactly
/// equal to the default `durationSec`) is only a safety net for a session
/// that never got a chance to submit (see the class doc of
/// `AirwaysEngine` and this story's final report for the "no margin"
/// mismatch worth tightening in content).
class AirwaysRenderer extends ActivityRenderer {
  const AirwaysRenderer();

  @override
  String get familyId => AirwaysEngine.engineFamilyId;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    final params = item.params as AirwaysParams;
    return _AirwaysView(
      key: ValueKey(item.id),
      render: render,
      seed: item.seed,
      params: params,
      difficulty: item.difficulty,
    );
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final runParams = run?.params;
    final params = runParams is AirwaysParams
        ? runParams
        : const AirwaysParams();
    return _AirwaysExample(params: params);
  }
}

class _AirwaysExample extends StatelessWidget {
  const _AirwaysExample({required this.params});

  final AirwaysParams params;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.airwaysExampleCapacity(
            params.capacity,
            params.blueCapacity,
          ),
          style: theme.textStyles.bodyStrong,
        ),
        SizedBox(height: theme.spacing.sm),
        Text(AppStrings.airwaysExampleBody, style: theme.textStyles.body),
        SizedBox(height: theme.spacing.md),
        Text(
          AppStrings.airwaysExampleLegendTitle,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.xs),
        Wrap(
          spacing: theme.spacing.sm,
          runSpacing: theme.spacing.xs,
          children: [
            for (final (i, color) in airwaysRouteColors.indexed)
              _RouteLegendChip(
                color: color,
                label: AppStrings.airwaysExampleButtonLabel(i + 1),
              ),
          ],
        ),
      ],
    );
  }
}

class _RouteLegendChip extends StatelessWidget {
  const _RouteLegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: theme.spacing.xs),
        Text(label, style: theme.textStyles.caption),
      ],
    );
  }
}

class _AirwaysView extends StatefulWidget {
  const _AirwaysView({
    required this.render,
    required this.seed,
    required this.params,
    required this.difficulty,
    super.key,
  });

  final ActivityRenderContext render;
  final int seed;
  final AirwaysParams params;
  final int difficulty;

  @override
  State<_AirwaysView> createState() => _AirwaysViewState();
}

class _AirwaysViewState extends State<_AirwaysView>
    with SingleTickerProviderStateMixin {
  late final AirwaysSimulation _sim = AirwaysSimulation(
    params: widget.params,
    difficulty: widget.difficulty,
    seed: widget.seed,
  );
  late final Ticker _ticker;
  final FocusNode _focusNode = FocusNode(debugLabel: 'attention_airways');

  int _lastElapsedMs = 0;
  int _flashUntilMs = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    if (widget.render.acceptsInput) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final deltaMs = elapsed.inMilliseconds - _lastElapsedMs;
    _lastElapsedMs = elapsed.inMilliseconds;
    if (deltaMs <= 0 || _submitted) return;
    _sim.advance(deltaMs);
    if (_sim.lastViolationZones.isNotEmpty) {
      _flashUntilMs = elapsed.inMilliseconds + 500;
    }
    if (_sim.isComplete && !_submitted) {
      _submitted = true;
      _ticker.stop();
      widget.render.onAnswer(
        Answer.raw({
          'violations': _sim.violations,
          'reroutes': _sim.reroutesUsed,
          'survivedMs': _sim.elapsedMs,
        }),
      );
    }
    setState(() {});
  }

  void _reroute(int routeId) {
    if (!widget.render.acceptsInput) return;
    if (_sim.reroute(routeId)) setState(() {});
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!widget.render.acceptsInput) return KeyEventResult.ignored;
    final routeId = _digitRouteId(event.logicalKey);
    if (routeId == null || routeId >= _sim.routeCount) {
      return KeyEventResult.ignored;
    }
    _reroute(routeId);
    return KeyEventResult.handled;
  }

  int? _digitRouteId(LogicalKeyboardKey key) => switch (key) {
    LogicalKeyboardKey.digit1 => 0,
    LogicalKeyboardKey.digit2 => 1,
    LogicalKeyboardKey.digit3 => 2,
    LogicalKeyboardKey.digit4 => 3,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final flashing = _lastElapsedMs < _flashUntilMs;
    final zoneFlashSet = flashing ? _sim.lastViolationZones.toSet() : <int>{};

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                AppStrings.airwaysReroutesCounter(_sim.reroutesUsed),
                style: theme.textStyles.caption,
              ),
              SizedBox(width: theme.spacing.md),
              Text(
                AppStrings.airwaysViolationsCounter(_sim.violations),
                style: theme.textStyles.caption.copyWith(
                  color: _sim.violations == 0
                      ? theme.colors.textSecondary
                      : theme.colors.error,
                ),
              ),
              const Spacer(),
              if (flashing)
                Text(
                  AppStrings.airwaysViolationFlash,
                  key: const Key('airways.crash_flash'),
                  style: theme.textStyles.bodyStrong.copyWith(
                    color: theme.colors.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: theme.spacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: theme.radii.mdAll,
              child: CustomPaint(
                painter: AirwaysPainter(
                  graph: _sim.graph,
                  zones: _sim.zones,
                  aircraft: _sim.aircraft,
                  flashZones: zoneFlashSet,
                  zoneBorderColor: theme.colors.borderStrong,
                  zoneLabelColor: theme.colors.textPrimary,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          SizedBox(height: theme.spacing.md),
          if (render.isAnswered)
            Text(
              _sim.violations == 0
                  ? AppStrings.airwaysSummaryClean(_sim.reroutesUsed)
                  : AppStrings.airwaysSummaryWithViolations(
                      _sim.violations,
                      _sim.reroutesUsed,
                    ),
              style: theme.textStyles.body,
            )
          else ...[
            Text(AppStrings.airwaysExampleLegendTitle, style: theme.textStyles.caption),
            SizedBox(height: theme.spacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 0; i < _sim.routeCount; i++)
                  _RouteButton(
                    key: Key('airways.route_button.$i'),
                    number: i + 1,
                    color: airwaysRouteColors[i],
                    onPressed: render.acceptsInput ? () => _reroute(i) : null,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RouteButton extends StatelessWidget {
  const _RouteButton({
    required this.number,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final int number;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: AppStrings.airwaysRouteButtonSemantics(number),
      builder: (context, state) => Container(
        width: theme.spacing.minTouchTarget,
        height: theme.spacing.minTouchTarget,
        decoration: BoxDecoration(
          color: onPressed == null
              ? color.withValues(alpha: 0.35)
              : color.withValues(alpha: state.pressed ? 0.7 : 1.0),
          shape: BoxShape.circle,
          border: state.focused
              ? Border.all(color: theme.colors.focusRing, width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: theme.textStyles.bodyStrong.copyWith(
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
