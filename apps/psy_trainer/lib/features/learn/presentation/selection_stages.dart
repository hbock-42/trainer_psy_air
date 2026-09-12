import 'package:flutter/widgets.dart';
import 'package:psy_content/psy_content.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../domain/selection_stage.dart';

/// The selection process as documented in `docs/content/psy0-spec.md` §1,
/// in chronological order. Confidence tags follow the spec's own tagging:
/// stage existence and rules are official (`confirmed`), venues, rates and
/// activity counts come from candidate debriefs (`reported`).
List<SelectionStage> selectionStagesOf(BuildContext context) => [
  SelectionStage(
    title: context.l10n.stageDossierTitle,
    when: context.l10n.stageDossierWhen,
    body: context.l10n.stageDossierBody,
    confidence: Confidence.confirmed,
    facts: [StageFact(context.l10n.stageDossierFactFee, Confidence.confirmed)],
  ),
  SelectionStage(
    title: context.l10n.stagePsy0Title,
    when: context.l10n.stagePsy0When,
    body: context.l10n.stagePsy0Body,
    confidence: Confidence.confirmed,
    isTarget: true,
    facts: [
      StageFact(context.l10n.stagePsy0FactDuration, Confidence.confirmed),
      StageFact(context.l10n.stagePsy0FactActivities, Confidence.reported),
      StageFact(context.l10n.stagePsy0FactWaitlist, Confidence.reported),
    ],
  ),
  SelectionStage(
    title: context.l10n.stagePsy1Title,
    when: context.l10n.stagePsy1When,
    body: context.l10n.stagePsy1Body,
    confidence: Confidence.confirmed,
    facts: [
      StageFact(context.l10n.stagePsy1FactDay, Confidence.confirmed),
      StageFact(context.l10n.stagePsy1FactVenue, Confidence.reported),
      StageFact(context.l10n.stagePsy1FactRate, Confidence.reported),
    ],
  ),
  SelectionStage(
    title: context.l10n.stagePsy2Title,
    when: context.l10n.stagePsy2When,
    body: context.l10n.stagePsy2Body,
    confidence: Confidence.confirmed,
    facts: [
      StageFact(context.l10n.stagePsy2FactContent, Confidence.confirmed),
      StageFact(context.l10n.stagePsy2FactCoaching, Confidence.confirmed),
    ],
  ),
  SelectionStage(
    title: context.l10n.stageMedicalTitle,
    when: context.l10n.stageMedicalWhen,
    body: context.l10n.stageMedicalBody,
    confidence: Confidence.confirmed,
    facts: [
      StageFact(context.l10n.stageMedicalFactClass2, Confidence.confirmed),
      StageFact(context.l10n.stageMedicalFactClass1, Confidence.confirmed),
    ],
  ),
  SelectionStage(
    title: context.l10n.stageTrainingTitle,
    when: context.l10n.stageTrainingWhen,
    body: context.l10n.stageTrainingBody,
    confidence: Confidence.confirmed,
    eliminatory: false,
    facts: [
      StageFact(context.l10n.stageTrainingFactDuration, Confidence.confirmed),
    ],
  ),
];
