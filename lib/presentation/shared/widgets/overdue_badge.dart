import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class OverdueBadge extends StatelessWidget {
  final int count;

  const OverdueBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical:   AppDimensions.spaceXS,
      ),
      decoration: BoxDecoration(
        color:        AppColors.statusOverdue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: AppColors.statusOverdue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size:  AppDimensions.iconSM,
            color: AppColors.statusOverdue,
          ),
          const SizedBox(width: AppDimensions.spaceXXS + 2),
          Text(
            '$count quá hạn',
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.statusOverdue,
            ),
          ),
        ],
      ),
    );
  }
}