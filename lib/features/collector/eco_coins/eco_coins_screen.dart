import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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
      appBar: const CustomAppBar(title: 'Collector Eco Coins & Marketplace', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collector Hero Coin Balance Card
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
                          'Collector Eco Coins',
                          style: AppTypography.titleSmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Collector Tier: Gold 🏆', style: AppTypography.labelSmall.copyWith(color: AppColors.surface)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(LucideIcons.coins, size: 40, color: AppColors.surface),
                        const SizedBox(width: 12),
                        Text(
                          '1,250',
                          style: AppTypography.displayLarge.copyWith(color: AppColors.surface, fontSize: 44),
                        ),
                        const SizedBox(width: 8),
                        Text('COINS', style: AppTypography.titleMedium.copyWith(color: AppColors.surface)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Earn Eco Coins on every pickup to redeem ration, healthcare & tools.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Collector Marketplace Section
              Text('Collector Benefit Marketplace 🏬', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

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
              const SizedBox(height: 24),

              // Transaction History
              Text('Coin Transactions', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              coinHistoryAsync.when(
                data: (history) => Column(
                  children: history.map((item) {
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
                                  item.isCredit ? LucideIcons.plusCircle : LucideIcons.minusCircle,
                                  color: item.isCredit ? AppColors.success : AppColors.error,
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
                              '${item.isCredit ? "+" : "-"}${item.coins} coins',
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
                loading: () => const SizedBox(),
                error: (e, s) => const SizedBox(),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: AppColors.rewardOrangeLight, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.rewardOrange, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                  const SizedBox(height: 4),
                  Text('$coins Eco Coins', style: AppTypography.labelSmall.copyWith(color: AppColors.rewardOrange)),
                ],
              ),
            ),
            CustomButton(
              text: 'Redeem',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully redeemed "$title"!')),
                );
              },
              type: ButtonType.secondary,
              width: 90,
            ),
          ],
        ),
      ),
    );
  }
}
