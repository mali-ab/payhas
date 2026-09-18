import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _filterIndex = 3; // Default: Ähli wagt

  final List<String> _filters = const [
    'Şu gün',
    'Bu hepde',
    'Şu aý',
    'Ähli wagt',
  ];

  // Data sets for each filter
  final Map<int, List<Map<String, dynamic>>> _leaderboardsByFilter = const {
    0: [
      // Şu gün
      {'rank': 1, 'name': 'Batyr Myradow', 'level': 8, 'score': 450, 'avatar': '🦁'},
      {'rank': 2, 'name': 'Aýna Saparowa', 'level': 9, 'score': 380, 'avatar': '🦅'},
      {'rank': 3, 'name': 'Mergen Amanow', 'level': 9, 'score': 310, 'avatar': '👑'},
      {'rank': 4, 'name': 'Serdar Nuryýew', 'level': 7, 'score': 260, 'avatar': '🏇'},
      {'rank': 5, 'name': 'Jeren Annabaýewa', 'level': 6, 'score': 210, 'avatar': '🦉'},
      {'rank': 6, 'name': 'Gülşat Berdiýewa', 'level': 6, 'score': 180, 'avatar': '🧑‍🎓'},
      {'rank': 7, 'name': 'Arslan Döwletow', 'level': 5, 'score': 140, 'avatar': '🧠'},
    ],
    1: [
      // Bu hepde
      {'rank': 1, 'name': 'Aýna Saparowa', 'level': 9, 'score': 1420, 'avatar': '🦅'},
      {'rank': 2, 'name': 'Mergen Amanow', 'level': 9, 'score': 1280, 'avatar': '👑'},
      {'rank': 3, 'name': 'Serdar Nuryýew', 'level': 7, 'score': 1050, 'avatar': '🏇'},
      {'rank': 4, 'name': 'Batyr Myradow', 'level': 8, 'score': 980, 'avatar': '🦁'},
      {'rank': 5, 'name': 'Jeren Annabaýewa', 'level': 6, 'score': 840, 'avatar': '🦉'},
      {'rank': 6, 'name': 'Arslan Döwletow', 'level': 5, 'score': 720, 'avatar': '🧠'},
      {'rank': 7, 'name': 'Gülşat Berdiýewa', 'level': 6, 'score': 650, 'avatar': '🧑‍🎓'},
    ],
    2: [
      // Şu aý
      {'rank': 1, 'name': 'Mergen Amanow', 'level': 9, 'score': 3150, 'avatar': '👑'},
      {'rank': 2, 'name': 'Aýna Saparowa', 'level': 9, 'score': 2840, 'avatar': '🦅'},
      {'rank': 3, 'name': 'Batyr Myradow', 'level': 8, 'score': 2490, 'avatar': '🦁'},
      {'rank': 4, 'name': 'Serdar Nuryýew', 'level': 7, 'score': 2120, 'avatar': '🏇'},
      {'rank': 5, 'name': 'Jeren Annabaýewa', 'level': 6, 'score': 1950, 'avatar': '🦉'},
      {'rank': 6, 'name': 'Gülşat Berdiýewa', 'level': 6, 'score': 1680, 'avatar': '🧑‍🎓'},
      {'rank': 7, 'name': 'Arslan Döwletow', 'level': 5, 'score': 1450, 'avatar': '🧠'},
    ],
    3: [
      // Ähli wagt
      {'rank': 1, 'name': 'Mergen Amanow', 'level': 10, 'score': 4850, 'avatar': '👑'},
      {'rank': 2, 'name': 'Aýna Saparowa', 'level': 9, 'score': 4120, 'avatar': '🦅'},
      {'rank': 3, 'name': 'Batyr Myradow', 'level': 8, 'score': 3650, 'avatar': '🦁'},
      {'rank': 4, 'name': 'Serdar Nuryýew', 'level': 7, 'score': 3100, 'avatar': '🏇'},
      {'rank': 5, 'name': 'Jeren Annabaýewa', 'level': 7, 'score': 2840, 'avatar': '🦉'},
      {'rank': 6, 'name': 'Gülşat Berdiýewa', 'level': 6, 'score': 2490, 'avatar': '🧑‍🎓'},
      {'rank': 7, 'name': 'Arslan Döwletow', 'level': 5, 'score': 2180, 'avatar': '🧠'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final currentLeaders = _leaderboardsByFilter[_filterIndex] ?? [];

    final top1 = currentLeaders.isNotEmpty ? currentLeaders[0] : null;
    final top2 = currentLeaders.length > 1 ? currentLeaders[1] : null;
    final top3 = currentLeaders.length > 2 ? currentLeaders[2] : null;
    final remainingLeaders =
        currentLeaders.length > 3 ? currentLeaders.sublist(3) : [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: AppTheme.glassMorphism.copyWith(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'REÝTİNG',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppTheme.gold.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '🪙 ${provider.coins}',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4 Filter Tabs: Şu gün, Bu hepde, Şu aý, Ähli wagt
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Row(
                    children: List.generate(_filters.length, (idx) {
                      final isSelected = _filterIndex == idx;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _filterIndex = idx),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                _filters[idx],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Top 3 Podium (🥇 🥈 🥉)
              if (top1 != null && top2 != null && top3 != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 🥈 2nd Place (Left)
                      _buildPodiumItem(
                        player: top2,
                        rank: 2,
                        medal: '🥈',
                        height: 110,
                        medalColor: const Color(0xFFB0BEC5),
                      ),
                      const SizedBox(width: 12),

                      // 🥇 1st Place (Center, Tallest)
                      _buildPodiumItem(
                        player: top1,
                        rank: 1,
                        medal: '🥇',
                        height: 135,
                        medalColor: AppTheme.gold,
                        isWinner: true,
                      ),
                      const SizedBox(width: 12),

                      // 🥉 3rd Place (Right)
                      _buildPodiumItem(
                        player: top3,
                        rank: 3,
                        medal: '🥉',
                        height: 95,
                        medalColor: const Color(0xFFCD7F32),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Remaining Players List (#4 onwards)
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: remainingLeaders.length,
                  itemBuilder: (context, index) {
                    final player = remainingLeaders[index];
                    final rank = player['rank'] as int;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        children: [
                          // Position
                          SizedBox(
                            width: 32,
                            child: Text(
                              '#$rank',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Avatar
                          Text(
                            player['avatar'] as String,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 12),

                          // Username and Level
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player['name'] as String,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${player['level']}-nji dereje',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Score
                          Text(
                            '⭐ ${player['score']}',
                            style: const TextStyle(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Current User's Rank Footer Bar
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.bg2,
                  border: const Border(
                    top: BorderSide(color: AppTheme.cardBorder, width: 1.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '#8',
                      style: TextStyle(
                        color: AppTheme.accentLight,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(provider.avatar, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${provider.username} (Siz)',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${provider.level}-nji dereje • ${provider.levelTitle}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '⭐ ${provider.totalScore}',
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumItem({
    required Map<String, dynamic> player,
    required int rank,
    required String medal,
    required double height,
    required Color medalColor,
    bool isWinner = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(player['avatar'] as String, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 4),
          Text(
            player['name'].toString().split(' ').first,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '⭐ ${player['score']}',
            style: TextStyle(
              color: medalColor,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),

          // Podium Base Block
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isWinner
                    ? [
                        AppTheme.gold.withValues(alpha: 0.35),
                        AppTheme.gold.withValues(alpha: 0.12)
                      ]
                    : [
                        AppTheme.accent.withValues(alpha: 0.25),
                        AppTheme.cardBg
                      ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(
                color: isWinner ? AppTheme.gold : AppTheme.cardBorder,
                width: isWinner ? 2 : 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(medal, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 4),
                  Text(
                    '${player['level']} dereje',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
