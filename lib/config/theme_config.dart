import 'package:flutter/material.dart';
import 'package:k_quiz/config/app_theme_colors.dart';

class ThemeConfig {
  static const AppThemeColors _lightExtra = AppThemeColors(
    success: Color(0xFF16A34A),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFDC2626),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    cardBorder: Color(0xFFE5E7EB),
    cardBackground: Colors.white,
    mutedSurface: Color(0xFFF3F4F6),
    gradientStart: Color(0xFF6B46C1),
    gradientEnd: Color(0xFF9333EA),
  );

  static const AppThemeColors _darkExtra = AppThemeColors(
    success: Color(0xFF22C55E),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    cardBorder: Color(0xFF334155),
    cardBackground: Color(0xFF111827),
    mutedSurface: Color(0xFF1E293B),
    gradientStart: Color(0xFF7C3AED),
    gradientEnd: Color(0xFFA855F7),
  );

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF6B46C1),
      secondary: Color(0xFF3B82F6),
      surface: Colors.white,
      error: Color(0xFFDC2626),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF111827),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F5F7),
        foregroundColor: Color(0xFF111827),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF111827)),
        bodyMedium: TextStyle(color: Color(0xFF6B7280)),
        titleLarge: TextStyle(color: Color(0xFF111827)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: const Color(0xFFE5E7EB),
      extensions: const [_lightExtra],
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFF60A5FA),
      surface: Color(0xFF111827),
      error: Color(0xFFF87171),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF8FAFC),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF111827),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Color(0xFFF8FAFC),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF8FAFC)),
        bodyMedium: TextStyle(color: Color(0xFF94A3B8)),
        titleLarge: TextStyle(color: Color(0xFFF8FAFC)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: const Color(0xFF334155),
      extensions: const [_darkExtra],
    );
  }
}
