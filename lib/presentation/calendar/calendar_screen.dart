import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../domain/entities/task.dart';
import '../shared/dialogs/add_task_bottom_sheet.dart';
import '../shared/widgets/fab_add_button.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/priority_badge.dart';
import 'calendar_viewmodel.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/day_dot_marker.dart';
import 'widgets/task_bottom_sheet.dart';

class CalendarScreen extends StatefulWidget {
  final CalendarViewModel viewModel;

  const CalendarScreen({super.key, required this.viewModel});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<CalendarViewModel>(
        builder: (context, vm, child) => Scaffold(
          backgroundColor: context.bgColor,
          body:            _buildBody(vm),
          floatingActionButton: FabAddButton(
            onPressed: () => AddTaskBottomSheet.show(
              context,
              onTaskAdded: vm.refresh,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CalendarViewModel vm) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [_buildSliverAppBar(vm)],
      body: vm.isLoading
          ? const LoadingWidget(message: 'Đang tải lịch...')
          : vm.isAgendaView
          ? _buildAgendaView(vm)
          : _buildMonthView(vm),
    );
  }

  Widget _buildSliverAppBar(CalendarViewModel vm) {
    // FIX: lấy màu theme
    final primary      = Theme.of(context).colorScheme.primary;
    final primaryLight = Color.lerp(primary, Colors.white, 0.25)!;

    return SliverAppBar(
      pinned:          true,
      backgroundColor: context.surfaceColor,
      elevation:       0,
      titleSpacing:    AppDimensions.screenPaddingH,
      title: Row(
        children: [
          // FIX: icon gradient theo theme
          Container(
            width:  32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primaryLight],
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.white,
              size:  18,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Text(
            'Lịch trình Tết 2026',
            style: AppTextStyles.headlineSmall.copyWith(
              color: context.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: vm.toggleView,
          child: Container(
            margin: const EdgeInsets.only(right: AppDimensions.spaceLG),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMD,
              vertical:   AppDimensions.spaceXS,
            ),
            decoration: BoxDecoration(
              // FIX: tint nền + màu text/icon theo theme
              color:        primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  vm.isAgendaView
                      ? Icons.calendar_month_outlined
                      : Icons.view_agenda_outlined,
                  size:  AppDimensions.iconSM,
                  color: primary,
                ),
                const SizedBox(width: AppDimensions.spaceXS),
                Text(
                  vm.isAgendaView ? 'Tháng' : 'Agenda',
                  style: AppTextStyles.labelMedium.copyWith(color: primary),
                ),
              ],
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: context.dividerColor),
      ),
    );
  }

  Widget _buildMonthView(CalendarViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        children: [
          CalendarWidget(
            viewModel: vm,
            onDaySelected: () => _showTaskSheet(vm),
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          const DayDotLegend(),
          const SizedBox(height: AppDimensions.space80),
        ],
      ),
    );
  }

  Widget _buildAgendaView(CalendarViewModel vm) {
    final entries = vm.agendaEntries;

    if (entries.isEmpty) {
      return Center(
        child: Text(
          '🎉 Không còn công việc nào sắp tới!',
          style: TextStyle(fontSize: 16, color: context.textPrimary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        return _AgendaGroup(
          date:  entry.key,
          tasks: entry.value,
          onTap: (task) => context.push(AppRoutes.taskDetailPath(task.id)),
        );
      },
    );
  }

  void _showTaskSheet(CalendarViewModel vm) {
    if (vm.selectedDay == null) return;

    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<CalendarViewModel>(
          builder: (_, innerVm, __) => TaskBottomSheet(
            selectedDay: innerVm.selectedDay!,
            tasks:       innerVm.selectedTasks,
            isLoading:   innerVm.isSheetLoading,
            onTaskTap: (task) {
              Navigator.pop(context);
              context.push(AppRoutes.taskDetailPath(task.id));
            },
          ),
        ),
      ),
    );
  }
}

// ── Agenda group ──────────────────────────────────────────────────
class _AgendaGroup extends StatelessWidget {
  final DateTime            date;
  final List<Task>          tasks;
  final void Function(Task) onTap;

  const _AgendaGroup({
    required this.date,
    required this.tasks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now     = DateTime.now();
    final isToday = date.year  == now.year  &&
        date.month == now.month &&
        date.day   == now.day;
    final primary = Theme.of(context).colorScheme.primary; // FIX

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceMD),
          child: Row(
            children: [
              // FIX: "hôm nay" box theo theme
              Container(
                width:  36,
                height: 36,
                decoration: BoxDecoration(
                  color: isToday ? primary : context.cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isToday ? AppColors.white : context.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _weekday(date.weekday),
                    style: AppTextStyles.titleSmall.copyWith(
                      // FIX: weekday màu theme khi là hôm nay
                      color: isToday ? primary : context.textPrimary,
                    ),
                  ),
                  Text(
                    'Tháng ${date.month}, ${date.year}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              if (isToday) ...[
                const SizedBox(width: AppDimensions.spaceSM),
                // FIX: "Hôm nay" pill theo theme
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSM,
                    vertical:   2,
                  ),
                  decoration: BoxDecoration(
                    color:        primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    'Hôm nay',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        ...tasks.map((task) => _AgendaTaskItem(
          task:  task,
          onTap: () => onTap(task),
        )),
        const SizedBox(height: AppDimensions.spaceSM),
      ],
    );
  }

  String _weekday(int day) {
    const days = [
      '', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư',
      'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật',
    ];
    return days[day];
  }
}

// ── Agenda task item ──────────────────────────────────────────────
class _AgendaTaskItem extends StatelessWidget {
  final Task         task;
  final VoidCallback onTap;

  const _AgendaTaskItem({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          left:   AppDimensions.space48,
          bottom: AppDimensions.spaceSM,
        ),
        padding: const EdgeInsets.all(AppDimensions.spaceMD),
        decoration: BoxDecoration(
          color:        context.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border(
            left: BorderSide(color: task.priority.color, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color:      context.isDark
                  ? Colors.black26
                  : AppColors.grey300.withValues(alpha: 0.25),
              blurRadius: 4,
              offset:     const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isCompleted
                          ? AppColors.grey400
                          : context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.roomType.label,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            PriorityBadge(priority: task.priority, compact: true),
          ],
        ),
      ),
    );
  }
}