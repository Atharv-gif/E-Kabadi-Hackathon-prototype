import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/custom_button.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
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
    ),
    OnboardingSlide(
      title: 'AI identifies & estimates your scrap',
      description: 'Snap a picture and let our smart AI categorize materials, estimate weight, and provide transparent price ranges.',
      icon: LucideIcons.scanLine,
      accentColor: AppColors.techBlue,
    ),
    OnboardingSlide(
      title: 'Track pickup. Get paid. Earn rewards.',
      description: 'Real-time collector tracking, instant digital UPI payment at your doorstep, plus Eco Points for saving the planet.',
      icon: LucideIcons.award,
      accentColor: AppColors.rewardOrange,
    ),
  ];

  void _next() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Top Bar Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(LucideIcons.recycle, size: 20, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'E-Kabaadi',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Skip',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // PageView Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentIndex = idx;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: slide.accentColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide.icon,
                            size: 90,
                            color: slide.accentColor,
                          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          style: AppTypography.displayMedium.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 14),
                        Text(
                          slide.description,
                          style: AppTypography.bodyLarge,
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 200.ms),
                      ],
                    );
                  },
                ),
              ),

              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Bottom Buttons
              CustomButton(
                text: _currentIndex == _slides.length - 1 ? 'Get Started' : 'Continue',
                onPressed: _next,
                icon: LucideIcons.arrowRight,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: AppTypography.bodyMedium),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Log in',
                      style: AppTypography.titleSmall.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
