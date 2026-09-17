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
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/pickup_provider.dart';

class ScrapVerificationScreen extends ConsumerStatefulWidget {
  const ScrapVerificationScreen({super.key});

  @override
  ConsumerState<ScrapVerificationScreen> createState() => _ScrapVerificationScreenState();
}

class _ScrapVerificationScreenState extends ConsumerState<ScrapVerificationScreen> {
  bool _confirming = false;

  Future<void> _onConfirmPayment() async {
    setState(() => _confirming = true);
    await ref.read(pickupProvider.notifier).completePickupAndPay(4.6, 118.0);
    if (mounted) {
      context.push('/citizen/payment-receipt');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Doorstep Scrap Verification'),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collector Verified Breakdown',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Collector Ramesh verified material quality and weighed your scrap on a digital scale.',
                style: AppTypography.bodyMedium.copyWith(height: 1.5),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── AI vs Verified comparison ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.sparkles, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text('AI Estimate', style: AppTypography.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('\u20B9118.00', style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Text('Est. 4.6 kg', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    Container(height: 56, width: 1, color: AppColors.border),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.badgeCheck, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text('Verified Final', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\u20B9118.00',
                              style: AppTypography.displayMedium.copyWith(fontSize: 26, color: AppColors.primary),
                            ),
                            const SizedBox(height: 2),
                            Text('Actual 4.6 kg', style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xxl),

              Text('Verified Itemized List', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _itemRow('PET Plastic Bottles', '1.4 kg @ \u20B950/kg', '\u20B970.00'),
                    const Divider(height: AppSpacing.xl),
                    _itemRow('Cardboard Boxes', '3.2 kg @ \u20B915/kg', '\u20B948.00'),
                    const Divider(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.titleSmall),
                        Text(
                          '\u20B9118.00',
                          style: AppTypography.titleMedium.copyWith(color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Eco points banner ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.rewardOrangeLight,
                  borderRadius: AppRadius.rLg,
                  border: Border.all(color: AppColors.rewardOrange.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.award, color: AppColors.rewardOrange, size: 26),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+20 Eco Points Reward', style: AppTypography.titleSmall.copyWith(color: AppColors.rewardOrange)),
                          Text(
                            'You will earn 20 Eco Points once payment completes.',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              CustomButton(
                text: 'Accept Amount & Receive Payment',
                onPressed: _confirming ? null : _onConfirmPayment,
                isLoading: _confirming,
                icon: LucideIcons.wallet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemRow(String label, String detail, String amount) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
              Text(detail, style: AppTypography.bodySmall),
            ],
          ),
        ),
        Text(amount, style: AppTypography.titleSmall),
      ],
    );
  }
}
