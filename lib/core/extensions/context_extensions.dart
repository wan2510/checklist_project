import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension ThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgColor => isDark
      ? AppColors.backgroundDark
      : AppColors.backgroundLight;

  Color get cardColor => isDark
      ? AppColors.cardDark
      : AppColors.cardLight;

  Color get surfaceColor => isDark
      ? AppColors.surfaceDark
      : AppColors.surfaceLight;

  Color get textPrimary => isDark
      ? AppColors.textPrimaryDark
      : AppColors.textPrimaryLight;

  Color get dividerColor => isDark
      ? AppColors.grey700
      : AppColors.grey200;
}