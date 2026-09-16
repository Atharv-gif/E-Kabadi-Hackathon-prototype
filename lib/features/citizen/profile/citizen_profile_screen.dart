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

class CitizenProfileScreen extends ConsumerStatefulWidget {
  const CitizenProfileScreen({super.key});

  @override
  ConsumerState<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends ConsumerState<CitizenProfileScreen> {
  String _selectedLanguage = 'English';

  void _switchRole() async {
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
      appBar: const CustomAppBar(title: 'Citizen Profile', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Header Card
              CustomCard(
                padding: const EdgeInsets.all(20),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name ?? 'Aarav Sharma', style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text(user?.phone ?? '+91 98765 12345', style: AppTypography.bodySmall),
                          const SizedBox(height: 2),
                          Text('Role: Citizen Household', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Switch Role Action Card
              CustomCard(
                padding: const EdgeInsets.all(16),
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
                      child: const Icon(LucideIcons.truck, color: AppColors.surface, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Switch to Scrap Collector Mode', style: AppTypography.titleSmall.copyWith(color: AppColors.techBlue)),
                          Text('Collect scrap, earn Eco Coins & route pickups', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.arrowRight, color: AppColors.techBlue),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text('Account Settings', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

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

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        onTap: onTap,
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
            const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textMuted),
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
