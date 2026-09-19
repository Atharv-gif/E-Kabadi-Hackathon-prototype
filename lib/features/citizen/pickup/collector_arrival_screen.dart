import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/pickup_provider.dart';

class CollectorArrivalScreen extends ConsumerWidget {
  const CollectorArrivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);
    final active = pickupState.activePickup;
    final otpCode = active?.otpCode ?? '4829';
    final collectorName = active?.collectorName ?? 'Ramesh Kumar';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Collector Arrived'),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Reserve space for the floating bottom navigation bar.
          padding: const EdgeInsets.fromLTRB(20, 20, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.truck, size: 56, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Your collector has arrived!',
                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Verify the collector\u2019s identity and share the OTP before handing over your scrap.',
                style: AppTypography.bodyLarge.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Collector identity card ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryDark,
                      child: Text('RK', style: AppTypography.titleLarge.copyWith(color: AppColors.surface)),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(collectorName, style: AppTypography.titleMedium, overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.badgeCheck, size: 17, color: AppColors.techBlue),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('ID: COL-EK-892', style: AppTypography.bodySmall),
                          Text(
                            'Verified E-Kabaadi Partner',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── OTP share box ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppRadius.rXl,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'SHARE THIS CODE WITH COLLECTOR',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: otpCode
                          .split('')
                          .map((digit) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                width: 52,
                                height: 62,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: AppRadius.rMd,
                                  border: Border.all(color: AppColors.borderStrong),
                                  boxShadow: AppShadows.card,
                                ),
                                child: Text(
                                  digit,
                                  style: AppTypography.displayMedium.copyWith(fontSize: 26, color: AppColors.primaryDark),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: otpCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP copied to clipboard')),
                        );
                      },
                      icon: const Icon(LucideIcons.copy, size: 16, color: AppColors.primary),
                      label: Text('Copy Code', style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              CustomButton(
                text: 'Continue to Scrap Verification',
                onPressed: () => context.push('/citizen/scrap-verification'),
                icon: LucideIcons.scale,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
