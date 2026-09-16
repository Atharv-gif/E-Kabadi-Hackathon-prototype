import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/scrap_provider.dart';

class SellScrapScreen extends ConsumerWidget {
  const SellScrapScreen({super.key});

  void _startAiScan(BuildContext context, WidgetRef ref) async {
    // Start scan and navigate to AI analysis screen
    await ref.read(scrapScanProvider.notifier).analyzeImage('assets/images/img 1.png');
    if (context.mounted) {
      context.push('/citizen/ai-analysis');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryPricesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sell Your Scrap', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload a Photo & Let AI Identify',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Our computer vision AI will scan materials, estimate weight, and calculate approximate market value.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Camera Upload Hero Box
              CustomCard(
                padding: const EdgeInsets.all(24),
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                border: Border.all(color: AppColors.primary, width: 2),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.camera, size: 40, color: AppColors.surface),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scan Scrap with AI Camera',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Supports Plastic, Paper, Metals, E-Waste & Appliances',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Take Photo',
                            onPressed: () => _startAiScan(context, ref),
                            icon: LucideIcons.camera,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'From Gallery',
                            onPressed: () => _startAiScan(context, ref),
                            type: ButtonType.secondary,
                            icon: LucideIcons.image,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Category Rates Grid
              Text('Live Scrap Rates', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              categoriesAsync.when(
                data: (categories) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return CustomCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () {
                        ref.read(scrapScanProvider.notifier).selectCategory(cat.category);
                        _startAiScan(context, ref);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(LucideIcons.package, size: 20, color: AppColors.primary),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textMuted),
                            ],
                          ),
                          const Spacer(),
                          Text(cat.category, style: AppTypography.titleSmall),
                          const SizedBox(height: 2),
                          Text(
                            cat.priceRange,
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error loading categories: $err'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
