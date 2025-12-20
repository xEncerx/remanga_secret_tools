import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import '../../features/features.dart';
import '../../shared/shared.dart';
import '../core.dart';

/// Get It instance for dependency injection.
final getIt = GetIt.I;

/// Sets up the dependencies for the application.
Future<void> setupDependencies() async {
  // === Logger ===
  final logger = Talker(
    observer: SentryTalkerObserver(),
    settings: TalkerSettings(
      // ignore: avoid_redundant_argument_values
      useConsoleLogs: kDebugMode,
    ),
  );

  // === Bloc Observer ===
  Bloc.observer = TalkerBlocObserver(
    talker: logger,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: false,
      printStateFullData: false,
    ),
  );

  // === REST client ===
  final restClient = RestClient(
    ApiClient(
      baseUrl: EnvConfig.apiUrl,
      logger: logger,
    ).createClient(),
  );

  // === Repositories ===
  final packRepo = PackRepositoryImpl(
    PackRemoteApi(restClient.dio),
  );

  // === Register dependencies ===
  getIt
    ..registerSingleton<Talker>(logger)
    ..registerSingleton<RestClient>(restClient)
    ..registerSingleton<PackRepository>(packRepo)
    ..registerSingleton<AppRouter>(AppRouter());
}
