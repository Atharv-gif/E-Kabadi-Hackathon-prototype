import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/user_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../providers/auth_provider.dart';

class CollectorProfileScreen extends ConsumerWidget {
  const CollectorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Collector Profile & Verification', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collector Card Header
              CustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.techBlue,
                      child: Text('RK', style: AppTypography.displayMedium.copyWith(color: AppColors.surface)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Ramesh Kumar', style: AppTypography.titleMedium),
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.badgeCheck, size: 20, color: AppColors.techBlue),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('ID: COL-EK-892 • Sector 62 Zone', style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                            child: Text('KYC VERIFIED', style: AppTypography.labelSmall.copyWith(color: AppColors.success)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Switch to Citizen Role Option
              CustomCard(
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryLight,
                border: Border.all(color: AppColors.primary, width: 1.5),
                onTap: () async {
                  await ref.read(authProvider.notifier).setRole(UserRole.citizen);
                  if (context.mounted) {
                    context.go('/citizen/home');
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.home, color: AppColors.surface, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Switch to Citizen Household Mode', style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark)),
                          Text('Sell household scrap & track pickups', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text('Verification & Vehicle Details', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              _buildDetailTile(LucideIcons.shieldCheck, 'Aadhaar & KYC Document', 'Verified • Unique ID 8912-****'),
              _buildDetailTile(LucideIcons.truck, 'Registered Vehicle', 'Mahindra Pickup • UP16 ET 4912'),
              _buildDetailTile(LucideIcons.building, 'ULB & Recycler License', 'Authorized Partner #REC-2026'),
              _buildDetailTile(LucideIcons.star, 'Customer Service Rating', '4.8 / 5.0 (480 Reviews)'),

              const SizedBox(height: 24),
              CustomButton(
                text: 'Log Out',
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                type: ButtonType.danger,
                icon: LucideIcons.logOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
