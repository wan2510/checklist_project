import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../shared/dialogs/add_task_bottom_sheet.dart';
import '../shared/widgets/app_progress_bar.dart';
import '../shared/widgets/fab_add_button.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/section_header.dart';
import 'home_viewmodel.dart';
import 'widgets/countdown_banner.dart';
import 'widgets/explore_grid.dart';
import 'widgets/quick_stats_row.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      child: Consumer<HomeViewModel>(
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

  Widget _buildBody(HomeViewModel vm) {
    if (vm.isLoading) {
      return const LoadingWidget(message: 'Đang tải dữ liệu...');
    }

    return RefreshIndicator(
      color:     AppColors.primary,
      onRefresh: vm.refresh,
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                const SizedBox(height: AppDimensions.spaceLG),

                CountdownBanner(daysLeft: vm.daysUntilTet),
                const SizedBox(height: AppDimensions.spaceXXL),

                _buildOverallProgress(vm),
                const SizedBox(height: AppDimensions.spaceXXL),

                SectionHeader(
                  title:       AppStrings.quickStats,
                  actionLabel: AppStrings.viewAll,
                  onAction:    () => context.go(AppRoutes.allTasks),
                ),
                const SizedBox(height: AppDimensions.spaceLG),
                QuickStatsRow(
                  todayCount:        vm.todayCount,
                  highPriorityCount: vm.highPriorityCount,
                  overdueCount:      vm.overdueCount,
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                SectionHeader(title: AppStrings.explore),
                const SizedBox(height: AppDimensions.spaceLG),
                ExploreGrid(
                  onRoomList: () => context.go(AppRoutes.roomList),
                  onAllTasks: () => context.go(AppRoutes.allTasks),
                  onCalendar: () => context.go(AppRoutes.calendar),
                  onReport:   () => context.go(AppRoutes.report),
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                _buildQuoteCard(),

                const SizedBox(height: AppDimensions.space80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── SliverAppBar ──────────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating:        true,
      snap:            true,
      backgroundColor: context.bgColor,                        // ✅
      elevation:       0,
      expandedHeight:  0,
      titleSpacing:    AppDimensions.screenPaddingH,
      title: Row(
        children: [
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              gradient:     AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: const Icon(
              Icons.cleaning_services_rounded,
              color: AppColors.white,
              size:  20,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Text(
            AppStrings.homeTitle,
            style: AppTextStyles.headlineMedium.copyWith(
              color: context.textPrimary,                      // ✅
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: context.textPrimary,                        // ✅
          ),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }

  // ── Overall progress card ─────────────────────────────────────
  Widget _buildOverallProgress(HomeViewModel vm) {
    final percent = vm.stats.completionPercent;
    final done    = vm.stats.completedTasks;
    final total   = vm.stats.totalTasks;
    final overdue = vm.overdueCount;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,                       // ✅
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      context.isDark
                ? Colors.black26
                : AppColors.grey300.withValues(alpha: 0.4),   // ✅
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.overallProgress,
                style: AppTextStyles.titleSmall.copyWith(
                  color: context.textPrimary,                  // ✅
                ),
              ),
              Text(
                '$percent%',
                style: AppTextStyles.progressPercent.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          AppProgressBar(
            value:  percent / 100,
            height: 10,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          Row(
            children: [
              Flexible(
                child: Text(
                  '$done / $total ${AppStrings.taskDone}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              if (overdue > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size:  14,
                      color: AppColors.statusOverdue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$overdue quá hạn',
                      style: AppTextStyles.bodySmall.copyWith(
                        color:      AppColors.statusOverdue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quote card ────────────────────────────────────────────────
  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,                       // ✅
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border:       Border.all(color: context.dividerColor), // ✅
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💬', style: TextStyle(fontSize: 20)),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Text(
              AppStrings.homeQuote,
              style: AppTextStyles.bodySmall.copyWith(
                color:     AppColors.grey500,
                height:    1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}