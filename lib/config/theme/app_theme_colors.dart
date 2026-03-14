import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color success;
  final Color warning;
  final Color danger;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardBorder;
  final Color cardBackground;
  final Color mutedSurface;
  final Color gradientStart;
  final Color gradientEnd;

  const AppThemeColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardBorder,
    required this.cardBackground,
    required this.mutedSurface,
    required this.gradientStart,
    required this.gradientEnd,
  });

  @override
  AppThemeColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? textPrimary,
    Color? textSecondary,
    Color? cardBorder,
    Color? cardBackground,
    Color? mutedSurface,
    Color? gradientStart,
    Color? gradientEnd,
  }) {
    return AppThemeColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      cardBorder: cardBorder ?? this.cardBorder,
      cardBackground: cardBackground ?? this.cardBackground,
      mutedSurface: mutedSurface ?? this.mutedSurface,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      mutedSurface: Color.lerp(mutedSurface, other.mutedSurface, t)!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>()!;
}
