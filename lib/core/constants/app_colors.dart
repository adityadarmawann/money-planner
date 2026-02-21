import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF03A9F4);
  static const Color primaryLight = Color(0xFF4FC3F7);
  static const Color primaryLighter = Color(0xFF81D4FA);
  static const Color primaryLightest = Color(0xFFB3E5FC);
  static const Color primaryDark = Color(0xFF0288D1);

  // Background
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF5FAFF);
  static const Color backgroundCard = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Income/Expense
  static const Color income = Color(0xFF4CAF50);
  static const Color expense = Color(0xFFF44336);

  // Border & divider
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Shadow
  static const Color shadow = Color(0x0D000000);

  // Overlay
  static const Color overlay = Color(0x80000000);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0288D1), Color(0xFF29B6F6)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF03A9F4), Color(0xFF4FC3F7)],
  );
}
