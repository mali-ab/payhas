import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Turkmen-inspired color palette - Light theme
  static const Color primary = Color(0xFF007B6E);      // Deep turquoise
  static const Color primaryLight = Color(0xFF00A896); // Lighter turquoise
  static const Color primaryDark = Color(0xFF005F56);  // Darker turquoise
  static const Color primaryContainer = Color(0xFFCFF6F3);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF002420);

  static const Color secondary = Color(0xFF5D8A56);    // Muted green
  static const Color secondaryLight = Color(0xFF8BB983);
  static const Color secondaryContainer = Color(0xFFE0F0DD);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1B2D18);

  static const Color tertiary = Color(0xFFE8A800);     // Gold/amber for achievements
  static const Color tertiaryLight = Color(0xFFFFD600);
  static const Color tertiaryContainer = Color(0xFFFFF3D6);
  static const Color onTertiary = Color(0xFF2D1D00);
  static const Color onTertiaryContainer = Color(0xFF3D2D00);

  static const Color gold = Color(0xFFE8A800);
  static const Color goldLight = Color(0xFFFFD600);
  static const Color goldContainer = Color(0xFFFFF3D6);

  static const Color correct = Color(0xFF2E7D32);
  static const Color correctLight = Color(0xFF66BB6A);
  static const Color correctContainer = Color(0xFFE8F5E9);
  static const Color onCorrect = Color(0xFFFFFFFF);

  static const Color wrong = Color(0xFFC62828);
  static const Color wrongLight = Color(0xFFEF5350);
  static const Color wrongContainer = Color(0xFFFFEBEE);
  static const Color onWrong = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F8F7);
  static const Color surfaceContainer = Color(0xFFEFF3F1);
  static const Color surfaceContainerHigh = Color(0xFFE5EAE8);
  static const Color outline = Color(0xFFC5CBC8);
  static const Color outlineVariant = Color(0xFFD6DCD9);

  static const Color background = Color(0xFFFAFCFB);
  static const Color onBackground = Color(0xFF1A1C1B);
  static const Color onSurface = Color(0xFF1A1C1B);
  static const Color onSurfaceVariant = Color(0xFF444745);

  static const Color textPrimary = Color(0xFF1A1C1B);
  static const Color textSecondary = Color(0xFF5A5E5B);
  static const Color textTertiary = Color(0xFF8A8E8B);

  static const Color shadowColor = Color(0x1A000000);
  static const Color shadowColorStrong = Color(0x26000000);

  // Semantic aliases retained for the feature screens.
  static const Color accent = primary;
  static const Color accentLight = primaryLight;
  static const Color bg2 = surfaceContainerHigh;
  static const Color cardBg = surface;
  static const Color cardBorder = outlineVariant;

  // Card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get cardDecorationElevated => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowColorStrong,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration get cardDecorationOutlined => BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline, width: 1.5),
      );

  static BoxDecoration get glassMorphism => BoxDecoration(
        color: surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Gradients
  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [primary, primaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get goldGradient => const LinearGradient(
        colors: [gold, goldLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get correctGradient => const LinearGradient(
        colors: [correct, correctLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get wrongGradient => const LinearGradient(
        colors: [wrong, wrongLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get backgroundGradient => const LinearGradient(
        colors: [background, surfaceVariant],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get accentGradient => primaryGradient;
  static LinearGradient get bgGradient => backgroundGradient;

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: primary,
          primaryContainer: primaryContainer,
          onPrimary: onPrimary,
          onPrimaryContainer: onPrimaryContainer,
          secondary: secondary,
          secondaryContainer: secondaryContainer,
          onSecondary: onSecondary,
          onSecondaryContainer: onSecondaryContainer,
          tertiary: tertiary,
          tertiaryContainer: tertiaryContainer,
          onTertiary: onTertiary,
          onTertiaryContainer: onTertiaryContainer,
          surface: surface,
          surfaceVariant: surfaceVariant,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          outline: outline,
          outlineVariant: outlineVariant,
          error: wrong,
          errorContainer: wrongContainer,
          onError: onWrong,
          onErrorContainer: wrong,
          background: background,
          onBackground: onBackground,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          shadow: shadowColor,
        ),
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
          displayLarge: GoogleFonts.outfit(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: GoogleFonts.outfit(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.25,
          ),
          displaySmall: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          headlineLarge: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          headlineSmall: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          titleLarge: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleSmall: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textSecondary,
            letterSpacing: 0.5,
          ),
          bodyLarge: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
          bodySmall: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textTertiary,
          ),
          labelLarge: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: onPrimary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: onPrimary,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: outline, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: wrong, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: wrong, width: 2),
          ),
          labelStyle: GoogleFonts.outfit(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.outfit(
            color: textTertiary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: GoogleFonts.outfit(
            color: primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: outlineVariant, width: 1),
          ),
          shadowColor: shadowColor,
        ),
        dividerTheme: DividerThemeData(
          color: outlineVariant,
          thickness: 1,
          space: 24,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surfaceContainer,
          selectedColor: primaryContainer,
          disabledColor: surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          labelStyle: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          secondaryLabelStyle: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: outlineVariant),
          ),
          side: const BorderSide(color: outlineVariant),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          elevation: 8,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          contentTextStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceContainerHigh,
          contentTextStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 8,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primary,
          linearTrackColor: surfaceContainer,
          circularTrackColor: surfaceContainer,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: primary,
          inactiveTrackColor: surfaceContainer,
          thumbColor: primary,
          overlayColor: primary.withValues(alpha: 0.12),
          valueIndicatorColor: primary,
          valueIndicatorTextStyle: GoogleFonts.outfit(
            color: onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: primary,
          unselectedLabelColor: textTertiary,
          indicatorColor: primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}