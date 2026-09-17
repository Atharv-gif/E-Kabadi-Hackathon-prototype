import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/custom_button.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color accentLight;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.accentLight,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Sell your scrap directly from your phone',
      description: 'No more waiting for unorganized collectors. Connect instantly with verified scrap collectors in your locality.',
      icon: LucideIcons.smartphone,
      accentColor: AppColors.primary,
      accentLight: AppColors.primaryLight,
    ),
    OnboardingSlide(
      title: 'AI identifies & estimates your scrap',
      description: 'Snap a picture and let our smart AI categorize materials, estimate weight, and provide transparent price ranges.',
      icon: LucideIcons.scanLine,
      accentColor: AppColors.techBlue,
      accentLight: AppColors.techBlueLight,
    ),
    OnboardingSlide(
      title: 'Track pickup. Get paid. Earn rewards.',
      description: 'Real-time collector tracking, instant digital UPI payment at your doorstep, plus Eco Points for saving the planet.',
      icon: LucideIcons.award,
      accentColor: AppColors.rewardOrange,
      accentLight: AppColors.rewardOrangeLight,
    ),
  ];

  void _next() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: AppDurations.normal,
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top bar: brand chip + skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.rSm,
                    ),
                    child: const Icon(LucideIcons.recycle, size: 20, color: AppColors.primary),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Skip',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (context, index) {
                    final s = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(
                              color: s.accentLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(s.icon, size: 84, color: s.accentColor),
                          )
                              .animate(delay: 100.ms)
                              .scale(duration: 500.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: AppSpacing.huge),
                          Text(
                            s.title,
                            style: AppTypography.displayMedium.copyWith(fontSize: 26, height: 1.25),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            s.description,
                            style: AppTypography.bodyLarge.copyWith(height: 1.55),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _currentIndex;
                  return AnimatedContainer(
                    duration: AppDurations.normal,
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? slide.accentColor : AppColors.borderStrong,
                      borderRadius: AppRadius.rPill,
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xxl),

              CustomButton(
                text: _currentIndex == _slides.length - 1 ? 'Get Started' : 'Next',
                onPressed: _next,
                icon: _currentIndex == _slides.length - 1 ? LucideIcons.arrowRight : null,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
