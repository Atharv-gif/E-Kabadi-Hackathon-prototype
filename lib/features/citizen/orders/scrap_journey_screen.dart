import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/common.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/rewards_provider.dart';

class ScrapJourneyScreen extends ConsumerWidget {
  const ScrapJourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(recyclingJourneysProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Scrap Journey & Traceability'),
      body: SafeArea(
        bottom: false,
        child: journeysAsync.when(
          data: (journeys) {
            if (journeys.isEmpty) {
              return const EmptyStateWidget(
                icon: LucideIcons.gitCommit,
                title: 'No journey records yet',
                description: 'Your recycling traceability timeline will appear here after your first completed pickup.',
              );
            }
            final jrn = journeys.first;
            return SingleChildScrollView(
              // Reserve space for the floating bottom navigation bar.
              padding: const EdgeInsets.fromLTRB(20, 20, 20, BottomNavBarMetrics.contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Certificate banner ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: AppRadius.rXl,
                      boxShadow: AppShadows.glowingGreen,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.badgeCheck, color: AppColors.surface, size: 26),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'Verified Recycling Certificate',
                                style: AppTypography.titleMedium.copyWith(color: AppColors.surface),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'BATCH ${jrn.certificateId}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryMedium, fontSize: 10, letterSpacing: 1),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${jrn.materialCategory} • ${jrn.weightKg} kg recycled',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.surface, fontSize: 19),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                  const SizedBox(height: AppSpacing.xxxl),

                  Text('End-to-End Material Traceability', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Timeline ──
                  ...List.generate(jrn.steps.length, (index) {
                    final step = jrn.steps[index];
                    final isLast = index == jrn.steps.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: step.isCompleted ? AppColors.primary : AppColors.surfaceVariant,
                                  shape: BoxShape.circle,
                                  border: step.isCompleted ? null : Border.all(color: AppColors.borderStrong),
                                ),
                                child: Icon(
                                  step.isCompleted ? LucideIcons.check : LucideIcons.circle,
                                  size: 15,
                                  color: step.isCompleted ? AppColors.surface : AppColors.textMuted,
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: step.isCompleted ? AppColors.primary : AppColors.border,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl),
                              child: CustomCard(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(step.title, style: AppTypography.titleSmall)),
                                        Text(step.timestamp, style: AppTypography.bodySmall),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(step.description, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: AppSpacing.sm),
                                    Row(
                                      children: [
                                        const Icon(LucideIcons.mapPin, size: 13, color: AppColors.primary),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            step.location,
                                            style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontSize: 10),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: (80.ms * index)).fadeIn(duration: 300.ms).slideY(begin: 0.06, end: 0);
                  }),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
          loading: () => const LoadingView(message: 'Loading your scrap journey…', icon: LucideIcons.gitCommit),
          error: (e, s) => ErrorView(
            message: 'Could not load traceability records.',
            onRetry: () => ref.invalidate(recyclingJourneysProvider),
          ),
        ),
      ),
    );
  }
}
