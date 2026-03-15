import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';

class ExploreGrid extends StatelessWidget {
  final VoidCallback onRoomList;
  final VoidCallback onAllTasks;
  final VoidCallback onCalendar;
  final VoidCallback onReport;

  const ExploreGrid({
    super.key,
    required this.onRoomList,
    required this.onAllTasks,
    required this.onCalendar,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _GridItem(
        icon:    HugeIcons.strokeRoundedHome09,
        label:   AppStrings.menuRoomList,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFE8344E)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onRoomList,
      ),
      _GridItem(
        icon:    HugeIcons.strokeRoundedTaskDone01,
        label:   AppStrings.menuAllTasks,
        gradient: const LinearGradient(
          colors: [Color(0xFF7C5CBF), Color(0xFF9B7FD4)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onAllTasks,
      ),
      _GridItem(
        icon:    HugeIcons.strokeRoundedCalendar03,
        label:   AppStrings.menuCalendar,
        gradient: const LinearGradient(
          colors: [Color(0xFFF5A623), Color(0xFFFFCC70)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onCalendar,
      ),
      _GridItem(
        icon:    HugeIcons.strokeRoundedAnalytics01,
        label:   AppStrings.menuReport,
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onReport,
      ),
    ];

    return GridView.count(
      crossAxisCount:   2,
      crossAxisSpacing: AppDimensions.spaceMD,
      mainAxisSpacing:  AppDimensions.spaceMD,
      shrinkWrap:       true,
      childAspectRatio: 1.3,
      physics:          const NeverScrollableScrollPhysics(),
      children:         items,
    );
  }
}

class _GridItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String              label;
  final LinearGradient      gradient;
  final VoidCallback        onTap;

  const _GridItem({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:        context.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color:      context.isDark
                  ? Colors.black26
                  : AppColors.grey300.withValues(alpha: 0.4),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width:  48,
                height: 48,
                decoration: BoxDecoration(
                  gradient:     gradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Center(
                  child: HugeIcon(
                    icon:        icon,
                    color:       AppColors.white,
                    size:        24,
                    strokeWidth: 1.6,
                  ),
                ),
              ),
              Text(
                label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: context.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}