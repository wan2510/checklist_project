import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class BarChartWidget extends StatelessWidget {
  final List<MapEntry<String, int>> weeklyData;

  const BarChartWidget({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    if (weeklyData.isEmpty) return const SizedBox.shrink();

    final maxY = weeklyData
        .map((e) => e.value)
        .fold(0, (a, b) => a > b ? a : b)
        .toDouble();

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY:          (maxY + 2).clamp(5, double.infinity),
          gridData:      FlGridData(
            show:                 true,
            drawVerticalLine:     false,
            horizontalInterval:   2,
            getDrawingHorizontalLine: (_) => FlLine(
              color:       AppColors.grey200,
              strokeWidth: 1,
            ),
          ),
          borderData:    FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:    AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles:   true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= weeklyData.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      weeklyData[idx].key,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: weeklyData.asMap().entries.map((e) {
            final index = e.key;
            final value = e.value.value.toDouble();
            final isToday = index == weeklyData.length - 1;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY:           value,
                  color:         isToday
                      ? AppColors.primary
                      : AppColors.accent.withValues(alpha:0.6),
                  width:         22,
                  borderRadius:  const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusXS),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}