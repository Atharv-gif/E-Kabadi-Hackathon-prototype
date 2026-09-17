import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/pickup_request_model.dart';

/// Vertical status timeline for the pickup lifecycle.
class PickupTimeline extends StatelessWidget {
  final PickupStatus status;

  const PickupTimeline({super.key, required this.status});

  static const _steps = <(PickupStatus, String, IconData)>[
    (PickupStatus.pending, 'Request sent', LucideIcons.clipboardList),
    (PickupStatus.accepted, 'Accepted', LucideIcons.userCheck),
    (PickupStatus.onTheWay, 'On the way', LucideIcons.truck),
    (PickupStatus.arrived, 'Arrived', LucideIcons.mapPin),
    (PickupStatus.verified, 'Collected', LucideIcons.scale),
    (PickupStatus.completed, 'Completed', LucideIcons.badgeCheck),
  ];

  int get _currentIndex {
    final idx = _steps.indexWhere((s) => s.$1 == status);
    return idx == -1 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_steps.length, (i) {
        final (stepStatus, label, icon) = _steps[i];
        final done = i < _currentIndex;
        final current = i == _currentIndex;
        final isLast = i == _steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: done || current
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                        border: current
                            ? Border.all(color: AppColors.primaryMedium, width: 3)
                            : null,
                        boxShadow: current ? AppShadows.glowingGreen : null,
                      ),
                      child: Icon(
                        done || current ? icon : LucideIcons.circle,
                        size: 15,
                        color: done || current ? AppColors.surface : AppColors.textMuted,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: done ? AppColors.primary : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: current
                            ? AppTypography.titleSmall.copyWith(color: AppColors.primaryDark)
                            : done
                                ? AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary)
                                : AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
                      ),
                      if (current)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: AppRadius.rPill,
                          ),
                          child: Text(
                            'NOW',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 600.ms).then().fadeOut(duration: 600.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
