import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_app_bar.dart';

class CollectorVoiceScreen extends StatefulWidget {
  const CollectorVoiceScreen({super.key});

  @override
  State<CollectorVoiceScreen> createState() => _CollectorVoiceScreenState();
}

class _CollectorVoiceScreenState extends State<CollectorVoiceScreen> {
  bool _isListening = false;
  String _recognizedText = 'Tap the microphone and speak...';

  void _startListening(String command) async {
    setState(() {
      _isListening = true;
      _recognizedText = 'Listening... ("$command")';
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Collector Voice Assistant', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Voice Visualizer Circle
              GestureDetector(
                onTap: () => _startListening('Show nearby pickups'),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isListening)
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: AppColors.techBlueLight,
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.3, 1.3), duration: 1000.ms),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: AppColors.techBlue,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Color(0x330284C7), blurRadius: 20, spreadRadius: 4)],
                      ),
                      child: Icon(
                        _isListening ? LucideIcons.micOff : LucideIcons.mic,
                        size: 70,
                        color: AppColors.surface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              Text(
                'Say what you want to do',
                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _recognizedText,
                  style: AppTypography.titleSmall.copyWith(color: AppColors.techBlue),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Voice Command Quick Action Shortcuts
              Text('Quick Voice Commands', style: AppTypography.titleMedium),
              const SizedBox(height: 16),

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
      label: Text(command, style: AppTypography.labelLarge.copyWith(color: AppColors.techBlue)),
      backgroundColor: AppColors.techBlueLight,
      onPressed: () => _startListening(command),
    );
  }
}
