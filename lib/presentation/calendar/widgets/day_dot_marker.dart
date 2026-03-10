import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

/// Legend row hiển thị ý nghĩa các màu dot
class DayDotLegend extends StatelessWidget {
  const DayDotLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical:   AppDimensions.spaceMD,
      ),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border:       Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LegendItem(
            color: AppColors.statusOverdue,
            label: 'Ưu tiên cao',
          ),
          const SizedBox(width: AppDimensions.spaceLG),
          _LegendItem(
            color: AppColors.secondary,
            label: 'Deadline',
          ),
          const SizedBox(width: AppDimensions.spaceLG),
          _LegendItem(
            color: AppColors.primary,
            label: 'Bình thường',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color  color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width:  8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceXS),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }
}