import 'package:flutter/material.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';

class LearningMethodCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const LearningMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<LearningMethodCard> createState() => _LearningMethodCardState();
}

class _LearningMethodCardState extends State<LearningMethodCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final extra = context.appColors;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: extra.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: extra.cardBorder),
          boxShadow: [
            BoxShadow(
              color: _isPressed
                  ? Colors.black.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isPressed ? 8 : 10,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.gradientColors[0].withOpacity(0.2),
                    widget.gradientColors[1].withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                color: widget.gradientColors[0],
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: extra.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: extra.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: extra.textSecondary.withValues(alpha: 0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
