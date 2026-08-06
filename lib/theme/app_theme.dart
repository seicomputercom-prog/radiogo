import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkCyberpunk {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accentGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentGreen,
        secondary: AppColors.accentGreenDim,
        surface: AppColors.surface,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(color: AppColors.accentGreen),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavBg,
        selectedItemColor: AppColors.accentGreen,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'ShareTechMono',
          fontSize: 10,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'ShareTechMono',
          fontSize: 10,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.accentGreenDim,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.accentGreenDim,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.accentGreen,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: AppColors.accentGreenDim,
          fontFamily: 'ShareTechMono',
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: 3,
          shadows: [
            Shadow(
              color: AppColors.accentGreen,
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 2,
          shadows: [
            Shadow(
              color: AppColors.accentGreen,
              blurRadius: 8,
              offset: Offset(0, 0),
            ),
          ],
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 1,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'ShareTechMono',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        titleSmall: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'ShareTechMono',
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textWhite,
          fontFamily: 'ShareTechMono',
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textWhite,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 10,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.accentGreen,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: AppColors.background,
        elevation: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.accentGreenDim,
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'ShareTechMono',
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.textWhite,
          fontFamily: 'ShareTechMono',
        ),
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentGreen;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accentGreenDim;
          }
          return AppColors.surface;
        }),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textWhite,
        iconColor: AppColors.accentGreen,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'ShareTechMono',
          fontSize: 14,
        ),
        subtitleTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'ShareTechMono',
          fontSize: 12,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'ShareTechMono',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.accentGreenDim),
        ),
      ),
    );
  }
}
