import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/proverb.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onHardSubmit(GameProvider game) {
    if (_textController.text.trim().isEmpty) return;
    game.updateTypedAnswer(_textController.text.trim());
    game.checkTypedAnswer();
  }

  void _handleContinue(BuildContext context, GameProvider game) {
    _textController.clear();
    if (game.lives <= 0) {
      _showGameOverDialog(context, game);
      return;
    }
    game.advanceNext();
  }

  void _showGameOverDialog(BuildContext context, GameProvider game) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bg2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.heart_broken_rounded, color: AppTheme.wrong, size: 22),
            Text(
              'Janlaryňyz gutardy!',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ähli ýürekleriňiz sarp edildi. 50 teňňe berip janlaryňyzy dolduryp bilersiňiz ýa-da oýny tamamlap bilersiňiz.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text(
                  'Häzirki teňňäňiz: ',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                Text(
                  '${game.coins} teňňe',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              game.advanceNext(); // finishes game
            },
            child: const Text(
              'Netijäni gör',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          if (game.coins >= 50)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final success = game.refillLives(cost: 50);
                Navigator.of(ctx).pop();
                if (success) {
                  game.advanceNext();
                }
              },
              child: const Text(
                '50 teňňä jan al (❤️ x5)',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _showHintSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.bg2,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.finished) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ResultScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) => FadeTransition(opacity: animation, child: child),
                transitionDuration: const Duration(milliseconds: 350),
              ),
            );
          });
        }

        if (game.loading || game.current == null) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: AppTheme.bgGradient),
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.accent),
              ),
            ),
          );
        }

        final proverb = game.current!;
        final progress = (game.currentIndex + 1) / game.total;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(gradient: AppTheme.bgGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Navigation & Stats Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: AppTheme.glassMorphism.copyWith(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Sorag 7 / 20 Display
                            Text(
                              'Sorag ${game.currentIndex + 1} / ${game.total}',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),

                            // Lives / Hearts
                            Row(
                              children: List.generate(
                                GameProvider.maxLives,
                                (i) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1.5,
                                  ),
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    size: 18,
                                    color: i < game.lives
                                        ? const Color(0xFFFF5252)
                                        : AppTheme.outlineVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Coins Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppTheme.gold.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                '${game.coins} teňňe',
                                style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Sub info: Category, Difficulty, Streak & Progress
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.cardBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                proverb.category,
                                style: const TextStyle(
                                  color: AppTheme.accentLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.cardBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                game.difficultyTitle,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (game.streak >= 2) ...[
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  Text(
                                    '${game.streak}x yzygiderli!',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Spacer(),
                            Text(
                              '+20 XP',
                              style: TextStyle(
                                color: Colors.purple.shade200,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppTheme.cardBg,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.accent,
                            ),
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Scroll Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Proverb Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: AppTheme.glassMorphism,
                            child: Column(
                              children: [
                                const Text(
                                  'Sorag:',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  game.awaitingContinue
                                      ? '“${proverb.completedText}”'
                                      : '“${proverb.questionText}”',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: game.awaitingContinue
                                        ? (game.answerState ==
                                                  AnswerState.correct
                                              ? const Color(0xFF81C784)
                                              : const Color(0xFFFFB74D))
                                        : AppTheme.textPrimary,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Hints toolbar
                          _buildHintsBar(context, game),

                          const SizedBox(height: 14),

                          // Interaction Area based on Difficulty
                          if (game.difficulty == Difficulty.easy)
                            _buildEasyOptions(game, proverb.answer)
                          else if (game.difficulty == Difficulty.medium)
                            _buildMediumWordAssembly(game)
                          else
                            _buildHardManualTyping(game),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Feedback & Continue Area (When Answered)
                  if (game.awaitingContinue)
                    _buildFeedbackBottomPanel(context, game, proverb),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Hints Toolbar
  Widget _buildHintsBar(BuildContext context, GameProvider game) {
    if (game.awaitingContinue) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Maslahat (Remove one wrong option)
              _HintButton(
                icon: Icons.lightbulb_outline_rounded,
                label: 'Maslahat',
                cost: 20,
                isEnabled:
                    game.coins >= 20 &&
                    game.difficulty == Difficulty.easy &&
                    game.removedOptions.length < 2,
                onTap: () {
                  final ok = game.useHintRemoveWrong();
                  if (!ok) {
                    _showHintSnackbar(
                      context,
                      'Ýeterlik teňňäňiz ýok (20 teňňe gerek)',
                    );
                  }
                },
              ),

              // Jogabyň bir bölegini görkez
              _HintButton(
                icon: Icons.search_rounded,
                label: 'Bölek görkez',
                cost: 30,
                isEnabled: game.coins >= 30 && game.revealedPart == null,
                onTap: () {
                  final ok = game.useHintRevealPart();
                  if (ok && game.difficulty == Difficulty.hard) {
                    _textController.value = TextEditingValue(
                      text: game.typedAnswer,
                      selection: TextSelection.collapsed(
                        offset: game.typedAnswer.length,
                      ),
                    );
                  }
                  if (!ok) {
                    _showHintSnackbar(
                      context,
                      'Ýeterlik teňňäňiz ýok (30 teňňe gerek)',
                    );
                  }
                },
              ),

              // ❤️ Durmuş (Restore one life)
              _HintButton(
                icon: Icons.favorite_outline_rounded,
                label: 'Durmuş',
                cost: 25,
                isEnabled:
                    game.coins >= 25 && game.lives < GameProvider.maxLives,
                onTap: () {
                  if (game.lives >= GameProvider.maxLives) {
                    _showHintSnackbar(context, 'Janlaryňyz eýýäm doly!');
                    return;
                  }
                  final ok = game.useHintRestoreLife();
                  if (!ok) {
                    _showHintSnackbar(
                      context,
                      'Ýeterlik teňňäňiz ýok (25 teňňe gerek)',
                    );
                  }
                },
              ),
            ],
          ),
          if (game.revealedPart != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.accentLight,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Jogabyň başlangyjy: "${game.revealedPart}..."',
                    style: const TextStyle(
                      color: AppTheme.accentLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 1. Easy: Four multiple choice answers (hiding/striking removed options)
  Widget _buildEasyOptions(GameProvider game, String correctAnswer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jogap saýlaň:',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...game.shuffledOptions.map((option) {
          final isRemoved = game.removedOptions.contains(option);

          if (isRemoved) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Text(
                      option,
                      style: const TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.block_rounded,
                      color: AppTheme.textTertiary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }

          final isSelected = game.selectedOption == option;
          final isCorrect =
              option.toLowerCase().trim() == correctAnswer.toLowerCase().trim();

          Color borderColor = AppTheme.cardBorder;
          Color bgColor = AppTheme.cardBg;
          Color textColor = AppTheme.textPrimary;

          if (game.awaitingContinue) {
            if (isCorrect) {
              borderColor = AppTheme.correct;
              bgColor = AppTheme.correct.withValues(alpha: 0.25);
              textColor = AppTheme.correct;
            } else if (isSelected) {
              borderColor = AppTheme.wrong;
              bgColor = AppTheme.wrong.withValues(alpha: 0.25);
              textColor = AppTheme.wrong;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => game.selectOption(option),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
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
                    if (game.awaitingContinue && isCorrect)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.correct,
                        size: 22,
                      ),
                    if (game.awaitingContinue && isSelected && !isCorrect)
                      const Icon(
                        Icons.cancel_rounded,
                        color: AppTheme.wrong,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // 2. Medium: Arrange scrambled letters
  Widget _buildMediumWordAssembly(GameProvider game) {
    final wordLengths = game.mediumWordLengths;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Harplary tertipleşdiriň:',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!game.awaitingContinue && game.assembledLetters.isNotEmpty)
              GestureDetector(
                onTap: game.clearAssembledLetters,
                child: const Text(
                  'Arassala',
                  style: TextStyle(
                    color: AppTheme.accentLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),

        // Assembled slots row
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            children: [
              for (
                var wordIndex = 0;
                wordIndex < wordLengths.length;
                wordIndex++
              ) ...[
                Builder(
                  builder: (context) {
                    final wordStart = wordLengths
                        .take(wordIndex)
                        .fold<int>(0, (sum, length) => sum + length);
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(wordLengths[wordIndex], (
                        letterIndex,
                      ) {
                        final index = wordStart + letterIndex;
                        final hasLetter = index < game.assembledLetters.length;
                        final letter = hasLetter
                            ? game.assembledLetters[index]
                            : '';

                        return GestureDetector(
                          onTap: () {
                            if (hasLetter && !game.awaitingContinue) {
                              game.removeAssembledLetter(index);
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 48,
                            decoration: BoxDecoration(
                              color: hasLetter
                                  ? AppTheme.accent.withValues(alpha: 0.3)
                                  : AppTheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: hasLetter
                                    ? AppTheme.primary
                                    : AppTheme.outline,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  color: AppTheme.primaryDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                if (wordIndex < wordLengths.length - 1)
                  const SizedBox(height: 10),
              ],
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Scrambled letter tiles
        if (!game.awaitingContinue)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: List.generate(game.scrambledLetters.length, (index) {
              final isUsed = game.letterUsed[index];
              final char = game.scrambledLetters[index];

              return InkWell(
                onTap: () => game.toggleScrambledLetter(index),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isUsed
                        ? AppTheme.surfaceContainerHigh
                        : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isUsed
                          ? AppTheme.outlineVariant
                          : AppTheme.cardBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      char,
                      style: TextStyle(
                        color: isUsed
                            ? AppTheme.textTertiary
                            : AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  // 3. Hard: Manual typing with a complete in-game keyboard
  Widget _buildHardManualTyping(GameProvider game) {
    const keyboardRows = [
      ['a', 'b', 'ç', 'd', 'e', 'ä', 'f', 'g', 'h'],
      ['i', 'j', 'ž', 'k', 'l', 'm', 'n', 'ň', 'o', 'ö'],
      ['p', 'r', 's', 'ş', 't', 'u', 'ü', 'w', 'y', 'ý', 'z'],
      ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '-'],
    ];

    void insert(String value) {
      final selection = _textController.selection;
      final start = selection.isValid
          ? selection.start
          : _textController.text.length;
      final end = selection.isValid ? selection.end : start;
      _textController.value = TextEditingValue(
        text: _textController.text.replaceRange(start, end, value),
        selection: TextSelection.collapsed(offset: start + value.length),
      );
      game.updateTypedAnswer(_textController.text);
    }

    void backspace() {
      final selection = _textController.selection;
      if (_textController.text.isEmpty) return;
      final end = selection.isValid
          ? selection.end
          : _textController.text.length;
      final start = selection.isValid && selection.start != selection.end
          ? selection.start
          : (end > 0 ? end - 1 : 0);
      _textController.value = TextEditingValue(
        text: _textController.text.replaceRange(start, end, ''),
        selection: TextSelection.collapsed(offset: start),
      );
      game.updateTypedAnswer(_textController.text);
    }

    Widget keyboardRow(List<String> characters) => Row(
      children: [
        for (var index = 0; index < characters.length; index++) ...[
          if (index > 0) const SizedBox(width: 4),
          Expanded(
            child: _KeyboardKey(
              label: characters[index],
              onTap: () => insert(characters[index]),
            ),
          ),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ýitirilen sözi ýazyň:',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Text Field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                readOnly: true,
                showCursor: true,
                enabled: !game.awaitingContinue,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: 'Sözi şu ýere ýazyň...',
                  hintStyle: const TextStyle(color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.cardBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.accentLight,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: game.updateTypedAnswer,
                onSubmitted: (_) => _onHardSubmit(game),
              ),
            ),
            if (!game.awaitingContinue) ...[
              const SizedBox(width: 10),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  onPressed: () => _onHardSubmit(game),
                  child: const Text(
                    'Barla',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 14),

        // Complete Turkmen alphabet, numbers and answer punctuation.
        if (!game.awaitingContinue)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Column(
              children: [
                for (final row in keyboardRows) ...[
                  keyboardRow(row),
                  const SizedBox(height: 6),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _KeyboardKey(
                        label: 'Boşluk',
                        wide: true,
                        onTap: () => insert(' '),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _KeyboardKey(
                      icon: Icons.backspace_outlined,
                      onTap: backspace,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  // 4. Feedback Bottom Panel (Shows Dogry! / Nädogry!, completed proverb, and [ DOWAM ET ])
  Widget _buildFeedbackBottomPanel(
    BuildContext context,
    GameProvider game,
    Proverb proverb,
  ) {
    final isCorrect = game.answerState == AnswerState.correct;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFF14301D) : const Color(0xFF331618),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isCorrect ? AppTheme.correct : AppTheme.wrong,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Success/Failure Animated Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCorrect
                      ? AppTheme.correct.withValues(alpha: 0.25)
                      : AppTheme.wrong.withValues(alpha: 0.25),
                ),
                child: Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: isCorrect ? AppTheme.correct : AppTheme.wrong,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),

              // Title: Dogry! or Nädogry!
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect ? 'Dogry!' : 'Nädogry!',
                    style: TextStyle(
                      color: isCorrect ? AppTheme.correct : AppTheme.wrong,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    isCorrect
                        ? '+10 bal  •  +20 XP  •  +5 teňňe'
                        : 'Dogry jogap: "${proverb.answer}"  •  -1 ❤️',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Completed Proverb Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              proverb.hasMissingWord
                  ? 'Doly görnüşi: “${proverb.completedText}”'
                  : 'Dogry jogap: ${proverb.answer}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // [ DOWAM ET ] Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? AppTheme.correct : AppTheme.wrong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              onPressed: () => _handleContinue(context, game),
              child: const Text(
                'DOWAM ET',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  const _KeyboardKey({
    this.label,
    this.icon,
    required this.onTap,
    this.wide = false,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) => Material(
    color: AppTheme.surface,
    borderRadius: BorderRadius.circular(9),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        constraints: BoxConstraints(minWidth: wide ? 110 : 0, minHeight: 40),
        padding: EdgeInsets.symmetric(horizontal: wide ? 9 : 2, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppTheme.outlineVariant),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 18, color: AppTheme.primary)
            : Text(
                label!,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    ),
  );
}

class _HintButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int cost;
  final bool isEnabled;
  final VoidCallback onTap;

  const _HintButton({
    required this.icon,
    required this.label,
    required this.cost,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppTheme.accent.withValues(alpha: 0.15)
              : AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? AppTheme.accent.withValues(alpha: 0.35)
                : AppTheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isEnabled ? AppTheme.primary : AppTheme.textTertiary,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled
                        ? AppTheme.primaryDark
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '$cost teňňe',
                  style: TextStyle(
                    color: isEnabled ? AppTheme.gold : AppTheme.textTertiary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
