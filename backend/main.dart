import 'dart:io';

import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:dart_frog/dart_frog.dart';

/// Initializes dependencies before the server starts.
Future<void> init(InternetAddress ip, int port) async {
  await InjectionContainer.init();

  await SchedulerManager.register(
    PackScheduler(
      packId: 10,
      interval: const Duration(minutes: 1),
    ),
  );

  ProcessSignal.sigint.watch().listen((_) async {
    await SchedulerManager.stopAll();
    await InjectionContainer.dispose();
  });
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
