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
            FadeTransition(
          opacity: animation,
          child: child,
        ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Top Bar: Player Level & Coins
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Player Level Badge
                        InkWell(
                          onTap: () => _navigateTo(context, const LevelsScreen()),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.accent.withValues(alpha: 0.45),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.trophy,
                                  color: AppTheme.accentLight,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${game.level}-nji dereje • ${game.levelTitle}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Coins Badge
                        InkWell(
                          onTap: () => _navigateTo(context, const ProfileScreen()),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.gold.withValues(alpha: 0.45),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.coins,
                                  color: AppTheme.gold,
                                  size: 17,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${game.coins} teňňe',
                                  style: const TextStyle(
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // App Logo & Title
                    const BrandMark(size: 96),

                    const SizedBox(height: 20),

                    // Title: SÖZİ TAP
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.accentGradient.createShader(bounds),
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

                    // Subtitle: Akyl-ylmyňy syna!
                    const Text(
                      'Akyl-ylmyňy syna!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Score & Streak Indicators Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      decoration: AppTheme.glassMorphism.copyWith(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ⭐ Current Score
                          Row(
                            children: [
                              const Text('⭐ ', style: TextStyle(fontSize: 18)),
                              Text(
                                '${_formatNumber(game.highScore)} bal',
                                style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 20),
                          Container(
                            width: 1.5,
                            height: 20,
                            color: AppTheme.cardBorder,
                          ),
                          const SizedBox(width: 20),

                          // 🔥 Streak
                          Row(
                            children: [
                              const Text('🔥 ', style: TextStyle(fontSize: 18)),
                              Text(
                                '${game.streakDays} gün',
                                style: const TextStyle(
                                  color: Color(0xFFFF8A65),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 1),

                    // [ OÝNA ] Button
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accent.withValues(alpha: 0.45),
                              blurRadius: 22,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () => _startGame(context),
                          child: const Text(
                            'OÝNA',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // [ GÜNDELİK SORAG ] Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE65100), Color(0xFFF57C00)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFE65100).withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () =>
                              _navigateTo(context, const DailyQuestionScreen()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(LucideIcons.flame,
                                  color: Colors.white, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'GÜNDELİK SORAG',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Secondary Navigation Row: Derejeler, Reýting, Profil
                    Row(
                      children: [
                        // “Derejeler” button
                        Expanded(
                          child: _NavMenuButton(
                            icon: LucideIcons.layers3,
                            label: 'Derejeler',
                            onTap: () =>
                                _navigateTo(context, const LevelsScreen()),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // “Reýting” button
                        Expanded(
                          child: _NavMenuButton(
                            icon: LucideIcons.chartNoAxesCombined,
                            label: 'Reýting',
                            onTap: () =>
                                _navigateTo(context, const LeaderboardScreen()),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // “Profil” button
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

                    const SizedBox(height: 24),
                  ],
                ),
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
            Icon(icon, color: AppTheme.accentLight, size: 22),
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
