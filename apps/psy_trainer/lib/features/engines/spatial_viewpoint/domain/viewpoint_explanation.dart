import '../../../../core/l10n/strings.dart';
import 'viewpoint_scene.dart';

/// The FR practice-feedback sentence naming two salient objects of the
/// scene's left-to-right order as seen from `scene.correctAzimuth`
/// (US-034 acceptance: "vu depuis la position n : l'objet X est à gauche
/// de Y").
///
/// Picks the leftmost and rightmost object of the ordering rather than an
/// arbitrary pair so the sentence always describes the widest, easiest to
/// verify split.
String explanationFor(ViewpointScene scene) {
  final order = projectionSignature(scene, scene.correctAzimuth).leftToRight;
  final leftmost = scene.objects[order.first];
  final rightmost = scene.objects[order.last];
  return AppStrings.viewpointExplanation(
    scene.correctAzimuth,
    _label(leftmost),
    _label(rightmost),
  );
}

String _label(ViewpointObject object) =>
    '${AppStrings.viewpointSolidName(object.kind)} '
    '${AppStrings.viewpointColorName(object.colorIndex)}';
