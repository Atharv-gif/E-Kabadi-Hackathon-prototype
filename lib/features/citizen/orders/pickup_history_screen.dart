import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/pickup_provider.dart';

class PickupHistoryScreen extends ConsumerWidget {
  const PickupHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);
    final pickups = pickupState.allPickups;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Pickup History', showBack: false),
      body: SafeArea(
        bottom: false,
        child: pickups.isEmpty
            ? EmptyStateWidget(
                icon: LucideIcons.packageOpen,
                title: 'No pickup history yet',
                description: 'Your completed scrap pickups will appear here.',
                buttonText: 'Find a Collector',
                onButtonPressed: () => context.go('/citizen/sell'),
              )
            : SingleChildScrollView(
                // Reserve space for the floating bottom navigation bar.
                padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Scrap Orders', style: AppTypography.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Track pickup status, receipts & recycling certificates.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ...pickups.map((pickup) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: CustomCard(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          onTap: () => context.push('/citizen/scrap-journey'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(LucideIcons.calendar, size: 15, color: AppColors.textMuted),
                                      const SizedBox(width: 6),
                                      Text(pickup.scheduledDate, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                  StatusBadge(status: pickup.status),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(11),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(LucideIcons.packageCheck, color: AppColors.primary, size: 20),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pickup.items.map((i) => i.category).toSet().join(', '),
                                          style: AppTypography.titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                        '\u20B9${pickup.totalEstimatedPrice.toStringAsFixed(0)}',
                                        style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${pickup.finalVerifiedWeight > 0 ? pickup.finalVerifiedWeight.toStringAsFixed(1) : '~${pickup.items.fold<double>(0, (s, i) => s + i.weightKg).toStringAsFixed(1)}'} kg',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: (80.ms * pickups.indexOf(pickup))).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}
