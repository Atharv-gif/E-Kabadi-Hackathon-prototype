import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_app_bar.dart';
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
    final weight = double.tryParse(_weightController.text) ?? 4.6;
    final amount = double.tryParse(_amountController.text) ?? 118.0;

    ref.read(collectorProvider.notifier).completeCollection(weight, amount);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(LucideIcons.checkCircle2, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Collection Completed!', style: AppTypography.titleMedium),
            const SizedBox(height: 8),
            Text('Citizen payment of ₹${amount.toStringAsFixed(0)} processed via UPI.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.rewardOrangeLight, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(LucideIcons.coins, color: AppColors.rewardOrange, size: 24),
                  const SizedBox(width: 10),
                  Text('+150 Eco Coins Earned!', style: AppTypography.titleSmall.copyWith(color: AppColors.rewardOrange)),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Verify & Weigh Scrap'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Handshake OTP Verification', style: AppTypography.titleMedium),
              const SizedBox(height: 8),
              Text('Ask the citizen for their 4-digit verification code to confirm pickup start.', style: AppTypography.bodySmall),
              const SizedBox(height: 12),

              CustomTextField(
                label: 'Citizen OTP Code',
                hint: '4829',
                controller: _otpController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(LucideIcons.key, color: AppColors.primary),
              ),
              const SizedBox(height: 24),

              Text('Scrap Weighing & Pricing', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              CustomCard(
                padding: const EdgeInsets.all(18),
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
                        const SizedBox(width: 14),
                        Expanded(
                          child: CustomTextField(
                            label: 'Final Payout (₹)',
                            hint: '118.00',
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(LucideIcons.indianRupee, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'AI Suggested Rate: ₹70 (Plastic) + ₹48 (Paper) = ₹118.00',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

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
