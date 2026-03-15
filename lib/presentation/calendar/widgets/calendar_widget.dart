import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
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
    final primary      = Theme.of(context).colorScheme.primary;
    final textPrimary  = context.textPrimary;
    final cardColor    = context.cardColor;
    final isDark       = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color:        cardColor, // FIX: dark mode
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      isDark
                ? Colors.black26
                : AppColors.grey300.withValues(alpha: 0.3),
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
        eventLoader:   viewModel.tasksForDay,
        onDaySelected: (selected, focused) {
          viewModel.selectDay(selected);
          onDaySelected?.call();
        },
        onPageChanged: viewModel.onPageChanged,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const { CalendarFormat.month: 'Tháng' },
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale:            'vi_VN',

        // ── Header ──────────────────────────────────────────
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered:       true,
          titleTextStyle: AppTextStyles.titleLarge.copyWith(
            color: textPrimary, // FIX: dark mode title
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: textPrimary.withValues(alpha: 0.6), // FIX
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: textPrimary.withValues(alpha: 0.6), // FIX
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceMD),
        ),

        // ── Days of week ─────────────────────────────────────
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.labelSmall.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey500, // FIX
          ),
          weekendStyle: AppTextStyles.labelSmall.copyWith(
            color: AppColors.statusOverdue.withValues(alpha: 0.7),
          ),
        ),

        // ── Calendar style ────────────────────────────────────
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: primary.withValues(alpha: 0.15), // FIX: theme
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppTextStyles.titleMedium.copyWith(
            color: primary, // FIX: theme
          ),
          selectedDecoration: BoxDecoration(
            color: primary, // FIX: theme
            shape: BoxShape.circle,
          ),
          selectedTextStyle: AppTextStyles.titleMedium.copyWith(
            color: AppColors.white,
          ),
          defaultTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: textPrimary, // FIX: dark mode ngày thường
          ),
          weekendTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.statusOverdue.withValues(alpha: 0.8),
          ),
          outsideTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.grey700 : AppColors.grey300,
          ),
          disabledTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.grey700 : AppColors.grey300,
          ),
          markersMaxCount: 0,
        ),

        // ── Custom markers ────────────────────────────────────
        calendarBuilders: CalendarBuilders(
          markerBuilder: (ctx, day, tasks) {
            if (tasks.isEmpty) return const SizedBox.shrink();
            return _buildMarkers(ctx, tasks.cast<Task>());
          },
        ),
      ),
    );
  }

  Widget _buildMarkers(BuildContext context, List<Task> tasks) {
    final primary   = Theme.of(context).colorScheme.primary;
    final hasHigh   = tasks.any((t) => t.priority.name == 'high');
    final hasNormal = tasks.any((t) => t.priority.name != 'high');

    return Row(
      mainAxisSize:      MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasHigh)   _dot(AppColors.statusOverdue),
        if (hasNormal) _dot(primary), // FIX: theme
      ],
    );
  }

  Widget _dot(Color color) => Container(
    width:  6,
    height: 6,
    margin: const EdgeInsets.symmetric(horizontal: 1),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}