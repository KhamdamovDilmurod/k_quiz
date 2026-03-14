import 'package:flutter/material.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color>? gradientColors;
  final double iconSize;
  final double containerSize;
  final Widget? actionButton;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradientColors,
    this.iconSize = 60,
    this.containerSize = 120,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    final colors = gradientColors ?? [
      extra.gradientStart.withValues(alpha: 0.2),
      extra.gradientEnd.withValues(alpha: 0.2),
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: extra.gradientEnd,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: extra.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: extra.textSecondary,
              ),
            ),
            if (actionButton != null) ...[
              const SizedBox(height: 24),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
