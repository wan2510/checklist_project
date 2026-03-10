import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/enums/room_type.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/task.dart';
import '../../../routes/app_routes.dart';
import '../../shared/dialogs/add_task_bottom_sheet.dart';
import '../../shared/dialogs/confirm_dialog.dart';
import '../../shared/widgets/app_progress_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/fab_add_button.dart';
import '../../shared/widgets/loading_widget.dart';
import 'room_detail_viewmodel.dart';
import 'widgets/task_item_card.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomType            roomType;
  final RoomDetailViewModel viewModel;

  const RoomDetailScreen({
    super.key,
    required this.roomType,
    required this.viewModel,
  });

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  static const _tabs = [
    RoomDetailTab.all,
    RoomDetailTab.pending,
    RoomDetailTab.inProgress,
    RoomDetailTab.done,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      widget.viewModel.setTab(_tabs[_tabController.index]);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.init(widget.roomType);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<RoomDetailViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: context.bgColor,                  // ✅
            body:            _buildBody(vm),
            floatingActionButton: FabAddButton(
              onPressed: () => AddTaskBottomSheet.show(
                context,
                onTaskAdded: vm.refresh,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(RoomDetailViewModel vm) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        _buildSliverAppBar(vm),
      ],
      body: vm.isLoading
          ? const LoadingWidget(message: 'Đang tải công việc...')
          : _buildTaskList(vm),
    );
  }

  Widget _buildSliverAppBar(RoomDetailViewModel vm) {
    return SliverAppBar(
      pinned:          true,
      backgroundColor: context.surfaceColor,                   // ✅
      elevation:       0,
      expandedHeight:  90,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size:  AppDimensions.iconMD,
          color: context.textPrimary,                          // ✅
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        widget.roomType.label,
        style: AppTextStyles.headlineSmall.copyWith(
          color: context.textPrimary,                          // ✅
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: context.textPrimary,                        // ✅
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: context.surfaceColor,                         // ✅
          padding: EdgeInsets.only(
            top:    MediaQuery.of(context).padding.top + 56,
            left:   AppDimensions.screenPaddingH,
            right:  AppDimensions.screenPaddingH,
            bottom: AppDimensions.spaceMD,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TIẾN ĐỘ PHÒNG',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: context.textPrimary,              // ✅
                    ),
                  ),
                  Text(
                    '${vm.progressPercent}% hoàn tất',
                    style: AppTextStyles.progressPercent,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSM),
              AppProgressBar(
                value:  vm.progressPercent / 100,
                height: 8,
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,                       // ✅
            border: Border(
              bottom: BorderSide(color: context.dividerColor), // ✅
            ),
          ),
          child: Consumer<RoomDetailViewModel>(
            builder: (_, vm, __) => TabBar(
              controller:           _tabController,
              labelColor:           AppColors.primary,
              unselectedLabelColor: AppColors.grey500,
              indicatorColor:       AppColors.primary,
              indicatorWeight:      2.5,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              labelStyle: AppTextStyles.titleSmall.copyWith(fontSize: 11),
              tabs: _tabs.map((tab) {
                final count = vm.tabCount(tab);
                return Tab(
                  child: Row(
                    mainAxisSize:      MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _tabLabel(tab),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ),
                      if (count > 0) ...[
                        const SizedBox(width: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical:   1,
                          ),
                          decoration: BoxDecoration(
                            color:        AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize:   9,
                              fontWeight: FontWeight.w700,
                              color:      AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(RoomDetailViewModel vm) {
    if (vm.filteredTasks.isEmpty) {
      return EmptyStateWidget.noTasks(
        onAdd: () => AddTaskBottomSheet.show(
          context,
          onTaskAdded: vm.refresh,
        ),
      );
    }

    return RefreshIndicator(
      color:     AppColors.primary,
      onRefresh: vm.refresh,
      child: ListView.builder(
        padding:   const EdgeInsets.all(AppDimensions.screenPaddingH),
        itemCount: vm.filteredTasks.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) return _buildListHeader(vm);
          final task = vm.filteredTasks[index - 1];
          return TaskItemCard(
            task:     task,
            onToggle: () => vm.toggleComplete(task),
            onEdit:   () => _navigateToDetail(task),
            onDelete: () => _confirmDelete(vm, task),
            onTap:    () => _navigateToDetail(task),
          );
        },
      ),
    );
  }

  Widget _buildListHeader(RoomDetailViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'DANH SÁCH (${vm.filteredTasks.length})',
              style: AppTextStyles.titleSmall.copyWith(
                color: context.textPrimary,                    // ✅
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSM),
          GestureDetector(
            onTap: vm.refresh,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.refresh_rounded,
                  size:  AppDimensions.iconSM,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Cập nhật',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _tabLabel(RoomDetailTab tab) {
    switch (tab) {
      case RoomDetailTab.all:        return 'Tất cả';
      case RoomDetailTab.pending:    return 'Chưa làm';
      case RoomDetailTab.inProgress: return 'Đang làm';
      case RoomDetailTab.done:       return 'Xong';
    }
  }

  void _navigateToDetail(Task task) {
    context.push(AppRoutes.taskDetailPath(task.id));
  }

  Future<void> _confirmDelete(RoomDetailViewModel vm, Task task) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:        'Xóa công việc?',
      content:      'Bạn có chắc muốn xóa "${task.title}" không? '
          'Hành động này không thể hoàn lại.',
      confirmLabel: 'Xóa',
      isDangerous:  true,
    );
    if (confirmed) await vm.deleteTask(task);
  }
}