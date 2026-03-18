import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';
import 'package:k_quiz/config/theme/theme_cubit.dart';

class AuthDecoratedBackground extends StatelessWidget {
  final Widget child;
  final bool showThemeSwitcher;

  const AuthDecoratedBackground({
    super.key,
    required this.child,
    this.showThemeSwitcher = true,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            extra.gradientStart.withValues(alpha: isDark ? 0.92 : 0.84),
            extra.gradientEnd.withValues(alpha: isDark ? 0.88 : 0.74),
            theme.colorScheme.surface.withValues(alpha: isDark ? 0.96 : 0.90),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: -30,
            child: _GlowOrb(
              color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.16),
              size: 180,
            ),
          ),
          Positioned(
            right: -40,
            top: 140,
            child: _GlowOrb(
              color: extra.gradientEnd.withValues(alpha: isDark ? 0.18 : 0.24),
              size: 140,
            ),
          ),
          Positioned(
            left: 40,
            bottom: -30,
            child: _GlowOrb(
              color: extra.gradientStart.withValues(alpha: isDark ? 0.16 : 0.18),
              size: 120,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                if (showThemeSwitcher)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        ThemeModeMenuButton(),
                      ],
                    ),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AuthSurfaceCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 520),
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: extra.cardBackground.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: extra.cardBorder.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AuthBrandHeader extends StatelessWidget {
  final String title;
  final double logoSize;

  const AuthBrandHeader({
    super.key,
    required this.title,
    this.logoSize = 94,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.96),
                extra.mutedSurface.withValues(alpha: 0.96),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: extra.gradientEnd.withValues(alpha: 0.22),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.menu_book_rounded,
              size: logoSize * 0.46,
              color: extra.gradientStart,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

InputDecoration authInputDecoration(
  BuildContext context, {
  required String label,
  required IconData icon,
  Widget? suffixIcon,
}) {
  final extra = context.appColors;

  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: extra.textSecondary),
    prefixIcon: Icon(icon, color: extra.textSecondary),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: extra.mutedSurface.withValues(alpha: 0.78),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: extra.cardBorder.withValues(alpha: 0.72)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: extra.gradientStart, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: extra.danger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: extra.danger, width: 1.4),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: extra.cardBorder),
    ),
  );
}

class ThemeModeMenuButton extends StatelessWidget {
  const ThemeModeMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeMode>(
          tooltip: 'Theme mode',
          initialValue: state.themeMode,
          onSelected: (mode) => context.read<ThemeCubit>().changeTheme(mode),
          color: extra.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: ThemeMode.system,
              child: _ThemeModeItem(
                icon: Icons.brightness_auto_rounded,
                label: 'System',
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: _ThemeModeItem(
                icon: Icons.light_mode_rounded,
                label: 'Light',
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: _ThemeModeItem(
                icon: Icons.dark_mode_rounded,
                label: 'Dark',
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_iconForMode(state.themeMode), color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  _labelForMode(state.themeMode),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static IconData _iconForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  static String _labelForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _ThemeModeItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ThemeModeItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return Row(
      children: [
        Icon(icon, size: 18, color: extra.textPrimary),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
