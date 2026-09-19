import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../services/reward_rules_service.dart';
import '../../../providers/collector_provider.dart';

class CollectorVerificationScreen extends ConsumerStatefulWidget {
  const CollectorVerificationScreen({super.key});

  @override
  ConsumerState<CollectorVerificationScreen> createState() => _CollectorVerificationScreenState();
}

class _CollectorVerificationScreenState extends ConsumerState<CollectorVerificationScreen> {
  final TextEditingController _otpController = TextEditingController(text: '4829');
  final TextEditingController _weightController = TextEditingController(text: '4.6');
  final TextEditingController _amountController = TextEditingController(text: '118.00');

  void _onCompleteCollection() {
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    // Eco Coins on EVERY completed transaction — 10% of the final verified
    // amount. No ₹500 threshold for collectors (citizen-only rule).
    final coinsEarned = RewardRules.collectorEcoCoins(amount);

    ref.read(collectorProvider.notifier).completeCollection(weight, amount);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.rXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                child: const Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 44),
              ).animate().scale(duration: 450.ms, curve: Curves.elasticOut),
              const SizedBox(height: AppSpacing.lg),
              Text('Collection Completed!', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Citizen payment of \u20B9${amount.toStringAsFixed(0)} processed via UPI.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: AppColors.rewardOrangeLight, borderRadius: AppRadius.rMd),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.coins, color: AppColors.rewardOrange, size: 22),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '+$coinsEarned Eco Coins Earned!',
                      style: AppTypography.titleSmall.copyWith(color: AppColors.rewardOrange),
                    ),
                  ],
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 300.ms)
                  .then()
                  .shake(duration: 400.ms, hz: 3),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Back to Dashboard',
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/collector/dashboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify & Weigh Scrap'),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Reserve space for the floating bottom navigation bar.
          padding: const EdgeInsets.fromLTRB(20, 20, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── OTP verification ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.rSm),
                    child: const Icon(LucideIcons.key, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text('Handshake OTP Verification', style: AppTypography.titleMedium)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Ask the citizen for their 4-digit code to confirm the pickup.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Citizen OTP Code',
                hint: '4829',
                controller: _otpController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(LucideIcons.key, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Weighing ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.techBlueLight, borderRadius: AppRadius.rSm),
                    child: const Icon(LucideIcons.scale, size: 18, color: AppColors.techBlue),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text('Scrap Weighing & Pricing', style: AppTypography.titleMedium)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Actual Weight (kg)',
                            hint: '4.6',
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(LucideIcons.scale, color: AppColors.textMuted),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: CustomTextField(
                            label: 'Final Payout (\u20B9)',
                            hint: '118.00',
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(LucideIcons.indianRupee, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: AppRadius.rSm),
                      child: Text(
                        'AI Suggested Rate: \u20B970 (Plastic) + \u20B948 (Paper) = \u20B9118.00',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              CustomButton(
                text: 'Confirm Collection & Send Payment',
                onPressed: _onCompleteCollection,
                icon: LucideIcons.checkCircle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
