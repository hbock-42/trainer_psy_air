import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/model/session.dart';
import '../../domain/engine/engine.dart';

/// Everything a renderer gets for the item on screen.
///
/// The renderer reads [item], [phase] and [feedback], draws the activity and
/// calls [onAnswer] exactly once per item (later calls are ignored by the
/// session). It never runs its own timers for the runtime's limits: the
/// countdown is drawn by `SessionHost` from [timing] and the deadlines; a
/// renderer that needs the cadence phases reads [phase]. A renderer may
/// still animate its own stimulus (a flash, a moving target) with the
/// widget layer's `Ticker`s.
class ActivityRenderContext {
  const ActivityRenderContext({
    required this.item,
    required this.mode,
    required this.phase,
    required this.timing,
    required this.itemIndex,
    required this.itemCount,
    required this.showsFeedback,
    required this.onAnswer,
    this.feedback,
    this.itemDeadline,
  });

  final Item item;
  final SessionMode mode;

  /// `stimulus` (cadence only) -> `answer` -> `answered`.
  final ItemPhase phase;
  final TimingPolicy timing;
  final int itemIndex;
  final int itemCount;

  /// Practice, or exam with live feedback: [feedback] is set once answered.
  final bool showsFeedback;

  /// Verdict of the current item once answered and only when
  /// [showsFeedback]; null before an answer and in silent exam mode.
  final ItemResult? feedback;

  /// Absolute time at which the item times out; null when untimed.
  final DateTime? itemDeadline;

  /// Hands the candidate's answer to the session.
  final void Function(Answer answer) onAnswer;

  bool get isAnswered => phase == ItemPhase.answered;
  bool get isExam => mode == SessionMode.exam;

  /// The renderer should accept input now.
  bool get acceptsInput => !isAnswered;
}

/// Builds the widget of one item; see [ActivityRenderContext].
typedef ActivityWidgetBuilder =
    Widget Function(BuildContext context, ActivityRenderContext render);

/// The run [ActivityRenderer.buildExample] is briefing for, when the
/// session's source is a generator (US-037): its `runSeed` (identical for
/// every item that will play) and `params`, so a renderer whose activity
/// derives run-specific state from the run seed (the rules engine's rule
/// set) can show this run's actual briefing instead of a generic stand-in.
/// Null on a bank source, or when the caller (a test, a catalogue screen)
/// has no run to describe yet.
class RunExampleContext {
  const RunExampleContext({required this.runSeed, required this.params});

  /// The run's seed (`GeneratorSource.seed`), shared by every item.
  final int runSeed;

  /// The run's generator params (`GeneratorSource.params`).
  final GeneratorParams params;
}

/// The widget half of an activity: one per family, registered in
/// `rendererRegistryProvider` next to its `ActivityEngine`.
///
/// Implementations build on the design system (`shared/widgets`, no
/// Material) and, for keyboard-native activities, wrap the item in a
/// `Focus` + `KeyboardListener` (see ARCHITECTURE.md, "Platforms").
abstract class ActivityRenderer {
  const ActivityRenderer();

  /// Registry key; equals the engine's family id.
  String get familyId;

  /// The item on screen. Called on every state change of the item (phase,
  /// feedback), so keep it a pure function of [render].
  Widget build(BuildContext context, ActivityRenderContext render);

  /// Optional worked example shown on the briefing screen; null shows the
  /// briefing text only. [run] is the run about to play when the source is
  /// a generator (see [RunExampleContext]); most renderers ignore it and
  /// show a fixed illustration, but one whose rule set is derived from the
  /// run seed (`attention_rules`) uses it to show this run's actual rule.
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) => null;
}

/// [ActivityRenderer] over a plain function, for tests and trivial
/// activities.
class FunctionRenderer extends ActivityRenderer {
  const FunctionRenderer({
    required this.familyId,
    required ActivityWidgetBuilder builder,
    Widget Function(BuildContext context)? example,
  }) : _builder = builder,
       _example = example;

  @override
  final String familyId;
  final ActivityWidgetBuilder _builder;
  final Widget Function(BuildContext context)? _example;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _builder(context, render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) =>
      _example?.call(context);
}

/// Raised when a session runs a family nobody registered a renderer for.
class RendererNotFoundError extends Error {
  RendererNotFoundError(this.familyId);

  final String familyId;

  @override
  String toString() =>
      'RendererNotFoundError: no renderer registered for $familyId';
}

/// The renderers available to `SessionHost`, keyed by family id.
class RendererRegistry {
  RendererRegistry(Iterable<ActivityRenderer> renderers) {
    for (final renderer in renderers) {
      register(renderer);
    }
  }

  final Map<String, ActivityRenderer> _byFamily = {};

  void register(ActivityRenderer renderer) {
    if (_byFamily.containsKey(renderer.familyId)) {
      throw ArgumentError.value(
        renderer.familyId,
        'renderer',
        'a renderer is already registered for this family',
      );
    }
    _byFamily[renderer.familyId] = renderer;
  }

  bool hasFamily(String familyId) => _byFamily.containsKey(familyId);

  /// Throws [RendererNotFoundError] when unknown.
  ActivityRenderer byFamily(String familyId) =>
      _byFamily[familyId] ?? (throw RendererNotFoundError(familyId));
}
