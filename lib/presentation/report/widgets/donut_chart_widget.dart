import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DonutChartWidget extends StatelessWidget {
  final int completedTasks;
  final int inProgressTasks;
  final int pendingTasks;
  final int completionPercent;

  const DonutChartWidget({
    super.key,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.pendingTasks,
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final total = completedTasks + inProgressTasks + pendingTasks;
    if (total == 0) return const SizedBox.shrink();

    // FIX: dùng theme primary cho text "100%"
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Pie chart ─────────────────────────────────────
          PieChart(
            PieChartData(
              sectionsSpace:     3,
              centerSpaceRadius: 65,
              sections: [
                PieChartSectionData(
                  value:     completedTasks.toDouble(),
                  color:     AppColors.statusDone,
                  radius:    30,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value:     inProgressTasks.toDouble(),
                  color:     AppColors.statusInProgress,
                  radius:    30,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value:     pendingTasks.toDouble(),
                  color:     AppColors.grey200,
                  radius:    30,
                  showTitle: false,
                ),
              ],
            ),
          ),

          // ── Center text ───────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$completionPercent%',
                style: AppTextStyles.headlineLarge.copyWith(
                  // FIX: màu theo theme thay vì AppColors.primary hardcode
                  color:      primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'hoàn thành',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}