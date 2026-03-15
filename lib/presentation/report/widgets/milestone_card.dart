import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../domain/entities/room.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_progress_bar.dart';

class MilestoneCard extends StatelessWidget {
  final String motivationMessage;
  final int    completionPercent;

  const MilestoneCard({
    super.key,
    required this.motivationMessage,
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final primary     = Theme.of(context).colorScheme.primary;
    final primaryDark = Color.lerp(primary, Colors.black, 0.15)!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryDark],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset:     const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Trophy icon ──────────────────────────────────────
          Container(
            width:  56,
            height: 56,
            decoration: BoxDecoration(
              color:        AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: const Center(
              child: Text('🏆', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceLG),

          // ── Text ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thành tích: Bậc Thầy Dọn Dẹp',
                  style: AppTextStyles.labelSmall.copyWith(
                    color:         AppColors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  motivationMessage,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Row(
                  children: [
                    Expanded(
                      child: AppProgressBar(
                        value:           completionPercent / 100,
                        height:          4,
                        fillColor:       AppColors.white,
                        backgroundColor: AppColors.white.withValues(alpha: 0.3),
                        animated:        false,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSM),
                    Text(
                      '$completionPercent%',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upcoming milestones ────────────────────────────────────────────
class UpcomingMilestones extends StatelessWidget {
  final List<Room> roomStats;

  const UpcomingMilestones({super.key, required this.roomStats});

  @override
  Widget build(BuildContext context) {
    final nearDone = roomStats
        .where((r) =>
    r.progressPercent >= 0.6 &&
        r.progressPercent < 1.0  &&
        r.totalTasks > 0)
        .take(3)
        .toList();

    if (nearDone.isEmpty) return const SizedBox.shrink();

    // FIX: theme primary cho icon tint
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MỐC QUAN TRỌNG SẮP TỚI',
          style: AppTextStyles.titleSmall,
        ),
        const SizedBox(height: AppDimensions.spaceMD),
        ...nearDone.map((room) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spaceLG),
            decoration: BoxDecoration(
              // FIX: dark mode card bg
              color:        context.cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              boxShadow: [
                BoxShadow(
                  color:      context.isDark
                      ? Colors.black26
                      : AppColors.grey300.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset:     const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // FIX: icon tint theo theme
                Container(
                  width:  36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:        primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.trending_up_rounded,
                      color: primary,
                      size:  AppDimensions.iconMD,
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
                        style: AppTextStyles.titleMedium.copyWith(
                          color: context.textPrimary,
                        ),
                      ),
                      Text(
                        'Hoàn thành ${room.progressInt}% ${room.name}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      AppProgressBar(
                        value:     room.progressPercent,
                        height:    4,
                        fillColor: primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}