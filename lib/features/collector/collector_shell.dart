import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class CollectorShell extends StatelessWidget {
  final Widget child;

  const CollectorShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/collector/navigation')) return 1;
    if (location.startsWith('/collector/eco-coins')) return 2;
    if (location.startsWith('/collector/voice')) return 3;
    if (location.startsWith('/collector/profile')) return 4;
    return 0; // /collector/dashboard
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/collector/dashboard');
        break;
      case 1:
        context.go('/collector/navigation');
        break;
      case 2:
        context.go('/collector/eco-coins');
        break;
      case 3:
        context.go('/collector/voice');
        break;
      case 4:
        context.go('/collector/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (idx) => _onItemTapped(idx, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.techBlue,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.layoutDashboard),
              activeIcon: Icon(LucideIcons.layoutDashboard, color: AppColors.techBlue),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.navigation),
              activeIcon: Icon(LucideIcons.navigation, color: AppColors.techBlue),
              label: 'Navigate',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.coins),
              activeIcon: Icon(LucideIcons.coins, color: AppColors.techBlue),
              label: 'Eco Coins',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.mic),
              activeIcon: Icon(LucideIcons.mic, color: AppColors.techBlue),
              label: 'Voice',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              activeIcon: Icon(LucideIcons.user, color: AppColors.techBlue),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
