import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/pickup_provider.dart';

class ScrapVerificationScreen extends ConsumerWidget {
  const ScrapVerificationScreen({super.key});

  void _onConfirmPayment(BuildContext context, WidgetRef ref) async {
    await ref.read(pickupProvider.notifier).completePickupAndPay(4.6, 118.0);
    if (context.mounted) {
      context.push('/citizen/payment-receipt');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Doorstep Scrap Verification'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collector Verified Breakdown',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Collector Ramesh verified material quality and weighed scrap using digital scales.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Side-by-side Comparison Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Estimate', style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Text('₹118.00', style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Text('Est. 4.6 kg', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    Container(height: 50, width: 1, color: AppColors.border),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verified Final', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                            const SizedBox(height: 4),
                            Text(
                              '₹118.00',
                              style: AppTypography.displayMedium.copyWith(fontSize: 24, color: AppColors.primary),
                            ),
                            const SizedBox(height: 2),
                            Text('Actual 4.6 kg', style: AppTypography.titleSmall),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Verified Itemized List', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('PET Plastic Bottles (1.4 kg @ ₹50/kg)', style: AppTypography.bodyMedium),
                        Text('₹70.00', style: AppTypography.titleSmall),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cardboard Boxes (3.2 kg @ ₹15/kg)', style: AppTypography.bodyMedium),
                        Text('₹48.00', style: AppTypography.titleSmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Eco Points Notification Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.rewardOrangeLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.rewardOrange.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.award, color: AppColors.rewardOrange, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+20 Eco Points Reward', style: AppTypography.titleSmall.copyWith(color: AppColors.rewardOrange)),
                          Text('You will earn 20 Eco Points upon payment completion.', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Accept Amount & Receive Payment',
                onPressed: () => _onConfirmPayment(context, ref),
                icon: LucideIcons.wallet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
