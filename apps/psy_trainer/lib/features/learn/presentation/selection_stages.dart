import '../../../core/content/content.dart';
import '../../../core/l10n/strings.dart';
import '../domain/selection_stage.dart';

/// The selection process as documented in `docs/content/psy0-spec.md` §1,
/// in chronological order. Confidence tags follow the spec's own tagging:
/// stage existence and rules are official (`confirmed`), venues, rates and
/// activity counts come from candidate debriefs (`reported`).
const List<SelectionStage> selectionStages = [
  SelectionStage(
    title: AppStrings.stageDossierTitle,
    when: AppStrings.stageDossierWhen,
    body: AppStrings.stageDossierBody,
    confidence: Confidence.confirmed,
    facts: [StageFact(AppStrings.stageDossierFactFee, Confidence.confirmed)],
  ),
  SelectionStage(
    title: AppStrings.stagePsy0Title,
    when: AppStrings.stagePsy0When,
    body: AppStrings.stagePsy0Body,
    confidence: Confidence.confirmed,
    isTarget: true,
    facts: [
      StageFact(AppStrings.stagePsy0FactDuration, Confidence.confirmed),
      StageFact(AppStrings.stagePsy0FactActivities, Confidence.reported),
      StageFact(AppStrings.stagePsy0FactWaitlist, Confidence.reported),
    ],
  ),
  SelectionStage(
    title: AppStrings.stagePsy1Title,
    when: AppStrings.stagePsy1When,
    body: AppStrings.stagePsy1Body,
    confidence: Confidence.confirmed,
    facts: [
      StageFact(AppStrings.stagePsy1FactDay, Confidence.confirmed),
      StageFact(AppStrings.stagePsy1FactVenue, Confidence.reported),
      StageFact(AppStrings.stagePsy1FactRate, Confidence.reported),
    ],
  ),
  SelectionStage(
    title: AppStrings.stagePsy2Title,
    when: AppStrings.stagePsy2When,
    body: AppStrings.stagePsy2Body,
    confidence: Confidence.confirmed,
    facts: [
      StageFact(AppStrings.stagePsy2FactContent, Confidence.confirmed),
      StageFact(AppStrings.stagePsy2FactCoaching, Confidence.confirmed),
    ],
  ),
  SelectionStage(
    title: AppStrings.stageMedicalTitle,
    when: AppStrings.stageMedicalWhen,
    body: AppStrings.stageMedicalBody,
    confidence: Confidence.confirmed,
    facts: [
      StageFact(AppStrings.stageMedicalFactClass2, Confidence.confirmed),
      StageFact(AppStrings.stageMedicalFactClass1, Confidence.confirmed),
    ],
  ),
  SelectionStage(
    title: AppStrings.stageTrainingTitle,
    when: AppStrings.stageTrainingWhen,
    body: AppStrings.stageTrainingBody,
    confidence: Confidence.confirmed,
    eliminatory: false,
    facts: [
      StageFact(AppStrings.stageTrainingFactDuration, Confidence.confirmed),
    ],
  ),
];
