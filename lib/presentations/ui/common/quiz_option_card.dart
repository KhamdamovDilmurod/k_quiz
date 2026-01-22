import 'package:flutter/material.dart';

enum OptionState {
  normal,
  correct,
  incorrect,
  correctShown, // Noto'g'ri tanlanganda to'g'ri javobni ko'rsatish
}

class QuizOptionCard extends StatelessWidget {
  final String option;
  final String optionLetter; // A, B, C, D
  final OptionState state;
  final VoidCallback? onTap;

  const QuizOptionCard({
    super.key,
    required this.option,
    required this.optionLetter,
    this.state = OptionState.normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    final isSelected = state != OptionState.normal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradientColors != null
                ? LinearGradient(colors: gradientColors)
                : null,
            color: gradientColors == null ? Colors.white : null,
            borderRadius: BorderRadius.circular(16),
            border: gradientColors == null
                ? Border.all(color: const Color(0xFFE5E7EB), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.black.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 12 : 8,
                offset: Offset(0, isSelected ? 6 : 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: gradientColors != null
                      ? Colors.white.withOpacity(0.3)
                      : const Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    optionLetter,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: gradientColors != null
                          ? Colors.white
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 18,
                    color: gradientColors != null
                        ? Colors.white
                        : const Color(0xFF1F2937),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
              if (state == OptionState.correct || state == OptionState.correctShown)
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
              if (state == OptionState.incorrect)
                const Icon(Icons.cancel, color: Colors.white, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  List<Color>? _getGradientColors() {
    switch (state) {
      case OptionState.correct:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case OptionState.incorrect:
        return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
      case OptionState.correctShown:
        return [
          const Color(0xFF10B981).withOpacity(0.5),
          const Color(0xFF059669).withOpacity(0.5),
        ];
      case OptionState.normal:
        return null;
    }
  }
}