/// A class to manage environment configurations using dotenv.
class EnvConfig {
  /// Gets the API URL.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  /// Gets the Remanga URL.
  static const String remangaUrl = String.fromEnvironment(
    'REMANGA_URL',
    defaultValue: 'https://remanga.org',
  );

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
}
