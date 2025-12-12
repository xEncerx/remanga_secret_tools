/// A class to manage environment configurations using dotenv.
class EnvConfig {
  /// Gets the flavor of the environment.
  static final EnvFlavor flavor = EnvFlavor.fromString(
    const String.fromEnvironment(
      'FLAVOR',
      defaultValue: 'dev',
    ),
  );

  // === Application config ===
  /// Gets the API URL.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8080/api/v1/',
  );

  /// Gets the Remanga URL.
  static const String remangaUrl = String.fromEnvironment(
    'REMANGA_URL',
    defaultValue: 'https://remanga.org',
  );

  // === Author information ===
  /// Gets the author Remanga URL.
  static const String authorRemanga = String.fromEnvironment(
    'AUTHOR_REMANGA',
    defaultValue: 'https://remanga.org/user/2053263/about',
  );

  /// Gets the GitHub repository URL.
  static const String githubRepo = String.fromEnvironment(
    'GITHUB_REPO',
    defaultValue: 'https://github.com/xEncerx/remanga_secret_tools',
  );

  // === Logging configuration parameters. ===
  /// The Sentry DSN for error tracking.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
}

/// The different environment flavors.
enum EnvFlavor {
  /// Development environment.
  development('dev'),

  /// Staging environment.
  staging('stage'),

  /// Production environment.
  production('prod')
  ;

  const EnvFlavor(this.name);

  /// The name of the flavor.
  final String name;

  /// Creates an [EnvFlavor] from a string.
  static EnvFlavor fromString(String flavor) {
    return EnvFlavor.values.firstWhere(
      (e) => e.name == flavor,
      orElse: () => EnvFlavor.development,
    );
  }
}
