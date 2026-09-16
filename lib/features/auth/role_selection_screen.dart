import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/custom_card.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, WidgetRef ref, UserRole role) async {
    await ref.read(authProvider.notifier).setRole(role);
    if (context.mounted) {
      if (role == UserRole.citizen) {
        context.go('/citizen/home');
      } else {
        context.go('/collector/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.recycle, size: 24, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'E-Kabaadi',
                    style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                'Who are you?',
                style: AppTypography.displayMedium.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your profile experience to continue inside the application.',
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: 32),

              // Option 1: CITIZEN
              CustomCard(
                padding: const EdgeInsets.all(20),
                border: Border.all(color: AppColors.primary, width: 2),
                onTap: () => _selectRole(context, ref, UserRole.citizen),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.home, size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'I am a Citizen',
                                style: AppTypography.titleMedium,
                              ),
                              const Spacer(),
                              const Icon(LucideIcons.arrowRight, size: 20, color: AppColors.primary),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sell household scrap, AI estimation & schedule home pickups.',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Option 2: SCRAP COLLECTOR
              CustomCard(
                padding: const EdgeInsets.all(20),
                border: Border.all(color: AppColors.techBlue, width: 2),
                onTap: () => _selectRole(context, ref, UserRole.collector),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.techBlueLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.truck, size: 36, color: AppColors.techBlue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'I am a Scrap Collector',
                                style: AppTypography.titleMedium,
                              ),
                              const Spacer(),
                              const Icon(LucideIcons.arrowRight, size: 20, color: AppColors.techBlue),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Receive nearby pickup requests, navigate, collect & earn Eco Coins.',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'You can switch roles anytime in Profile Settings.',
                  style: AppTypography.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
