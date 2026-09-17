import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';

enum ButtonType { primary, secondary, outline, text, danger }

/// Premium button with press-scale feedback, loading & disabled states.
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  Color get _bg {
    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.secondary:
        return AppColors.primaryLight;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.text:
        return Colors.transparent;
      case ButtonType.danger:
        return AppColors.error;
    }
  }

  Color get _fg {
    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.surface;
      case ButtonType.secondary:
        return AppColors.primaryDark;
      case ButtonType.outline:
        return AppColors.textPrimary;
      case ButtonType.text:
        return AppColors.primary;
      case ButtonType.danger:
        return AppColors.surface;
    }
  }

  BorderSide get _border {
    switch (widget.type) {
      case ButtonType.outline:
        return const BorderSide(color: AppColors.borderStrong, width: 1.5);
      case ButtonType.secondary:
        return const BorderSide(color: AppColors.primaryMedium, width: 1);
      default:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    final fg = _fg;

    Widget content = widget.isLoading
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
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLarge.copyWith(color: fg),
                ),
              ),
            ],
          );

    final button = AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: AppDurations.fast,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: Curves.easeInOut,
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: enabled
              ? _bg
              : (widget.type == ButtonType.text || widget.type == ButtonType.outline
                  ? Colors.transparent
                  : AppColors.border),
          borderRadius: AppRadius.rMd,
          border: Border.fromBorderSide(_border),
          boxShadow: enabled && widget.type == ButtonType.primary ? AppShadows.glowingGreen : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? widget.onPressed : null,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            borderRadius: AppRadius.rMd,
            splashColor: fg.withValues(alpha: 0.08),
            highlightColor: fg.withValues(alpha: 0.04),
            child: Center(child: content),
          ),
        ),
      ),
    );

    if (!enabled) {
      return Opacity(opacity: 0.55, child: button);
    }
    return button;
  }
}
