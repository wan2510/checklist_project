import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

enum PriorityLevel {
  high,
  medium,
  low;

  String get label {
    switch (this) {
      case PriorityLevel.high:   return AppStrings.priorityHigh;
      case PriorityLevel.medium: return AppStrings.priorityMedium;
      case PriorityLevel.low:    return AppStrings.priorityLow;
    }
  }

  Color get color {
    switch (this) {
      case PriorityLevel.high:   return AppColors.priorityHigh;
      case PriorityLevel.medium: return AppColors.priorityMedium;
      case PriorityLevel.low:    return AppColors.priorityLow;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PriorityLevel.high:   return AppColors.priorityHigh.withOpacity(0.12);
      case PriorityLevel.medium: return AppColors.priorityMedium.withOpacity(0.12);
      case PriorityLevel.low:    return AppColors.priorityLow.withOpacity(0.12);
    }
  }

  int get sortOrder {
    switch (this) {
      case PriorityLevel.high:   return 0;
      case PriorityLevel.medium: return 1;
      case PriorityLevel.low:    return 2;
    }
  }

  static PriorityLevel fromString(String value) {
    return PriorityLevel.values.firstWhere(
          (e) => e.name == value,
      orElse: () => PriorityLevel.medium,
    );
  }
}