import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';

class CollectorNavigationScreen extends ConsumerWidget {
  const CollectorNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Navigation', showBack: false),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Target customer card ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                color: AppColors.primaryLight,
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: 18,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary,
                      child: const Icon(LucideIcons.user, color: AppColors.surface, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Navigating to Aarav Sharma', style: AppTypography.titleSmall),
                          const SizedBox(height: 2),
                          Text(
                            'Flat 402, Green Valley, Sector 62',
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('1.2 km', style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark)),
                        Text('ETA ~6 min', style: AppTypography.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Map area ──
            Expanded(
              child: Stack(
                children: [
                  const CustomPaint(size: Size.infinite, painter: CollectorRouteMapPainter()),

                  // Turn instruction banner
                  Positioned(
                    top: 16,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.rLg,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.elevated,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: AppColors.techBlueLight, shape: BoxShape.circle),
                            child: const Icon(LucideIcons.cornerUpRight, color: AppColors.techBlue, size: 20),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('In 200 m, turn right onto Sector 62 Main Rd', style: AppTypography.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                                Text('Speed limit 40 km/h • Clear traffic', style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating arrive card — raised above the floating
                  // bottom navigation bar so the button stays accessible.
                  Positioned(
                    bottom: BottomNavBarMetrics.totalHeight + 16,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.rXl,
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppShadows.elevated,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            text: 'I Have Arrived at Household',
                            onPressed: () => context.push('/collector/verify'),
                            icon: LucideIcons.mapPin,
                          ),
                        ],
                      ),
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
}

class CollectorRouteMapPainter extends CustomPainter {
  const CollectorRouteMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8EDF3);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.55, size.width * 0.8, size.height * 0.2);

    canvas.drawPath(roadPath, roadPaint);

    // Route outline + line
    final routeOutline = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.25)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(roadPath, routeOutline);

    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(roadPath, routePaint);

    // Collector vehicle pin
    final vehicle = Offset(size.width * 0.1, size.height * 0.8);
    canvas.drawCircle(vehicle, 16, Paint()..color = AppColors.techBlue);
    canvas.drawCircle(vehicle, 5, Paint()..color = AppColors.surface);

    // Customer destination pin
    final dest = Offset(size.width * 0.8, size.height * 0.2);
    canvas.drawCircle(dest, 18, Paint()..color = AppColors.primaryDark.withValues(alpha: 0.2));
    canvas.drawCircle(dest, 10, Paint()..color = AppColors.primaryDark);
    canvas.drawCircle(dest, 4, Paint()..color = AppColors.surface);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
