import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  final List<Map<String, dynamic>> _levels = const [
    {
      'level': 1,
      'title': 'Başlangyç',
      'desc': 'Söz dünýäsine ilkinji ädim',
      'requiredScore': 0,
      'stars': 3,
    },
    {
      'level': 2,
      'title': 'Şägirt',
      'desc': 'Aňyňy we pikiriňi ösdür',
      'requiredScore': 200,
      'stars': 3,
    },
    {
      'level': 3,
      'title': 'Synagçy',
      'desc': 'Kynrak nakyllaryň synagy',
      'requiredScore': 500,
      'stars': 3,
    },
    {
      'level': 4,
      'title': 'Gözlegçi',
      'desc': 'Çuňňur manyly sözler',
      'requiredScore': 800,
      'stars': 3,
    },
    {
      'level': 5,
      'title': 'Bilgir',
      'desc': 'Diliň baýlygyna düşünýän',
      'requiredScore': 1200,
      'stars': 2,
    },
    {
      'level': 6,
      'title': 'Paýhasly',
      'desc': 'Kämilleşen söz ussady',
      'requiredScore': 1600,
      'stars': 0,
    },
    {
      'level': 7,
      'title': 'Danalyk',
      'desc': 'Halk döredijiliginiň bilermeni',
      'requiredScore': 2000,
      'stars': 0,
    },
    {
      'level': 8,
      'title': 'Alym',
      'desc': 'Ýokary derejeli paýhas eýesi',
      'requiredScore': 2500,
      'stars': 0,
    },
    {
      'level': 9,
      'title': 'Danyşment',
      'desc': 'Söz sungatynyň ussady',
      'requiredScore': 3200,
      'stars': 0,
    },
    {
      'level': 10,
      'title': 'Beýik Paýhas',
      'desc': 'Iň ýokary mertebe',
      'requiredScore': 4000,
      'stars': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentLevel = context.watch<GameProvider>().level;

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
                      'Derejeler',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Current Level Header Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.military_tech_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Häzirki derejäňiz: $currentLevel-nji dereje',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Nakyllary çözüp täze derejeleri açyň!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Levels List
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: _levels.length,
                  itemBuilder: (context, index) {
                    final item = _levels[index];
                    final lvl = item['level'] as int;
                    final isUnlocked = lvl <= currentLevel;
                    final isCurrent = lvl == currentLevel;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppTheme.accent.withValues(alpha: 0.2)
                            : AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCurrent
                              ? AppTheme.accent
                              : (isUnlocked
                                  ? AppTheme.cardBorder
                                  : Colors.white10),
                          width: isCurrent ? 2 : 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isUnlocked
                                  ? (isCurrent
                                      ? AppTheme.accentGradient
                                      : const LinearGradient(colors: [
                                          Color(0xFF388E3C),
                                          Color(0xFF66BB6A)
                                        ]))
                                  : const LinearGradient(colors: [
                                      Color(0xFF424242),
                                      Color(0xFF616161)
                                    ]),
                            ),
                            child: Center(
                              child: isUnlocked
                                  ? Text(
                                      '$lvl',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.lock_rounded,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '$lvl-nji dereje: ${item['title']}',
                                      style: TextStyle(
                                        color: isUnlocked
                                            ? AppTheme.textPrimary
                                            : AppTheme.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (isCurrent) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Häzirki',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['desc'] as String,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isUnlocked && !isCurrent)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.correct,
                              size: 22,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
