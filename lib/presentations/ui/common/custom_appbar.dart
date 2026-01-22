import 'package:flutter/material.dart';

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
      backgroundColor: backgroundColor ?? const Color(0xFFF5F5F7),
      leading: leading ?? (showMenuButton ? _buildMenuButton(context) : null),
      actions: actions,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? const Color(0xFF1F2937),
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
                Colors.grey.withOpacity(0.6),
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
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6B46C1),
                Color(0xFF9333EA),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.1),
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