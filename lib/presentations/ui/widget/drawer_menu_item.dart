import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Color> gradientColors;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing; // Qo'shimcha widget (badge, counter)

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.gradientColors,
    this.isSelected = false,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: gradientColors[0].withOpacity(0.3),
          highlightColor: gradientColors[0].withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                colors: [
                  gradientColors[0].withOpacity(0.3),
                  gradientColors[1].withOpacity(0.3),
                ],
              )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? gradientColors[0].withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 44 : 40,
                  height: isSelected ? 44 : 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: gradientColors[1].withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isSelected ? 24 : 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSelected ? 17 : 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                    child: Text(title),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 24 : 0,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(isSelected ? 0.8 : 0.5),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============ BADGE WIDGET (Notification counter) ============
class DrawerBadge extends StatelessWidget {
  final int count;
  final Color? backgroundColor;

  const DrawerBadge({
    super.key,
    required this.count,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.red,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? Colors.red).withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}