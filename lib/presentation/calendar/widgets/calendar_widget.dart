import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/task.dart';
import '../calendar_viewmodel.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarViewModel viewModel;
  final VoidCallback?     onDaySelected;

  const CalendarWidget({
    super.key,
    required this.viewModel,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      AppColors.grey300.withValues(alpha:0.3),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar<Task>(
        firstDay:    DateTime(2025, 1, 1),
        lastDay:     DateTime(2027, 12, 31),
        focusedDay:  viewModel.focusedDay,
        selectedDayPredicate: (day) =>
        viewModel.selectedDay != null &&
            isSameDay(viewModel.selectedDay!, day),

        // ── Events ──────────────────────────────────────────
        eventLoader: viewModel.tasksForDay,

        // ── Callbacks ───────────────────────────────────────
        onDaySelected: (selected, focused) {
          viewModel.selectDay(selected);
          onDaySelected?.call();
        },
        onPageChanged: viewModel.onPageChanged,

        // ── Format ──────────────────────────────────────────
        calendarFormat:   CalendarFormat.month,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Tháng',
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale:            'vi_VN',

        // ── Header style ────────────────────────────────────
        headerStyle: HeaderStyle(
          formatButtonVisible:  false,
          titleCentered:        true,
          titleTextStyle:       AppTextStyles.titleLarge,
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.grey600,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.grey600,
          ),
          headerPadding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spaceMD,
          ),
        ),

        // ── Days of week ────────────────────────────────────
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.labelSmall.copyWith(
            color: AppColors.grey500,
          ),
          weekendStyle: AppTextStyles.labelSmall.copyWith(
            color: AppColors.statusOverdue.withValues(alpha:0.7),
          ),
        ),

        // ── Calendar style ──────────────────────────────────
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color:        AppColors.primary.withValues(alpha:0.15),
            shape:        BoxShape.circle,
          ),
          todayTextStyle: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
          ),
          selectedDecoration: const BoxDecoration(
            color:  AppColors.primary,
            shape:  BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.titleMedium.copyWith(
            color: AppColors.white,
          ),
          defaultTextStyle:  AppTextStyles.bodyMedium,
          weekendTextStyle:  AppTextStyles.bodyMedium.copyWith(
            color: AppColors.statusOverdue.withValues(alpha:0.8),
          ),
          markerDecoration: const BoxDecoration(
            color:  AppColors.primary,
            shape:  BoxShape.circle,
          ),
          markerSize:       6,
          markersMaxCount:  3,
          markerMargin: const EdgeInsets.symmetric(horizontal: 1),
          cellMargin: const EdgeInsets.all(4),
        ),

        // ── Custom marker builder ────────────────────────────
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, tasks) {
            if (tasks.isEmpty) return const SizedBox.shrink();
            return _buildMarkers(day, tasks.cast<Task>());
          },
        ),
      ),
    );
  }

  Widget _buildMarkers(DateTime day, List<Task> tasks) {
    final hasHigh = tasks.any(
          (t) => t.priority.name == 'high',
    );
    final hasNormal = tasks.any(
          (t) => t.priority.name != 'high',
    );

    return Positioned(
      bottom: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHigh)
            _dot(AppColors.statusOverdue),
          if (hasNormal)
            _dot(AppColors.primary),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
    width:  6,
    height: 6,
    margin: const EdgeInsets.symmetric(horizontal: 1),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}