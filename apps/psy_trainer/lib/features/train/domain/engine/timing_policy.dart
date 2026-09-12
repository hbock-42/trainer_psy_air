import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:psy_content/psy_content.dart';

part 'timing_policy.freezed.dart';
part 'timing_policy.g.dart';

/// How a section is timed. Any combination of a per-item limit, a hard
/// section limit and a fixed [cadence] (contract v2, `ExamSection`).
///
/// - `perItemMs`: the item times out after this delay (a timeout attempt is
///   recorded and the session advances).
/// - `sectionMs`: the whole section stops when this runs out, whatever the
///   item index; the current unanswered item is recorded as a timeout.
/// - `cadence`: each item is shown for `stimulusMs` then answerable for
///   `answerWindowMs` more; the session advances at the end of the window
///   whether or not an answer came (a missing answer is a timeout). Cadence
///   takes precedence over `perItemMs`.
///
/// With none of the three the session is untimed (practice default).
@freezed
abstract class TimingPolicy with _$TimingPolicy {
  const factory TimingPolicy({
    int? perItemMs,
    int? sectionMs,
    Cadence? cadence,
  }) = _TimingPolicy;

  const TimingPolicy._();

  factory TimingPolicy.fromJson(Map<String, Object?> json) =>
      _$TimingPolicyFromJson(json);

  /// The timing of a blueprint section.
  factory TimingPolicy.fromSection(ExamSection section) => TimingPolicy(
    perItemMs: _seconds(section.perItemTimeSec),
    sectionMs: _seconds(section.sectionTimeSec),
    cadence: section.cadence,
  );

  /// The family's default timing for practice (`defaultPerItemTimeSec`,
  /// `defaultCadence`); [timed] false gives an untimed drill except for
  /// cadence-driven activities, which keep their rhythm.
  factory TimingPolicy.forPractice(TestFamily family, {bool timed = true}) =>
      TimingPolicy(
        perItemMs: timed ? _seconds(family.defaultPerItemTimeSec) : null,
        cadence: family.defaultCadence,
      );

  static const TimingPolicy none = TimingPolicy();

  static int? _seconds(int? seconds) => seconds == null ? null : seconds * 1000;

  bool get isCadence => cadence != null;

  bool get isUntimed => perItemMs == null && sectionMs == null && !isCadence;

  Duration? get perItem =>
      perItemMs == null ? null : Duration(milliseconds: perItemMs!);

  Duration? get section =>
      sectionMs == null ? null : Duration(milliseconds: sectionMs!);

  /// Time an item stays on screen before it times out: the cadence window
  /// (stimulus + answer) or the per-item limit; null when untimed.
  Duration? get itemLimit {
    final c = cadence;
    if (c != null) {
      return Duration(milliseconds: c.stimulusMs + c.answerWindowMs);
    }
    return perItem;
  }

  /// Under a cadence, how long the stimulus is displayed before the answer
  /// phase; null otherwise.
  Duration? get stimulus =>
      cadence == null ? null : Duration(milliseconds: cadence!.stimulusMs);
}
