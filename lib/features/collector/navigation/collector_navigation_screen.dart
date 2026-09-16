import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';


class CollectorNavigationScreen extends ConsumerWidget {
  const CollectorNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Navigation & Turn-by-Turn', showBack: false),
      body: SafeArea(
        child: Column(
          children: [
            // Target Customer Card Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.surface,
              child: CustomCard(
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryLight,
                border: Border.all(color: AppColors.primary, width: 1.5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary,
                      child: const Icon(LucideIcons.user, color: AppColors.surface, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Navigating to Aarav Sharma', style: AppTypography.titleSmall),
                          const SizedBox(height: 2),
                          Text('Flat 402, Green Valley, Sector 62', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('1.2 km', style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
                        Text('ETA 6 min', style: AppTypography.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Map Area Canvas
            Expanded(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: CollectorRouteMapPainter(),
                  ),

                  // Floating Navigation Card at Bottom
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(color: AppColors.techBlueLight, shape: BoxShape.circle),
                                child: const Icon(LucideIcons.navigation, color: AppColors.techBlue, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('In 200m, Turn Right onto Sector 62 Main Rd', style: AppTypography.titleSmall),
                                    Text('Speed limit 40 km/h • Clear traffic', style: AppTypography.bodySmall),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          CustomButton(
                            text: 'I Have Arrived at Household',
                            onPressed: () => context.push('/collector/verify'),
                            type: ButtonType.primary,
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
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 28
      ..style = PaintingStyle.stroke;

    final roadPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.8)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.2);

    canvas.drawPath(roadPath, roadPaint);

    // Route line
    final routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(roadPath, routePaint);

    // Collector Vehicle Pin
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.8), 20, Paint()..color = AppColors.techBlue);

    // Customer Destination Pin
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 20, Paint()..color = AppColors.primaryDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
