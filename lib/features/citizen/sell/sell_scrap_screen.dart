import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/common.dart';
import '../../../providers/scrap_provider.dart';

class SellScrapScreen extends ConsumerWidget {
  const SellScrapScreen({super.key});

  void _startAiScan(BuildContext context, WidgetRef ref) async {
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
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload a Photo & Let AI Identify',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Our AI detects the material type; you confirm the approximate weight. Final amount is calculated after collector verification.',
                style: AppTypography.bodyMedium.copyWith(height: 1.5),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Premium upload zone ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.4),
                  borderRadius: AppRadius.rXl,
                  border: Border.all(color: AppColors.primaryMedium, width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Color(0x3315803D), blurRadius: 20, offset: Offset(0, 8))],
                      ),
                      child: const Icon(LucideIcons.scanLine, size: 36, color: AppColors.surface),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Scan Scrap with AI Camera',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Plastic • Paper • Metal • E-Waste • Appliances',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Take Photo',
                            onPressed: () => _startAiScan(context, ref),
                            icon: LucideIcons.camera,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
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
              const SizedBox(height: AppSpacing.xxxl),

              // ── Live rates ──
              const SectionHeader(title: 'Live Scrap Rates'),
              const SizedBox(height: AppSpacing.md),
              categoriesAsync.when(
                data: (categories) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
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
                                  borderRadius: AppRadius.rSm,
                                ),
                                child: const Icon(LucideIcons.package, size: 18, color: AppColors.primary),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textMuted),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            cat.category,
                            style: AppTypography.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                loading: () => GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: List.generate(6, (_) => const _RateCardSkeleton()),
                ),
                error: (err, stack) => ErrorView(
                  message: 'Could not load today\u2019s scrap rates.',
                  onRetry: () => ref.invalidate(categoryPricesProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RateCardSkeleton extends StatelessWidget {
  const _RateCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SkeletonBox(width: 36, height: 36, radius: 10),
          Spacer(),
          SkeletonBox(width: 90, height: 14, radius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: 64, height: 11, radius: 6),
        ],
      ),
    );
  }
}
