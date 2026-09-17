import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/pickup_timeline.dart';
import '../../../providers/pickup_provider.dart';

class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);
    final active = pickupState.activePickup;

    final collectorName = active?.collectorName ?? 'Ramesh Kumar';
    final collectorPhone = active?.collectorPhone ?? '+91 98765 43210';
    final status = active?.status;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Live Collector Tracking'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── ETA header card ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: CustomCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                color: AppColors.techBlueLight,
                border: Border.all(color: AppColors.techBlue, width: 1.5),
                borderRadius: 18,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.techBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.truck, color: AppColors.surface, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Collector is on the way',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$collectorName • 1.2 km away • ETA ~6 min',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.techBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Map canvas ──
            Expanded(
              child: Stack(
                children: [
                  const CustomPaint(size: Size.infinite, painter: MockMapPainter()),

                  // GPS live badge
                  Positioned(
                    top: 16,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.rPill,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.card,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .fadeOut(duration: 700.ms)
                              .then()
                              .fadeIn(duration: 700.ms),
                          const SizedBox(width: 8),
                          Text('GPS Live Sync', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                          // trailing kept for spacing symmetry
                        ],
                      ),
                    ),
                  ),

                  // Collector info + actions
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.rXl,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.elevated,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.primaryLight,
                                child: Text('RK', style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark)),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(collectorName, style: AppTypography.titleSmall),
                                    Text('Rating 4.8 ★ • Verified Collector', style: AppTypography.bodySmall),
                                  ],
                                ),
                              ),
                              _roundAction(
                                icon: LucideIcons.phone,
                                bg: AppColors.primaryLight,
                                iconColor: AppColors.primary,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling $collectorPhone…')),
                                  );
                                },
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              _roundAction(
                                icon: LucideIcons.messageSquare,
                                bg: AppColors.techBlueLight,
                                iconColor: AppColors.techBlue,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Opening chat with collector')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          CustomButton(
                            text: 'Collector Arrived (Simulate Handshake)',
                            onPressed: () => context.push('/citizen/collector-arrival'),
                            icon: LucideIcons.badgeCheck,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Status timeline ──
            if (status != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pickup Progress', style: AppTypography.titleSmall),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 210,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: PickupTimeline(status: status),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _roundAction({
    required IconData icon,
    required Color bg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }
}

class MockMapPainter extends CustomPainter {
  const MockMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8EDF3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Blocks (buildings)
    final blockPaint = Paint()..color = const Color(0xFFDDE4EC);
    final blocks = [
      const Rect.fromLTWH(0.05, 0.05, 0.16, 0.14),
      const Rect.fromLTWH(0.55, 0.04, 0.2, 0.12),
      const Rect.fromLTWH(0.08, 0.55, 0.14, 0.18),
      const Rect.fromLTWH(0.72, 0.5, 0.2, 0.2),
      const Rect.fromLTWH(0.45, 0.75, 0.18, 0.16),
    ];
    for (final r in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(r.left * size.width, r.top * size.height, r.width * size.width, r.height * size.height),
          const Radius.circular(4),
        ),
        blockPaint,
      );
    }

    // Streets
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.32)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.28, size.width, size.height * 0.42),
      streetPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.32, 0)
        ..quadraticBezierTo(size.width * 0.38, size.height * 0.5, size.width * 0.34, size.height),
      streetPaint,
    );

    // Route
    final routePath = Path()
      ..moveTo(size.width * 0.34, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.36, size.width * 0.68, size.height * 0.6);

    final routeOutline = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.25)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, routeOutline);

    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, routePaint);

    // Citizen pin (destination)
    final citizenPos = Offset(size.width * 0.68, size.height * 0.6);
    canvas.drawCircle(citizenPos, 16, Paint()..color = AppColors.primary.withValues(alpha: 0.2));
    canvas.drawCircle(citizenPos, 9, Paint()..color = AppColors.primary);
    canvas.drawCircle(citizenPos, 3.5, Paint()..color = AppColors.surface);

    // Collector truck marker
    final truckPos = Offset(size.width * 0.34, size.height * 0.3);
    canvas.drawCircle(truckPos, 20, Paint()..color = AppColors.techBlue);
    canvas.drawCircle(truckPos, 20, Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4);
    final tp = TextPainter(
      text: const TextSpan(
        text: '🚛',
        style: TextStyle(fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, truckPos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
