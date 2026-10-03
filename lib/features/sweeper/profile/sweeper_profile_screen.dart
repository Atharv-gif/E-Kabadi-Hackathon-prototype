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
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/auth_provider.dart';

class SweeperProfileScreen extends ConsumerWidget {
  const SweeperProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sanitation Partner Profile', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sweeper header ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.sweeperAmber,
                      child: Text(
                        'SK',
                        style: AppTypography.displayMedium.copyWith(color: AppColors.surface),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Suresh Kumar',
                                  style: AppTypography.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(LucideIcons.badgeCheck, size: 18, color: AppColors.sweeperAmber),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('ID: SWP-EK-902 • Sector 62 Ward', style: AppTypography.bodySmall),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: AppRadius.rPill,
                                ),
                                child: Text(
                                  'KYC & MUNICIPAL VERIFIED',
                                  style: AppTypography.labelSmall.copyWith(color: AppColors.success, fontSize: 9.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Impact stats ──
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Cleanups Done',
                      value: '18',
                      icon: LucideIcons.checkCheck,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Volume Cleared',
                      value: '450 L',
                      icon: LucideIcons.trash2,
                      color: AppColors.sweeperAmber,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Hero Rating',
                      value: '4.9 ★',
                      icon: LucideIcons.star,
                      color: AppColors.rewardOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Role switching cards ──
              Text('Switch Profile Experience', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),

              // Switch to Citizen
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.md),
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
                      child: const Icon(LucideIcons.home, color: AppColors.surface, size: 18),
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
                          Text('Sell household scrap & schedule pickups', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, size: 18, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Switch to Collector
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                color: AppColors.techBlueLight,
                border: Border.all(color: AppColors.techBlue, width: 1.5),
                onTap: () async {
                  await ref.read(authProvider.notifier).setRole(UserRole.collector);
                  if (context.mounted) {
                    context.go('/collector/dashboard');
                  }
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppColors.techBlue, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.truck, color: AppColors.surface, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch to Collector Mode',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.techBlue),
                          ),
                          Text('Collect scrap, weigh & earn Eco Coins', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, size: 18, color: AppColors.techBlue),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Safety Gear & Partner Affiliation ──
              Text('Safety Equipment & Gear Checklist', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _buildDetailTile(LucideIcons.shieldCheck, 'Heavy-Duty Nitrile Gloves', 'Equipped & Verified (Weekly Renewal)'),
              _buildDetailTile(LucideIcons.eye, 'Reflective High-Visibility Vest', 'Active Standard Uniform (Yellow/Orange)'),
              _buildDetailTile(LucideIcons.hardHat, 'Protective Mask & Boots', 'Certified for Municipal Cleanups'),
              _buildDetailTile(LucideIcons.building, 'Urban Local Body Affiliation', 'Noida Municipal Corporation • Ward 14'),
              const SizedBox(height: AppSpacing.xl),

              // ── Account Settings ──
              Text('Support & Settings', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _buildActionTile(
                icon: LucideIcons.phoneCall,
                title: 'Sanitation Worker Emergency Helpline',
                subtitle: 'Toll-free 1800-SWACHH (24x7 Support)',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling Sanitation Helpline 1800-792-244...')),
                  );
                },
              ),
              _buildActionTile(
                icon: LucideIcons.fileText,
                title: 'Proof of Cleanup Records',
                subtitle: 'Download monthly certificates for municipal benefits',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading Municipal Service Certificate...')),
                  );
                },
              ),
              _buildActionTile(
                icon: LucideIcons.languages,
                title: 'App Language',
                subtitle: 'English (हिन्दी / বাংলা available)',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Logout Button ──
              CustomButton(
                text: 'Log Out',
                variant: ButtonVariant.outline,
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.rLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 9.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: CustomCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: AppRadius.rMd,
              ),
              child: Icon(icon, size: 20, color: AppColors.sweeperAmber),
            ),
            const SizedBox(width: AppSpacing.md),
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

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: CustomCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: AppRadius.rMd,
              ),
              child: Icon(icon, size: 20, color: AppColors.textPrimary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleSmall),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
