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

    // === Configure data sources ===
    final packLocalDataSource = PackLocalDataSourceImpl(_database);

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

    // === Register dependencies ===
    getIt
      ..registerSingleton<Talker>(logger)
      ..registerSingleton<RestClient>(restClient)
      ..registerSingleton<PackLocalDataSource>(packLocalDataSource)
      ..registerSingleton<CacheService>(cacheService)
      // === Use cases ===
      ..registerLazySingleton(
        () => PacksUseCases(
          restClient: restClient,
          packLocalDataSource: packLocalDataSource,
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
