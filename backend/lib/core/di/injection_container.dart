import 'package:backend/core/core.dart';
import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';

/// Dependency injection container.
final getIt = GetIt.I;

/// Initializes the dependency injection container.
class InjectionContainer {
  static late final AppDatabase _database;

  /// Initializes the dependency injection container.
  static Future<void> init() async {
    // === Configure logger ===
    final logger = Talker(
      logger: TalkerLogger(
        formatter: const ColoredLoggerFormatter(),
        settings: TalkerLoggerSettings(
          enableColors: EnvConfig.flavor == EnvFlavor.development,
          level: EnvConfig.flavor == EnvFlavor.development
              ? LogLevel.verbose
              : LogLevel.warning,
        ),
      ),
      observer: SentryTalkerObserver(),
    );

    // === Configure database ===
    _database = AppDatabase(DatabaseConnection.create());

    // === Configure REST client ===
    final restClient = RestClient(
      ApiClient(
        baseUrl: '${EnvConfig.apiRemangaUrl}/api/v2/',
        logger: logger,
      ).createClient(),
    );

    // === Cache service with Redis and In-Memory fallback ===
    final cacheService = await CacheFactory.createRedisWithFallback(
      host: EnvConfig.redisHost,
      port: EnvConfig.redisPort,
      password: EnvConfig.redisPassword,
      database: EnvConfig.redisDatabase,
      onFallback: (error) {
        logger
          ..warning('⚠ Redis connection failed: $error')
          ..warning('⚠ Using In-Memory cache instead');
      },
    );

    // === Repositories ===
    final packRepo = PackRepositoryImpl(_database);
    final cardRepo = CardRepositoryImpl(_database);

    getIt
      ..registerSingleton<PackRepository>(packRepo)
      ..registerSingleton<CardRepository>(cardRepo)
      // === Services ===
      ..registerSingleton<Talker>(logger)
      ..registerSingleton<RestClient>(restClient)
      ..registerSingleton<CacheService>(cacheService)
      // === Use cases ===
      ..registerSingleton<SyncPackUseCase>(
        SyncPackUseCase(
          restClient: restClient,
          packRepository: packRepo,
          cardRepository: cardRepo,
          packHashGenerator: PackHashGenerator(),
        ),
      )
      ..registerSingleton<DownloadCardCoverUseCase>(
        DownloadCardCoverUseCase(
          dio: ApiClient(
            baseUrl: EnvConfig.apiRemangaUrl,
            logger: logger,
          ).createClient(),
          cardRepository: cardRepo,
          fileStorage: LocalFileStorage(basePath: EnvConfig.mediaRoot),
        ),
      )
      ..registerSingleton<ProcessPendingDownloadsUseCase>(
        ProcessPendingDownloadsUseCase(
          cardRepository: cardRepo,
          downloadCardCoverUseCase: getIt<DownloadCardCoverUseCase>(),
          maxConcurrent: 5,
        ),
      )
      ..registerSingleton<GetPackUseCase>(
        GetPackUseCase(
          packRepository: packRepo,
          cardRepository: cardRepo,
        ),
      );

    logger.info('Dependency injection container initialized.');
  }

  /// Disposes the dependency injection container. And cleans up resources.
  static Future<void> dispose() async {
    await _database.close();
    getIt<RestClient>().dio.close();
    await getIt<CacheService>().dispose();

    getIt<Talker>().info('Dependency injection container disposed.');
  }
}
