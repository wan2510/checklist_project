import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickStatsRow extends StatelessWidget {
  final int todayCount;
  final int highPriorityCount;
  final int overdueCount;

  const QuickStatsRow({
    super.key,
    required this.todayCount,
    required this.highPriorityCount,
    required this.overdueCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon:       Icons.today_outlined,
            iconColor:  AppColors.accent,
            bgColor:    AppColors.accent.withValues(alpha:0.1),
            count:      todayCount,
            label:      AppStrings.statToday,
            subLabel:   AppStrings.taskNeedDone,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          child: _StatCard(
            icon:       Icons.star_outline_rounded,
            iconColor:  AppColors.secondary,
            bgColor:    AppColors.secondary.withValues(alpha:0.1),
            count:      highPriorityCount,
            label:      AppStrings.statPriority,
            subLabel:   AppStrings.taskHighPriority,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          child: _StatCard(
            icon:       Icons.warning_amber_rounded,
            iconColor:  AppColors.statusOverdue,
            bgColor:    AppColors.statusOverdue.withValues(alpha:0.1),
            count:      overdueCount,
            label:      AppStrings.statNearDue,
            subLabel:   AppStrings.taskNearDeadline,
            isAlert:    overdueCount > 0,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final Color    bgColor;
  final int      count;
  final String   label;
  final String   subLabel;
  final bool     isAlert;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.count,
    required this.label,
    required this.subLabel,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color:      AppColors.grey300.withValues(alpha:0.4),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
        border: isAlert
            ? Border.all(
          color: AppColors.statusOverdue.withValues(alpha:0.3),
          width: 1,
        )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon ────────────────────────────────────────────
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              color:        bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Icon(icon, color: iconColor, size: AppDimensions.iconMD),
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // ── Count ────────────────────────────────────────────
          Text(
            count.toString().padLeft(2, '0'),
            style: AppTextStyles.statNumber.copyWith(
              color: isAlert && count > 0
                  ? AppColors.statusOverdue
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXS),

          // ── Label ─────────────────────────────────────────────
          Text(
            label,
            style: AppTextStyles.statLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subLabel,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}