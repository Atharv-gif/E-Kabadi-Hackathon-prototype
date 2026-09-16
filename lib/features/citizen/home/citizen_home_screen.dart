import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/pickup_provider.dart';

class CitizenHomeScreen extends ConsumerWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final pickupState = ref.watch(pickupProvider);
    final userName = authState.user?.name ?? 'Aarav Sharma';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, $userName 👋',
                        style: AppTypography.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Sector 62, Noida, UP',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifications view open')),
                          );
                        },
                        icon: const Icon(LucideIcons.bell, color: AppColors.textPrimary),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Active Pickup Live Tracker Banner (if any active)
              if (pickupState.activePickup != null) ...[
                CustomCard(
                  color: AppColors.techBlueLight,
                  border: Border.all(color: AppColors.techBlue, width: 1.5),
                  onTap: () => context.push('/citizen/live-tracking'),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.techBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.truck, color: AppColors.surface, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Collector Ramesh is on the way!',
                              style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ETA: 6 mins • 1.2 km away',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.techBlue),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, color: AppColors.techBlue),
                    ],
                  ),
                ).animate().shimmer(duration: 1500.ms),
                const SizedBox(height: 20),
              ],

              // Hero Action Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.glowingGreen,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '⚡ Instant Doorstep Pickup',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.surface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Turn Unused Household Scrap Into Cash',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.surface,
                        fontSize: 22,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload scrap photos, get instant AI price estimates & doorstep collection.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryLight),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: '+ Sell Scrap',
                            onPressed: () => context.go('/citizen/sell'),
                            type: ButtonType.primary,
                            icon: LucideIcons.camera,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'Schedule',
                            onPressed: () => context.push('/citizen/schedule-pickup'),
                            type: ButtonType.secondary,
                            icon: LucideIcons.calendar,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Your Eco Impact Metrics
              Text('Your Environmental Impact 🌿', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.scale, color: AppColors.primary, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            '12.5 kg',
                            style: AppTypography.titleLarge.copyWith(fontSize: 20),
                          ),
                          Text(
                            'Scrap Recycled',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.leaf, color: AppColors.success, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            '23.4 kg',
                            style: AppTypography.titleLarge.copyWith(fontSize: 20),
                          ),
                          Text(
                            'CO₂ Saved',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.award, color: AppColors.rewardOrange, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            '840',
                            style: AppTypography.titleLarge.copyWith(fontSize: 20, color: AppColors.rewardOrange),
                          ),
                          Text(
                            'Eco Points',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Recent Activity Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Pickups', style: AppTypography.titleMedium),
                  TextButton(
                    onPressed: () => context.go('/citizen/orders'),
                    child: Text('View All', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              CustomCard(
                onTap: () => context.push('/citizen/scrap-journey'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.packageCheck, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Plastic & Cardboard Scrap', style: AppTypography.titleSmall),
                          const SizedBox(height: 2),
                          Text('18 Sep 2026 • Collector Ramesh Kumar', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('+ ₹118', style: AppTypography.titleSmall.copyWith(color: AppColors.success)),
                        Text('+20 Points', style: AppTypography.bodySmall.copyWith(color: AppColors.rewardOrange)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
