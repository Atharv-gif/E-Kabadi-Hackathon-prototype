import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';

class CollectorMatchingScreen extends StatefulWidget {
  const CollectorMatchingScreen({super.key});

  @override
  State<CollectorMatchingScreen> createState() => _CollectorMatchingScreenState();
}

class _CollectorMatchingScreenState extends State<CollectorMatchingScreen> {
  bool _isFound = false;

  @override
  void initState() {
    super.initState();
    _startMatchingAnimation();
  }

  void _startMatchingAnimation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isFound = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isFound) ...[
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.3, 1.3), duration: 1500.ms),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.radar, size: 70, color: AppColors.surface),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Finding Nearby Collector...',
                  style: AppTypography.displayMedium.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Connecting with verified scrap collectors within 3 km of your area',
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
              ] else ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.checkCircle2, size: 64, color: AppColors.primary),
                ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                const SizedBox(height: 20),
                Text(
                  'Collector Found!',
                  style: AppTypography.displayMedium.copyWith(fontSize: 26),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ramesh Kumar accepted your pickup request',
                  style: AppTypography.bodyLarge,
                ),
                const SizedBox(height: 32),

                // Collector Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  border: Border.all(color: AppColors.primary, width: 2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              'RK',
                              style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Ramesh Kumar', style: AppTypography.titleMedium),
                                    const SizedBox(width: 6),
                                    const Icon(LucideIcons.badgeCheck, size: 18, color: AppColors.techBlue),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(LucideIcons.star, size: 14, color: AppColors.warning),
                                    const SizedBox(width: 4),
                                    Text('4.8 Rating • 480 Pickups', style: AppTypography.bodySmall),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Vehicle: Mahindra Pickup (UP16 ET 4912)',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text('1.2 km away', style: AppTypography.titleSmall),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(LucideIcons.clock, size: 16, color: AppColors.techBlue),
                              const SizedBox(width: 6),
                              Text('ETA ~6 mins', style: AppTypography.titleSmall.copyWith(color: AppColors.techBlue)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                const Spacer(),
                CustomButton(
                  text: 'Track Collector Live',
                  onPressed: () => context.go('/citizen/live-tracking'),
                  icon: LucideIcons.navigation,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
