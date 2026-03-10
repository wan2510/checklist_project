import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskGroupHeader extends StatelessWidget {
  final String groupKey;
  final int    count;

  const TaskGroupHeader({
    super.key,
    required this.groupKey,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = groupKey == 'QUÁ HẠN';

    return Padding(
      padding: const EdgeInsets.only(
        top:    AppDimensions.spaceLG,
        bottom: AppDimensions.spaceSM,
      ),
      child: Row(
        children: [
          // ── Colored dot ──────────────────────────────────────
          Container(
            width:  6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOverdue
                  ? AppColors.statusOverdue
                  : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),

          // ── Group label ──────────────────────────────────────
          Text(
            groupKey,
            style: AppTextStyles.titleSmall.copyWith(
              color: isOverdue
                  ? AppColors.statusOverdue
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXS),

          // ── Count badge ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceSM,
              vertical:   1,
            ),
            decoration: BoxDecoration(
              color: isOverdue
                  ? AppColors.statusOverdue.withOpacity(0.1)
                  : AppColors.grey100,
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusFull,
              ),
            ),
            child: Text(
              '$count việc',
              style: AppTextStyles.labelSmall.copyWith(
                color: isOverdue
                    ? AppColors.statusOverdue
                    : AppColors.grey500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}