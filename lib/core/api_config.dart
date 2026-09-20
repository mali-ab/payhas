/// Contract placeholders for the future Flutter → FastAPI → PostgreSQL stack.
/// The first release intentionally does not instantiate a network client.
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.sozitap.tm/v1',
  );

  static const questionsPath = '/questions';
  static const dailyChallengePath = '/daily-challenges';
  static const leaderboardPath = '/leaderboard';
  static const profilePath = '/me';
  static const achievementsPath = '/achievements';
}
