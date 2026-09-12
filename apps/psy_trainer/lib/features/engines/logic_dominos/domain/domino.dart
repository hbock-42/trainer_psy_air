/// One domino: two halves, each 0-6 (spec §2.4-G).
class Domino {
  const Domino(this.top, this.bottom);

  final int top;
  final int bottom;

  @override
  bool operator ==(Object other) =>
      other is Domino && other.top == top && other.bottom == bottom;

  @override
  int get hashCode => Object.hash(top, bottom);

  @override
  String toString() => 'Domino($top|$bottom)';
}

/// `(x mod 7)`, always in `0..6` (Dart's `%` already returns a non-negative
/// result for a positive modulus, kept here as one documented spot for the
/// domino arithmetic).
int mod7(int x) => x % 7;
