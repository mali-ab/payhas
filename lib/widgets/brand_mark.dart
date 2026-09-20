import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Sözi Tap speech-bubble word-puzzle mark.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    final tileSize = size * .24;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size * .88,
            height: size * .70,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(size * .26),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: .28),
                  blurRadius: size * .22,
                  offset: Offset(0, size * .08),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: size * .08,
            left: size * .18,
            child: Transform.rotate(
              angle: -.55,
              child: Container(
                width: size * .24,
                height: size * .24,
                decoration: const BoxDecoration(color: AppTheme.primary),
              ),
            ),
          ),
          Positioned(
            top: size * .25,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LetterTile(letter: 'S', size: tileSize),
                SizedBox(width: size * .045),
                _LetterTile(letter: 'O', size: tileSize),
                SizedBox(width: size * .045),
                _LetterTile(letter: '?', size: tileSize, missing: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({required this.letter, required this.size, this.missing = false});

  final String letter;
  final double size;
  final bool missing;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: missing ? AppTheme.goldContainer : Colors.white,
          borderRadius: BorderRadius.circular(size * .24),
        ),
        child: Text(
          letter,
          style: TextStyle(
            color: missing ? AppTheme.gold : AppTheme.primaryDark,
            fontSize: size * .60,
            height: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
