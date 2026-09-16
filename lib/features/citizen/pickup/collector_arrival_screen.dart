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

class CollectorArrivalScreen extends ConsumerWidget {
  const CollectorArrivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);
    final active = pickupState.activePickup;
    final otpCode = active?.otpCode ?? '4829';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Collector Arrived'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.truck, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                'Your collector has arrived!',
                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Verify the collector identity & share the OTP before handing over scrap.',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Collector Verification Card
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryDark,
                      child: Text('RK', style: AppTypography.titleLarge.copyWith(color: AppColors.surface)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Ramesh Kumar', style: AppTypography.titleMedium),
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.badgeCheck, size: 18, color: AppColors.techBlue),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('ID: COL-EK-892', style: AppTypography.bodySmall),
                          Text('Verified E-Kabaadi Partner', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Share OTP Code Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Column(
                  children: [
                    Text('Share Verification OTP', style: AppTypography.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: otpCode.split('').map((digit) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            digit,
                            style: AppTypography.displayMedium.copyWith(color: AppColors.primary),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              CustomButton(
                text: 'Verify Scrap & Calculate Price',
                onPressed: () => context.push('/citizen/scrap-verification'),
                icon: LucideIcons.scale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
