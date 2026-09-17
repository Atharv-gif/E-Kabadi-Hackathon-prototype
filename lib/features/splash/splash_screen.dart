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
    await Future.delayed(const Duration(milliseconds: 2600));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
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
                      color: AppColors.primaryMedium.withValues(alpha: 0.35),
                      blurRadius: 40,
                      spreadRadius: 8,
                    )
                  ],
                ),
                child: Image.asset(
                  AssetPaths.logo,
                  width: 84,
                  height: 84,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    LucideIcons.recycle,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .then()
                  .shimmer(duration: 1200.ms, colors: const [Colors.white, Color(0xFFDCFCE7), Colors.white]),
              const SizedBox(height: 28),
              Text(
                AppConstants.appName,
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.surface,
                  fontSize: 34,
                ),
              ).animate(delay: 250.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primaryLight.withValues(alpha: 0.9),
                  letterSpacing: 1.2,
                ),
              ).animate(delay: 450.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: 64),
              SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryLight.withValues(alpha: 0.7),
                  ),
                ),
              ).animate(delay: 700.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
