import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repositories.dart';
import '../../domain/psy2_sessions.dart';

/// Every finished PSY2 interview-practice session, newest first (US-111).
/// Refreshed with `ref.invalidate` after a new self-assessment is saved.
final FutureProvider<List<TrainingSession>> interviewSessionsProvider =
    FutureProvider<List<TrainingSession>>(
      (ref) => ref
          .watch(progressRepositoryProvider)
          .sessions(
            familyId: Psy2SessionFamily.interview,
            mode: SessionMode.practice,
            status: SessionStatus.completed,
          ),
    );

/// Every finished PSY2 group-exercise self-assessment, newest first
/// (US-112).
final FutureProvider<List<TrainingSession>> groupExerciseSessionsProvider =
    FutureProvider<List<TrainingSession>>(
      (ref) => ref
          .watch(progressRepositoryProvider)
          .sessions(
            familyId: Psy2SessionFamily.groupExercise,
            mode: SessionMode.practice,
            status: SessionStatus.completed,
          ),
    );
