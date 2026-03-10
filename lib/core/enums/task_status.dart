import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

enum TaskStatus {
  pending,
  inProgress,
  done;

  String get label {
    switch (this) {
      case TaskStatus.pending:    return AppStrings.statusPending;
      case TaskStatus.inProgress: return AppStrings.statusInProgress;
      case TaskStatus.done:       return AppStrings.statusDone;
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pending:    return AppColors.statusPending;
      case TaskStatus.inProgress: return AppColors.statusInProgress;
      case TaskStatus.done:       return AppColors.statusDone;
    }
  }

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
          (e) => e.name == value,
      orElse: () => TaskStatus.pending,
    );
  }

  static TaskStatus fromProgress(int progress) {
    if (progress <= 0)   return TaskStatus.pending;
    if (progress >= 100) return TaskStatus.done;
    return TaskStatus.inProgress;
  }
}