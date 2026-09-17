import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
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
      appBar: const CustomAppBar(title: 'Collector Profile', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Collector header ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.techBlue,
                      child: Text('RK', style: AppTypography.displayMedium.copyWith(color: AppColors.surface)),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text('Ramesh Kumar', style: AppTypography.titleMedium, overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.badgeCheck, size: 18, color: AppColors.techBlue),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('ID: COL-EK-892 • Sector 62 Zone', style: AppTypography.bodySmall),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: AppRadius.rPill,
                            ),
                            child: Text(
                              'KYC VERIFIED',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 9.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Switch role card ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                      child: const Icon(LucideIcons.home, color: AppColors.surface, size: 19),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch to Citizen Mode',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark),
                          ),
                          Text('Sell household scrap & track pickups', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, size: 18, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('Verification & Vehicle Details', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _buildDetailTile(LucideIcons.shieldCheck, 'Aadhaar & KYC Document', 'Verified • Unique ID 8912-****'),
              _buildDetailTile(LucideIcons.truck, 'Registered Vehicle', 'Mahindra Pickup • UP16 ET 4912'),
              _buildDetailTile(LucideIcons.building, 'ULB & Recycler License', 'Authorized Partner #REC-2026'),
              _buildDetailTile(LucideIcons.star, 'Customer Service Rating', '4.8 / 5.0 (480 Reviews)'),
              const SizedBox(height: AppSpacing.xxl),

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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: CustomCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppRadius.rSm,
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 19),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  Text(subtitle, style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
