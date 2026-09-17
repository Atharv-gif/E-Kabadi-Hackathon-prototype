import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/auth/location_permission_screen.dart';
import '../../features/auth/role_selection_screen.dart';

import '../../features/citizen/citizen_shell.dart';
import '../../features/citizen/home/citizen_home_screen.dart';
import '../../features/citizen/sell/sell_scrap_screen.dart';
import '../../features/citizen/sell/ai_analysis_screen.dart';
import '../../features/citizen/pickup/schedule_pickup_screen.dart';
import '../../features/citizen/pickup/collector_matching_screen.dart';
import '../../features/citizen/pickup/live_tracking_screen.dart';
import '../../features/citizen/pickup/collector_arrival_screen.dart';
import '../../features/citizen/pickup/scrap_verification_screen.dart';
import '../../features/citizen/pickup/payment_receipt_screen.dart';
import '../../features/citizen/rewards/eco_rewards_screen.dart';
import '../../features/citizen/orders/pickup_history_screen.dart';
import '../../features/citizen/orders/scrap_journey_screen.dart';
import '../../features/citizen/profile/citizen_profile_screen.dart';

import '../../features/collector/collector_shell.dart';
import '../../features/collector/dashboard/collector_dashboard_screen.dart';
import '../../features/collector/navigation/collector_navigation_screen.dart';
import '../../features/collector/verification/collector_verification_screen.dart';
import '../../features/collector/eco_coins/eco_coins_screen.dart';
import '../../features/collector/voice/collector_voice_screen.dart';
import '../../features/collector/profile/collector_profile_screen.dart';

/// Smooth fade-through transition used across all routes.
CustomTransitionPage<void> _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.015),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _fadePage(const SplashScreen(), state),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _fadePage(const OnboardingScreen(), state),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _fadePage(const LoginScreen(), state),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => _fadePage(const SignupScreen(), state),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        final phone = state.extra as String? ?? '9876512345';
        return _fadePage(OtpVerificationScreen(phoneNumber: phone), state);
      },
    ),
    GoRoute(
      path: '/location-permission',
      pageBuilder: (context, state) => _fadePage(const LocationPermissionScreen(), state),
    ),
    GoRoute(
      path: '/role-selection',
      pageBuilder: (context, state) => _fadePage(const RoleSelectionScreen(), state),
    ),

    // Citizen Routes Shell
    ShellRoute(
      builder: (context, state, child) => CitizenShell(child: child),
      routes: [
        GoRoute(
          path: '/citizen/home',
          pageBuilder: (context, state) => _fadePage(const CitizenHomeScreen(), state),
        ),
        GoRoute(
          path: '/citizen/sell',
          pageBuilder: (context, state) => _fadePage(const SellScrapScreen(), state),
        ),
        GoRoute(
          path: '/citizen/ai-analysis',
          pageBuilder: (context, state) => _fadePage(const AiAnalysisScreen(), state),
        ),
        GoRoute(
          path: '/citizen/schedule-pickup',
          pageBuilder: (context, state) => _fadePage(const SchedulePickupScreen(), state),
        ),
        GoRoute(
          path: '/citizen/collector-matching',
          pageBuilder: (context, state) => _fadePage(const CollectorMatchingScreen(), state),
        ),
        GoRoute(
          path: '/citizen/live-tracking',
          pageBuilder: (context, state) => _fadePage(const LiveTrackingScreen(), state),
        ),
        GoRoute(
          path: '/citizen/collector-arrival',
          pageBuilder: (context, state) => _fadePage(const CollectorArrivalScreen(), state),
        ),
        GoRoute(
          path: '/citizen/scrap-verification',
          pageBuilder: (context, state) => _fadePage(const ScrapVerificationScreen(), state),
        ),
        GoRoute(
          path: '/citizen/payment-receipt',
          pageBuilder: (context, state) => _fadePage(const PaymentReceiptScreen(), state),
        ),
        GoRoute(
          path: '/citizen/orders',
          pageBuilder: (context, state) => _fadePage(const PickupHistoryScreen(), state),
        ),
        GoRoute(
          path: '/citizen/scrap-journey',
          pageBuilder: (context, state) => _fadePage(const ScrapJourneyScreen(), state),
        ),
        GoRoute(
          path: '/citizen/rewards',
          pageBuilder: (context, state) => _fadePage(const EcoRewardsScreen(), state),
        ),
        GoRoute(
          path: '/citizen/profile',
          pageBuilder: (context, state) => _fadePage(const CitizenProfileScreen(), state),
        ),
      ],
    ),

    // Collector Routes Shell
    ShellRoute(
      builder: (context, state, child) => CollectorShell(child: child),
      routes: [
        GoRoute(
          path: '/collector/dashboard',
          pageBuilder: (context, state) => _fadePage(const CollectorDashboardScreen(), state),
        ),
        GoRoute(
          path: '/collector/navigation',
          pageBuilder: (context, state) => _fadePage(const CollectorNavigationScreen(), state),
        ),
        GoRoute(
          path: '/collector/verify',
          pageBuilder: (context, state) => _fadePage(const CollectorVerificationScreen(), state),
        ),
        GoRoute(
          path: '/collector/eco-coins',
          pageBuilder: (context, state) => _fadePage(const EcoCoinsScreen(), state),
        ),
        GoRoute(
          path: '/collector/voice',
          pageBuilder: (context, state) => _fadePage(const CollectorVoiceScreen(), state),
        ),
        GoRoute(
          path: '/collector/profile',
          pageBuilder: (context, state) => _fadePage(const CollectorProfileScreen(), state),
        ),
      ],
    ),
  ],
);
