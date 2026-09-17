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
import '../../../providers/scrap_provider.dart';

class AiAnalysisScreen extends ConsumerWidget {
  const AiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scrapScanProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'AI Scrap Analysis'),
      body: SafeArea(
        bottom: false,
        child: scanState.isAnalyzing
            ? _AnalyzingView()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image preview with AI tag ──
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.rXl,
                          child: Container(
                            height: 210,
                            width: double.infinity,
                            color: AppColors.surfaceVariant,
                            child: Image.asset(
                              'assets/images/img 1.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                                child: const Center(
                                  child: Icon(LucideIcons.recycle, size: 72, color: AppColors.surface),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark.withValues(alpha: 0.92),
                              borderRadius: AppRadius.rPill,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(LucideIcons.sparkles, size: 13, color: AppColors.primaryMedium),
                                const SizedBox(width: 6),
                                Text(
                                  'AI ANALYSIS COMPLETE',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.surface,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Detected materials ──
                    Text('AI Detected Material', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Automatic identification from your photo',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    ...scanState.analyzedItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: CustomCard(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(LucideIcons.package, color: AppColors.primary, size: 20),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.category, style: AppTypography.titleSmall),
                                        Text(item.subType, style: AppTypography.bodySmall),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.techBlueLight,
                                      borderRadius: AppRadius.rPill,
                                    ),
                                    child: Text(
                                      '${(item.confidenceScore * 100).toStringAsFixed(0)}% match',
                                      style: AppTypography.labelSmall.copyWith(color: AppColors.techBlue, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Citizen-entered weight (clearly separated) ──
                    Text('Approximate Weight (you enter)', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'AI cannot measure physical weight from a photo — please estimate.',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          for (var i = 0; i < scanState.analyzedItems.length; i++) ...[
                            if (i > 0) const Divider(height: AppSpacing.xxl),
                            _WeightRow(
                              label: scanState.analyzedItems[i].subType,
                              initialKg: scanState.analyzedItems[i].weightKg,
                            ),
                          ],
                          if (scanState.analyzedItems.isEmpty) ...[
                            const _WeightRow(label: 'Mixed scrap', initialKg: 5.0),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Estimated value summary ──
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: AppRadius.rLg,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estimated Value',
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.primaryLight),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '\u20B9${_totalEstimate(scanState)}',
                                  style: AppTypography.displayMedium.copyWith(color: AppColors.surface, fontSize: 28),
                                ),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.info, size: 18, color: AppColors.primaryLight),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Final amount is calculated after collector verification.',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.primaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    CustomButton(
                      text: 'Confirm & Schedule Pickup',
                      onPressed: () => context.push('/citizen/schedule-pickup'),
                      icon: LucideIcons.calendarCheck,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Retake Photo',
                            onPressed: () => context.pop(),
                            type: ButtonType.outline,
                            icon: LucideIcons.refreshCw,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: CustomButton(
                            text: 'Edit Manually',
                            onPressed: () => context.pop(),
                            type: ButtonType.secondary,
                            icon: LucideIcons.edit3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String _totalEstimate(ScrapScanState state) {
    final total = state.analyzedItems.fold<double>(0, (sum, i) => sum + i.estimatedTotal);
    return total.toStringAsFixed(0);
  }
}

class _WeightRow extends StatefulWidget {
  final String label;
  final double initialKg;

  const _WeightRow({required this.label, required this.initialKg});

  @override
  State<_WeightRow> createState() => _WeightRowState();
}

class _WeightRowState extends State<_WeightRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKg.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
              Text('approximate weight', style: AppTypography.bodySmall),
            ],
          ),
        ),
        SizedBox(
          width: 110,
          child: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark),
            decoration: InputDecoration(
              suffixText: 'kg',
              suffixStyle: AppTypography.bodySmall,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              fillColor: AppColors.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalyzingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.scanLine, size: 56, color: AppColors.primary),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(begin: const Offset(0.92, 0.92), end: const Offset(1.08, 1.08), duration: 900.ms, curve: Curves.easeInOut),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Analyzing your scrap…',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Identifying material type from your photo',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: 160,
            child: ClipRRect(
              borderRadius: AppRadius.rPill,
              child: const LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
