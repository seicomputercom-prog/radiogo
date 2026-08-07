import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData fromColors(ThemeColors c) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.background,
      primaryColor: c.accent,
      colorScheme: ColorScheme.dark(
        primary: c.accent,
        secondary: c.accentDim,
        surface: c.surface,
        onPrimary: c.background,
        onSurface: c.textPrimary,
        error: const Color(0xFFFF0040),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 20,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(color: c.accent),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: c.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: c.divider, width: 1),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.bottomNavBg,
        selectedItemColor: c.accent,
        unselectedItemColor: c.textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'ShareTechMono',
          fontSize: 10,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'ShareTechMono',
          fontSize: 10,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.accentDim, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.accentDim, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
        hintStyle: TextStyle(
          color: c.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: c.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: 3,
          shadows: [
            Shadow(color: c.accent, blurRadius: 10, offset: Offset.zero),
          ],
        ),
        headlineMedium: TextStyle(
          color: c.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 2,
          shadows: [
            Shadow(color: c.accent, blurRadius: 8, offset: Offset.zero),
          ],
        ),
        headlineSmall: TextStyle(
          color: c.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 1,
        ),
        titleLarge: TextStyle(
          color: c.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1,
        ),
        titleMedium: TextStyle(
          color: c.textPrimary,
          fontFamily: 'ShareTechMono',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        titleSmall: TextStyle(
          color: c.textSecondary,
          fontFamily: 'ShareTechMono',
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: c.textWhite,
          fontFamily: 'ShareTechMono',
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: c.textWhite,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: c.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: c.textPrimary,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          color: c.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: c.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 10,
        ),
      ),
      iconTheme: IconThemeData(color: c.accent),
      dividerTheme: DividerThemeData(
        color: c.divider,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: c.background,
        elevation: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.accent;
          return c.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.accentDim;
          return c.surface;
        }),
      ),
      listTileTheme: ListTileThemeData(
        textColor: c.textWhite,
        iconColor: c.accent,
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
        ),
        subtitleTextStyle: TextStyle(
          color: c.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 12,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.surface,
        contentTextStyle: TextStyle(
          color: c.textPrimary,
          fontFamily: 'ShareTechMono',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: c.accentDim),
        ),
      ),
    );
  }

  static ThemeData get darkCyberpunk => fromColors(ThemeColors.cyberpunk);
}
