class LeaderboardEntry {
  const LeaderboardEntry({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.level,
    required this.score,
  });

  final int id;
  final int rank;
  final String name;
  final String avatar;
  final int level;
  final int score;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
        id: json['id'] as int,
        rank: json['rank'] as int,
        name: json['name'] as String,
        avatar: json['avatar'] as String,
        level: json['level'] as int,
        score: json['score'] as int,
      );
}
