import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.checkCircle2, size: 72, color: AppColors.primary),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),

              Text(
                'Payment Received!',
                style: AppTypography.displayMedium.copyWith(fontSize: 26, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 6),
              Text(
                'Direct UPI transfer completed successfully',
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '₹118.00',
                style: AppTypography.displayLarge.copyWith(fontSize: 40, color: AppColors.primary),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),

              // Transaction Receipt Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method', style: AppTypography.bodySmall),
                        Text('UPI / Google Pay', style: AppTypography.titleSmall),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transaction ID', style: AppTypography.bodySmall),
                        Text('TXN948102948', style: AppTypography.titleSmall),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date & Time', style: AppTypography.bodySmall),
                        Text('Today, 11:45 AM', style: AppTypography.titleSmall),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Collector', style: AppTypography.bodySmall),
                        Text('Ramesh Kumar', style: AppTypography.titleSmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Eco Reward Badge Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.rewardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.award, color: AppColors.surface, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+20 Eco Points Awarded!', style: AppTypography.titleSmall.copyWith(color: AppColors.surface)),
                          Text('You have unlocked Recycler Level 2!', style: AppTypography.bodySmall.copyWith(color: AppColors.surface.withValues(alpha: 0.9))),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.3, end: 0, delay: 500.ms),
              const Spacer(),

              CustomButton(
                text: 'Track Scrap Journey & Recycling',
                onPressed: () => context.go('/citizen/scrap-journey'),
                icon: LucideIcons.gitCommit,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Done',
                onPressed: () => context.go('/citizen/home'),
                type: ButtonType.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
