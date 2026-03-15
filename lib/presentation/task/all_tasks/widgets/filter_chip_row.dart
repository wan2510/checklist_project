import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../all_tasks_viewmodel.dart';

class FilterChipRow extends StatelessWidget {
  final TaskFilterTab             activeFilter;
  final ValueChanged<TaskFilterTab> onFilterChanged;
  final int                       overdueCount;

  const FilterChipRow({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary; // FIX

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      child: Row(
        children: TaskFilterTab.values.map((filter) {
          final isActive  = activeFilter == filter;
          final isOverdue = filter == TaskFilterTab.overdue;

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSM),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLG,
                  vertical:   AppDimensions.spaceSM,
                ),
                decoration: BoxDecoration(
                  color: isActive ? primary : AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  border: Border.all(
                    color: isActive ? primary : AppColors.grey300,
                    width: 1,
                  ),
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color:      primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset:     const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _label(filter),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isActive ? AppColors.white : AppColors.grey600,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    // Badge đỏ cho overdue (giữ đỏ vì đây là cảnh báo)
                    if (isOverdue && overdueCount > 0) ...[
                      const SizedBox(width: AppDimensions.spaceXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical:   1,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.white.withValues(alpha: 0.3)
                              : AppColors.statusOverdue,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          '$overdueCount',
                          style: const TextStyle(
                            fontSize:   10,
                            fontWeight: FontWeight.w700,
                            color:      AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(TaskFilterTab filter) {
    switch (filter) {
      case TaskFilterTab.all:          return 'Tất cả';
      case TaskFilterTab.today:        return 'Hôm nay';
      case TaskFilterTab.thisWeek:     return 'Tuần này';
      case TaskFilterTab.overdue:      return 'Quá hạn';
      case TaskFilterTab.highPriority: return 'Ưu tiên cao';
    }
  }
}