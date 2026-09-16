import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/pickup_provider.dart';

class PickupHistoryScreen extends ConsumerWidget {
  const PickupHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);
    final pickups = pickupState.allPickups;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Pickup Orders & Traceability', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Scrap Orders', style: AppTypography.titleLarge),
              const SizedBox(height: 6),
              Text('Track doorstep pickup status, receipts & recycling certificates.', style: AppTypography.bodyMedium),
              const SizedBox(height: 20),

              if (pickups.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text('No pickup history found.', style: AppTypography.bodyMedium),
                  ),
                )
              else
                Column(
                  children: pickups.map((pickup) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CustomCard(
                        padding: const EdgeInsets.all(16),
                        onTap: () => context.push('/citizen/scrap-journey'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(LucideIcons.calendar, size: 16, color: AppColors.textMuted),
                                    const SizedBox(width: 6),
                                    Text(pickup.scheduledDate, style: AppTypography.bodySmall),
                                  ],
                                ),
                                StatusBadge(status: pickup.status),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(LucideIcons.packageCheck, color: AppColors.primary, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pickup.items.map((i) => i.category).toSet().join(', '),
                                        style: AppTypography.titleSmall,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Collector: ${pickup.collectorName}',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹${pickup.totalEstimatedPrice.toStringAsFixed(0)}',
                                      style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text('Traceability', style: AppTypography.labelSmall.copyWith(color: AppColors.techBlue)),
                                        const Icon(LucideIcons.chevronRight, size: 14, color: AppColors.techBlue),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
