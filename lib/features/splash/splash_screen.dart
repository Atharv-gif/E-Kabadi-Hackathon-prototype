import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryMedium.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Image.asset(
                AssetPaths.logo,
                width: 90,
                height: 90,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  LucideIcons.recycle,
                  size: 70,
                  color: AppColors.primary,
                ),
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            const SizedBox(height: 28),
            Text(
              AppConstants.appName,
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.surface,
                letterSpacing: 1.2,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 10),
            Text(
              AppConstants.appTagline,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(delay: 700.ms),
            const SizedBox(height: 60),
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMedium),
              ),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
