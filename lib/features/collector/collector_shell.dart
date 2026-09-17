import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

class _NavItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem(this.route, this.icon, this.activeIcon, this.label);
}

const _items = <_NavItem>[
  _NavItem('/collector/dashboard', LucideIcons.layoutDashboard, LucideIcons.layoutDashboard, 'Home'),
  _NavItem('/collector/navigation', LucideIcons.navigation, LucideIcons.navigation, 'Requests'),
  _NavItem('/collector/eco-coins', LucideIcons.coins, LucideIcons.coins, 'Rewards'),
  _NavItem('/collector/voice', LucideIcons.mic, LucideIcons.mic, 'Voice'),
  _NavItem('/collector/profile', LucideIcons.user, LucideIcons.user, 'Profile'),
];

class CollectorShell extends StatelessWidget {
  final Widget child;

  const CollectorShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < _items.length; i++) {
      if (location.startsWith(_items[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.rXl,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.elevated,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = i == selectedIndex;
            final color = selected ? AppColors.primary : AppColors.textMuted;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.go(item.route),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryLight : Colors.transparent,
                    borderRadius: AppRadius.rLg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(selected ? item.activeIcon : item.icon, size: 21, color: color),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10.5,
                          color: color,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
