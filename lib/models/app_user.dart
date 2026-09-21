class GameStats {
  const GameStats({
    required this.totalScore,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streakDays,
    required this.longestStreak,
    required this.totalCorrectAnswers,
    required this.totalWrongAnswers,
    required this.completedQuestions,
  });

  final int totalScore;
  final int level;
  final int xp;
  final int coins;
  final int streakDays;
  final int longestStreak;
  final int totalCorrectAnswers;
  final int totalWrongAnswers;
  final int completedQuestions;

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
        totalScore: json['total_score'] as int? ?? 0,
        level: json['level'] as int? ?? 1,
        xp: json['xp'] as int? ?? 0,
        coins: json['coins'] as int? ?? 0,
        streakDays: json['streak_days'] as int? ?? 0,
        longestStreak: json['longest_streak'] as int? ?? 0,
        totalCorrectAnswers: json['total_correct_answers'] as int? ?? 0,
        totalWrongAnswers: json['total_wrong_answers'] as int? ?? 0,
        completedQuestions: json['completed_questions'] as int? ?? 0,
      );
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.stats,
  });

  final int id;
  final String name;
  final String email;
  final String avatar;
  final GameStats? stats;

  AppUser copyWith({String? name, String? avatar}) => AppUser(
        id: id,
        name: name ?? this.name,
        email: email,
        avatar: avatar ?? this.avatar,
        stats: stats,
      );

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        avatar: (json['avatar'] as String?) ?? '🧑‍🎓',
        stats: json['stats'] is Map<String, dynamic>
            ? GameStats.fromJson(json['stats'] as Map<String, dynamic>)
            : null,
      );
}
