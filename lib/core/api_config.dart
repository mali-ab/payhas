/// API endpoints used by the optional FastAPI service.
abstract final class ApiConfig {
  static const defaultBaseUrl = 'http://10.0.2.2:8000';
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: defaultBaseUrl,
  );

  /// An explicit API URL means this is an internet/API-backed build.
  static const useRemote =
      bool.fromEnvironment('USE_REMOTE_API') || baseUrl != defaultBaseUrl;

  static const questionsPath = '/questions';
  static const dailyChallengePath = '/daily-challenges';
  static const leaderboardPath = '/leaderboard';
  static const profilePath = '/me';
  static const achievementsPath = '/achievements';
  static const signUpPath = '/auth/signup';
  static const loginPath = '/auth/login';
}
