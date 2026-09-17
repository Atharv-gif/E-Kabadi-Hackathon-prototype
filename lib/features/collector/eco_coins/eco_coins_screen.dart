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
import '../../../providers/rewards_provider.dart';

class EcoCoinsScreen extends ConsumerWidget {
  const EcoCoinsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinHistoryAsync = ref.watch(collectorCoinHistoryProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Eco Coins', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero coin wallet ──
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
                          'Collector Eco Coins',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.2),
                            borderRadius: AppRadius.rPill,
                          ),
                          child: Text(
                            'GOLD TIER',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.surface, fontSize: 9.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(LucideIcons.coins, size: 34, color: AppColors.surface),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '1,250',
                          style: AppTypography.displayLarge.copyWith(color: AppColors.surface, fontSize: 42),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'COINS',
                            style: AppTypography.titleMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                          ),
                        ),
                      ],
                    ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Earn coins on every pickup — redeem for ration, healthcare & tools.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9), height: 1.45),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xl),

              // ── Earnings stats ──
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.trendingUp, size: 20, color: AppColors.success),
                          const SizedBox(height: AppSpacing.sm),
                          Text('+150', style: AppTypography.titleLarge.copyWith(fontSize: 19)),
                          Text('Earned Today', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CustomCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.trophy, size: 20, color: AppColors.rewardOrange),
                          const SizedBox(height: AppSpacing.sm),
                          Text('4,830', style: AppTypography.titleLarge.copyWith(fontSize: 19)),
                          Text('Total Earned', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Marketplace ──
              Text('Collector Benefit Marketplace', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _buildBenefitCard(
                context,
                title: 'Monthly Household Ration Kit',
                subtitle: 'Includes 10kg Atta, 5kg Basmati Rice, 2L Oil & Pulses.',
                coins: 500,
                icon: LucideIcons.shoppingBag,
              ),
              _buildBenefitCard(
                context,
                title: 'Free Family Healthcare Voucher',
                subtitle: 'Valid for full body health checkup at Apollo Clinic.',
                coins: 300,
                icon: LucideIcons.stethoscope,
              ),
              _buildBenefitCard(
                context,
                title: 'Heavy Duty Gloves & Digital Scale',
                subtitle: 'Professional 100kg digital scale + Kevlar grip gloves.',
                coins: 400,
                icon: LucideIcons.wrench,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Coin history ──
              Text('Coin Transactions', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              coinHistoryAsync.when(
                data: (history) => Column(
                  children: history.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: CustomCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: item.isCredit ? AppColors.successLight : AppColors.errorLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.isCredit ? LucideIcons.plusCircle : LucideIcons.minusCircle,
                                color: item.isCredit ? AppColors.success : AppColors.error,
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
                              '${item.isCredit ? "+" : "-"}${item.coins}',
                              style: AppTypography.titleSmall.copyWith(
                                color: item.isCredit ? AppColors.success : AppColors.error,
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

  Widget _buildBenefitCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int coins,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: CustomCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: const BoxDecoration(color: AppColors.rewardOrangeLight, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.rewardOrange, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$coins Eco Coins',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.rewardOrange, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            CustomButton(
              text: 'Redeem',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully redeemed "$title"!')),
                );
              },
              type: ButtonType.secondary,
              width: 88,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
