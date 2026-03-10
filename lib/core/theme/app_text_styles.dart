import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ──────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryLight,
  );

  // ── Headline ─────────────────────────────────────────────────
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  // ── Title ────────────────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
  );

  // ── Body ─────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight,
  );

  // ── Label ────────────────────────────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textSecondaryLight,
  );

  // ── Countdown (số lớn trên banner) ───────────────────────────
  static const TextStyle countdownNumber = TextStyle(
    fontSize: 36, fontWeight: FontWeight.w900,
    color: AppColors.white, letterSpacing: -1,
  );

  static const TextStyle countdownLabel = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // ── Progress percent ─────────────────────────────────────────
  static const TextStyle progressPercent = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // ── Stats card ───────────────────────────────────────────────
  static const TextStyle statNumber = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w800,
    color: AppColors.textPrimaryLight,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w600,
    letterSpacing: 0.8, color: AppColors.textSecondaryLight,
  );

  // ── Badge / chip ─────────────────────────────────────────────
  static const TextStyle badgeText = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // ── White variants (dùng trên nền màu) ───────────────────────
  static TextStyle get displayLargeWhite =>
      displayLarge.copyWith(color: AppColors.white);

  static TextStyle get headlineLargeWhite =>
      headlineLarge.copyWith(color: AppColors.white);

  static TextStyle get bodyMediumWhite =>
      bodyMedium.copyWith(color: AppColors.white.withOpacity(0.85));
}