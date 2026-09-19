import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../providers/scrap_provider.dart';

class AiAnalysisScreen extends ConsumerStatefulWidget {
  const AiAnalysisScreen({super.key});

  @override
  ConsumerState<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends ConsumerState<AiAnalysisScreen> {
  // Manual weight entry — one controller per detected item.
  // Starts EMPTY by design: AI must NEVER pre-fill or auto-generate weights.
  final Map<String, TextEditingController> _weightControllers = {};
  final Map<String, String?> _weightErrors = {};

  TextEditingController _controllerFor(String id) {
    return _weightControllers.putIfAbsent(id, () => TextEditingController());
  }

  @override
  void dispose() {
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validateWeights(List<String> ids) {
    var valid = true;
    for (final id in ids) {
      final text = _controllerFor(id).text.trim();
      final value = double.tryParse(text);
      if (text.isEmpty || value == null || value <= 0) {
        _weightErrors[id] = 'Enter a valid weight';
        valid = false;
      } else {
        _weightErrors[id] = null;
      }
    }
    setState(() {});
    return valid;
  }

  void _applyManualWeights() {
    final scanState = ref.read(scrapScanProvider);
    final weights = <String, double>{
      for (final item in scanState.analyzedItems)
        if (double.tryParse(_controllerFor(item.id).text.trim()) case final v? when v > 0)
          item.id: v,
    };
    if (weights.isNotEmpty) {
      ref.read(scrapScanProvider.notifier).applyManualWeights(weights);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scrapScanProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'AI Scrap Analysis'),
      body: SafeArea(
        bottom: false,
        child: scanState.isAnalyzing
            ? const _AnalyzingView()
            : SingleChildScrollView(
                // Reserve space for the floating bottom navigation bar so the
                // Confirm / Retake / Edit buttons are never covered.
                padding: const EdgeInsets.fromLTRB(20, 8, 20, BottomNavBarMetrics.contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image preview (real captured photo when available) ──
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.rXl,
                          child: Container(
                            height: 210,
                            width: double.infinity,
                            color: AppColors.surfaceVariant,
                            child: _previewImage(scanState),
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
                          child: Row(
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
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Citizen-entered weight (manual, starts EMPTY) ──
                    Text('Approximate Weight (you enter)', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'AI cannot measure physical weight from a photo — please type your estimate below.',
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
                              key: ValueKey(scanState.analyzedItems[i].id),
                              label: scanState.analyzedItems[i].subType,
                              controller: _controllerFor(scanState.analyzedItems[i].id),
                              errorText: _weightErrors[scanState.analyzedItems[i].id],
                            ),
                          ],
                          if (scanState.analyzedItems.isEmpty)
                            _WeightRow(
                              key: const ValueKey('mixed'),
                              label: 'Mixed scrap',
                              controller: _controllerFor('mixed'),
                              errorText: _weightErrors['mixed'],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Info banner: estimates only, no value promises ──
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.techBlueLight,
                        borderRadius: AppRadius.rLg,
                        border: Border.all(color: AppColors.techBlue.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.info, size: 20, color: AppColors.techBlue),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              'Your weight is only an initial estimate. Final payment is based on the weight and bill verified by the collector at your doorstep.',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.techBlue, height: 1.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    CustomButton(
                      text: 'Confirm & Schedule Pickup',
                      onPressed: () {
                        final ids = [
                          ...scanState.analyzedItems.map((i) => i.id),
                          if (scanState.analyzedItems.isEmpty) 'mixed',
                        ];
                        if (!_validateWeights(ids)) return;
                        _applyManualWeights();
                        context.push('/citizen/schedule-pickup');
                      },
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

  Widget _previewImage(ScrapScanState state) {
    final path = state.imagePath;
    if (path != null && path.isNotEmpty && !path.startsWith('assets/') && !path.startsWith('http')) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _assetFallback(),
        );
      }
    }
    return _assetFallback();
  }

  Widget _assetFallback() {
    return Image.asset(
      'assets/images/img 1.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: const Center(
          child: Icon(LucideIcons.recycle, size: 72, color: AppColors.surface),
        ),
      ),
    );
  }
}

class _WeightRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;

  const _WeightRow({
    super.key,
    required this.label,
    required this.controller,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
              Text('approximate weight', style: AppTypography.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 150,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}[.]?\d{0,2}')),
            ],
            textAlign: TextAlign.right,
            style: AppTypography.titleSmall.copyWith(color: AppColors.primaryDark),
            decoration: InputDecoration(
              hintText: 'Enter weight',
              hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              suffixText: 'kg',
              suffixStyle: AppTypography.bodySmall,
              errorText: errorText,
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
  const _AnalyzingView();

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
