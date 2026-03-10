import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/entities/room.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../../../shared/widgets/overdue_badge.dart';

class RoomCard extends StatelessWidget {
  final Room         room;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        decoration: BoxDecoration(
          color:        AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color:      AppColors.grey300.withValues(alpha:0.35),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: icon + name + badge + arrow ─────────────
            Row(
              children: [
                // Emoji icon
                Container(
                  width:  48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:        AppColors.primary.withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Center(
                    child: Text(
                      room.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),

                // Name + task count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: AppDimensions.spaceXXS),
                      Text(
                        '${room.totalTasks} công việc',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Overdue badge hoặc completed icon
                if (room.isCompleted)
                  _buildCompletedBadge()
                else if (room.hasOverdue)
                  OverdueBadge(count: room.overdueTasks)
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey400,
                  ),
              ],
            ),

            const SizedBox(height: AppDimensions.spaceLG),

            // ── Row 2: progress bar ───────────────────────────
            AppProgressBar(
              value:      room.progressPercent,
              height:     6,
              fillColor: room.isCompleted
                  ? AppColors.statusDone
                  : AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Row 3: done count + percent ───────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${room.completedTasks}/${room.totalTasks} việc hoàn thành',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                Text(
                  '${room.progressInt}%',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: room.isCompleted
                        ? AppColors.statusDone
                        : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMD,
        vertical:   AppDimensions.spaceXS,
      ),
      decoration: BoxDecoration(
        color:        AppColors.statusDone.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size:  14,
            color: AppColors.statusDone,
          ),
          const SizedBox(width: 4),
          Text(
            'Hoàn thành',
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.statusDone,
            ),
          ),
        ],
      ),
    );
  }
}