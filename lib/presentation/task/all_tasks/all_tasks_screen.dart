import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/task.dart';
import '../../../routes/app_routes.dart';
import '../../shared/dialogs/add_task_bottom_sheet.dart';
import '../../shared/dialogs/confirm_dialog.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/fab_add_button.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../room/room_detail/widgets/task_item_card.dart';
import 'all_tasks_viewmodel.dart';
import 'widgets/filter_chip_row.dart';
import 'widgets/task_group_header.dart';

class AllTasksScreen extends StatefulWidget {
  final AllTasksViewModel viewModel;

  const AllTasksScreen({super.key, required this.viewModel});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<AllTasksViewModel>(
        builder: (_, vm, __) => Scaffold(
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

  Widget _buildBody(AllTasksViewModel vm) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [_buildSliverAppBar(vm)],
      body: vm.isLoading
          ? const LoadingWidget(message: 'Đang tải công việc...')
          : _buildContent(vm),
    );
  }

  // ── SliverAppBar ──────────────────────────────────────────────
  Widget _buildSliverAppBar(AllTasksViewModel vm) {
    return SliverAppBar(
      floating:        true,
      snap:            true,
      pinned:          false,
      backgroundColor: context.surfaceColor,
      elevation:       0,
      titleSpacing:    AppDimensions.screenPaddingH,
      title: Text(
        'Tất cả công việc',
        style: AppTextStyles.headlineSmall.copyWith(
          color: context.textPrimary,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.spaceLG),
          child: Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              gradient:     AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.white,
              size:  20,
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

  // ── Main content ──────────────────────────────────────────────
  Widget _buildContent(AllTasksViewModel vm) {
    return RefreshIndicator(
      color:     AppColors.primary,
      onRefresh: vm.refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPaddingH,
                AppDimensions.spaceLG,
                AppDimensions.screenPaddingH,
                AppDimensions.spaceSM,
              ),
              child: _buildSearchBar(vm),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceSM,
              ),
              child: FilterChipRow(
                activeFilter:    vm.activeFilter,
                onFilterChanged: vm.setFilter,
                overdueCount:    vm.overdueCount,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
                vertical:   AppDimensions.spaceSM,
              ),
              child: _buildSortRow(vm),
            ),
          ),

          if (vm.displayList.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget.noTasks(
                onAdd: () => AddTaskBottomSheet.show(
                  context,
                  onTaskAdded: vm.refresh,
                ),
              ),
            )
          else
            _buildGroupedList(vm),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.space80),
          ),
        ],
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────
  Widget _buildSearchBar(AllTasksViewModel vm) {
    return TextField(
      controller: _searchController,
      onChanged:  vm.onSearch,
      style: AppTextStyles.bodyMedium.copyWith(
        color: context.textPrimary,
      ),
      decoration: InputDecoration(
        hintText:  AppStrings.hintSearchTask,
        filled:    true,
        fillColor: context.cardColor,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.grey400,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon:      const Icon(Icons.clear_rounded),
          onPressed: () {
            _searchController.clear();
            vm.onSearch('');
          },
        )
            : null,
      ),
    );
  }

  // ── Sort row ──────────────────────────────────────────────────
  Widget _buildSortRow(AllTasksViewModel vm) {
    return Row(
      children: [
        Text(
          'Sắp xếp theo:',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSM),
        Expanded(
          child: GestureDetector(
            onTap: () => _showSortSheet(vm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMD,
                vertical:   AppDimensions.spaceXS,
              ),
              decoration: BoxDecoration(
                color:        context.cardColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                border:       Border.all(color: context.dividerColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vm.sortLabel(vm.sortOption),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceXS),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size:  AppDimensions.iconSM,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Grouped list ──────────────────────────────────────────────
  Widget _buildGroupedList(AllTasksViewModel vm) {
    final grouped = vm.groupedByDate;
    final keys    = grouped.keys.toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (_, index) {
            int cursor = 0;
            for (final key in keys) {
              final tasks = grouped[key]!;
              if (index == cursor) {
                return TaskGroupHeader(groupKey: key, count: tasks.length);
              }
              cursor++;
              for (final task in tasks) {
                if (index == cursor) {
                  return TaskItemCard(
                    task:     task,
                    onToggle: () => vm.toggleComplete(task),
                    onEdit:   () => _goToDetail(task),
                    onDelete: () => _confirmDelete(vm, task),
                    onTap:    () => _goToDetail(task),
                  );
                }
                cursor++;
              }
            }
            return null;
          },
          childCount: grouped.entries.fold(
            0, (sum, e) => sum! + 1 + e.value.length,
          ),
        ),
      ),
    );
  }

  // ── Sort bottom sheet ─────────────────────────────────────────
  void _showSortSheet(AllTasksViewModel vm) {
    showModalBottomSheet(
      context:         context,
      backgroundColor: Colors.transparent,
      builder:         (_) => _SortBottomSheet(
        current:  vm.sortOption,
        onSelect: (opt) {
          vm.setSort(opt);
          Navigator.pop(context);
        },
        labelOf: vm.sortLabel,
      ),
    );
  }

  void _goToDetail(Task task) {
    context.push(AppRoutes.taskDetailPath(task.id));
  }

  Future<void> _confirmDelete(AllTasksViewModel vm, Task task) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:        'Xóa công việc?',
      content:      'Bạn có chắc muốn xóa "${task.title}"? '
          'Hành động này không thể hoàn lại.',
      confirmLabel: 'Xóa',
      isDangerous:  true,
    );
    if (confirmed) await vm.deleteTask(task);
  }
}

// ── Sort bottom sheet widget ──────────────────────────────────────
class _SortBottomSheet extends StatelessWidget {
  final TaskSortOption                  current;
  final ValueChanged<TaskSortOption>    onSelect;
  final String Function(TaskSortOption) labelOf;

  const _SortBottomSheet({
    required this.current,
    required this.onSelect,
    required this.labelOf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ─────────────────────────────────────────
          Center(
            child: Container(
              width:  40,
              height: 4,
              decoration: BoxDecoration(
                color: context.isDark
                    ? AppColors.grey600
                    : AppColors.grey300,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          Text(
            'Sắp xếp theo',
            style: AppTextStyles.headlineSmall.copyWith(
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),
          ...TaskSortOption.values.map((opt) {
            final isSelected = current == opt;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width:  40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : context.cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Icon(
                  _sortIcon(opt),
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey500,
                  size: AppDimensions.iconMD,
                ),
              ),
              title: Text(
                labelOf(opt),
                style: AppTextStyles.titleMedium.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : context.textPrimary,
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
              )
                  : null,
              onTap: () => onSelect(opt),
            );
          }),
          const SizedBox(height: AppDimensions.spaceLG),
        ],
      ),
    );
  }

  IconData _sortIcon(TaskSortOption opt) {
    switch (opt) {
      case TaskSortOption.deadline: return Icons.calendar_today_outlined;
      case TaskSortOption.priority: return Icons.flag_outlined;
      case TaskSortOption.room:     return Icons.home_outlined;
      case TaskSortOption.progress: return Icons.percent_rounded;
    }
  }
}