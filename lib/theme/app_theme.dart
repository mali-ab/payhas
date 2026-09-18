import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette
  static const Color bg1 = Color(0xFF0D0E21);
  static const Color bg2 = Color(0xFF1A1B3A);
  static const Color accent = Color(0xFF6C63FF);
  static const Color accentLight = Color(0xFF9D97FF);
  static const Color gold = Color(0xFFFFD700);
  static const Color cardBg = Color(0x22FFFFFF);
  static const Color cardBorder = Color(0x44FFFFFF);
  static const Color correct = Color(0xFF4CAF50);
  static const Color wrong = Color(0xFFEF5350);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0CC);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg1,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: accentLight,
          surface: bg2,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      );

  static LinearGradient get bgGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [bg1, bg2, Color(0xFF12133A)],
      );

  static LinearGradient get accentGradient => const LinearGradient(
        colors: [accent, Color(0xFF9B59B6)],
      );

  static BoxDecoration get glassMorphism => BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder, width: 1.5),
      );
}
