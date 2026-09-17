import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';

class _RankedCollector {
  final int rank;
  final String name;
  final String initials;
  final double rating;
  final int pickups;
  final String distance;
  final String eta;
  final String queue;
  final bool available;

  const _RankedCollector({
    required this.rank,
    required this.name,
    required this.initials,
    required this.rating,
    required this.pickups,
    required this.distance,
    required this.eta,
    required this.queue,
    required this.available,
  });
}

const _collectors = <_RankedCollector>[
  _RankedCollector(
    rank: 1,
    name: 'Ramesh Kumar',
    initials: 'RK',
    rating: 4.8,
    pickups: 480,
    distance: '1.8 km',
    eta: '~14 min',
    queue: '1 request ahead',
    available: true,
  ),
  _RankedCollector(
    rank: 2,
    name: 'Suresh Yadav',
    initials: 'SY',
    rating: 4.7,
    pickups: 355,
    distance: '2.1 km',
    eta: '~18 min',
    queue: 'No requests ahead',
    available: true,
  ),
  _RankedCollector(
    rank: 3,
    name: 'Anil Verma',
    initials: 'AV',
    rating: 4.6,
    pickups: 290,
    distance: '1.2 km',
    eta: '~21 min',
    queue: '2 requests ahead',
    available: false,
  ),
];

class CollectorMatchingScreen extends StatefulWidget {
  const CollectorMatchingScreen({super.key});

  @override
  State<CollectorMatchingScreen> createState() => _CollectorMatchingScreenState();
}

class _CollectorMatchingScreenState extends State<CollectorMatchingScreen> {
  bool _isSearching = true;
  int _selectedRank = 1;

  @override
  void initState() {
    super.initState();
    _startMatchingAnimation();
  }

  void _startMatchingAnimation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isSearching = false);
    }
  }

  void _showRankingInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.rSm),
                  child: const Icon(LucideIcons.info, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Text('How we recommend collectors', style: AppTypography.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _infoRow(LucideIcons.map, 'Road travel time', 'Actual road distance from the collector to your address — not straight-line distance.'),
            _infoRow(LucideIcons.users, 'Current queue', 'How many pickups the collector is already heading to before yours.'),
            _infoRow(LucideIcons.activity, 'Availability', 'Only collectors who are online right now are recommended.'),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'The ranking is only a recommendation — you can freely choose any collector from the top 3.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.bodySmall.copyWith(height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: _isSearching ? 'Finding Collectors' : 'Nearby Collectors'),
      body: SafeArea(
        bottom: false,
        child: _isSearching ? _buildSearching() : _buildResults(),
      ),
    );
  }

  // ── Searching radar state ──
  Widget _buildSearching() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.7, 0.7), end: const Offset(1.35, 1.35), duration: 1500.ms, curve: Curves.easeOut),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glowingGreen,
                ),
                child: const Icon(LucideIcons.radar, size: 56, color: AppColors.surface),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.huge),
          Text(
            'Finding nearby collectors…',
            style: AppTypography.titleMedium.copyWith(fontSize: 19),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Checking road distance, live queue and\navailability of collectors near you',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Ranked results ──
  Widget _buildResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top 3 Collectors', style: AppTypography.titleLarge),
                    const SizedBox(height: 2),
                    Text('Ranked by distance, queue & availability', style: AppTypography.bodySmall),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showRankingInfo(context),
                child: Text('How?', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          ..._collectors.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _CollectorCard(
                collector: c,
                selected: _selectedRank == c.rank,
                onSelect: () => setState(() => _selectedRank = c.rank),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.sm),
          CustomButton(
            text: 'Choose Collector',
            onPressed: () => context.go('/citizen/live-tracking'),
            icon: LucideIcons.checkCircle,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomButton(
            text: 'Skip & Auto-assign Best Match',
            onPressed: () => context.go('/citizen/live-tracking'),
            type: ButtonType.text,
          ),
        ],
      ),
    );
  }
}

class _CollectorCard extends StatelessWidget {
  final _RankedCollector collector;
  final bool selected;
  final VoidCallback onSelect;

  const _CollectorCard({
    required this.collector,
    required this.selected,
    required this.onSelect,
  });

  Color get _rankColor {
    switch (collector.rank) {
      case 1:
        return AppColors.primary;
      case 2:
        return AppColors.techBlue;
      default:
        return AppColors.textSecondary;
    }
  }

  Color get _rankBg {
    switch (collector.rank) {
      case 1:
        return AppColors.primaryLight;
      case 2:
        return AppColors.techBlueLight;
      default:
        return AppColors.surfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = collector;
    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      border: Border.all(
        color: selected ? AppColors.primary : AppColors.border,
        width: selected ? 2 : 1,
      ),
      onTap: onSelect,
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: _rankBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  '#${c.rank}',
                  style: AppTypography.labelLarge.copyWith(color: _rankColor, fontSize: 13),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              CircleAvatar(
                radius: 24,
                backgroundColor: _rankBg,
                child: Text(
                  c.initials,
                  style: AppTypography.titleSmall.copyWith(color: _rankColor),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(c.name, style: AppTypography.titleSmall, overflow: TextOverflow.ellipsis),
                        ),
                        if (c.rank == 1) ...[
                          const SizedBox(width: 6),
                          const Icon(LucideIcons.badgeCheck, size: 16, color: AppColors.techBlue),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(LucideIcons.star, size: 13, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '${c.rating} • ${c.pickups} pickups',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Availability dot
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: c.available ? AppColors.success : AppColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    c.available ? 'Available' : 'Busy',
                    style: AppTypography.bodySmall.copyWith(
                      color: c.available ? AppColors.success : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.rSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat(LucideIcons.map, c.distance),
                _divider(),
                _stat(LucideIcons.clock, c.eta),
                _divider(),
                _stat(LucideIcons.users, c.queue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 18, color: AppColors.border);
  }
}
