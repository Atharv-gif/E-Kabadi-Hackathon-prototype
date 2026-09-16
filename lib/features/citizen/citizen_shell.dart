import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class CitizenShell extends StatelessWidget {
  final Widget child;

  const CitizenShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/citizen/sell')) return 1;
    if (location.startsWith('/citizen/orders')) return 2;
    if (location.startsWith('/citizen/rewards')) return 3;
    if (location.startsWith('/citizen/profile')) return 4;
    return 0; // /citizen/home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/citizen/home');
        break;
      case 1:
        context.go('/citizen/sell');
        break;
      case 2:
        context.go('/citizen/orders');
        break;
      case 3:
        context.go('/citizen/rewards');
        break;
      case 4:
        context.go('/citizen/profile');
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
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              activeIcon: Icon(LucideIcons.home, color: AppColors.primary),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.camera),
              activeIcon: Icon(LucideIcons.camera, color: AppColors.primary),
              label: 'Sell',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.packageCheck),
              activeIcon: Icon(LucideIcons.packageCheck, color: AppColors.primary),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.award),
              activeIcon: Icon(LucideIcons.award, color: AppColors.primary),
              label: 'Rewards',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              activeIcon: Icon(LucideIcons.user, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
