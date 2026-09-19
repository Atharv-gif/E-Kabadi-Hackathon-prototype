import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/rewards_provider.dart';
import '../../../repositories/rewards_repository.dart';

class EcoRewardsScreen extends ConsumerWidget {
  const EcoRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(availableCouponsProvider);
    final historyAsync = ref.watch(citizenPointHistoryProvider);
    final points = ref.watch(citizenEcoPointsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Eco Rewards', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Reserve space for the floating bottom navigation bar.
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero points wallet ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  gradient: AppColors.rewardGradient,
                  borderRadius: AppRadius.rXl,
                  boxShadow: [BoxShadow(color: AppColors.rewardOrange.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Eco Points Balance',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.2),
                            borderRadius: AppRadius.rPill,
                          ),
                          child: Text(
                            'CITIZEN • ECO POINTS',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.surface, fontSize: 9.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(LucideIcons.award, size: 36, color: AppColors.surface),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '$points',
                          style: AppTypography.displayLarge.copyWith(color: AppColors.surface, fontSize: 42),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('PTS', style: AppTypography.titleMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9))),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // The citizen rule: Eco Points are earned only when the
                    // FINAL VERIFIED scrap bill is ₹500+ (10% of the bill).
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.14),
                        borderRadius: AppRadius.rMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.info, size: 15, color: AppColors.surface),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Earn 10% Eco Points on every pickup with a final bill of \u20B9500 or more.',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.surface, fontSize: 11.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Redeem coupons ──
              const SectionHeader(title: 'Redeem Rewards & Coupons'),
              const SizedBox(height: AppSpacing.md),
              couponsAsync.when(
                data: (coupons) => Column(
                  children: coupons.map((c) {
                    final affordable = points >= c.pointsCost;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: CustomCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(11),
                              decoration: const BoxDecoration(
                                color: AppColors.rewardOrangeLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.ticket, color: AppColors.rewardOrange, size: 22),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.title, style: AppTypography.titleSmall),
                                  const SizedBox(height: 2),
                                  Text(
                                    c.description,
                                    style: AppTypography.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${c.pointsCost} points required',
                                    style: AppTypography.labelSmall.copyWith(color: AppColors.rewardOrange, fontSize: 10),
                                  ),
                                  if (!affordable) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Need ${c.pointsCost - points} more points',
                                      style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomButton(
                                  // Disabled (null onPressed) until the citizen
                                  // has enough Eco Points — clearly greyed out.
                                  text: 'Redeem',
                                  onPressed: affordable ? () => _redeem(context, ref, c) : null,
                                  type: ButtonType.secondary,
                                  width: 88,
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => Column(
                  children: List.generate(
                    3,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: _CouponSkeleton(),
                    ),
                  ),
                ),
                error: (e, s) => ErrorView(
                  message: 'Could not load rewards right now.',
                  onRetry: () => ref.invalidate(availableCouponsProvider),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Points history ──
              const SectionHeader(title: 'Points Transaction History'),
              const SizedBox(height: AppSpacing.md),
              historyAsync.when(
                data: (history) => Column(
                  children: history.map((item) {
                    final isEarned = item.type == 'earned';
                    final isZeroAward = isEarned && item.points == 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: CustomCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isZeroAward
                                    ? AppColors.warningLight
                                    : isEarned
                                        ? AppColors.successLight
                                        : AppColors.errorLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isZeroAward
                                    ? LucideIcons.info
                                    : isEarned
                                        ? LucideIcons.arrowUpRight
                                        : LucideIcons.arrowDownLeft,
                                color: isZeroAward
                                    ? AppColors.warning
                                    : isEarned
                                        ? AppColors.success
                                        : AppColors.error,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: AppTypography.titleSmall),
                                  Text(item.description, style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                            Text(
                              isZeroAward ? '+0 pts' : '${isEarned ? "+" : "-"}${item.points} pts',
                              style: AppTypography.titleSmall.copyWith(
                                color: isZeroAward
                                    ? AppColors.textMuted
                                    : isEarned
                                        ? AppColors.success
                                        : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))),
                ),
                error: (e, s) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _redeem(BuildContext context, WidgetRef ref, RewardCoupon c) {
    final ok = ref.read(citizenEcoPointsProvider.notifier).redeem(c.pointsCost);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Redeemed ${c.title}! Coupon code: ${c.couponCode}'
              : 'Not enough Eco Points — you need ${c.pointsCost} points.',
        ),
      ),
    );
  }
}

class _CouponSkeleton extends StatelessWidget {
  const _CouponSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: const [
          SkeletonBox(width: 44, height: 44, radius: 22),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 140, height: 14, radius: 6),
                SizedBox(height: 8),
                SkeletonBox(width: 200, height: 11, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
