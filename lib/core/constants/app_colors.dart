import 'package:flutter/material.dart';

class AppColors {
  // Modern Primary Colors - Purple/Blue gradient theme
  static const Color primary = Color(0xFF6366F1); // Modern Indigo
  static const Color primaryDark = Color(0xFF4F46E5); // Dark Indigo
  static const Color primaryLight = Color(0xFFA5B4FC); // Light Indigo
  static const Color accent = Color(0xFF8B5CF6); // Purple accent

  // Secondary Colors - Teal/Cyan
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color secondaryDark = Color(0xFF0891B2); // Dark Cyan
  static const Color secondaryLight = Color(0xFF67E8F9); // Light Cyan

  // Modern Background Colors
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color backgroundDark = Color(0xFF0F172A); // Slate-900
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate-100
  static const Color surfaceDark = Color(0xFF1E293B); // Slate-800

  // Modern Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate-400
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B); // Slate-800

  // Modern Status Colors
  static const Color success = Color(0xFF10B981); // Emerald-500
  static const Color successLight = Color(0xFFD1FAE5); // Emerald-100
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber-100
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorLight = Color(0xFFFEE2E2); // Red-100
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue-100

  // Leave Status Colors with modern palette
  static const Color pending = Color(0xFFF59E0B); // Amber
  static const Color pendingBg = Color(0xFFFEF3C7);
  static const Color approved = Color(0xFF10B981); // Emerald
  static const Color approvedBg = Color(0xFFD1FAE5);
  static const Color rejected = Color(0xFFEF4444); // Red
  static const Color rejectedBg = Color(0xFFFEE2E2);
  static const Color cancelled = Color(0xFF6B7280); // Gray-500
  static const Color cancelledBg = Color(0xFFF3F4F6);

  // Modern Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Purple to Indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)], // Cyan to Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)], // Slate gradient
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glass morphism colors
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Shadow colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x1F000000);
  static const Color shadowColor = Color(0xFF000000);

  // Border colors
  static const Color borderColor = Color(0xFFE2E8F0); // Slate-200
  static const Color borderLight = Color(0xFFF1F5F9); // Slate-100
  static const Color borderDark = Color(0xFF94A3B8); // Slate-400
}
