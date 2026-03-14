import 'package:flutter/material.dart';
import 'package:k_quiz/config/theme/app_theme_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final bool showGradientDivider;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final bool showMenuButton; // Yangi parameter

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.showGradientDivider = true,
    this.actions,
    this.leading,
    this.elevation = 0,
    this.showMenuButton = false, // Default false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      leading: leading ?? (showMenuButton ? _buildMenuButton(context) : null),
      actions: actions,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? context.appColors.textPrimary,
          fontSize: titleFontSize ?? 28,
          fontWeight: titleFontWeight ?? FontWeight.bold,
        ),
      ),
      bottom: showGradientDivider
          ? PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Theme.of(context).dividerColor.withValues(alpha: 0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    final extra = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [extra.gradientStart, extra.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: extra.gradientEnd.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (showGradientDivider ? 1 : 0),
  );
}
