import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/task.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/priority_badge.dart';
import '../../shared/widgets/app_progress_bar.dart';

class TaskBottomSheet extends StatelessWidget {
  final DateTime  selectedDay;
  final List<Task> tasks;
  final bool      isLoading;
  final void Function(Task) onTaskTap;

  const TaskBottomSheet({
    super.key,
    required this.selectedDay,
    required this.tasks,
    required this.isLoading,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      decoration: const BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ─────────────────────────────────────────
          const SizedBox(height: AppDimensions.spaceMD),
          Center(
            child: Container(
              width:  40,
              height: 4,
              decoration: BoxDecoration(
                color:        AppColors.grey300,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusFull,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Header ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLG,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceSM),
                  decoration: BoxDecoration(
                    color:        AppColors.primary.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSM,
                    ),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.primary,
                    size:  AppDimensions.iconMD,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(selectedDay),
                      style: AppTextStyles.headlineSmall,
                    ),
                    Text(
                      '${tasks.length} công việc',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          const Divider(height: 1),

          // ── Content ─────────────────────────────────────────
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(AppDimensions.space40),
              child:   LoadingWidget(),
            )
          else if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXXL),
              child:   EmptyStateWidget.noTasks(),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.spaceLG),
                itemCount: tasks.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: AppDimensions.spaceSM),
                itemBuilder: (_, i) => _TaskSheetItem(
                  task:  tasks[i],
                  onTap: () => onTaskTap(tasks[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
      'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
      'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12',
    ];
    return '${dt.day} ${months[dt.month]}, ${dt.year}';
  }
}

// ── Task item trong bottom sheet ──────────────────────────────
class _TaskSheetItem extends StatelessWidget {
  final Task         task;
  final VoidCallback onTap;

  const _TaskSheetItem({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color:        AppColors.grey50,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            // ── Status dot ────────────────────────────────────
            Container(
              width:  10,
              height: 10,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? AppColors.statusDone
                    : task.isOverdue
                    ? AppColors.statusOverdue
                    : AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),

            // ── Title + progress ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? AppColors.grey400
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.isInProgress) ...[
                    const SizedBox(height: AppDimensions.spaceXS),
                    AppProgressBar(
                      value:  task.progressPercent / 100,
                      height: 3,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSM),

            // ── Priority badge ────────────────────────────────
            PriorityBadge(priority: task.priority, compact: true),
            const SizedBox(width: AppDimensions.spaceXS),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey400,
              size:  AppDimensions.iconMD,
            ),
          ],
        ),
      ),
    );
  }
}