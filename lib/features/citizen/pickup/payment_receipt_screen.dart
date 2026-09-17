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
import '../../../providers/pickup_provider.dart';

class PaymentReceiptScreen extends ConsumerWidget {
  const PaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payment = ref.watch(pickupProvider).lastPayment;

    final amount = payment != null ? '\u20B9${payment.amount.toStringAsFixed(2)}' : '\u20B9118.00';
    final txnId = payment?.transactionId ?? 'TXN948102948';
    final points = payment?.ecoPointsEarned ?? 20;
    final method = payment?.method ?? 'UPI / Google Pay';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.25), blurRadius: 30, spreadRadius: 6)],
                ),
                child: const Icon(LucideIcons.checkCircle2, size: 64, color: AppColors.success),
              )
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.elasticOut)
                  .then()
                  .shake(duration: 300.ms, hz: 4),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                'Payment Received!',
                style: AppTypography.displayMedium.copyWith(fontSize: 26, color: AppColors.primaryDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Direct UPI transfer completed successfully',
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                amount,
                style: AppTypography.displayLarge.copyWith(fontSize: 40, color: AppColors.primary),
              ).animate(delay: 250.ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.xxl),

              // ── Receipt card ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    _receiptRow('Payment Method', method),
                    const Divider(height: AppSpacing.xl),
                    _receiptRow('Transaction ID', txnId),
                    const Divider(height: AppSpacing.xl),
                    _receiptRow('Date & Time', 'Today, 11:45 AM'),
                    const Divider(height: AppSpacing.xl),
                    _receiptRow('Collector', 'Ramesh Kumar'),
                    const Divider(height: AppSpacing.xl),
                    _receiptRow('Weight Verified', '4.6 kg'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Eco reward banner ──
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: AppColors.rewardGradient,
                  borderRadius: AppRadius.rLg,
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.award, color: AppColors.surface, size: 30),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+$points Eco Points Awarded!',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.surface),
                          ),
                          Text(
                            'You have unlocked Recycler Level 2!',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 450.ms).slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic).fadeIn(),
              const SizedBox(height: AppSpacing.xxl),

              CustomButton(
                text: 'Track Scrap Journey & Recycling',
                onPressed: () => context.push('/citizen/scrap-journey'),
                icon: LucideIcons.gitCommit,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomButton(
                text: 'Done',
                onPressed: () => context.go('/citizen/home'),
                type: ButtonType.secondary,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall),
        Flexible(
          child: Text(
            value,
            style: AppTypography.titleSmall.copyWith(fontSize: 13.5),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
