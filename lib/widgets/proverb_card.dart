import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProverbCard extends StatelessWidget {
  final String text;

  const ProverbCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // Replace blank marker with a styled underline span
    final parts = text.split('______');
    final hasBlank = parts.length == 2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: AppTheme.glassMorphism.copyWith(
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.18),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Nakyl',
                style: TextStyle(
                  color: AppTheme.accentLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          hasBlank
              ? RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                    children: [
                      TextSpan(text: parts[0]),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: AppTheme.accentGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '  ?  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: parts[1]),
                    ],
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
        ],
      ),
    );
  }
}
