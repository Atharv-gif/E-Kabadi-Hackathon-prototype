import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../providers/sweeper_provider.dart';
import '../../../providers/rewards_provider.dart';
import '../../../models/cleaning_task_model.dart';

class TaskCompletionScreen extends ConsumerWidget {
  const TaskCompletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sweeperState = ref.watch(sweeperProvider);
    final task = sweeperState.activeTask;
    final ecoPoints = ref.watch(sweeperEcoPointsProvider);

    if (task == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.checkCircle, size: 48, color: AppColors.success),
              const SizedBox(height: AppSpacing.lg),
              Text('No active task', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Back to Dashboard',
                onPressed: () {
                  ref.read(sweeperProvider.notifier).clearActiveTask();
                  context.go('/sweeper/dashboard');
                },
                width: 200,
              ),
            ],
          ),
        ),
      );
    }

    final isVerificationPending = task.status == CleaningTaskStatus.verificationPending;
    final isCompleted = task.status == CleaningTaskStatus.completed;
    final estimatedPoints = task.ecoPointsAwarded;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // ── Success icon ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.successLight : AppColors.sweeperAmberLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? LucideIcons.checkCircle2 : LucideIcons.clock,
                  size: 64,
                  color: isCompleted ? AppColors.success : AppColors.sweeperAmber,
                ),
              ).animate().scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                isCompleted ? 'Cleaning Verified! ✅' : 'Cleaning Submitted ✅',
                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.md),

              Text(
                isCompleted
                    ? 'Your task has been verified and Eco Points have been credited!'
                    : 'Your task is now under verification.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Points info ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.successLight : AppColors.sweeperAmberLight,
                  borderRadius: AppRadius.rXl,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.3)
                        : AppColors.sweeperAmber.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      isCompleted ? 'Eco Points Credited' : 'Estimated Eco Points',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.award,
                          size: 28,
                          color: isCompleted ? AppColors.success : AppColors.sweeperAmber,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '+$estimatedPoints',
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 36,
                            color: isCompleted ? AppColors.success : AppColors.sweeperAmber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isCompleted
                          ? 'Total balance: $ecoPoints Eco Points'
                          : 'You will receive your Eco Points after verification.',
                      style: AppTypography.bodySmall.copyWith(
                        color: isCompleted ? AppColors.success : AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (task.reportedVolumeLitres != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Reported volume: ${task.reportedVolumeLitres!.toStringAsFixed(0)} L',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.lg),

              // ── Status badge ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.successLight : AppColors.warningLight,
                  borderRadius: AppRadius.rPill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompleted ? LucideIcons.shieldCheck : LucideIcons.clock,
                      size: 16,
                      color: isCompleted ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isCompleted ? 'Verified & Completed' : 'Verification Pending',
                      style: AppTypography.labelSmall.copyWith(
                        color: isCompleted ? AppColors.success : AppColors.warning,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ── Action buttons ──
              if (isVerificationPending) ...[
                CustomButton(
                  text: 'Mock Verify (Demo)',
                  onPressed: sweeperState.isLoading
                      ? null
                      : () async {
                          await ref.read(sweeperProvider.notifier).mockApproveActiveTask();
                        },
                  isLoading: sweeperState.isLoading,
                  icon: LucideIcons.shieldCheck,
                  type: ButtonType.secondary,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              CustomButton(
                text: isCompleted ? 'View Rewards' : 'Back to Dashboard',
                onPressed: () {
                  if (isCompleted) {
                    ref.read(sweeperProvider.notifier).clearActiveTask();
                    context.go('/sweeper/rewards');
                  } else {
                    ref.read(sweeperProvider.notifier).clearActiveTask();
                    context.go('/sweeper/dashboard');
                  }
                },
                icon: isCompleted ? LucideIcons.award : LucideIcons.home,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
