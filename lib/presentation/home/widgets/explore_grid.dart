import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
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
        emoji:    '🏠',
        label:    AppStrings.menuRoomList,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFE8344E)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onRoomList,
      ),
      _GridItem(
        emoji:    '📋',
        label:    AppStrings.menuAllTasks,
        gradient: const LinearGradient(
          colors: [Color(0xFF7C5CBF), Color(0xFF9B7FD4)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onAllTasks,
      ),
      _GridItem(
        emoji:    '📅',
        label:    AppStrings.menuCalendar,
        gradient: const LinearGradient(
          colors: [Color(0xFFF5A623), Color(0xFFFFCC70)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        onTap: onCalendar,
      ),
      _GridItem(
        emoji:    '📊',
        label:    AppStrings.menuReport,
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
  final String         emoji;
  final String         label;
  final LinearGradient gradient;
  final VoidCallback   onTap;

  const _GridItem({
    required this.emoji,
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
          color:        AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color:      AppColors.grey300.withValues(alpha:0.4),
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
              // ── Icon container ──────────────────────────────
              Container(
                width:  44,
                height: 44,
                decoration: BoxDecoration(
                  gradient:     gradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),

              // ── Label ────────────────────────────────────────
              Text(
                label,
                style: AppTextStyles.titleMedium,
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