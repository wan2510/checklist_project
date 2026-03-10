import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/enums/priority_level.dart';
import '../../../core/theme/app_text_styles.dart';

class PriorityBadge extends StatelessWidget {
  final PriorityLevel priority;
  final bool          compact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact
            ? AppDimensions.spaceSM
            : AppDimensions.spaceMD,
        vertical: compact
            ? AppDimensions.spaceXXS + 1
            : AppDimensions.spaceXS,
      ),
      decoration: BoxDecoration(
        color:        priority.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        priority.label,
        style: AppTextStyles.badgeText.copyWith(
          color:    priority.color,
          fontSize: compact ? 10 : 11,
        ),
      ),
    );
  }
}