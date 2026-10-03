import 'dart:io';
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
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/sweeper_provider.dart';
import '../../../services/camera_service.dart';

class CleaningWorkflowScreen extends ConsumerStatefulWidget {
  const CleaningWorkflowScreen({super.key});

  @override
  ConsumerState<CleaningWorkflowScreen> createState() => _CleaningWorkflowScreenState();
}

class _CleaningWorkflowScreenState extends ConsumerState<CleaningWorkflowScreen> {
  final CameraService _cameraService = CameraService();
  final TextEditingController _bagsController = TextEditingController(text: '1');
  final TextEditingController _bagSizeController = TextEditingController(text: '20');

  double get _estimatedVolume {
    final bags = int.tryParse(_bagsController.text) ?? 0;
    final bagSize = int.tryParse(_bagSizeController.text) ?? 20;
    return (bags * bagSize).toDouble();
  }

  Future<void> _takeBeforePhoto() async {
    final result = await _cameraService.capturePhoto();
    if (result is CameraCaptureSuccess) {
      await ref.read(sweeperProvider.notifier).submitBeforePhoto(result.filePath);
    } else if (result is CameraCaptureFailure && mounted) {
      // Fallback: use a mock photo path for demo
      await ref.read(sweeperProvider.notifier).submitBeforePhoto('demo_before_photo.jpg');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo: Before photo captured ✓')),
        );
      }
    } else if (result is CameraCaptureCancelled) {
      // Use mock for demo if camera not available
      await ref.read(sweeperProvider.notifier).submitBeforePhoto('demo_before_photo.jpg');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo: Before photo captured ✓')),
        );
      }
    }
  }

  Future<void> _takeAfterPhoto() async {
    final result = await _cameraService.capturePhoto();
    if (result is CameraCaptureSuccess) {
      await ref.read(sweeperProvider.notifier).submitAfterPhoto(result.filePath);
    } else if (result is CameraCaptureFailure && mounted) {
      await ref.read(sweeperProvider.notifier).submitAfterPhoto('demo_after_photo.jpg');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo: After photo captured ✓')),
        );
      }
    } else if (result is CameraCaptureCancelled) {
      await ref.read(sweeperProvider.notifier).submitAfterPhoto('demo_after_photo.jpg');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo: After photo captured ✓')),
        );
      }
    }
  }

  Future<void> _submitCompletion() async {
    final volume = _estimatedVolume;
    if (volume <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the collected volume.')),
      );
      return;
    }
    final success = await ref.read(sweeperProvider.notifier).submitCompletion(volume);
    if (success && mounted) {
      context.go('/sweeper/task-completion');
    }
  }

  @override
  void dispose() {
    _bagsController.dispose();
    _bagSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sweeperState = ref.watch(sweeperProvider);
    final task = sweeperState.activeTask;

    if (task == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Cleaning', showBack: true),
        body: const Center(child: Text('No active task')),
      );
    }

    final hasBeforePhoto = task.beforePhotoPath != null;
    final hasAfterPhoto = task.afterPhotoPath != null;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cleaning in Progress', showBack: true),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Status banner ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.sweeperAmberLight,
                  borderRadius: AppRadius.rLg,
                  border: Border.all(color: AppColors.sweeperAmber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.sweeperAmber,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.sweeperAmber.withValues(alpha: 0.5), blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Status: ${task.statusLabel}',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.sweeperAmber),
                          ),
                          Text(
                            'Follow the steps below to complete the task',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Step 1: Before Photo ──
              _StepCard(
                stepNumber: 1,
                title: 'Upload Before Photo',
                subtitle: hasBeforePhoto ? 'Photo captured ✓' : 'Take a photo of the garbage before cleaning',
                isCompleted: hasBeforePhoto,
                isActive: !hasBeforePhoto,
                child: hasBeforePhoto
                    ? _PhotoPreview(path: task.beforePhotoPath!)
                    : CustomButton(
                        text: 'Take Photo',
                        onPressed: _takeBeforePhoto,
                        icon: LucideIcons.camera,
                        type: ButtonType.secondary,
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Step 2: Clean the garbage ──
              _StepCard(
                stepNumber: 2,
                title: 'Clean the Garbage',
                subtitle: hasBeforePhoto
                    ? (hasAfterPhoto ? 'Cleaning done ✓' : 'Clean the area thoroughly')
                    : 'Complete step 1 first',
                isCompleted: hasAfterPhoto,
                isActive: hasBeforePhoto && !hasAfterPhoto,
                child: hasBeforePhoto && !hasAfterPhoto
                    ? Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.sweeperTealLight,
                          borderRadius: AppRadius.rMd,
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.sparkles, size: 24, color: AppColors.sweeperTeal),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'Clean the garbage from the area. Take your time to do it properly.',
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.sweeperTeal),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Step 3: After Photo ──
              _StepCard(
                stepNumber: 3,
                title: 'Upload After Photo',
                subtitle: hasAfterPhoto ? 'Photo captured ✓' : 'Take a photo after cleaning',
                isCompleted: hasAfterPhoto,
                isActive: hasBeforePhoto && !hasAfterPhoto,
                child: hasBeforePhoto && !hasAfterPhoto
                    ? CustomButton(
                        text: 'Take After Photo',
                        onPressed: _takeAfterPhoto,
                        icon: LucideIcons.camera,
                        type: ButtonType.secondary,
                      )
                    : hasAfterPhoto
                        ? _PhotoPreview(path: task.afterPhotoPath!)
                        : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Step 4: Enter volume ──
              _StepCard(
                stepNumber: 4,
                title: 'Enter Collected Volume',
                subtitle: hasAfterPhoto ? 'Report how much you collected' : 'Complete steps above first',
                isCompleted: false,
                isActive: hasAfterPhoto,
                child: hasAfterPhoto
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Number of bags', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                                    const SizedBox(height: 6),
                                    _NumberInput(controller: _bagsController, onChanged: () => setState(() {})),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text('×', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bag capacity (L)', style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                                    const SizedBox(height: 6),
                                    _NumberInput(controller: _bagSizeController, onChanged: () => setState(() {})),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: AppRadius.rMd,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.droplets, size: 18, color: AppColors.primary),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Estimated: ${_estimatedVolume.toStringAsFixed(0)} L',
                                  style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Text(
                                  '→ ${(_estimatedVolume * 2).toStringAsFixed(0)} Eco Points',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Submit ──
              if (hasBeforePhoto && hasAfterPhoto)
                CustomButton(
                  text: 'Submit Completion',
                  onPressed: sweeperState.isLoading ? null : _submitCompletion,
                  isLoading: sweeperState.isLoading,
                  icon: LucideIcons.checkCircle,
                ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step card ──

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final Widget? child;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isActive,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? AppColors.success
        : isActive
            ? AppColors.sweeperAmber
            : AppColors.textMuted;

    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: Border.all(
        color: isCompleted
            ? AppColors.success.withValues(alpha: 0.4)
            : isActive
                ? AppColors.sweeperAmber.withValues(alpha: 0.4)
                : AppColors.border,
        width: isActive ? 1.5 : 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.successLight : (isActive ? AppColors.sweeperAmberLight : AppColors.surfaceVariant),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(LucideIcons.check, size: 16, color: color)
                      : Text('$stepNumber', style: AppTypography.titleSmall.copyWith(fontSize: 14, color: color)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleSmall.copyWith(color: isActive || isCompleted ? AppColors.textPrimary : AppColors.textMuted)),
                    Text(subtitle, style: AppTypography.bodySmall.copyWith(color: isCompleted ? AppColors.success : null)),
                  ],
                ),
              ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: AppSpacing.lg),
            child!,
          ],
        ],
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  final String path;

  const _PhotoPreview({required this.path});

  @override
  Widget build(BuildContext context) {
    // Check if we have a real file path or a demo placeholder
    final file = File(path);
    final isRealFile = file.existsSync();

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: AppRadius.rMd,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: isRealFile
          ? ClipRRect(
              borderRadius: AppRadius.rMd,
              child: Image.file(file, fit: BoxFit.cover),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.checkCheck, size: 32, color: AppColors.success),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Photo captured ✓',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _NumberInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.rMd,
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (_) => onChanged(),
        style: AppTypography.titleMedium,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
