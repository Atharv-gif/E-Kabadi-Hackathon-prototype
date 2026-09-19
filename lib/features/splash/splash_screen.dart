import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2600));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            // ── Ambient decorative glows ──
            Positioned(
              top: -90,
              left: -70,
              child: _glowCircle(260, AppColors.surface.withValues(alpha: 0.05)),
            ),
            Positioned(
              bottom: -110,
              right: -80,
              child: _glowCircle(320, AppColors.primaryMedium.withValues(alpha: 0.10)),
            ),
            Positioned(
              top: 120,
              right: -50,
              child: _glowCircle(150, AppColors.primaryMedium.withValues(alpha: 0.07)),
            ),

            // ── Drifting eco leaves ──
            const _FloatingLeaf(left: 36, top: 150, size: 20, riseDuration: 3200, delayMs: 200),
            const _FloatingLeaf(left: 300, top: 210, size: 15, riseDuration: 3800, delayMs: 900),
            const _FloatingLeaf(left: 60, top: 560, size: 17, riseDuration: 3500, delayMs: 1500),
            const _FloatingLeaf(left: 285, top: 620, size: 22, riseDuration: 4100, delayMs: 500),
            const _FloatingLeaf(left: 165, top: 120, size: 13, riseDuration: 3000, delayMs: 2100),

            // ── Center content ──
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoBadge(),
                  const SizedBox(height: 30),
                  Text(
                    AppConstants.appName,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.surface,
                      fontSize: 36,
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic)
                      .then()
                      .shimmer(
                        duration: 1600.ms,
                        colors: const [Colors.white, Color(0xFFDCFCE7), Colors.white],
                      ),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.appTagline,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.primaryLight.withValues(alpha: 0.9),
                      letterSpacing: 1.4,
                    ),
                  ).animate(delay: 450.ms).fadeIn(duration: 500.ms),

                  // ── Leaf divider ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dividerLine(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          LucideIcons.leaf,
                          size: 14,
                          color: AppColors.primaryLight.withValues(alpha: 0.75),
                        ),
                      ),
                      _dividerLine(),
                    ],
                  )
                      .animate(delay: 650.ms)
                      .fadeIn(duration: 500.ms)
                      .scaleX(begin: 0.4, end: 1, curve: Curves.easeOutCubic),

                  const SizedBox(height: 56),

                  // ── Loading dots ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                        )
                            .animate(
                              onPlay: (c) => c.repeat(),
                              delay: (700 + i * 180).ms,
                            )
                            .fadeIn(duration: 300.ms)
                            .then()
                            .fadeOut(duration: 300.ms),
                      ],
                    ],
                  ).animate(delay: 650.ms).fadeIn(duration: 300.ms),
                ],
              ),
            ),

            // ── Version footer ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Column(
                children: [
                  Text(
                    'Version 1.0.0',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.surface.withValues(alpha: 0.55),
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ).animate(delay: 1000.ms).fadeIn(duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoBadge() {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding radar pulses behind the badge.
          _radarPulse(150, 0.ms),
          _radarPulse(150, 900.ms),

          // Slowly rotating dashed ring.
          SizedBox(
            width: 168,
            height: 168,
            child: CustomPaint(
              painter: const DashedRingPainter(
                color: AppColors.primaryMedium,
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .rotate(duration: 12.seconds, begin: 0, end: 1),
          ),

          // Badge with entrance pop + breathing glow.
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryMedium.withValues(alpha: 0.4),
                  blurRadius: 46,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: CustomPaint(painter: const RecycleLogoPainter()),
            ),
          )
              .animate()
              .scale(
                duration: 650.ms,
                curve: Curves.easeOutBack,
                begin: const Offset(0.4, 0.4),
                end: const Offset(1, 1),
              )
              .then()
              .shimmer(
                duration: 1400.ms,
                colors: const [Colors.white, Color(0xFFDCFCE7), Colors.white],
              ),
        ],
      ),
    );
  }

  Widget _radarPulse(double size, Duration delay) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
    )
        .animate(
          onPlay: (c) => c.repeat(),
          delay: delay,
        )
        .scale(
          begin: const Offset(0.75, 0.75),
          end: const Offset(1.25, 1.25),
          duration: 1800.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 200.ms)
        .then()
        .fadeOut(duration: 1400.ms);
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.12, 1.12),
          duration: 4200.ms,
          curve: Curves.easeInOut,
        );
  }

  Widget _dividerLine() {
    return Container(
      width: 44,
      height: 1,
      color: AppColors.surface.withValues(alpha: 0.35),
    );
  }
}

