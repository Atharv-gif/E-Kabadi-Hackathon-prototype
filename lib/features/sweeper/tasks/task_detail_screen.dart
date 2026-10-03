import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/sweeper_provider.dart';
import '../../../models/garbage_spot_model.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key});

  IconData _garbageIcon(GarbageType type) {
    switch (type) {
      case GarbageType.mixed:
        return LucideIcons.trash2;
      case GarbageType.plastic:
        return LucideIcons.recycle;
      case GarbageType.organic:
        return LucideIcons.leaf;
      case GarbageType.construction:
        return LucideIcons.building;
      case GarbageType.eWaste:
        return LucideIcons.cpu;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sweeperState = ref.watch(sweeperProvider);
    final spot = sweeperState.activeSpot;
    final activeTask = sweeperState.activeTask;
    final isLoading = sweeperState.isLoading;

    if (spot == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Task Details', showBack: true),
        body: const Center(child: Text('No task selected')),
      );
    }

    final distanceKm = ref.read(sweeperProvider.notifier).getDistanceKm(spot);
    final isClaimed = activeTask != null && activeTask.garbageSpotId == spot.id;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Garbage Cleaning Task', showBack: true),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Task hero ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.sweeperAmberLight,
                  borderRadius: AppRadius.rXl,
                  border: Border.all(color: AppColors.sweeperAmber.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: AppColors.sweeperAmber,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_garbageIcon(spot.garbageType), size: 28, color: AppColors.surface),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spot.garbageTypeLabel,
                                style: AppTypography.titleLarge.copyWith(fontSize: 20),
                              ),
                              Text(
                                spot.sizeLabel,
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.sweeperAmber),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xxl),

              // ── Details ──
              Text('Task Details', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),

              _DetailRow(icon: LucideIcons.droplets, label: 'Estimated Volume', value: '~${spot.estimatedVolumeLitres} L'),
              _DetailRow(icon: LucideIcons.mapPin, label: 'Distance', value: '${distanceKm.toStringAsFixed(1)} km away'),
              _DetailRow(icon: LucideIcons.award, label: 'Eco Points', value: 'Up to ${spot.rewardPoints}'),
              _DetailRow(icon: LucideIcons.calendar, label: 'Reported', value: spot.createdAt),
              _DetailRow(
                icon: LucideIcons.info,
                label: 'Status',
                value: isClaimed ? 'Claimed by you' : 'Available',
                valueColor: isClaimed ? AppColors.sweeperAmber : AppColors.success,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Description ──
              Text('Description', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  spot.description,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Location placeholder ──
              Text('Location', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppRadius.rLg,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.mapPin, size: 32, color: AppColors.sweeperAmber),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '📍 ${spot.latitude.toStringAsFixed(4)}, ${spot.longitude.toStringAsFixed(4)}',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${distanceKm.toStringAsFixed(1)} km from your location',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.sweeperAmber),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Action buttons ──
              if (!isClaimed)
                CustomButton(
                  text: 'Claim Task',
                  onPressed: isLoading
                      ? null
                      : () async {
                          final success = await ref.read(sweeperProvider.notifier).claimTask(spot.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Task claimed! You can now start cleaning.')),
                            );
                          }
                        },
                  isLoading: isLoading,
                  icon: LucideIcons.handMetal,
                )
              else
                CustomButton(
                  text: 'Start Cleaning',
                  onPressed: isLoading
                      ? null
                      : () async {
                          final success = await ref.read(sweeperProvider.notifier).startTask();
                          if (success && context.mounted) {
                            context.go('/sweeper/cleaning-workflow');
                          }
                        },
                  isLoading: isLoading,
                  icon: LucideIcons.sparkles,
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label, style: AppTypography.bodyMedium),
          ),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              fontSize: 14,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
