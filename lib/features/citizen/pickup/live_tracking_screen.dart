import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/pickup_provider.dart';

class LiveTrackingScreen extends ConsumerWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);
    final active = pickupState.activePickup;

    final collectorName = active?.collectorName ?? 'Ramesh Kumar';
    final collectorPhone = active?.collectorPhone ?? '+91 98765 43210';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Live Collector Tracking'),
      body: SafeArea(
        child: Column(
          children: [
            // Top Collector ETA Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.surface,
              child: CustomCard(
                padding: const EdgeInsets.all(16),
                color: AppColors.techBlueLight,
                border: Border.all(color: AppColors.techBlue, width: 1.5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.techBlue,
                      child: const Icon(LucideIcons.truck, color: AppColors.surface, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Collector is on the way',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.techBlue),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$collectorName • ETA: 6 mins (1.2 km)',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Map View Canvas Mock
            Expanded(
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: MockMapPainter(),
                  ),

                  // Route Badge Floating overlay
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text('GPS Live Sync', style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                  ),

                  // Simulation trigger floating action bar
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16)],
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(collectorName, style: AppTypography.titleSmall),
                                    Text('Rating 4.8 ★ • Verified Collector', style: AppTypography.bodySmall),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling $collectorPhone...')),
                                  );
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                                  child: const Icon(LucideIcons.phone, color: AppColors.primary, size: 20),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Opening chat with collector')),
                                  );
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: AppColors.techBlueLight, shape: BoxShape.circle),
                                  child: const Icon(LucideIcons.messageSquare, color: AppColors.techBlue, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          CustomButton(
                            text: 'Collector Arrived (Simulate Handshake)',
                            onPressed: () => context.push('/citizen/collector-arrival'),
                            type: ButtonType.primary,
                            icon: LucideIcons.badgeCheck,
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

class MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE5E9F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Grid lines for streets
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.4);
    final path2 = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width * 0.4, size.height);

    canvas.drawPath(path1, streetPaint);
    canvas.drawPath(path2, streetPaint);

    // Polyline Route
    final routePaint = Paint()
      ..color = AppColors.techBlue
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.35, size.width * 0.7, size.height * 0.6);

    canvas.drawPath(routePath, routePaint);

    // Citizen Location Pin (Green)
    final citizenPin = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 18, citizenPin);

    // Collector Truck Pin (Blue)
    final truckPin = Paint()..color = AppColors.techBlue;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.3), 22, truckPin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
