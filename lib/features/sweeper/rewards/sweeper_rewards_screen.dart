import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/bottom_nav_metrics.dart';
import '../../../providers/rewards_provider.dart';

class SweeperRewardsScreen extends ConsumerStatefulWidget {
  const SweeperRewardsScreen({super.key});

  @override
  ConsumerState<SweeperRewardsScreen> createState() => _SweeperRewardsScreenState();
}

class _SweeperRewardsScreenState extends ConsumerState<SweeperRewardsScreen> {
  // Pre-configured welfare perks tailored specifically for sanitation workers
  final List<Map<String, dynamic>> _welfarePerks = [
    {
      'id': 'welf_med_01',
      'title': 'Comprehensive Health Checkup',
      'subtitle': 'Full body tests + respiratory health check',
      'provider': 'Apollo Clinics & Swachhata Health Mission',
      'pointsCost': 200,
      'category': 'Health',
      'icon': LucideIcons.heartPulse,
      'badge': 'RECOMMENDED',
    },
    {
      'id': 'welf_gro_02',
      'title': 'Monthly Family Ration Kit',
      'subtitle': 'Atta, rice, oil, pulses worth ₹500',
      'provider': 'DMart & BigBasket Subsidized Scheme',
      'pointsCost': 250,
      'category': 'Grocery',
      'icon': LucideIcons.shoppingBag,
      'badge': 'POPULAR',
    },
    {
      'id': 'welf_gear_03',
      'title': 'Heavy-Duty Safety Gear Kit',
      'subtitle': 'Nitrile gloves, safety boots, high-vis jacket',
      'provider': 'Safex Municipal Equipment Store',
      'pointsCost': 150,
      'category': 'Safety',
      'icon': LucideIcons.shieldCheck,
      'badge': 'ESSENTIAL',
    },
    {
      'id': 'welf_upi_04',
      'title': 'Direct Cashout to Bank / UPI',
      'subtitle': 'Instant transfer (100 Eco Points = ₹50)',
      'provider': 'E-Kabaadi Direct Benefit Transfer',
      'pointsCost': 100,
      'category': 'Cash',
      'icon': LucideIcons.wallet,
      'badge': 'INSTANT',
    },
  ];

  // Transaction history for hackathon demo
  final List<Map<String, dynamic>> _history = [
    {
      'title': 'Sector 62 Roadside Cleanup',
      'points': '+300',
      'isCredit': true,
      'date': 'Today, 09:30 AM',
      'detail': '150 Litres verified volume',
    },
    {
      'title': 'Health Checkup Voucher Redeemed',
      'points': '-200',
      'isCredit': false,
      'date': 'Yesterday, 04:15 PM',
      'detail': 'Apollo Clinics Sector 62',
    },
    {
      'title': 'Park Green Belt Plastic Cleanup',
      'points': '+160',
      'isCredit': true,
      'date': '01 Oct 2026',
      'detail': '80 Litres verified volume',
    },
    {
      'title': 'Weekly Swachhata Hero Bonus',
      'points': '+250',
      'isCredit': true,
      'date': '28 Sep 2026',
      'detail': 'Top municipal area rating',
    },
  ];

  void _handleRedeem(Map<String, dynamic> perk, int currentBalance) {
    final cost = perk['pointsCost'] as int;

    if (currentBalance < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient balance. You need ${cost - currentBalance} more Eco Points.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.rXl),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.sweeperAmberLight,
                shape: BoxShape.circle,
              ),
              child: Icon(perk['icon'] as IconData, color: AppColors.sweeperAmber, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Redeem Benefit',
                style: AppTypography.titleMedium,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              perk['title'] as String,
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              perk['subtitle'] as String,
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: AppRadius.rMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Points Required:', style: AppTypography.bodySmall),
                  Text(
                    '$cost Eco Points',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.sweeperAmberDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sweeperAmber,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMd),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              final success = ref.read(sweeperEcoPointsProvider.notifier).redeem(cost);
              if (success) {
                _showSuccessSheet(perk);
              }
            },
            child: const Text('Confirm Redeem', style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSheet(Map<String, dynamic> perk) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.checkCheck, color: AppColors.success, size: 36),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Redemption Successful!', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your voucher for ${perk['title']} has been generated.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: AppRadius.rLg,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('VOUCHER CODE', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Text(
                    'EK-HERO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.sweeperAmberDark,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Show this code at any ${perk['provider']} partner counter',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton(
              text: 'Done',
              backgroundColor: AppColors.sweeperAmber,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(sweeperEcoPointsProvider);
    final inrValue = (points * 0.50).toInt();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Sanitation Rewards', showBack: false),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero points wallet ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.rXl,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD97706).withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sweeper Eco Points Balance',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.95)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.22),
                            borderRadius: AppRadius.rPill,
                          ),
                          child: Text(
                            'SWEEPER • ECO REWARDS',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.surface,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          points.toString(),
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.surface,
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            'pts',
                            style: AppTypography.titleMedium.copyWith(color: AppColors.surface.withValues(alpha: 0.9)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '≈ ₹$inrValue monetary value • Earn 2 pts per verified litre cleaned',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.surface.withValues(alpha: 0.85)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.15),
                        borderRadius: AppRadius.rMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.medal, size: 18, color: AppColors.surface),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sanitation Champion Tier: Silver Partner (12 Cleanups)',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.surface),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: AppSpacing.xxl),

              // ── Dignified Welfare Benefits ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Worker Welfare Benefits', style: AppTypography.titleMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.sweeperAmberLight,
                      borderRadius: AppRadius.rPill,
                    ),
                    child: Text(
                      'GOVT & MUNICIPAL BACKED',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.sweeperAmberDark,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Convert your hard-earned cleanup points into healthcare, groceries, and safety gear.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),

              ..._welfarePerks.map((perk) {
                final cost = perk['pointsCost'] as int;
                final canAfford = points >= cost;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: CustomCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.sweeperAmberLight,
                                borderRadius: AppRadius.rMd,
                              ),
                              child: Icon(perk['icon'] as IconData, color: AppColors.sweeperAmber, size: 24),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          perk['title'] as String,
                                          style: AppTypography.titleSmall,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceWarm,
                                          borderRadius: AppRadius.rPill,
                                        ),
                                        child: Text(
                                          perk['badge'] as String,
                                          style: AppTypography.labelSmall.copyWith(
                                            color: AppColors.sweeperAmberDark,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(perk['subtitle'] as String, style: AppTypography.bodySmall),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Partner: ${perk['provider']}',
                                    style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.award, size: 16, color: AppColors.sweeperAmber),
                                const SizedBox(width: 4),
                                Text(
                                  '$cost Points',
                                  style: AppTypography.titleSmall.copyWith(
                                    color: AppColors.sweeperAmberDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canAfford ? AppColors.sweeperAmber : AppColors.surfaceWarm,
                                foregroundColor: canAfford ? AppColors.surface : AppColors.textMuted,
                                elevation: canAfford ? 1 : 0,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMd),
                              ),
                              onPressed: () => _handleRedeem(perk, points),
                              child: Text(
                                canAfford ? 'Redeem Now' : 'Need ${cost - points} pts',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),

              // ── Recent Points History ──
              Text('Points Ledger & Activity', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ..._history.map((item) {
                final isCredit = item['isCredit'] as bool;
                final color = isCredit ? AppColors.success : AppColors.error;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: CustomCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCredit ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                            color: color,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'] as String, style: AppTypography.titleSmall),
                              const SizedBox(height: 2),
                              Text(
                                '${item['detail']} • ${item['date']}',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${item['points']} pts',
                          style: AppTypography.titleSmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
