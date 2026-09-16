import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/custom_button.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(
                  color: AppColors.techBlueLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 80,
                  color: AppColors.techBlue,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Enable Location Services',
                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'E-Kabaadi uses your location to match nearby collectors in real-time, show estimated arrival times, and calculate accurate pickup distances.',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                text: 'Allow Location Access',
                onPressed: () => context.go('/role-selection'),
                icon: LucideIcons.navigation,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/role-selection'),
                child: Text(
                  'Enter Location Manually',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
