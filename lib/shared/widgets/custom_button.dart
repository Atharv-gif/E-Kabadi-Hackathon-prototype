import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum ButtonType { primary, secondary, outline, text, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (type) {
      case ButtonType.primary:
        bg = AppColors.primary;
        fg = AppColors.surface;
        break;
      case ButtonType.secondary:
        bg = AppColors.primaryLight;
        fg = AppColors.primaryDark;
        break;
      case ButtonType.outline:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = const BorderSide(color: AppColors.border, width: 1.5);
        break;
      case ButtonType.text:
        bg = Colors.transparent;
        fg = AppColors.primary;
        break;
      case ButtonType.danger:
        bg = AppColors.error;
        fg = AppColors.surface;
        break;
    }

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: AppTypography.labelLarge.copyWith(color: fg),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: border,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}
