import 'package:flutter/material.dart';

class GradientCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final bool enableAnimation;

  const GradientCard({
    super.key,
    required this.child,
    this.onTap,
    this.gradientColors,
    this.margin,
    this.padding,
    this.borderRadius,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.enableAnimation = true,
  });

  @override
  State<GradientCard> createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gradientColors ?? [
      const Color(0xFF6B46C1),
      const Color(0xFF9333EA),
    ];

    return GestureDetector(
      onTapDown: widget.enableAnimation && widget.onTap != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onTap != null
          ? (_) {
        if (widget.enableAnimation) {
          setState(() => _isPressed = false);
        }
        widget.onTap!();
      }
          : null,
      onTapCancel: widget.enableAnimation
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        transform: widget.enableAnimation
            ? (Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: widget.shadowBlurRadius ?? 12,
              offset: widget.shadowOffset ?? const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(20),
          child: widget.child,
        ),
      ),
    );
  }
}