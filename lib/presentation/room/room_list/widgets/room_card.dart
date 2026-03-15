import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/context_extensions.dart';
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
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        decoration: BoxDecoration(
          color:        context.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color:      context.isDark
                  ? Colors.black26
                  : AppColors.grey300.withValues(alpha: 0.35),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // FIX: HugeIcon nhận List<List<dynamic>> từ room.type.hugeIcon
                Container(
                  width:  52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: room.type.iconGradient,
                      begin:  Alignment.topLeft,
                      end:    Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon:        room.type.hugeIcon,
                      color:       AppColors.white,
                      size:        26,
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXXS),
                      Text(
                        '${room.totalTasks} công việc',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),

                if (room.isCompleted)
                  _buildCompletedBadge()
                else if (room.hasOverdue)
                  OverdueBadge(count: room.overdueTasks)
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: context.isDark ? AppColors.grey500 : AppColors.grey400,
                  ),
              ],
            ),

            const SizedBox(height: AppDimensions.spaceLG),

            AppProgressBar(
              value:     room.progressPercent,
              height:    6,
              fillColor: room.isCompleted ? AppColors.statusDone : primary,
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${room.completedTasks}/${room.totalTasks} việc hoàn thành',
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  '${room.progressInt}%',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: room.isCompleted ? AppColors.statusDone : primary,
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
        color:        AppColors.statusDone.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.statusDone),
          const SizedBox(width: 4),
          Text(
            'Hoàn thành',
            style: AppTextStyles.badgeText.copyWith(color: AppColors.statusDone),
          ),
        ],
      ),
    );
  }
}