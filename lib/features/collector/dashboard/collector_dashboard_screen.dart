import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../providers/collector_provider.dart';

class CollectorDashboardScreen extends ConsumerWidget {
  const CollectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectorState = ref.watch(collectorProvider);
    final isAvailable = collectorState.isAvailable;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Availability Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Ramesh Kumar', style: AppTypography.titleLarge),
                          const SizedBox(width: 6),
                          const Icon(LucideIcons.badgeCheck, size: 20, color: AppColors.techBlue),
                        ],
                      ),
                      Text('Sector 62 & 63 Zone, Noida', style: AppTypography.bodySmall),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.go('/collector/voice'),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppColors.techBlueLight, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.mic, color: AppColors.techBlue, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Availability Toggle Switch Box
              CustomCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                color: isAvailable ? AppColors.primaryLight : AppColors.surfaceVariant,
                border: Border.all(color: isAvailable ? AppColors.primary : AppColors.border, width: 1.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isAvailable ? AppColors.success : AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isAvailable ? 'ONLINE • AVAILABLE FOR PICKUPS' : 'OFFLINE • DUTY PAUSED',
                          style: AppTypography.labelSmall.copyWith(
                            color: isAvailable ? AppColors.primaryDark : AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isAvailable,
                      onChanged: (val) {
                        ref.read(collectorProvider.notifier).toggleAvailability(val);
                      },
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Operational Metrics Grid
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.wallet, color: AppColors.primary, size: 24),
                          const SizedBox(height: 10),
                          Text('₹${collectorState.todayEarnings.toStringAsFixed(0)}', style: AppTypography.titleLarge.copyWith(fontSize: 20)),
                          Text('Today Earnings', style: AppTypography.bodySmall),
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
                          const Icon(LucideIcons.package, color: AppColors.techBlue, size: 24),
                          const SizedBox(height: 10),
                          Text('${collectorState.todayPickupsCount}', style: AppTypography.titleLarge.copyWith(fontSize: 20)),
                          Text('Completed Pickups', style: AppTypography.bodySmall),
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
                          const Icon(LucideIcons.scale, color: AppColors.warning, size: 24),
                          const SizedBox(height: 10),
                          Text('${collectorState.todayWeightKg} kg', style: AppTypography.titleLarge.copyWith(fontSize: 20)),
                          Text('Scrap Collected', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Nearby Requests Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nearby Pickup Requests 📍', style: AppTypography.titleMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.techBlueLight, borderRadius: BorderRadius.circular(20)),
                    child: Text('3 Live Requests', style: AppTypography.labelSmall.copyWith(color: AppColors.techBlue)),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Request Card 1
              CustomCard(
                padding: const EdgeInsets.all(18),
                border: Border.all(color: AppColors.techBlue, width: 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text('1.2 km away • Sector 62', style: AppTypography.titleSmall),
                          ],
                        ),
                        Text('Est. ₹118', style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Household: Aarav Sharma', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Address: Flat 402, Green Valley Apts, Sector 62', style: AppTypography.bodySmall),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.package, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 8),
                          Text('Plastic PET & Cardboard (~4.6 kg)', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Accept Request',
                            onPressed: () {
                              ref.read(collectorProvider.notifier).acceptRequest(collectorState.nearbyRequests.first);
                              context.go('/collector/navigation');
                            },
                            type: ButtonType.primary,
                            icon: LucideIcons.check,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'View Details',
                            onPressed: () => context.go('/collector/navigation'),
                            type: ButtonType.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Request Card 2
              CustomCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.mapPin, size: 16, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Text('2.4 km away • Sector 63', style: AppTypography.titleSmall),
                          ],
                        ),
                        Text('Est. ₹850', style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Household: Priya Verma', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Address: House 84, Block B, Sector 63', style: AppTypography.bodySmall),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.cpu, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 8),
                          Text('E-Waste: Old Laptops & Cables (~3.0 kg)', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Accept Request',
                            onPressed: () => context.go('/collector/navigation'),
                            type: ButtonType.primary,
                            icon: LucideIcons.check,
                          ),
                        ),
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
