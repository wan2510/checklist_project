import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/task.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/priority_badge.dart';

class TaskItemCard extends StatelessWidget {
  final Task         task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskItemCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
      child: Slidable(
        key: ValueKey(task.id),

        // ── Swipe right: Edit ─────────────────────────────────
        startActionPane: ActionPane(
          motion:   const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed:       (_) => onEdit(),
              backgroundColor: AppColors.statusInProgress,
              foregroundColor: AppColors.white,
              icon:            Icons.edit_outlined,
              label:           'Sửa',
              borderRadius:    BorderRadius.circular(AppDimensions.radiusLG),
            ),
          ],
        ),

        // ── Swipe left: Delete ────────────────────────────────
        endActionPane: ActionPane(
          motion:   const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed:       (_) => onDelete(),
              backgroundColor: AppColors.statusOverdue,
              foregroundColor: AppColors.white,
              icon:            Icons.delete_outline_rounded,
              label:           'Xóa',
              borderRadius:    BorderRadius.circular(AppDimensions.radiusLG),
            ),
          ],
        ),

        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            decoration: BoxDecoration(
              color:        AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              border: task.isOverdue
                  ? Border.all(
                color: AppColors.statusOverdue.withValues(alpha:0.4),
                width: 1,
              )
                  : null,
              boxShadow: [
                BoxShadow(
                  color:      AppColors.grey300.withValues(alpha:0.3),
                  blurRadius: 6,
                  offset:     const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: checkbox + title + priority ─────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: onToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width:  24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXS,
                          ),
                          border: Border.all(
                            color: task.isCompleted
                                ? AppColors.primary
                                : AppColors.grey300,
                            width: 1.5,
                          ),
                        ),
                        child: task.isCompleted
                            ? const Icon(
                          Icons.check_rounded,
                          size:  16,
                          color: AppColors.white,
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMD),

                    // Title
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? AppColors.grey400
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM),

                    // Priority badge
                    PriorityBadge(
                      priority: task.priority,
                      compact:  true,
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spaceMD),

                // ── Row 2: deadline ───────────────────────────
                Row(
                  children: [
                    const SizedBox(width: 36), // align với title
                    Icon(
                      Icons.calendar_today_outlined,
                      size:  AppDimensions.iconSM,
                      color: task.isOverdue
                          ? AppColors.statusOverdue
                          : AppColors.grey400,
                    ),
                    const SizedBox(width: AppDimensions.spaceXS),
                    Text(
                      '${task.deadline.day} Tháng ${task.deadline.month}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: task.isOverdue
                            ? AppColors.statusOverdue
                            : AppColors.grey500,
                        fontWeight: task.isOverdue
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (task.isOverdue) ...[
                      const SizedBox(width: AppDimensions.spaceXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceXS,
                          vertical:   1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.statusOverdue.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXS,
                          ),
                        ),
                        child: Text(
                          'Hôm qua',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.statusOverdue,
                          ),
                        ),
                      ),
                    ],
                    if (task.isCompleted) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceSM,
                          vertical:   2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.statusDone.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                        ),
                        child: Text(
                          'Xong',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.statusDone,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // ── Row 3: progress bar (nếu inProgress) ─────
                if (task.isInProgress && task.progressPercent > 0) ...[
                  const SizedBox(height: AppDimensions.spaceMD),
                  Row(
                    children: [
                      const SizedBox(width: 36),
                      Expanded(
                        child: AppProgressBar(
                          value:  task.progressPercent / 100,
                          height: AppDimensions.progressBarHeightSM,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceSM),
                      Text(
                        '${task.progressPercent}%',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}