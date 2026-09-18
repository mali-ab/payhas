import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class DailyQuestionScreen extends StatefulWidget {
  const DailyQuestionScreen({super.key});

  @override
  State<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  String? _selectedOption;
  bool _answered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<GameProvider>();
      if (!provider.dailyCompleted) {
        provider.startDailyChallenge();
      }
    });
  }

  void _onSelect(String option, String correctAnswer) {
    if (_answered) return;
    final isCorrect =
        (option.toLowerCase().trim() == correctAnswer.toLowerCase().trim());
    setState(() {
      _selectedOption = option;
      _answered = true;
      _isCorrect = isCorrect;
    });
  }

  void _onNext(GameProvider provider) {
    provider.advanceDailyQuestion(_isCorrect);
    if (provider.dailyFinished) {
      provider.claimDailyChallengeReward();
    } else {
      setState(() {
        _selectedOption = null;
        _answered = false;
        _isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    // If daily was already completed today and not in progress
    if (provider.dailyCompleted &&
        (!provider.dailyFinished && provider.dailyProverbs.isEmpty)) {
      return _buildAlreadyCompletedScreen(provider);
    }

    // If just finished the 5 questions
    if (provider.dailyFinished) {
      return _buildCompletionRewardScreen(provider);
    }

    if (provider.loading || provider.currentDaily == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.bgGradient),
          child: const Center(
            child: CircularProgressIndicator(color: AppTheme.accent),
          ),
        ),
      );
    }

    final proverb = provider.currentDaily!;
    final progress = (provider.dailyIndex + 1) / 5.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Padding(
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
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'GÜNDELİK SORAG',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
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

                const SizedBox(height: 18),

                // Banner: Şu gün 5 nakyly tamamla!
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE65100), Color(0xFFF57C00)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE65100).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Şu gün 5 nakyly tamamla!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Sorag ${provider.dailyIndex + 1} / 5 • 🔥 ${provider.streakDays} gün yzygiderlilik',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Progress Indicator
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.cardBg,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF57C00)),
                    minHeight: 5,
                  ),
                ),

                const SizedBox(height: 22),

                // Proverb Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: AppTheme.glassMorphism,
                  child: Column(
                    children: [
                      Text(
                        _answered
                            ? 'Tamamlanan nakyl:'
                            : 'Nokatlaryň ýerine dogry sözi goýuň:',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _answered
                            ? '“${proverb.completedText}”'
                            : '“${proverb.text}”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _answered
                              ? (_isCorrect
                                  ? const Color(0xFF81C784)
                                  : const Color(0xFFFFB74D))
                              : AppTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Jogap wariantlary:',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // Options List
                Expanded(
                  child: ListView.builder(
                    itemCount: proverb.options.length,
                    itemBuilder: (context, index) {
                      final option = proverb.options[index];
                      final isChosen = _selectedOption == option;
                      final isRight = option.toLowerCase().trim() ==
                          proverb.answer.toLowerCase().trim();

                      Color borderColor = AppTheme.cardBorder;
                      Color bgColor = AppTheme.cardBg;
                      Color textColor = AppTheme.textPrimary;

                      if (_answered) {
                        if (isRight) {
                          borderColor = AppTheme.correct;
                          bgColor = AppTheme.correct.withValues(alpha: 0.25);
                          textColor = AppTheme.correct;
                        } else if (isChosen) {
                          borderColor = AppTheme.wrong;
                          bgColor = AppTheme.wrong.withValues(alpha: 0.25);
                          textColor = AppTheme.wrong;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => _onSelect(option, proverb.answer),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 15),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: borderColor, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (_answered && isRight)
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppTheme.correct, size: 20),
                                if (_answered && isChosen && !isRight)
                                  const Icon(Icons.cancel_rounded,
                                      color: AppTheme.wrong, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Continue / Next Button
                if (_answered) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isCorrect ? AppTheme.correct : AppTheme.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _onNext(provider),
                      child: Text(
                        provider.dailyIndex < 4
                            ? 'İNDİKİ SORAG (${provider.dailyIndex + 2}/5)'
                            : 'SYNAGY TAMAMLA',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Completion Reward Screen (🎉 Gutlaýarys! +100 XP, +50 🪙)
  Widget _buildCompletionRewardScreen(GameProvider provider) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Animated celebration badge
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withValues(alpha: 0.5),
                        blurRadius: 36,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 54)),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Gutlaýarys!',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Şu günki 5 nakyly üstünlikli tamamladyňyz!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 32),

                // Rewards Card (+100 XP, +50 🪙)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.glassMorphism,
                  child: Column(
                    children: [
                      const Text(
                        'Gazanan baýraklaryňyz:',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _RewardBadge(
                            icon: '⭐',
                            value: '+100 XP',
                            color: Colors.purple.shade300,
                          ),
                          _RewardBadge(
                            icon: '🪙',
                            value: '+50 teňňe',
                            color: AppTheme.gold,
                          ),
                        ],
                      ),
                      const Divider(color: AppTheme.cardBorder, height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: Colors.orange, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            '🔥 ${provider.streakDays} gün yzygiderlilik gazandyňyz!',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Done Button
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Baş sahypa dolan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Already Completed Screen
  Widget _buildAlreadyCompletedScreen(GameProvider provider) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.correct.withValues(alpha: 0.15),
                    border: Border.all(color: AppTheme.correct, width: 2),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: AppTheme.correct,
                    size: 52,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Günüň synagy tamamlandy!',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Siz şu günki 5 nakyly üstünlikli çözdüňiz.\n🔥 ${provider.streakDays} gün yzygiderlilik dowam edýär.\nErtir täze synag açylar!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Yza dolan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;

  const _RewardBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
