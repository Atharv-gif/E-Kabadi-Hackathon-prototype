import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/collector_provider.dart';
import '../../../providers/rewards_provider.dart';

class CollectorDashboardScreen extends ConsumerWidget {
  const CollectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectorState = ref.watch(collectorProvider);
    final ecoCoins = ref.watch(collectorEcoCoinsProvider);
    final isAvailable = collectorState.isAvailable;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Reserve space for the floating bottom navigation bar.
          padding: const EdgeInsets.fromLTRB(20, 16, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
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
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Ramesh Kumar',
                                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(LucideIcons.badgeCheck, size: 19, color: AppColors.techBlue),
                          ],
                        ),
                        Text('Sector 62 & 63 Zone, Noida', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.techBlueLight,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => context.go('/collector/voice'),
                      icon: const Icon(LucideIcons.mic, color: AppColors.techBlue, size: 21),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Availability toggle ──
              AnimatedContainer(
                duration: AppDurations.normal,
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isAvailable ? AppColors.successLight : AppColors.surfaceVariant,
                  borderRadius: AppRadius.rLg,
                  border: Border.all(
                    color: isAvailable ? AppColors.success : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isAvailable ? AppColors.success : AppColors.textMuted,
                        shape: BoxShape.circle,
                        boxShadow: isAvailable
                            ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1)]
                            : null,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeOut(duration: 900.ms).then().fadeIn(duration: 900.ms),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAvailable ? 'You\u2019re ONLINE' : 'You\u2019re OFFLINE',
                            style: AppTypography.titleSmall.copyWith(
                              color: isAvailable ? AppColors.success : AppColors.textMuted,
                            ),
                          ),
                          Text(
                            isAvailable ? 'Available for pickups' : 'Duty paused — no new requests',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isAvailable,
                      onChanged: (val) {
                        ref.read(collectorProvider.notifier).toggleAvailability(val);
                      },
                      activeThumbColor: AppColors.success,
                      activeTrackColor: AppColors.successLight,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Metrics grid ──
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      icon: LucideIcons.wallet,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primaryLight,
                      value: '\u20B9${collectorState.todayEarnings.toStringAsFixed(0)}',
                      label: 'Today Earnings',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: MetricCard(
                      icon: LucideIcons.package,
                      iconColor: AppColors.techBlue,
                      iconBg: AppColors.techBlueLight,
                      value: '${collectorState.todayPickupsCount}',
                      label: 'Pickups Done',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: MetricCard(
                      icon: LucideIcons.scale,
                      iconColor: AppColors.warning,
                      iconBg: AppColors.warningLight,
                      value: '${collectorState.todayWeightKg} kg',
                      label: 'Collected',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Eco coins quick card ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                color: AppColors.rewardOrangeLight,
                border: Border.all(color: AppColors.rewardOrange.withValues(alpha: 0.35)),
                onTap: () => context.go('/collector/eco-coins'),
                child: Row(
                  children: [
                    const Icon(LucideIcons.coins, color: AppColors.rewardOrange, size: 26),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eco Coins Balance', style: AppTypography.bodySmall),
                          Text(
                            '$ecoCoins coins • 10% on every pickup',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.rewardOrange),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.rewardOrange),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Nearby requests ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Nearby Pickup Requests', style: AppTypography.titleMedium, overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.techBlueLight, borderRadius: AppRadius.rPill),
                    child: Text(
                      '${collectorState.nearbyRequests.length} LIVE',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.techBlue, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Request card 1 — active assignable
              if (collectorState.nearbyRequests.isNotEmpty)
                _RequestCard(
                  distance: '1.2 km away • Sector 62',
                  amount: '\u20B9118',
                  citizen: 'Aarav Sharma',
                  address: 'Flat 402, Green Valley Apts, Sector 62',
                  scrap: 'Plastic PET & Cardboard (~4.6 kg)',
                  scrapIcon: LucideIcons.package,
                  highlighted: true,
                  onAccept: () {
                    ref.read(collectorProvider.notifier).acceptRequest(collectorState.nearbyRequests.first);
                    context.go('/collector/navigation');
                  },
                  onView: () => context.go('/collector/navigation'),
                ),
              const SizedBox(height: AppSpacing.md),

              // Request card 2
              _RequestCard(
                distance: '2.4 km away • Sector 63',
                amount: '\u20B9850',
                citizen: 'Priya Verma',
                address: 'House 84, Block B, Sector 63',
                scrap: 'E-Waste: Old Laptops & Cables (~3.0 kg)',
                scrapIcon: LucideIcons.cpu,
                highlighted: false,
                onAccept: () => context.go('/collector/navigation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String distance;
  final String amount;
  final String citizen;
  final String address;
  final String scrap;
  final IconData scrapIcon;
  final bool highlighted;
  final VoidCallback onAccept;
  final VoidCallback? onView;

  const _RequestCard({
    required this.distance,
    required this.amount,
    required this.citizen,
    required this.address,
    required this.scrap,
    required this.scrapIcon,
    required this.highlighted,
    required this.onAccept,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: Border.all(
        color: highlighted ? AppColors.primary : AppColors.border,
        width: highlighted ? 1.5 : 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 15, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        distance,
                        style: AppTypography.titleSmall.copyWith(fontSize: 13.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Est. $amount',
                style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            citizen,
            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text(address, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: AppRadius.rSm),
            child: Row(
              children: [
                Icon(scrapIcon, size: 16, color: AppColors.textMuted),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    scrap,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Accept Request',
                  onPressed: onAccept,
                  icon: LucideIcons.check,
                ),
              ),
              if (onView != null) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomButton(
                    text: 'View Details',
                    onPressed: onView,
                    type: ButtonType.secondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
