import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_app_bar.dart';

class CollectorVoiceScreen extends StatefulWidget {
  const CollectorVoiceScreen({super.key});

  @override
  State<CollectorVoiceScreen> createState() => _CollectorVoiceScreenState();
}

class _CollectorVoiceScreenState extends State<CollectorVoiceScreen> {
  bool _isListening = false;
  String _recognizedText = 'Tap the microphone and speak…';

  Future<void> _startListening(String command) async {
    setState(() {
      _isListening = true;
      _recognizedText = 'Listening… ("$command")';
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _recognizedText = 'Recognized: "$command"';
    });
    // Execute command navigation demo
    if (command.contains('nearby') || command.contains('pickups')) {
      context.go('/collector/dashboard');
    } else if (command.contains('Navigate')) {
      context.go('/collector/navigation');
    } else if (command.contains('complete')) {
      context.go('/collector/verify');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Voice Assistant', showBack: false),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Mic button ──
              GestureDetector(
                onTap: () => _startListening('Show nearby pickups'),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isListening)
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          color: AppColors.techBlueLight,
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.85, 0.85), end: const Offset(1.35, 1.35), duration: 1000.ms, curve: Curves.easeOut),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: _isListening ? AppColors.techBlue : AppColors.techBlue.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppColors.techBlue.withValues(alpha: 0.25), blurRadius: 24, spreadRadius: 4)],
                      ),
                      child: Icon(
                        _isListening ? LucideIcons.activity : LucideIcons.mic,
                        size: 62,
                        color: AppColors.surface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.huge),

              Text(
                _isListening ? 'Listening…' : 'Say what you want to do',
                style: AppTypography.displayMedium.copyWith(fontSize: 23),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppRadius.rLg,
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _recognizedText,
                  style: AppTypography.titleSmall.copyWith(color: AppColors.techBlue),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Quick commands ──
              Text('Quick Voice Commands', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.lg),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildCommandChip('Show nearby pickups'),
                  _buildCommandChip('Accept this pickup'),
                  _buildCommandChip('Navigate to customer'),
                  _buildCommandChip('Mark pickup complete'),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommandChip(String command) {
    return ActionChip(
      avatar: const Icon(LucideIcons.volume2, size: 16, color: AppColors.techBlue),
      label: Text(command, style: AppTypography.labelLarge.copyWith(color: AppColors.techBlue, fontSize: 12.5)),
      backgroundColor: AppColors.techBlueLight,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rPill),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      onPressed: () => _startListening(command),
    );
  }
}
