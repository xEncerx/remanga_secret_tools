import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/core.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Sentry for error tracking
      await SentryFlutter.init(
        (options) {
          options
            ..dsn = EnvConfig.sentryDsn
            ..environment = EnvConfig.flavor.name
            ..debug = kDebugMode
            ..sendDefaultPii = true
            ..tracesSampleRate = EnvConfig.flavor == EnvFlavor.production ? 0.2 : 1.0;
        },
      );

      // Initialize Hydrated Bloc storage
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory.web,
      );

      // Setup dependencies
      await setupDependencies();

      // Preload SVG assets
      preloadSVGs([
        'assets/svgs/github.svg',
        'assets/svgs/yin-yang.svg',
      ]);

      runApp(const MainApp());
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
