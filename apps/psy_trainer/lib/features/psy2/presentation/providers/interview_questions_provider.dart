import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psy_content/psy_content.dart';

import '../../../../core/repositories/repositories.dart';

/// The PSY2 interview practice bank (US-111), ordered by id (theme then
/// number, since ids are `interview.<theme>.<nnnn>`). Empty until the
/// bundle is seeded.
final FutureProvider<List<InterviewQuestion>> interviewQuestionsProvider =
    FutureProvider<List<InterviewQuestion>>(
      (ref) => ref
          .watch(contentRepositoryProvider)
          .interviewQuestions(familyId: 'interview'),
    );
