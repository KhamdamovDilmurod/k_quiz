import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_quiz/presentations/ui/common/gradient_card.dart';
import 'package:lottie/lottie.dart';

class StudyResultMetric {
  final String value;
  final String label;

  const StudyResultMetric({
    required this.value,
    required this.label,
  });
}

class StudyResultAction {
  final String label;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const StudyResultAction({
    required this.label,
    required this.gradientColors,
    required this.onTap,
  });
}

class StudyResultDialog extends StatefulWidget {
  final Color accentColor;
  final String title;
  final String? subtitle;
  final String? lottieAssetPath;
  final List<StudyResultMetric> metrics;
  final StudyResultAction primaryAction;
  final StudyResultAction? secondaryAction;

  const StudyResultDialog({
    super.key,
    required this.accentColor,
    required this.title,
    this.subtitle,
    this.lottieAssetPath,
    required this.metrics,
    required this.primaryAction,
    this.secondaryAction,
  });

  @override
  State<StudyResultDialog> createState() => _StudyResultDialogState();
}

class _StudyResultDialogState extends State<StudyResultDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _iconLoopController;
  late final ConfettiController _confettiController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _iconPulseAnimation;
  late final Animation<double> _iconLoopScaleAnimation;
  late final Animation<double> _iconLoopRotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    _iconPulseAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.75, curve: Curves.elasticOut),
      ),
    );
    _iconLoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );
    _iconLoopScaleAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _iconLoopController, curve: Curves.easeInOut),
    );
    _iconLoopRotateAnimation = Tween<double>(begin: -0.035, end: 0.035).animate(
      CurvedAnimation(parent: _iconLoopController, curve: Curves.easeInOut),
    );
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 2400),
    );
    _controller.forward();
    _iconLoopController.repeat(reverse: true);
    _confettiController.play();
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconLoopController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFC)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeroAnimation(),
                    const SizedBox(height: 20),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B7280),
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (widget.metrics.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: List.generate(
                          widget.metrics.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == widget.metrics.length - 1 ? 0 : 12,
                              ),
                              child: _buildMetricCard(index),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    _buildAnimatedActions(),
                  ],
                ),
              ),
              Positioned(
                top: -48,
                right: -24,
                child: IgnorePointer(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.accentColor.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -64,
                left: -32,
                child: IgnorePointer(
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.accentColor.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.directional,
                      blastDirection: pi / 2,
                      gravity: 0.22,
                      emissionFrequency: 0.12,
                      numberOfParticles: 24,
                      maxBlastForce: 26,
                      minBlastForce: 12,
                      shouldLoop: false,
                      colors: const [
                        Color(0xFF6B46C1),
                        Color(0xFF9333EA),
                        Color(0xFF10B981),
                        Color(0xFF3B82F6),
                        Color(0xFFF59E0B),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(int index) {
    final metric = widget.metrics[index];
    final start = (0.28 + index * 0.08).clamp(0.0, 0.85);
    final end = (start + 0.32).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.14),
          end: Offset.zero,
        ).animate(animation),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Text(
                metric.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                metric.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeroIcon() {
    return Lottie.asset(
      widget.lottieAssetPath ?? 'assets/lotties/celeberate.json',
      repeat: true,
      fit: BoxFit.contain,
    );
  }

  Widget _buildHeroAnimation() {
    return ScaleTransition(
      scale: _iconPulseAnimation,
      child: AnimatedBuilder(
        animation: _iconLoopController,
        builder: (context, child) => Transform.rotate(
          angle: _iconLoopRotateAnimation.value,
          child: Transform.scale(
            scale: _iconLoopScaleAnimation.value,
            child: child,
          ),
        ),
        child: Container(
          width: 128,
          height: 128,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.16),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
              child: _buildAnimatedHeroIcon()),
        ),
      ),
    );
  }

  Widget _buildAnimatedActions() {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 1.0, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(animation),
        child: widget.secondaryAction != null
            ? Row(
                children: [
                  Expanded(child: _buildActionButton(widget.secondaryAction!)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildActionButton(widget.primaryAction)),
                ],
              )
            : _buildActionButton(widget.primaryAction),
      ),
    );
  }

  Widget _buildActionButton(StudyResultAction action) {
    return GradientCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 14),
      borderRadius: 12,
      gradientColors: action.gradientColors,
      onTap: action.onTap,
      child: Text(
        action.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
