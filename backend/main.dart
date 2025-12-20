import 'dart:async';
import 'dart:io';

import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:sentry/sentry.dart';

/// Initializes dependencies before the server starts.
Future<void> init(InternetAddress ip, int port) async {
  await Sentry.init((options) {
    options
      ..dsn = EnvConfig.sentryDsn
      ..environment = EnvConfig.flavor.name
      ..tracesSampleRate = EnvConfig.flavor == EnvFlavor.production ? 0.2 : 1.0;
  });

  await runZonedGuarded(
    () async {
      await InjectionContainer.init();

      await SchedulerManager.register(
        PackSyncScheduler(
          packId: 10,
          syncPackUseCase: getIt<SyncPackUseCase>(),
          interval: const Duration(seconds: 30),
        ),
      );
      await SchedulerManager.register(
        CardCoverDownloaderScheduler(
          processPendingDownloadsUseCase:
              getIt<ProcessPendingDownloadsUseCase>(),
          interval: const Duration(seconds: 15),
        ),
      );

      ProcessSignal.sigint.watch().listen((_) async {
        await SchedulerManager.stopAll();
        await InjectionContainer.dispose();
        await Sentry.close();
      });
    },
    (error, stackTrace) async {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'source': 'zone',
          'type': 'unhandled',
          'time': DateTime.now().toIso8601String(),
        }),
      );
    },
  );
}

/// Runs the Dart Frog server with custom configurations.
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(
    handler,
    ip,
    port,
    poweredByHeader: 'Powered by Owarty(Encer)',
  );
}
