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
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/sweeper_provider.dart';
import '../../../models/cleaning_task_model.dart';

class SweeperTasksScreen extends ConsumerStatefulWidget {
  const SweeperTasksScreen({super.key});

  @override
  ConsumerState<SweeperTasksScreen> createState() => _SweeperTasksScreenState();
}

class _SweeperTasksScreenState extends ConsumerState<SweeperTasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(sweeperProvider.notifier).loadNearbySpots();
      ref.read(sweeperProvider.notifier).loadHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(CleaningTaskStatus status) {
    switch (status) {
      case CleaningTaskStatus.available:
        return AppColors.textMuted;
      case CleaningTaskStatus.claimed:
        return AppColors.techBlue;
      case CleaningTaskStatus.inProgress:
        return AppColors.sweeperAmber;
      case CleaningTaskStatus.submitted:
      case CleaningTaskStatus.verificationPending:
        return AppColors.secondary;
      case CleaningTaskStatus.completed:
        return AppColors.success;
      case CleaningTaskStatus.cancelled:
      case CleaningTaskStatus.rejected:
        return AppColors.error;
    }
  }

  String _getStatusLabel(CleaningTaskStatus status) {
    switch (status) {
      case CleaningTaskStatus.available:
        return 'AVAILABLE';
      case CleaningTaskStatus.claimed:
        return 'CLAIMED';
      case CleaningTaskStatus.inProgress:
        return 'IN PROGRESS';
      case CleaningTaskStatus.submitted:
        return 'SUBMITTED';
      case CleaningTaskStatus.verificationPending:
        return 'VERIFYING';
      case CleaningTaskStatus.completed:
        return 'COMPLETED';
      case CleaningTaskStatus.cancelled:
        return 'CANCELLED';
      case CleaningTaskStatus.rejected:
        return 'REJECTED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sweeperState = ref.watch(sweeperProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sanitation Tasks',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 20, color: AppColors.textPrimary),
            tooltip: 'Refresh tasks',
            onPressed: () {
              ref.read(sweeperProvider.notifier).loadNearbySpots();
              ref.read(sweeperProvider.notifier).loadHistory();
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Tab selector ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.rLg,
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.sweeperAmberLight,
                  borderRadius: AppRadius.rMd,
                  border: Border.all(color: AppColors.sweeperAmber.withValues(alpha: 0.3)),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.sweeperAmberDark,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: AppTypography.labelMedium,
                tabs: const [
                  Tab(text: 'Active Task'),
                  Tab(text: 'Available'),
                  Tab(text: 'History'),
                ],
              ),
            ),

            // ── Tab Views ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveTaskTab(context, sweeperState),
                  _buildAvailableSpotsTab(context, sweeperState),
                  _buildHistoryTab(context, sweeperState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTaskTab(BuildContext context, SweeperState state) {
    final active = state.activeTask;
    if (active == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.sweeperAmberLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.sparkles, size: 48, color: AppColors.sweeperAmber),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('No Active Cleaning Task', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'You currently do not have any claimed task in progress. Check available spots nearby to claim one.',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'View Available Spots',
                icon: LucideIcons.mapPin,
                backgroundColor: AppColors.sweeperAmber,
                onPressed: () {
                  _tabController.animateTo(1);
                },
              ),
            ],
          ),
        ),
      );
    }

    final statusColor = _getStatusColor(active.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, BottomNavBarMetrics.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            border: Border.all(color: AppColors.sweeperAmber, width: 1.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.14),
                        borderRadius: AppRadius.rPill,
                      ),
                      child: Text(
                        _getStatusLabel(active.status),
                        style: AppTypography.labelSmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'Task #${active.id}',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Active Cleanup in Sector 62', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Spot ID: ${active.garbageSpotId} • Claimed on ${active.claimedAt.split('T').first}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Volume & Reward Info
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm,
                    borderRadius: AppRadius.rMd,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estimated Volume', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text('${active.estimatedVolumeLitres.toInt()} Litres', style: AppTypography.titleSmall),
                          ],
                        ),
                      ),
                      Container(height: 30, width: 1, color: AppColors.border),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Expected Reward', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(LucideIcons.award, size: 16, color: AppColors.sweeperAmber),
                                const SizedBox(width: 4),
                                Text(
                                  '+${(active.estimatedVolumeLitres * 2).toInt()} Pts',
                                  style: AppTypography.titleSmall.copyWith(color: AppColors.sweeperAmberDark),
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

                // Workflow progress indicators
                Row(
                  children: [
                    _buildStepDot(
                      label: 'Before Photo',
                      done: active.beforePhotoUrl != null,
                      active: active.status == CleaningTaskStatus.claimed || active.status == CleaningTaskStatus.inProgress,
                    ),
                    Expanded(child: Container(height: 2, color: active.afterPhotoUrl != null ? AppColors.success : AppColors.border)),
                    _buildStepDot(
                      label: 'After Photo',
                      done: active.afterPhotoUrl != null,
                      active: active.beforePhotoUrl != null && active.afterPhotoUrl == null,
                    ),
                    Expanded(child: Container(height: 2, color: active.status == CleaningTaskStatus.completed ? AppColors.success : AppColors.border)),
                    _buildStepDot(
                      label: 'Verified',
                      done: active.status == CleaningTaskStatus.completed,
                      active: active.status == CleaningTaskStatus.verificationPending || active.status == CleaningTaskStatus.submitted,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // CTA Button
                if (active.status == CleaningTaskStatus.claimed || active.status == CleaningTaskStatus.inProgress)
                  CustomButton(
                    text: 'Continue Cleaning Workflow',
                    icon: LucideIcons.arrowRight,
                    backgroundColor: AppColors.sweeperAmber,
                    onPressed: () => context.go('/sweeper/cleaning-workflow'),
                  )
                else if (active.status == CleaningTaskStatus.submitted || active.status == CleaningTaskStatus.verificationPending)
                  CustomButton(
                    text: 'Check Verification Status',
                    icon: LucideIcons.badgeCheck,
                    backgroundColor: AppColors.techBlue,
                    onPressed: () => context.go('/sweeper/task-completion'),
                  )
                else
                  CustomButton(
                    text: 'View Completion Summary',
                    icon: LucideIcons.checkCircle2,
                    backgroundColor: AppColors.success,
                    onPressed: () => context.go('/sweeper/task-completion'),
                  ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildStepDot({required String label, required bool done, required bool active}) {
    final color = done
        ? AppColors.success
        : active
            ? AppColors.sweeperAmber
            : AppColors.border;

    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: done ? AppColors.success : (active ? AppColors.sweeperAmberLight : AppColors.surface),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: done
              ? const Icon(LucideIcons.check, size: 13, color: AppColors.surface)
              : (active ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.sweeperAmber, shape: BoxShape.circle))) : null),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 10,
            color: active || done ? AppColors.textPrimary : AppColors.textMuted,
            fontWeight: active || done ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableSpotsTab(BuildContext context, SweeperState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.sweeperAmber));
    }

    final spots = state.nearbySpots;
    if (spots.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.checkCircle2, size: 48, color: AppColors.success),
              const SizedBox(height: AppSpacing.md),
              Text('All Cleaned Up!', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'No pending garbage spots in your area right now. Good job!',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, BottomNavBarMetrics.contentPadding),
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        final distanceKm = ref.read(sweeperProvider.notifier).getDistanceKm(spot);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: CustomCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            onTap: () {
              ref.read(sweeperProvider.notifier).selectSpot(spot);
              context.go('/sweeper/task-detail');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.sweeperAmberLight,
                    borderRadius: AppRadius.rMd,
                  ),
                  child: const Icon(LucideIcons.trash2, color: AppColors.sweeperAmber, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWarm,
                              borderRadius: AppRadius.rPill,
                            ),
                            child: Text(
                              spot.typeDisplayName.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.sweeperAmberDark,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '~${distanceKm.toStringAsFixed(1)} km',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        spot.description,
                        style: AppTypography.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(LucideIcons.box, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '~${spot.estimatedVolumeLitres.toInt()} L',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          const Icon(LucideIcons.award, size: 14, color: AppColors.sweeperAmber),
                          const SizedBox(width: 4),
                          Text(
                            '+${spot.rewardPoints} Eco Pts',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.sweeperAmberDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevronRight, size: 20, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab(BuildContext context, SweeperState state) {
    final history = state.taskHistory;
    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.history, size: 48, color: AppColors.textMuted),
              const SizedBox(height: AppSpacing.md),
              Text('No Cleaning History Yet', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Complete your first cleanup task to see it logged here with earned rewards.',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, BottomNavBarMetrics.contentPadding),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final task = history[index];
        final pointsEarned = ((task.verifiedVolumeLitres ?? task.estimatedVolumeLitres) * 2).toInt();

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: CustomCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.checkCheck, color: AppColors.success, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Task #${task.id}', style: AppTypography.titleSmall),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: AppRadius.rPill,
                            ),
                            child: Text(
                              '+$pointsEarned PTS',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Spot: ${task.garbageSpotId} • Verified ${task.verifiedVolumeLitres?.toInt() ?? task.estimatedVolumeLitres.toInt()} L',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Completed: ${task.completedAt?.toIso8601String().split('T').first ?? 'Recent'}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
