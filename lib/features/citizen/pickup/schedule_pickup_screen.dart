import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../models/scrap_item_model.dart';
import '../../../providers/scrap_provider.dart';
import '../../../providers/pickup_provider.dart';

class SchedulePickupScreen extends ConsumerStatefulWidget {
  const SchedulePickupScreen({super.key});

  @override
  ConsumerState<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends ConsumerState<SchedulePickupScreen> {
  String _selectedDate = 'Today, 18 Sep';
  String _selectedTimeSlot = AppConstants.timeSlots[1]; // 11 AM - 1 PM
  final TextEditingController _instructionsController = TextEditingController(text: 'Call me when you arrive');
  final String _address = 'Flat 402, Green Valley Apts, Sector 62, Noida, UP - 201301';

  void _onConfirmPickup() async {
    final items = ref.read(scrapScanProvider).analyzedItems;
    await ref.read(pickupProvider.notifier).createRequest(
      items: items.isEmpty
          ? [
              const ScrapItemModel(
                id: 'DEMO-1',
                category: 'Plastic',
                subType: 'PET Bottles',
                weightKg: 1.4,
                pricePerKg: 50,
                estimatedTotal: 70,
                confidenceScore: 0.94,
              ),
              const ScrapItemModel(
                id: 'DEMO-2',
                category: 'Paper',
                subType: 'Cardboard Boxes',
                weightKg: 3.2,
                pricePerKg: 15,
                estimatedTotal: 48,
                confidenceScore: 0.91,
              ),
            ]
          : items,
      date: _selectedDate,
      timeSlot: _selectedTimeSlot,
      address: _address,
      instructions: _instructionsController.text,
    );

    if (mounted) {
      context.push('/citizen/collector-matching');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Schedule Doorstep Pickup'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pickup Address Card
              Text('Pickup Address', style: AppTypography.titleMedium),
              const SizedBox(height: 10),
              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.mapPin, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Home Address', style: AppTypography.titleSmall),
                          const SizedBox(height: 2),
                          Text(_address, style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Change', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Date Selection
              Text('Select Pickup Date', style: AppTypography.titleMedium),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildDateTile('Today, 18 Sep'),
                  const SizedBox(width: 10),
                  _buildDateTile('Tomorrow, 19 Sep'),
                  const SizedBox(width: 10),
                  _buildDateTile('20 Sep'),
                ],
              ),
              const SizedBox(height: 24),

              // Time Slot Selection
              Text('Select Preferred Time Slot', style: AppTypography.titleMedium),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: AppConstants.timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = AppConstants.timeSlots[index];
                  final isSelected = _selectedTimeSlot == slot;
                  return CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: isSelected ? AppColors.primaryLight : AppColors.surface,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedTimeSlot = slot;
                      });
                    },
                    child: Center(
                      child: Text(
                        slot,
                        style: AppTypography.titleSmall.copyWith(
                          color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Additional Instructions
              CustomTextField(
                label: 'Pickup Instructions (Optional)',
                hint: 'e.g., Ring bell twice, items kept at gate',
                controller: _instructionsController,
                prefixIcon: const Icon(LucideIcons.messageSquare, color: AppColors.textMuted),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Confirm Pickup Request',
                onPressed: _onConfirmPickup,
                icon: LucideIcons.checkCircle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTile(String label) {
    final isSelected = _selectedDate == label;
    return Expanded(
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: isSelected ? AppColors.primaryLight : AppColors.surface,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        onTap: () {
          setState(() {
            _selectedDate = label;
          });
        },
        child: Center(
          child: Text(
            label,
            style: AppTypography.titleSmall.copyWith(
              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
