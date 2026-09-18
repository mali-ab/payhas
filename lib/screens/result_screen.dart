import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleFade = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getMessage(int correct, int total) {
    if (total == 0) return 'Gowy synanyşyk! 👏';
    final ratio = correct / total;
    if (ratio >= 0.85) return 'Ajaýyp! 🎉';
    if (ratio >= 0.6) return 'Gowy netije! 👏';
    if (ratio >= 0.35) return 'Dowam et! 💪';
    return 'Gaýrat et! 📚';
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final isNewRecord = game.score >= game.highScore && game.score > 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Trophy Icon
                ScaleTransition(
                  scale: _scaleFade,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isNewRecord
                            ? [AppTheme.gold, const Color(0xFFFF9800)]
                            : [AppTheme.accent, const Color(0xFF9B59B6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isNewRecord ? AppTheme.gold : AppTheme.accent)
                              .withValues(alpha: 0.5),
                          blurRadius: 32,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      isNewRecord
                          ? Icons.emoji_events_rounded
                          : Icons.star_rounded,
                      size: 54,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  _getMessage(game.correctCount, game.currentIndex + 1),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (isNewRecord) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppTheme.gold.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      '🏆 Täze rekord!',
                      style: TextStyle(
                        color: AppTheme.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Score Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: AppTheme.glassMorphism,
                  child: Column(
                    children: [
                      const Text(
                        'Oýun baly',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.accentGradient.createShader(bounds),
                        child: Text(
                          '${game.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Divider(color: AppTheme.cardBorder, height: 28),

                      // Detailed Stats Row 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.check_circle_rounded,
                            color: AppTheme.correct,
                            label: 'Dogry',
                            value: '${game.correctCount}',
                          ),
                          _StatItem(
                            icon: Icons.cancel_rounded,
                            color: AppTheme.wrong,
                            label: 'Ýalňyş',
                            value: '${game.wrongCount}',
                          ),
                          _StatItem(
                            icon: Icons.quiz_rounded,
                            color: AppTheme.accentLight,
                            label: 'Soraglar',
                            value: '${game.currentIndex + 1} / ${game.total}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Category & Difficulty Tags
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Kategoriýa: ${game.selectedCategory}',
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Kynlyk: ${game.difficultyTitle}',
                              style: const TextStyle(
                                  color: AppTheme.accentLight, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Play Again Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withValues(alpha: 0.4),
                          blurRadius: 18,
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
                      onPressed: () async {
                        await game.restart();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Täzeden oýna',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Return Home Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );
                    },
                    child: const Text(
                      'Baş sahypa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
