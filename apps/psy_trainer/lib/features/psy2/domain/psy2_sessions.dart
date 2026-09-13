/// `TrainingSession.familyId` tags for the two PSY2 self-assessment kinds
/// (US-111/US-112). Deliberately distinct from the content family ids
/// (`interview`, `group_exercise` in `assets/content/psy2/`): these are
/// session-tracking labels read back by the Progress tab, not references
/// into the content bundle, and PSY2 has no timed engine to register them
/// with (see `docs/content/psy2-spec.md` ethics note: self-assessment only).
abstract final class Psy2SessionFamily {
  static const String interview = 'psy2_interview';
  static const String groupExercise = 'psy2_group_exercise';
}
