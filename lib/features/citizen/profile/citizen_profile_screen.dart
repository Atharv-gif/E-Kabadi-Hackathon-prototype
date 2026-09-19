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

class CitizenProfileScreen extends ConsumerStatefulWidget {
  const CitizenProfileScreen({super.key});

  @override
  ConsumerState<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends ConsumerState<CitizenProfileScreen> {
  String _selectedLanguage = 'English';

  Future<void> _switchRole() async {
    await ref.read(authProvider.notifier).setRole(UserRole.collector);
    if (mounted) {
      context.go('/collector/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Reserve space for the floating bottom navigation bar.
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── User header card ──
              CustomCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        user?.name.substring(0, 1) ?? 'A',
                        style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Aarav Sharma',
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(user?.phone ?? '+91 98765 12345', style: AppTypography.bodySmall),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: AppRadius.rPill,
                            ),
                            child: Text(
                              'CITIZEN HOUSEHOLD',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontSize: 9.5),
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
                color: AppColors.techBlueLight,
                border: Border.all(color: AppColors.techBlue, width: 1.5),
                onTap: _switchRole,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.techBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.truck, color: AppColors.surface, size: 19),
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
                          Text(
                            'Collect scrap, earn Eco Coins & route pickups',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, size: 18, color: AppColors.techBlue),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text('Account Settings', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _buildOptionTile(
                icon: LucideIcons.mapPin,
                title: 'Saved Addresses',
                subtitle: 'Flat 402, Green Valley, Noida',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: LucideIcons.wallet,
                title: 'Payment Methods & UPI',
                subtitle: 'GPay • aarav@upi',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: LucideIcons.globe,
                title: 'App Language',
                subtitle: _selectedLanguage,
                onTap: _showLanguageDialog,
              ),
              _buildOptionTile(
                icon: LucideIcons.helpCircle,
                title: 'Help & Customer Support',
                subtitle: '24/7 Helpline & FAQs',
                onTap: () {},
              ),
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

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: CustomCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        onTap: onTap,
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
            const Icon(LucideIcons.chevronRight, size: 17, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select App Language', style: AppTypography.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: _selectedLanguage == 'English' ? const Icon(LucideIcons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedLanguage = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('हिन्दी (Hindi)'),
              trailing: _selectedLanguage == 'Hindi' ? const Icon(LucideIcons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedLanguage = 'Hindi');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
