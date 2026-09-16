import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette - Eco Deep & Emerald
  static const Color primaryDark = Color(0xFF14532D);   // Deep Forest Green
  static const Color primary = Color(0xFF15803D);       // Rich Eco Green
  static const Color primaryMedium = Color(0xFF22C55E); // Bright Emerald
  static const Color primaryLight = Color(0xFFDCFCE7);  // Soft Tint Green

  // Tech Accent - Smart City Blue
  static const Color techBlue = Color(0xFF0284C7);
  static const Color techBlueLight = Color(0xFFE0F2FE);

  // Reward Accent - Energy Orange
  static const Color rewardOrange = Color(0xFFEA580C);
  static const Color rewardOrangeLight = Color(0xFFFFEDD5);

  // Neutral Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);

  // Status & Feedback Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Shimmer / Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF15803D), Color(0xFF166534)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ecoGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient rewardGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
