import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class StatsGrid extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int overdueTasks;

  const StatsGrid({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.overdueTasks,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount:   2,
      crossAxisSpacing: AppDimensions.spaceMD,
      mainAxisSpacing:  AppDimensions.spaceMD,
      shrinkWrap:       true,
      childAspectRatio: 1.6,
      physics:  const NeverScrollableScrollPhysics(),
      children: [
        _StatTile(
          icon:      Icons.list_alt_rounded,
          iconColor: AppColors.accent,
          bgColor:   AppColors.accent.withValues(alpha:0.1),
          value:     '$totalTasks',
          label:     'TẤT CẢ',
          sublabel:  'Tổng số việc',
        ),
        _StatTile(
          icon:      Icons.check_circle_outline_rounded,
          iconColor: AppColors.statusDone,
          bgColor:   AppColors.statusDone.withValues(alpha:0.1),
          value:     '$completedTasks',
          label:     'HOÀN TẤT',
          sublabel:  'Đã xong',
        ),
        _StatTile(
          icon:      Icons.autorenew_rounded,
          iconColor: AppColors.secondary,
          bgColor:   AppColors.secondary.withValues(alpha:0.1),
          value:     '$inProgressTasks',
          label:     'TIẾN HÀNH',
          sublabel:  'Đang làm',
        ),
        _StatTile(
          icon:      Icons.warning_amber_rounded,
          iconColor: AppColors.statusOverdue,
          bgColor:   AppColors.statusOverdue.withValues(alpha:0.1),
          value:     '$overdueTasks',
          label:     'CẦN CHÚ Ý',
          sublabel:  'Quá hạn',
          isAlert:   overdueTasks > 0,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final Color    bgColor;
  final String   value;
  final String   label;
  final String   sublabel;
  final bool     isAlert;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.label,
    required this.sublabel,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: isAlert
            ? Border.all(
          color: AppColors.statusOverdue.withValues(alpha:0.3),
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
      child: Row(
        children: [
          Container(
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              color:        bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Icon(icon, color: iconColor, size: AppDimensions.iconMD),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: AppTextStyles.statNumber.copyWith(
                    fontSize: 22,
                    color: isAlert && int.parse(value) > 0
                        ? AppColors.statusOverdue
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(label,    style: AppTextStyles.statLabel),
                Text(sublabel, style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color:    AppColors.grey400,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}