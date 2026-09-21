import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _availableAvatars = const [
    '🧑‍🎓',
    '🧙‍♂️',
    '🦉',
    '🦅',
    '🦁',
    '🏇',
    '👑',
    '🧠',
  ];

  void _showEditUsernameDialog(BuildContext context, GameProvider provider, AuthProvider auth) {
    if (!auth.isAuthenticated) return;
    final controller = TextEditingController(text: auth.user?.name ?? provider.username);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bg2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Ulanyjy adyny üýtget',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Täze adyňyz...',
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            filled: true,
            fillColor: AppTheme.cardBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.cardBorder),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ýatyr',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                final saved = await auth.updateProfile(name: newName);
                if (saved) await provider.setUsername(newName);
              }
              if (!ctx.mounted) return;
              Navigator.of(ctx).pop();
            },
            child: const Text('Ýatda sakla',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAvatarSelectorDialog(BuildContext context, GameProvider provider, AuthProvider auth) {
    if (!auth.isAuthenticated) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bg2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Awatar saýlaň',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Wrap(
          spacing: 14,
          runSpacing: 14,
          children: _availableAvatars.map((av) {
            final isSelected = (auth.user?.avatar ?? provider.avatar) == av;
            return InkWell(
              onTap: () async {
                final saved = await auth.updateProfile(avatar: av);
                if (saved) await provider.setAvatar(av);
                if (!ctx.mounted) return;
                Navigator.of(ctx).pop();
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accent.withValues(alpha: 0.3)
                      : AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.accentLight : AppTheme.cardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(av, style: const TextStyle(fontSize: 28)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final canEditProfile = auth.isAuthenticated;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Top Bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: AppTheme.glassMorphism.copyWith(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          LucideIcons.arrowLeft,
                          size: 18,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Profil',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
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

                const SizedBox(height: 24),

                // Avatar & Username Header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppTheme.accentGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.accent.withValues(alpha: 0.4),
                                    blurRadius: 26,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  user?.avatar ?? provider.avatar,
                                  style: const TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          if (canEditProfile)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    _showAvatarSelectorDialog(context, provider, auth),
                                child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.pencil,
                                    size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Username with edit button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.name ?? provider.username,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (canEditProfile) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () =>
                                  _showEditUsernameDialog(context, provider, auth),
                              child: const Icon(
                                LucideIcons.pencil,
                                size: 18,
                                color: AppTheme.accentLight,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Level and Title
                      Text(
                        '${provider.level}-nji dereje • ${provider.levelTitle}',
                        style: const TextStyle(
                          color: AppTheme.accentLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),
                      if (user != null)
                        Text(user.email, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      if (!canEditProfile)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            'Myhman tertibi: profil maglumatlaryny üýtgetmek üçin hasaba giriň.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),

                      // XP Progress Bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: AppTheme.glassMorphism.copyWith(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tejribe (XP):',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${provider.xp % provider.xpToNextLevel} / ${provider.xpToNextLevel} XP',
                                  style: TextStyle(
                                    color: Colors.purple.shade200,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: provider.xpProgress.clamp(0.0, 1.0),
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.purple.shade300),
                                minHeight: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Statistics Section Header
                const Text(
                  'Statistika',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Stats Grid
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: '⭐',
                        title: 'Jemi bal',
                        value: '${provider.totalScore}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: '🎯',
                        title: 'Tamamlanan',
                        value: '${provider.completedQuestions} sorag',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: '✅',
                        title: 'Dogry jogap',
                        value: '${provider.totalCorrectAnswers}',
                        valueColor: AppTheme.correct,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: '❌',
                        title: 'Ýalňyş jogap',
                        value: '${provider.totalWrongAnswers}',
                        valueColor: AppTheme.wrong,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: '🔥',
                        title: 'Häzirki seri',
                        value: '${provider.streakDays} gün',
                        valueColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: '⚡',
                        title: 'Iň uzyn seri',
                        value: '${provider.longestStreak} gün',
                        valueColor: const Color(0xFFFF7043),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Achievements (Üstünlikler) Section Header
                const Text(
                  'Üstünlikler',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // 1. 🏆 Ilkinji ädim (First correct answer)
                _buildAchievementCard(
                  icon: '🏆',
                  title: 'Ilkinji ädim',
                  desc: 'Ilkinji dogry jogabyňyzy beriň.',
                  current: min(provider.totalCorrectAnswers, 1),
                  target: 1,
                  isUnlocked: provider.totalCorrectAnswers >= 1,
                ),

                // 2. 🔥 7 günlük seri (7-day streak)
                _buildAchievementCard(
                  icon: '🔥',
                  title: '7 günlük seri',
                  desc: '7 gün yzly-yzyna oýun oýnaň.',
                  current: min(provider.streakDays, 7),
                  target: 7,
                  isUnlocked: provider.streakDays >= 7,
                ),

                // 3. 🧠 Paýhasly (100 correct answers)
                _buildAchievementCard(
                  icon: '🧠',
                  title: 'Paýhasly',
                  desc: '100 nakyla dogry jogap beriň.',
                  current: min(provider.totalCorrectAnswers, 100),
                  target: 100,
                  isUnlocked: provider.totalCorrectAnswers >= 100,
                ),

                // 4. 📚 Nakyllar bilermeni (500 completed proverbs)
                _buildAchievementCard(
                  icon: '📚',
                  title: 'Nakyllar bilermeni',
                  desc: '500 nakyly tamamlap çözüň.',
                  current: min(provider.completedQuestions, 500),
                  target: 500,
                  isUnlocked: provider.completedQuestions >= 500,
                ),

                // 5. 💯 Kämillik (100 questions in a row)
                _buildAchievementCard(
                  icon: '💯',
                  title: 'Kämillik',
                  desc: 'Yzly-yzyna 100 soraga dogry jogap beriň.',
                  current: min(provider.longestStreak, 100),
                  target: 100,
                  isUnlocked: provider.longestStreak >= 100,
                ),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: auth.busy
                        ? null
                        : () {
                            if (auth.isAuthenticated) {
                              auth.logout();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AuthScreen(),
                                ),
                              );
                            }
                          },
                    icon: Icon(
                      auth.isAuthenticated
                          ? LucideIcons.logOut
                          : LucideIcons.logIn,
                    ),
                    label: Text(
                      auth.isAuthenticated ? 'Hasapdan çyk' : 'Hasaba gir',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: auth.isAuthenticated
                          ? AppTheme.wrong
                          : AppTheme.accent,
                      side: BorderSide(
                        color: auth.isAuthenticated
                            ? AppTheme.wrong
                            : AppTheme.accent,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required String icon,
    required String title,
    required String desc,
    required int current,
    required int target,
    required bool isUnlocked,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.cardBg : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.accent.withValues(alpha: 0.4)
              : Colors.white10,
          width: isUnlocked ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? AppTheme.accent.withValues(alpha: 0.2)
                  : Colors.white10,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isUnlocked
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '$current / $target',
                      style: TextStyle(
                        color: isUnlocked ? AppTheme.gold : Colors.white38,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isUnlocked ? AppTheme.gold : AppTheme.accent,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            isUnlocked ? Icons.star_rounded : Icons.lock_rounded,
            color: isUnlocked ? AppTheme.gold : Colors.white24,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: AppTheme.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
