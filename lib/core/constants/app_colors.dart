import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors (KozPay inspired - Dark Blue to Light Blue gradient)
  static const Color primary = Color(0xFF0052CC);
  static const Color primaryLight = Color(0xFF0066FF);
  static const Color primaryLighter = Color(0xFF4493FF);
  static const Color primaryLightest = Color(0xFFE8F0FF);
  static const Color primaryDark = Color(0xFF003D99);

  // Secondary colors (Orange accent)
  static const Color secondary = Color(0xFFFFA500);
  static const Color secondaryLight = Color(0xFFFFCD99);

  // Background
  static const Color background = Color(0xFFFAFBFF);
  static const Color backgroundSecondary = Color(0xFFF0F4FF);
  static const Color backgroundCard = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F1929);
  static const Color textSecondary = Color(0xFF66758E);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF1DBE4A);
  static const Color successLight = Color(0xFFE6F8E6);
  static const Color error = Color(0xFFE85547);
  static const Color errorLight = Color(0xFFFEE8E6);
  static const Color warning = Color(0xFFFFA500);
  static const Color warningLight = Color(0xFFFFF1E6);
  static const Color info = Color(0xFF0052CC);
  static const Color infoLight = Color(0xFFE8F0FF);

  // Income/Expense
  static const Color income = Color(0xFF1DBE4A);
  static const Color expense = Color(0xFFE85547);

  // Border & divider
  static const Color border = Color(0xFFE8EAED);
  static const Color divider = Color(0xFFF0F2F5);

  // Shadow
  static const Color shadow = Color(0x0D000000);

  // Overlay
  static const Color overlay = Color(0x80000000);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF003D99), Color(0xFF0066FF)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0052CC), Color(0xFF4493FF)],
  );
}
