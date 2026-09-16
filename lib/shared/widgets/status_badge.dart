import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/pickup_request_model.dart';

class StatusBadge extends StatelessWidget {
  final PickupStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case PickupStatus.pending:
        bg = AppColors.warning.withValues(alpha: 0.15);
        fg = AppColors.warning;
        label = 'PENDING';
        break;
      case PickupStatus.accepted:
        bg = AppColors.techBlue.withValues(alpha: 0.15);
        fg = AppColors.techBlue;
        label = 'ACCEPTED';
        break;
      case PickupStatus.onTheWay:
        bg = AppColors.techBlue.withValues(alpha: 0.15);
        fg = AppColors.techBlue;
        label = 'ON THE WAY';
        break;
      case PickupStatus.arrived:
        bg = AppColors.primary.withValues(alpha: 0.15);
        fg = AppColors.primary;
        label = 'ARRIVED';
        break;
      case PickupStatus.verified:
        bg = AppColors.primary.withValues(alpha: 0.15);
        fg = AppColors.primary;
        label = 'VERIFIED';
        break;
      case PickupStatus.completed:
        bg = AppColors.success.withValues(alpha: 0.15);
        fg = AppColors.success;
        label = 'COMPLETED';
        break;
      case PickupStatus.cancelled:
        bg = AppColors.error.withValues(alpha: 0.15);
        fg = AppColors.error;
        label = 'CANCELLED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
