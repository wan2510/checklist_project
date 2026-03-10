import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/enums/task_status.dart';
import '../../../core/theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final TaskStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical:   AppDimensions.spaceXS,
      ),
      decoration: BoxDecoration(
        color:        status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.badgeText.copyWith(
          color: status.color,
        ),
      ),
    );
  }
}