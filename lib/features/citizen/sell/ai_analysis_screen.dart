import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/scrap_provider.dart';

class AiAnalysisScreen extends ConsumerWidget {
  const AiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scrapScanProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'AI Scrap Classification'),
      body: SafeArea(
        child: scanState.isAnalyzing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.scanLine, size: 64, color: AppColors.primary),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1)),
                    const SizedBox(height: 24),
                    Text(
                      'AI Computer Vision Scanning...',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detecting polymers, density, and market rates',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Preview with AI overlay tag
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            color: AppColors.surfaceVariant,
                            child: Image.asset(
                              'assets/images/img 1.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.primaryDark,
                                child: const Center(
                                  child: Icon(LucideIcons.recycle, size: 80, color: AppColors.surface),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.sparkles, size: 14, color: AppColors.primaryMedium),
                                const SizedBox(width: 6),
                                Text(
                                  'AI Identified • 94% Confidence',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.surface),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Text('Detected Scrap Materials', style: AppTypography.titleMedium),
                    const SizedBox(height: 12),

                    // Detected Items List
                    ...scanState.analyzedItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          padding: const EdgeInsets.all(16),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryLight,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(LucideIcons.package, color: AppColors.primary, size: 22),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.category, style: AppTypography.titleSmall),
                                          Text(item.subType, style: AppTypography.bodySmall),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${item.estimatedTotal.toStringAsFixed(0)}',
                                        style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
                                      ),
                                      Text(
                                        '~${item.weightKg} kg',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Mandatory AI Disclaimer Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.alertCircle, color: AppColors.warning, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'The AI provides an approximate classification and price estimate. Final classification, weight and price are verified during pickup.',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    CustomButton(
                      text: 'Confirm & Schedule Pickup',
                      onPressed: () => context.push('/citizen/schedule-pickup'),
                      icon: LucideIcons.calendarCheck,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Retake Photo',
                            onPressed: () => context.pop(),
                            type: ButtonType.outline,
                            icon: LucideIcons.refreshCw,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'Edit Manually',
                            onPressed: () => context.pop(),
                            type: ButtonType.secondary,
                            icon: LucideIcons.edit3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
