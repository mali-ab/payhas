import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String _selectedCategory = 'Hemmesi';
  Difficulty _selectedDifficulty = Difficulty.easy;

  final List<Map<String, String>> _categories = const [
    {'name': 'Hemmesi', 'icon': '🌟', 'desc': 'Ähli ugurlar boýunça nakyllar'},
    {'name': 'Maşgala', 'icon': '👨‍👩‍👧', 'desc': 'Öý-ojak, ata-ene we çagalar'},
    {'name': 'Dostluk', 'icon': '🤝', 'desc': 'Agzybirlik, ynam we dostlar'},
    {'name': 'Zähmet', 'icon': '💼', 'desc': 'Işjeňlik, hünär we bereket'},
    {'name': 'Akyl-paýhas', 'icon': '🧠', 'desc': 'Danalyk we pähim-paýhas'},
    {'name': 'Söýgi', 'icon': '❤️', 'desc': 'Watan, yşk we mähir'},
    {'name': 'Bilim', 'icon': '📚', 'desc': 'Okamak, kitap we ylym'},
    {'name': 'Durmuş', 'icon': '🌱', 'desc': 'Ýaşaýyş, tejribe we ömür'},
    {'name': 'Adamçylyk', 'icon': '🗣️', 'desc': 'Edep-terbiýe we päklik'},
    {'name': 'Üstünlik', 'icon': '🏆', 'desc': 'Ýeňiş, maksat we zähmet'},
    {'name': 'Sabyr', 'icon': '⏳', 'desc': 'Çydamlylyk we kanagat'},
  ];

  void _startGame() {
    final provider = context.read<GameProvider>();
    provider.startNewGame(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      questionCount: 20,
    );

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GameScreen(),
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
                      'Oýun Sazlamalary',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Difficulty Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kynlyk derejesi:',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        children: [
                          _buildDifficultyTab(
                            title: 'Ýeňil',
                            icon: Icons.check_circle_outline_rounded,
                            difficulty: Difficulty.easy,
                          ),
                          _buildDifficultyTab(
                            title: 'Orta',
                            icon: Icons.extension_rounded,
                            difficulty: Difficulty.medium,
                          ),
                          _buildDifficultyTab(
                            title: 'Kyn',
                            icon: Icons.keyboard_rounded,
                            difficulty: Difficulty.hard,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getDifficultyDescription(_selectedDifficulty),
                      style: const TextStyle(
                        color: AppTheme.accentLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Category Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'Kategoriýany saýlaň:',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Categories Grid / List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat['name'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat['name']!;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.accent.withValues(alpha: 0.22)
                                : AppTheme.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.accentLight
                                  : AppTheme.cardBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                cat['icon']!,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat['name']!,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : AppTheme.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      cat['desc']!,
                                      style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppTheme.accentLight,
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Start Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withValues(alpha: 0.45),
                          blurRadius: 20,
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
                      onPressed: _startGame,
                      child: const Text(
                        'BAŞLA (20 Sorag)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyTab({
    required String title,
    required IconData icon,
    required Difficulty difficulty,
  }) {
    final isSelected = _selectedDifficulty == difficulty;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDifficulty = difficulty),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDifficultyDescription(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        return '💡 Ýeňil: 4 sany saýlaw warianty berilýär.';
      case Difficulty.medium:
        return '🧩 Orta: Berlen harplary basyp sözi düzmeli.';
      case Difficulty.hard:
        return '✍️ Kyn: Ýitirilen sözi el bilen ýazmaly.';
    }
  }
}
