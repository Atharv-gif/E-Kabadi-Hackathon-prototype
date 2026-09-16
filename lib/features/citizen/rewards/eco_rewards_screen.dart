import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/rewards_provider.dart';

class EcoRewardsScreen extends ConsumerWidget {
  const EcoRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(availableCouponsProvider);
    final historyAsync = ref.watch(citizenPointHistoryProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Eco Rewards & Badges', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Points Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.rewardGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Eco Points Balance',
                          style: AppTypography.titleSmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Level: Recycler 🌿', style: AppTypography.labelSmall.copyWith(color: AppColors.surface)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(LucideIcons.award, size: 40, color: AppColors.surface),
                        const SizedBox(width: 12),
                        Text(
                          '840',
                          style: AppTypography.displayLarge.copyWith(color: AppColors.surface, fontSize: 44),
                        ),
                        const SizedBox(width: 8),
                        Text('PTS', style: AppTypography.titleMedium.copyWith(color: AppColors.surface)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.84,
                        minHeight: 8,
                        backgroundColor: Colors.white30,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '160 points away from Green Hero level badge',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Redeem Vouchers Section
              Text('Redeem Rewards & Coupons', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              couponsAsync.when(
                data: (coupons) => Column(
                  children: coupons.map((c) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CustomCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.rewardOrangeLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.ticket, color: AppColors.rewardOrange, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.title, style: AppTypography.titleSmall),
                                  const SizedBox(height: 2),
                                  Text(c.description, style: AppTypography.bodySmall),
                                  const SizedBox(height: 4),
                                  Text('${c.pointsCost} Points Required', style: AppTypography.labelSmall.copyWith(color: AppColors.rewardOrange)),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: 'Redeem',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Redeemed ${c.title}! Coupon code: ${c.couponCode}')),
                                );
                              },
                              type: ButtonType.secondary,
                              width: 90,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error loading coupons: $e'),
              ),
              const SizedBox(height: 24),

              // Points History List
              Text('Points Transaction History', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              historyAsync.when(
                data: (history) => Column(
                  children: history.map((item) {
                    final isEarned = item.type == 'earned';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isEarned ? LucideIcons.arrowUpRight : LucideIcons.arrowDownLeft,
                                  color: isEarned ? AppColors.success : AppColors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: AppTypography.titleSmall),
                                    Text(item.description, style: AppTypography.bodySmall),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '${isEarned ? "+" : "-"}${item.points} pts',
                              style: AppTypography.titleSmall.copyWith(
                                color: isEarned ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const SizedBox(),
                error: (e, s) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
