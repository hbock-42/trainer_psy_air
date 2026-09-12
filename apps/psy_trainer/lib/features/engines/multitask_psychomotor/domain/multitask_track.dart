/// The four cardinal directions the tracking circle can move in and the
/// arrow the candidate must hold to follow it (spec §2.4-M).
///
/// Kept here (rather than as a raw `LogicalKeyboardKey`) so the whole domain
/// layer -- simulation, scoring, tests -- stays pure Dart (no Flutter); the
/// renderer maps [arrowKeyLabel] to/from `LogicalKeyboardKey.keyLabel`.
enum TrackDirection {
  up,
  down,
  left,
  right;

  /// The other three directions, in enum order.
  List<TrackDirection> others() =>
      TrackDirection.values.where((d) => d != this).toList(growable: false);

  /// The reversal of this direction.
  TrackDirection get opposite => switch (this) {
    TrackDirection.up => TrackDirection.down,
    TrackDirection.down => TrackDirection.up,
    TrackDirection.left => TrackDirection.right,
    TrackDirection.right => TrackDirection.left,
  };

  /// Unit displacement of this direction (`y` grows downward, matching
  /// screen/canvas coordinates).
  (double, double) get delta => switch (this) {
    TrackDirection.up => (0, -1),
    TrackDirection.down => (0, 1),
    TrackDirection.left => (-1, 0),
    TrackDirection.right => (1, 0),
  };

  /// The engine's own token for this direction (not a `LogicalKeyboardKey`
  /// name: the domain layer stays pure Dart). The renderer maps
  /// `LogicalKeyboardKey.arrowUp`/etc. to/from these tokens; anything that
  /// stores a direction (`RawAnswer` payloads, test fixtures) uses them.
  String get token => switch (this) {
    TrackDirection.up => 'up',
    TrackDirection.down => 'down',
    TrackDirection.left => 'left',
    TrackDirection.right => 'right',
  };

  static TrackDirection fromToken(String token) => TrackDirection.values
      .firstWhere((d) => d.token == token, orElse: () => TrackDirection.up);
}
