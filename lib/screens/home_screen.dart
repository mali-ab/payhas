import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import 'category_selection_screen.dart';
import 'daily_question_screen.dart';
import 'levels_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'subject_tests_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Initialize provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().init();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startGame(BuildContext context) {
    _navigateTo(context, const CategorySelectionScreen());
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TopBadge(
                                icon: LucideIcons.trophy,
                                label: '${game.level}-nji dereje',
                                value: game.levelTitle,
                                color: AppTheme.primary,
                                onTap: () =>
                                    _navigateTo(context, const LevelsScreen()),
                              ),
                              _TopBadge(
                                icon: LucideIcons.coins,
                                label: '${game.coins}',
                                value: 'teňňe',
                                color: AppTheme.gold,
                                onTap: () =>
                                    _navigateTo(context, const ProfileScreen()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const BrandMark(size: 96),
                          const SizedBox(height: 18),
                          ShaderMask(
                            shaderCallback:
                                AppTheme.accentGradient.createShader,
                            child: const Text(
                              'SÖZİ TAP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Akyl-ylmyňy syna!',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _StatsCard(
                            score: _formatNumber(game.highScore),
                            streak: game.streakDays,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
                    child: Column(
                      children: [
                        _GradientButton(
                          label: 'OÝNA',
                          icon: LucideIcons.play,
                          onPressed: () => _startGame(context),
                        ),
                        const SizedBox(height: 12),
                        _GradientButton(
                          label: 'DERS SYNAGLARY',
                          icon: LucideIcons.graduationCap,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6842A0), Color(0xFF8C5BC4)],
                          ),
                          onPressed: () =>
                              _navigateTo(context, const SubjectTestsScreen()),
                        ),
                        const SizedBox(height: 12),
                        _GradientButton(
                          label: 'GÜNDELİK SORAG',
                          icon: LucideIcons.flame,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE65100), Color(0xFFF57C00)],
                          ),
                          onPressed: () =>
                              _navigateTo(context, const DailyQuestionScreen()),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _NavMenuButton(
                                icon: LucideIcons.layers3,
                                label: 'Derejeler',
                                onTap: () =>
                                    _navigateTo(context, const LevelsScreen()),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _NavMenuButton(
                                icon: LucideIcons.chartNoAxesCombined,
                                label: 'Reýting',
                                onTap: () => _navigateTo(
                                  context,
                                  const LeaderboardScreen(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _NavMenuButton(
                                icon: LucideIcons.userRound,
                                label: 'Profil',
                                onTap: () =>
                                    _navigateTo(context, const ProfileScreen()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatNumber(int num) {
    if (num < 1000) return '$num';
    final s = '$num';
    final len = s.length;
    final prefix = s.substring(0, len - 3);
    final suffix = s.substring(len - 3);
    return '$prefix $suffix';
  }
}

class _TopBadge extends StatelessWidget {
  const _TopBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            '$label ',
            style: TextStyle(
              color: color == AppTheme.primary ? AppTheme.primaryDark : color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.score, required this.streak});
  final String score;
  final int streak;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    decoration: AppTheme.glassMorphism.copyWith(
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppTheme.gold, size: 19),
        const SizedBox(width: 5),
        Text(
          '$score bal',
          style: const TextStyle(
            color: AppTheme.gold,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        Container(
          width: 1,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          color: AppTheme.cardBorder,
        ),
        const Icon(
          Icons.local_fire_department_rounded,
          color: Color(0xFFE8663D),
          size: 19,
        ),
        const SizedBox(width: 5),
        Text(
          '$streak gün',
          style: const TextStyle(
            color: Color(0xFFE8663D),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.gradient,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: .24),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    ),
  );
}

class _NavMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        decoration: AppTheme.glassMorphism.copyWith(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
