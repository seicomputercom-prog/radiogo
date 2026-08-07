import 'dart:ui';

class AppColors {
  // Base cyberpunk (default)
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF0D1117);
  static const Color surfaceLight = Color(0xFF161B22);
  static const Color accentGreen = Color(0xFF00FF41);
  static const Color accentGreenDim = Color(0xFF00CC33);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color matrixGreen = Color(0xFF00FF41);
  static const Color textPrimary = Color(0xFF00FF41);
  static const Color textSecondary = Color(0xB339FF14);
  static const Color textWhite = Color(0xFFE6E6E6);
  static const Color errorRed = Color(0xFFFF0040);
  static const Color divider = Color(0xFF1A3A1A);
  static const Color cardBg = Color(0xFF161B22);
  static const Color bottomNavBg = Color(0xFF0D1117);
}

class ThemeColors {
  final String name;
  final String key;
  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color accent;
  final Color accentDim;
  final Color textPrimary;
  final Color textSecondary;
  final Color textWhite;
  final Color divider;
  final Color cardBg;
  final Color bottomNavBg;

  const ThemeColors({
    required this.name,
    required this.key,
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.accent,
    required this.accentDim,
    required this.textPrimary,
    required this.textSecondary,
    required this.textWhite,
    required this.divider,
    required this.cardBg,
    required this.bottomNavBg,
  });

  static const cyberpunk = ThemeColors(
    name: 'Cyberpunk Green',
    key: 'cyberpunk',
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF0D1117),
    surfaceLight: Color(0xFF161B22),
    accent: Color(0xFF00FF41),
    accentDim: Color(0xFF00CC33),
    textPrimary: Color(0xFF00FF41),
    textSecondary: Color(0xB339FF14),
    textWhite: Color(0xFFE6E6E6),
    divider: Color(0xFF1A3A1A),
    cardBg: Color(0xFF161B22),
    bottomNavBg: Color(0xFF0D1117),
  );

  static const neonBlue = ThemeColors(
    name: 'Neon Blue',
    key: 'neon_blue',
    background: Color(0xFF0A0A14),
    surface: Color(0xFF0D1120),
    surfaceLight: Color(0xFF161B30),
    accent: Color(0xFF00D4FF),
    accentDim: Color(0xFF0099CC),
    textPrimary: Color(0xFF00D4FF),
    textSecondary: Color(0xB30099CC),
    textWhite: Color(0xFFE6E6E6),
    divider: Color(0xFF1A1A3A),
    cardBg: Color(0xFF161B30),
    bottomNavBg: Color(0xFF0D1120),
  );

  static const synthwave = ThemeColors(
    name: 'Synthwave Pink',
    key: 'synthwave',
    background: Color(0xFF140A14),
    surface: Color(0xFF1A0D1A),
    surfaceLight: Color(0xFF221622),
    accent: Color(0xFFFF00FF),
    accentDim: Color(0xFFCC00CC),
    textPrimary: Color(0xFFFF66FF),
    textSecondary: Color(0xB3CC00CC),
    textWhite: Color(0xFFE6E6E6),
    divider: Color(0xFF3A1A3A),
    cardBg: Color(0xFF221622),
    bottomNavBg: Color(0xFF1A0D1A),
  );

  static const amberTerminal = ThemeColors(
    name: 'Amber Terminal',
    key: 'amber',
    background: Color(0xFF0F0D0A),
    surface: Color(0xFF141110),
    surfaceLight: Color(0xFF1E1A16),
    accent: Color(0xFFFFB000),
    accentDim: Color(0xFFCC8D00),
    textPrimary: Color(0xFFFFB000),
    textSecondary: Color(0xB3CC8D00),
    textWhite: Color(0xFFE6E6E6),
    divider: Color(0xFF3A2E1A),
    cardBg: Color(0xFF1E1A16),
    bottomNavBg: Color(0xFF141110),
  );

  static const redMatrix = ThemeColors(
    name: 'Red Matrix',
    key: 'red_matrix',
    background: Color(0xFF0F0A0A),
    surface: Color(0xFF140D0D),
    surfaceLight: Color(0xFF1E1414),
    accent: Color(0xFFFF0040),
    accentDim: Color(0xFFCC0033),
    textPrimary: Color(0xFFFF0040),
    textSecondary: Color(0xB3CC0033),
    textWhite: Color(0xFFE6E6E6),
    divider: Color(0xFF3A1A1A),
    cardBg: Color(0xFF1E1414),
    bottomNavBg: Color(0xFF140D0D),
  );

  static const all = [
    cyberpunk,
    neonBlue,
    synthwave,
    amberTerminal,
    redMatrix,
  ];

  static ThemeColors fromKey(String key) {
    return all.firstWhere(
      (t) => t.key == key,
      orElse: () => cyberpunk,
    );
  }
}
