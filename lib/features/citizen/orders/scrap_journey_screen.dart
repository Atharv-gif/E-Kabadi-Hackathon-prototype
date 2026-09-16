import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/rewards_provider.dart';

class ScrapJourneyScreen extends ConsumerWidget {
  const ScrapJourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeysAsync = ref.watch(recyclingJourneysProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Scrap Journey & Traceability'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: journeysAsync.when(
            data: (journeys) {
              if (journeys.isEmpty) return const Center(child: Text('No journey records'));
              final jrn = journeys.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Certificate Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.award, color: AppColors.surface, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              'Verified Recycling Certificate',
                              style: AppTypography.titleMedium.copyWith(color: AppColors.surface),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Batch ID: ${jrn.certificateId}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${jrn.materialCategory} • ${jrn.weightKg} kg Recycled',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.surface, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  Text('End-to-End Material Traceability Timeline', style: AppTypography.titleMedium),
                  const SizedBox(height: 16),

                  // Vertical Timeline Steps
                  ...List.generate(jrn.steps.length, (index) {
                    final step = jrn.steps[index];
                    final isLast = index == jrn.steps.length - 1;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: step.isCompleted ? AppColors.primary : AppColors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                step.isCompleted ? LucideIcons.check : LucideIcons.circle,
                                size: 16,
                                color: step.isCompleted ? AppColors.surface : AppColors.textMuted,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 50,
                                color: step.isCompleted ? AppColors.primary : AppColors.border,
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: CustomCard(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(step.title, style: AppTypography.titleSmall),
                                      Text(step.timestamp, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(step.description, style: AppTypography.bodySmall),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(LucideIcons.mapPin, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 4),
                                      Text(step.location, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error: $e'),
          ),
        ),
      ),
    );
  }
}
