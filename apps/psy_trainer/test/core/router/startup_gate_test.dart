import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/db/seed/content_ready_provider.dart';
import 'package:psy_trainer/core/db/seed/content_seeder.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/error_screen.dart';
import 'package:psy_trainer/core/router/startup_gate.dart';

import '../../helpers/content_ready_fakes.dart';
import '../../helpers/onboarding_fakes.dart';
import '../../helpers/pump_app.dart';

const Key childKey = Key('gated-child');

Future<ProviderContainer> pumpGate(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  await tester.pumpApp(
    UncontrolledProviderScope(
      container: container,
      child: const StartupGate(child: SizedBox(key: childKey)),
    ),
    align: false,
  );
  return container;
}

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  testWidgets('shows the child once the content is ready and the onboarding '
      'flag is hydrated', (tester) async {
    await pumpGate(
      tester,
      overrides: [progressRepositoryOverride(), contentReadyOverride()],
    );
    await tester.pumpAndSettle();

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('stays blank then shows the splash while seeding', (
    tester,
  ) async {
    final seeding = Completer<SeedResult>();
    await pumpGate(
      tester,
      overrides: [
        progressRepositoryOverride(),
        contentReadyProvider.overrideWith((ref) => seeding.future),
      ],
    );
    await tester.pump();

    expect(find.byKey(childKey), findsNothing);
    expect(find.byType(SplashScreen), findsOneWidget);
    final opacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(opacity.opacity, 0, reason: 'blank before the splash delay');

    await tester.pump(StartupGate.splashDelay);
    await tester.pump();
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );
    expect(find.text(l10nFr.startupLoadingContent), findsOneWidget);
    expect(find.text(l10nFr.appName), findsOneWidget);

    seeding.complete(const SeedResult.upToDate(1));
    await tester.pumpAndSettle();
    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('waits for the onboarding flag even when the content is '
      'ready', (tester) async {
    final repository = _SlowProgressRepository();
    await pumpGate(
      tester,
      overrides: [
        progressRepositoryOverride(repository: repository),
        contentReadyOverride(),
      ],
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(childKey), findsNothing);
    expect(find.byType(SplashScreen), findsOneWidget);

    repository.release();
    await tester.pumpAndSettle();
    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('a seeding error shows the ErrorScreen and retry re-runs the '
      'seeder', (tester) async {
    var attempts = 0;
    await pumpGate(
      tester,
      overrides: [
        progressRepositoryOverride(),
        contentReadyProvider.overrideWith((ref) async {
          attempts++;
          if (attempts == 1) {
            throw const ContentParseException(
              file: 'assets/content/psy0/module.json',
              message: 'invalid JSON',
            );
          }
          return const SeedResult.upToDate(1);
        }),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.byKey(childKey), findsNothing);
    expect(find.textContaining('psy0/module.json'), findsOneWidget);
    expect(find.text(l10nFr.errorBackHome), findsNothing);

    await tester.tap(find.text(l10nFr.actionRetry));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.byType(ErrorScreen), findsNothing);
    expect(find.byKey(childKey), findsOneWidget);
  });
}

/// A completed profile whose first read only answers after [release].
class _SlowProgressRepository extends InMemoryProgressRepository {
  _SlowProgressRepository() {
    storedProfile = completedAnswers.applyTo(null);
  }

  final Completer<void> _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<UserProfile?> profile() async {
    await _gate.future;
    return super.profile();
  }
}
