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
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../services/camera_service.dart';
import '../../../providers/scrap_provider.dart';

class SellScrapScreen extends ConsumerWidget {
  const SellScrapScreen({super.key});

  /// Opens the REAL Android device camera. Results are handled gracefully:
  /// cancellation is silent, failures show a friendly message.
  Future<void> _takePhoto(BuildContext context, WidgetRef ref) async {
    final camera = ref.read(cameraServiceProvider);
    final result = await camera.capturePhoto();

    if (!context.mounted) return;

    switch (result) {
      case CameraCaptureSuccess(:final filePath):
        // Replace any previous photo with the new capture.
        await ref.read(scrapScanProvider.notifier).analyzeCameraPhoto(filePath);
        if (context.mounted) {
          context.push('/citizen/ai-analysis');
        }
      case CameraCaptureCancelled():
        // User backed out of the camera — nothing to do.
        break;
      case CameraCaptureFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  /// Gallery pick keeps the same downstream flow as the camera capture.
  Future<void> _pickFromGallery(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(cameraServiceProvider).captureFromGallery();
    if (!context.mounted) return;
    switch (result) {
      case CameraCaptureSuccess(:final filePath):
        await ref.read(scrapScanProvider.notifier).analyzeImage(filePath);
        if (context.mounted) {
          context.push('/citizen/ai-analysis');
        }
      case CameraCaptureCancelled():
        break;
      case CameraCaptureFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryPricesProvider);
    final scanState = ref.watch(scrapScanProvider);
    final preview = previewFileOf(scanState);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sell Your Scrap', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Reserve space for the floating bottom navigation bar.
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
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
                    if (preview != null) ...[
                      // ── Live preview of the captured photo ──
                      ClipRRect(
                        borderRadius: AppRadius.rLg,
                        child: SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Image.file(
                            preview,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.surfaceVariant,
                              child: const Icon(LucideIcons.imageOff, size: 40, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.checkCircle2, size: 15, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Photo captured — tap Take Photo to replace',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ] else ...[
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
                    ],
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
                            onPressed: () => _takePhoto(context, ref),
                            icon: LucideIcons.camera,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: CustomButton(
                            text: 'From Gallery',
                            onPressed: () => _pickFromGallery(context, ref),
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

              // ── Live rates (informational only — NOT clickable) ──
              const SectionHeader(title: 'Live Scrap Rates'),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Indicative rates per kg — final payout is confirmed after doorstep weighing.',
                style: AppTypography.bodySmall,
              ),
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
                    // Informational card only: no onTap, no ripple,
                    // no navigation arrow. Tapping does nothing.
                    return CustomCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: AppRadius.rSm,
                            ),
                            child: const Icon(LucideIcons.package, size: 18, color: AppColors.primary),
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
