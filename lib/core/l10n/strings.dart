/// User-facing strings, French only for now.
///
/// Interim solution until US-091 introduces ARB-based localisation: every
/// screen reads its copy from here so no literal is hard-coded in a widget and
/// the migration to `flutter_localizations` is a mechanical rename.
///
/// Disclaimer wording comes verbatim from `docs/content/psy0-spec.md` §7
/// ("Disclaimer text for the app"); keep both in sync.
abstract final class AppStrings {
  static const String appName = 'PSY Trainer';

  // Tabs (bottom bar / rail), in `AppRoutes.tabs` order.
  static const String tabLearn = 'Apprendre';
  static const String tabTrain = 'Pratique';
  static const String tabExam = 'Examen';
  static const String tabProgress = 'Progrès';
  static const String tabSettings = 'Réglages';

  /// Accessibility label of the tab bar itself.
  static const String tabBarLabel = 'Navigation principale';

  // Unofficial-trainer disclaimer (spec §7).
  static const String disclaimerShort =
      'Entraîneur indépendant et non officiel — aucun lien avec Air France.';
  static const String disclaimerTitle = 'Application non officielle.';
  static const String disclaimerParagraph1 =
      'Cette application est un outil d\'entraînement indépendant. '
      'Elle n\'est ni affiliée à, ni approuvée par Air France, Transavia, '
      'l\'ENAC ou leurs prestataires. Les marques citées appartiennent à leurs '
      'propriétaires et ne sont utilisées que pour décrire le processus de '
      'sélection visé.';
  static const String disclaimerParagraph2 =
      'Les exercices, questions et durées proposés sont conçus par nous à '
      'partir d\'informations publiques et de retours de candidats ; ils sont '
      'estimatifs et ne reproduisent aucun sujet réel. Le contenu de la '
      'sélection réelle évolue chaque année. Aucun résultat obtenu ici ne '
      'préjuge de votre réussite à la sélection.';
}
