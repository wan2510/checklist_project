import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/enums/priority_level.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrioritySelector extends StatelessWidget {
  final PriorityLevel               selected;
  final ValueChanged<PriorityLevel> onChanged;

  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: PriorityLevel.values.map((p) {
        final isSelected = selected == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: AppDimensions.spaceSM),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceMD,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? p.backgroundColor
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusMD,
                ),
                border: isSelected
                    ? Border.all(color: p.color, width: 1.5)
                    : Border.all(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _priorityIcon(p),
                    color: isSelected ? p.color : AppColors.grey400,
                    size:  AppDimensions.iconMD,
                  ),
                  const SizedBox(height: AppDimensions.spaceXS),
                  Text(
                    p.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? p.color : AppColors.grey500,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _priorityIcon(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.high:   return Icons.keyboard_double_arrow_up_rounded;
      case PriorityLevel.medium: return Icons.remove_rounded;
      case PriorityLevel.low:    return Icons.keyboard_double_arrow_down_rounded;
    }
  }
}