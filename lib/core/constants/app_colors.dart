import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand / Tết palette ──────────────────────────────────────
  static const Color primary        = Color(0xFFE8344E); // Đỏ Tết
  static const Color primaryLight   = Color(0xFFFF6B81);
  static const Color primaryDark    = Color(0xFFC0213A);

  static const Color secondary      = Color(0xFFF5A623); // Vàng may mắn
  static const Color secondaryLight = Color(0xFFFFCC70);
  static const Color secondaryDark  = Color(0xFFD4871A);

  static const Color accent         = Color(0xFF7C5CBF); // Tím nhẹ (từ mockup)

  // ── Priority colors ─────────────────────────────────────────
  static const Color priorityHigh   = Color(0xFFE8344E); // Cao   - đỏ
  static const Color priorityMedium = Color(0xFFF5A623); // Trung - vàng
  static const Color priorityLow    = Color(0xFF4CAF50); // Thấp  - xanh lá

  // ── Status colors ────────────────────────────────────────────
  static const Color statusDone     = Color(0xFF4CAF50);
  static const Color statusInProgress = Color(0xFF2196F3);
  static const Color statusPending  = Color(0xFF9E9E9E);
  static const Color statusOverdue  = Color(0xFFE8344E);

  // ── Neutral ──────────────────────────────────────────────────
  static const Color white          = Color(0xFFFFFFFF);
  static const Color black          = Color(0xFF000000);
  static const Color grey50         = Color(0xFFFAFAFA);
  static const Color grey100        = Color(0xFFF5F5F5);
  static const Color grey200        = Color(0xFFEEEEEE);
  static const Color grey300        = Color(0xFFE0E0E0);
  static const Color grey400        = Color(0xFFBDBDBD);
  static const Color grey500        = Color(0xFF9E9E9E);
  static const Color grey600        = Color(0xFF757575);
  static const Color grey700        = Color(0xFF616161);
  static const Color grey800        = Color(0xFF424242);
  static const Color grey900        = Color(0xFF212121);

  // ── Background ───────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark  = Color(0xFF121212);
  static const Color surfaceLight    = Color(0xFFFFFFFF);
  static const Color surfaceDark     = Color(0xFF1E1E1E);
  static const Color cardLight       = Color(0xFFFFFFFF);
  static const Color cardDark        = Color(0xFF2C2C2C);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark    = Color(0xFFF1F1F1);
  static const Color textSecondaryDark  = Color(0xFFAAAAAA);

  // ── Progress bar ─────────────────────────────────────────────
  static const Color progressBackground = Color(0xFFEEEEEE);
  static const Color progressFill       = Color(0xFFE8344E);

  // ── Chart colors (cho pie/bar chart) ─────────────────────────
  static const List<Color> chartColors = [
    Color(0xFFE8344E),
    Color(0xFFF5A623),
    Color(0xFF4CAF50),
    Color(0xFF7C5CBF),
    Color(0xFF2196F3),
    Color(0xFFFF7043),
  ];

  // ── Gradient ─────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE8344E), Color(0xFFFF6B81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFE8344E), Color(0xFFC0213A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFFFCC70)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}