/// A small leaf that fades in, drifts upward with a gentle tilt, then fades
/// out — looping for a calm, alive eco feel.
class _FloatingLeaf extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final int riseDuration;
  final int delayMs;

  const _FloatingLeaf({
    required this.left,
    required this.top,
    required this.size,
    required this.riseDuration,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Icon(
        LucideIcons.leaf,
        size: size,
        color: AppColors.primaryLight.withValues(alpha: 0.45),
      )
          .animate(onPlay: (c) => c.repeat(), delay: delayMs.ms)
          .fadeIn(duration: 700.ms, curve: Curves.easeIn)
          .then()
          .moveY(
            begin: 0,
            end: -38,
            duration: riseDuration.ms,
            curve: Curves.linear,
          )
          .rotate(begin: 0, end: 0.25, duration: riseDuration.ms, curve: Curves.linear)
          .then()
          .fadeOut(duration: 600.ms),
    );
  }
}

/// Hand-drawn eco logo mark: three recycling arrows orbiting a leaf.
/// Vector-based so it stays crisp at any size with zero image assets.
class RecycleLogoPainter extends CustomPainter {
  const RecycleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.30;

    final arrowPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Three arcs spaced 120° apart, each with an arrowhead.
    for (var i = 0; i < 3; i++) {
      final start = -math.pi / 2 + i * 2 * math.pi / 3 + 0.45;
      final sweep = 2 * math.pi / 3 - 0.9;
      final rect = Rect.fromCircle(center: center, radius: radius);
      final path = Path()..arcTo(rect, start, sweep, false);
      canvas.drawPath(path, arrowPaint);

      final endAngle = start + sweep;
      final tip = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );
      final tangent = endAngle + math.pi / 2;
      final headLen = size.width * 0.115;
      final head = Path()
        ..moveTo(
          tip.dx + headLen * math.cos(tangent - 0.55),
          tip.dy + headLen * math.sin(tangent - 0.55),
        )
        ..lineTo(tip.dx, tip.dy)
        ..lineTo(
          tip.dx + headLen * math.cos(tangent + 0.55),
          tip.dy + headLen * math.sin(tangent + 0.55),
        );
      canvas.drawPath(head, arrowPaint);
    }

    // Center leaf.
    final leafPaint = Paint()
      ..color = AppColors.primaryMedium
      ..style = PaintingStyle.fill;

    final lw = size.width * 0.15;
    final lh = size.width * 0.28;
    final leaf = Path()
      ..moveTo(center.dx, center.dy - lh / 2)
      ..quadraticBezierTo(center.dx + lw, center.dy, center.dx, center.dy + lh / 2)
      ..quadraticBezierTo(center.dx - lw, center.dy, center.dx, center.dy - lh / 2)
      ..close();
    canvas.drawPath(leaf, leafPaint);

    // Leaf midrib.
    canvas.drawLine(
      Offset(center.dx, center.dy - lh * 0.32),
      Offset(center.dx, center.dy + lh * 0.32),
      Paint()
        ..color = AppColors.surface
        ..strokeWidth = size.width * 0.022
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Dashed circle ring that slowly rotates around the logo badge.
class DashedRingPainter extends CustomPainter {
  final Color color;

  const DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashCount = 30;
    final sweep = 2 * math.pi / dashCount;
    final rect = Rect.fromCircle(center: center, radius: radius);
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(rect, i * sweep, sweep * 0.42, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DashedRingPainter oldDelegate) =>
      oldDelegate.color != color;
}
