import 'package:flutter/widgets.dart';

/// Colour-blind-safe (Okabe-Ito) palette a scene's solids are drawn in, one
/// entry per `ViewpointObject.colorIndex` (US-034: "distinct colours"); the
/// order and the hues match `AppStrings`' `viewpointColorName` so the practice
/// explanation always names the colour actually on screen.
const List<Color> viewpointPalette = [
  Color(0xFFE69F00), // orange
  Color(0xFF56B4E9), // sky blue
  Color(0xFF009E73), // bluish green
  Color(0xFFF0E442), // yellow
  Color(0xFF0072B2), // blue
  Color(0xFFD55E00), // vermillion
];

Color viewpointColorOf(int colorIndex) =>
    viewpointPalette[colorIndex % viewpointPalette.length];
