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

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final phone = state.extra as String? ?? '9876512345';
        return OtpVerificationScreen(phoneNumber: phone);
      },
    ),
    GoRoute(
      path: '/location-permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),

    // Citizen Routes Shell
    ShellRoute(
      builder: (context, state, child) => CitizenShell(child: child),
      routes: [
        GoRoute(
          path: '/citizen/home',
          builder: (context, state) => const CitizenHomeScreen(),
        ),
        GoRoute(
          path: '/citizen/sell',
          builder: (context, state) => const SellScrapScreen(),
        ),
        GoRoute(
          path: '/citizen/ai-analysis',
          builder: (context, state) => const AiAnalysisScreen(),
        ),
        GoRoute(
          path: '/citizen/schedule-pickup',
          builder: (context, state) => const SchedulePickupScreen(),
        ),
        GoRoute(
          path: '/citizen/collector-matching',
          builder: (context, state) => const CollectorMatchingScreen(),
        ),
        GoRoute(
          path: '/citizen/live-tracking',
          builder: (context, state) => const LiveTrackingScreen(),
        ),
        GoRoute(
          path: '/citizen/collector-arrival',
          builder: (context, state) => const CollectorArrivalScreen(),
        ),
        GoRoute(
          path: '/citizen/scrap-verification',
          builder: (context, state) => const ScrapVerificationScreen(),
        ),
        GoRoute(
          path: '/citizen/payment-receipt',
          builder: (context, state) => const PaymentReceiptScreen(),
        ),
        GoRoute(
          path: '/citizen/orders',
          builder: (context, state) => const PickupHistoryScreen(),
        ),
        GoRoute(
          path: '/citizen/scrap-journey',
          builder: (context, state) => const ScrapJourneyScreen(),
        ),
        GoRoute(
          path: '/citizen/rewards',
          builder: (context, state) => const EcoRewardsScreen(),
        ),
        GoRoute(
          path: '/citizen/profile',
          builder: (context, state) => const CitizenProfileScreen(),
        ),
      ],
    ),

    // Collector Routes Shell
    ShellRoute(
      builder: (context, state, child) => CollectorShell(child: child),
      routes: [
        GoRoute(
          path: '/collector/dashboard',
          builder: (context, state) => const CollectorDashboardScreen(),
        ),
        GoRoute(
          path: '/collector/navigation',
          builder: (context, state) => const CollectorNavigationScreen(),
        ),
        GoRoute(
          path: '/collector/verify',
          builder: (context, state) => const CollectorVerificationScreen(),
        ),
        GoRoute(
          path: '/collector/eco-coins',
          builder: (context, state) => const EcoCoinsScreen(),
        ),
        GoRoute(
          path: '/collector/voice',
          builder: (context, state) => const CollectorVoiceScreen(),
        ),
        GoRoute(
          path: '/collector/profile',
          builder: (context, state) => const CollectorProfileScreen(),
        ),
      ],
    ),
  ],
);
