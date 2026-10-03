import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/sweeper_provider.dart';
import '../../../providers/rewards_provider.dart';
import '../../../models/garbage_spot_model.dart';
import '../../../models/cleaning_task_model.dart';

class SweeperDashboardScreen extends ConsumerStatefulWidget {
  const SweeperDashboardScreen({super.key});

  @override
  ConsumerState<SweeperDashboardScreen> createState() => _SweeperDashboardScreenState();
}

class _SweeperDashboardScreenState extends ConsumerState<SweeperDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load nearby garbage spots on first build
    Future.microtask(() {
      ref.read(sweeperProvider.notifier).loadNearbySpots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final sweeperState = ref.watch(sweeperProvider);
    final ecoPoints = ref.watch(sweeperEcoPointsProvider);
    final userName = authState.user?.name.split(' ').first ?? 'Suresh';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.sweeperAmber,
          backgroundColor: AppColors.surface,
          onRefresh: () async {
            await ref.read(sweeperProvider.notifier).loadNearbySpots();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, BottomNavBarMetrics.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning 👋',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userName,
                            style: AppTypography.displayMedium.copyWith(fontSize: 26),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.sweeperAmberLight,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifications coming soon')),
                          );
                        },
                        icon: const Icon(LucideIcons.bell, size: 22, color: AppColors.sweeperAmber),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Eco Points hero card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFB45309)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppRadius.rXl,
                    boxShadow: [BoxShadow(color: AppColors.sweeperAmber.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Eco Points Balance',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.2),
                              borderRadius: AppRadius.rPill,
                            ),
                            child: Text(
                              'SWEEPER • ECO POINTS',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.surface, fontSize: 9.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(LucideIcons.award, size: 36, color: AppColors.surface),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            '$ecoPoints',
                            style: AppTypography.displayLarge.copyWith(color: AppColors.surface, fontSize: 42),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('PTS', style: AppTypography.titleMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9))),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.14),
                          borderRadius: AppRadius.rMd,
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.info, size: 15, color: AppColors.surface),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Earn 2 Eco Points per litre of garbage cleaned & verified.',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.surface, fontSize: 11.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
                const SizedBox(height: AppSpacing.xl),

                // ── Quick stats ──
                Row(
                  children: [
                    Expanded(
                      child: MetricCard(
                        icon: LucideIcons.checkCircle,
                        iconColor: AppColors.success,
                        iconBg: AppColors.successLight,
                        value: '${sweeperState.taskHistory.where((t) => t.status == CleaningTaskStatus.completed).length}',
                        label: 'Tasks Done',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: MetricCard(
                        icon: LucideIcons.mapPin,
                        iconColor: AppColors.sweeperAmber,
                        iconBg: AppColors.sweeperAmberLight,
                        value: '${sweeperState.nearbySpots.length}',
                        label: 'Nearby Tasks',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: MetricCard(
                        icon: LucideIcons.award,
                        iconColor: AppColors.rewardOrange,
                        iconBg: AppColors.rewardOrangeLight,
                        value: '$ecoPoints',
                        label: 'Eco Points',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Active task banner (if any) ──
                if (sweeperState.activeTask != null) ...[
                  CustomCard(
                    color: AppColors.sweeperAmberLight,
                    border: Border.all(color: AppColors.sweeperAmber, width: 1.5),
                    borderRadius: 18,
                    onTap: () => context.go('/sweeper/cleaning-workflow'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: const BoxDecoration(
                            color: AppColors.sweeperAmber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.sparkles, color: AppColors.surface, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Cleaning Task',
                                style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sweeperState.activeTask!.statusLabel,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.sweeperAmber),
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevronRight, size: 20, color: AppColors.sweeperAmber),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.08, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // ── Nearby cleaning tasks ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Nearby Cleaning Tasks', style: AppTypography.titleMedium, overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.sweeperAmberLight, borderRadius: AppRadius.rPill),
                      child: Text(
                        '${sweeperState.nearbySpots.length} AVAILABLE',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.sweeperAmber, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                if (sweeperState.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator(color: AppColors.sweeperAmber)),
                  )
                else if (sweeperState.nearbySpots.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(LucideIcons.sparkles, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No tasks nearby right now',
                            style: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Pull down to refresh',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...sweeperState.nearbySpots.map((spot) {
                    final distanceKm = ref.read(sweeperProvider.notifier).getDistanceKm(spot);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _GarbageTaskCard(
                        spot: spot,
                        distanceKm: distanceKm,
                        onViewTask: () {
                          ref.read(sweeperProvider.notifier).selectSpot(spot);
                          context.go('/sweeper/task-detail');
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Task card ──

class _GarbageTaskCard extends StatelessWidget {
  final GarbageSpot spot;
  final double distanceKm;
  final VoidCallback onViewTask;

  const _GarbageTaskCard({
    required this.spot,
    required this.distanceKm,
    required this.onViewTask,
  });

  IconData get _garbageIcon {
    switch (spot.garbageType) {
      case GarbageType.mixed:
        return LucideIcons.trash2;
      case GarbageType.plastic:
        return LucideIcons.recycle;
      case GarbageType.organic:
        return LucideIcons.leaf;
      case GarbageType.construction:
        return LucideIcons.building;
      case GarbageType.eWaste:
        return LucideIcons.cpu;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: Border.all(color: AppColors.border, width: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.sweeperAmberLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_garbageIcon, size: 20, color: AppColors.sweeperAmber),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🗑️ ${spot.sizeLabel.split(' ').first} Garbage ${spot.garbageType == GarbageType.mixed ? "Dump" : "Waste"}',
                            style: AppTypography.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            spot.garbageTypeLabel,
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: AppRadius.rSm),
            child: Row(
              children: [
                _InfoChip(icon: LucideIcons.mapPin, text: '${distanceKm.toStringAsFixed(1)} km'),
                const SizedBox(width: AppSpacing.lg),
                _InfoChip(icon: LucideIcons.droplets, text: '~${spot.estimatedVolumeLitres} L'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.sweeperAmberLight,
                    borderRadius: AppRadius.rPill,
                  ),
                  child: Text(
                    '+${spot.rewardPoints} Eco Points',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.sweeperAmber, fontSize: 10.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton(
            text: 'View Task',
            onPressed: onViewTask,
            icon: LucideIcons.eye,
            type: ButtonType.secondary,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
