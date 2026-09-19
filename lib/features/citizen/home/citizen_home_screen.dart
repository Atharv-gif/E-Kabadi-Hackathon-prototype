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
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/pickup_provider.dart';
import '../../../providers/rewards_provider.dart';
import '../../../models/pickup_request_model.dart';

class CitizenHomeScreen extends ConsumerWidget {
  const CitizenHomeScreen({super.key});

  String _statusLine(PickupStatus? status) {
    switch (status) {
      case PickupStatus.pending:
      case PickupStatus.accepted:
        return 'Finding a collector for you';
      case PickupStatus.onTheWay:
        return 'Collector is on the way';
      case PickupStatus.arrived:
        return 'Collector has arrived';
      case PickupStatus.verified:
        return 'Scrap verified';
      case PickupStatus.completed:
        return 'Pickup completed';
      default:
        return 'Pickup in progress';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final pickupState = ref.watch(pickupProvider);
    final ecoPoints = ref.watch(citizenEcoPointsProvider);
    final userName = authState.user?.name ?? 'Aarav Sharma';
    final active = pickupState.activePickup;
    final hasActive = active != null &&
        active.status != PickupStatus.completed &&
        active.status != PickupStatus.cancelled;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () async {
            await ref.read(pickupProvider.notifier).loadPickups();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // Reserve space for the floating bottom navigation bar.
            padding: const EdgeInsets.fromLTRB(20, 16, 20, BottomNavBarMetrics.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userName.split(' ').first,
                            style: AppTypography.displayMedium.copyWith(fontSize: 26),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Notifications view open')),
                              );
                            },
                            icon: const Icon(LucideIcons.bell, size: 22, color: AppColors.textPrimary),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Active pickup banner ──
                if (hasActive) ...[
                  CustomCard(
                    color: AppColors.techBlueLight,
                    border: Border.all(color: AppColors.techBlue, width: 1.5),
                    borderRadius: 18,
                    onTap: () => context.push('/citizen/live-tracking'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
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
                                _statusLine(active.status),
                                style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${active.collectorName} • ETA ~6 min',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.techBlue),
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevronRight, size: 20, color: AppColors.techBlue),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.08, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // ── Hero CTA card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: AppRadius.rXl,
                    boxShadow: AppShadows.glowingGreen,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.16),
                          borderRadius: AppRadius.rPill,
                        ),
                        child: Text(
                          'INSTANT DOORSTEP PICKUP',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primaryLight,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Find a Scrap Collector',
                        style: AppTypography.displayMedium.copyWith(
                          color: AppColors.surface,
                          fontSize: 26,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Turn unused household scrap into cash — AI estimates, verified pickup, instant UPI payment.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primaryLight.withValues(alpha: 0.95),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Sell Scrap Now',
                              onPressed: () => context.go('/citizen/sell'),
                              icon: LucideIcons.camera,
                              type: ButtonType.secondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: CustomButton(
                              text: 'Schedule Pickup',
                              onPressed: () => context.push('/citizen/schedule-pickup'),
                              icon: LucideIcons.calendar,
                              type: ButtonType.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Impact metrics ──
                const SectionHeader(title: 'Your Environmental Impact'),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        icon: LucideIcons.scale,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.primaryLight,
                        value: '12.5 kg',
                        label: 'Scrap Recycled',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: MetricCard(
                        icon: LucideIcons.leaf,
                        iconColor: AppColors.success,
                        iconBg: AppColors.successLight,
                        value: '23.4 kg',
                        label: 'CO\u2082 Saved',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: MetricCard(
                        icon: LucideIcons.award,
                        iconColor: AppColors.rewardOrange,
                        iconBg: AppColors.rewardOrangeLight,
                        value: '$ecoPoints',
                        label: 'Eco Points',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Money received card ──
                CustomCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: AppRadius.rMd,
                        ),
                        child: const Icon(LucideIcons.banknote, size: 24, color: AppColors.primary),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Money Received', style: AppTypography.bodySmall),
                            const SizedBox(height: 2),
                            Text(
                              '\u20B91,248',
                              style: AppTypography.titleLarge.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/citizen/orders'),
                        child: Text('History', style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ── Recent pickups ──
                SectionHeader(
                  title: 'Recent Pickups',
                  actionLabel: 'View All',
                  onAction: () => context.go('/citizen/orders'),
                ),
                const SizedBox(height: AppSpacing.md),
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
                        child: const Icon(LucideIcons.packageCheck, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Plastic & Cardboard Scrap', style: AppTypography.titleSmall),
                            const SizedBox(height: 2),
                            Text(
                              '18 Sep 2026 • Collector Ramesh Kumar',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('+ \u20B9118', style: AppTypography.titleSmall.copyWith(color: AppColors.success)),
                          // ₹118 bill is below the ₹500 minimum → no Eco Points.
                          Text(
                            'No Eco Points',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
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
      ),
    );
  }
}
