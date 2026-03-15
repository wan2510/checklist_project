import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../shared/widgets/app_progress_bar.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/section_header.dart';
import 'report_viewmodel.dart';
import 'widgets/bar_chart_widget.dart';
import 'widgets/donut_chart_widget.dart';
import 'widgets/milestone_card.dart';
import 'widgets/stats_grid.dart';

class ReportScreen extends StatefulWidget {
  final ReportViewModel viewModel;

  const ReportScreen({super.key, required this.viewModel});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
      child: Consumer<ReportViewModel>(
        builder: (_, vm, __) => Scaffold(
          backgroundColor: context.bgColor,
          body:            _buildBody(vm),
        ),
      ),
    );
  }

  Widget _buildBody(ReportViewModel vm) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [_buildAppBar()],
      body: vm.isLoading
          ? const LoadingWidget(message: 'Đang tải báo cáo...')
          : _buildContent(vm),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating:        true,
      snap:            true,
      backgroundColor: context.surfaceColor,
      elevation:       0,
      titleSpacing:    AppDimensions.screenPaddingH,
      title: Text(
        'Báo cáo tiến độ',
        style: AppTextStyles.headlineSmall.copyWith(color: context.textPrimary),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh_rounded, color: context.textPrimary),
          onPressed: () => widget.viewModel.refresh(),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: context.dividerColor),
      ),
    );
  }

  Widget _buildContent(ReportViewModel vm) {
    final primary = Theme.of(context).colorScheme.primary; // FIX

    return RefreshIndicator(
      color:     primary, // FIX
      onRefresh: vm.refresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spaceSM),

            MilestoneCard(
              motivationMessage: vm.motivationMsg,
              completionPercent: vm.completionPct,
            ),
            const SizedBox(height: AppDimensions.spaceXXL),

            StatsGrid(
              totalTasks:      vm.totalTasks,
              completedTasks:  vm.completedTasks,
              inProgressTasks: vm.inProgressTasks,
              overdueTasks:    vm.overdueTasks,
            ),
            const SizedBox(height: AppDimensions.spaceLG),

            _buildAvgTimeCard(vm, primary),
            const SizedBox(height: AppDimensions.spaceXXL),

            SectionHeader(title: 'Trạng thái hoàn thành'),
            Text(
              'Tỉ lệ công việc đã thực hiện',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildChartCard(
              child: DonutChartWidget(
                completedTasks:    vm.completedTasks,
                inProgressTasks:   vm.inProgressTasks,
                pendingTasks:      vm.totalTasks - vm.completedTasks - vm.inProgressTasks,
                completionPercent: vm.completionPct,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXXL),

            SectionHeader(title: 'Hiệu suất theo tuần'),
            Text(
              'Số việc hoàn thành 7 ngày qua',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildChartCard(child: BarChartWidget(weeklyData: vm.weeklyData)),
            const SizedBox(height: AppDimensions.spaceXXL),

            SectionHeader(title: 'Phân bổ theo phòng'),
            Text(
              'Khối lượng công việc mỗi khu vực',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: AppDimensions.spaceLG),
            _buildRoomDistribution(vm),
            const SizedBox(height: AppDimensions.spaceXXL),

            UpcomingMilestones(roomStats: vm.stats.roomStats),
            const SizedBox(height: AppDimensions.space80),
          ],
        ),
      ),
    );
  }

  Widget _buildAvgTimeCard(ReportViewModel vm, Color primary) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color:      context.isDark ? Colors.black26 : AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // FIX: icon tint theo theme
          Container(
            width:  48,
            height: 48,
            decoration: BoxDecoration(
              color:        primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Icon(
              Icons.trending_up_rounded,
              color: primary,
              size:  AppDimensions.iconLG,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceLG),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${vm.avgMinutes.toInt()} phút / việc',
                style: AppTextStyles.headlineSmall.copyWith(color: context.textPrimary),
              ),
              Text(
                'Thời gian trung bình hoàn thành',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          // FIX: "HIỆU SUẤT" label theo theme
          Text(
            'HIỆU SUẤT',
            style: AppTextStyles.labelSmall.copyWith(
              color:         primary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      context.isDark ? Colors.black26 : AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRoomDistribution(ReportViewModel vm) {
    final rooms = vm.stats.roomStats.where((r) => r.totalTasks > 0).toList();
    if (rooms.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      context.isDark ? Colors.black26 : AppColors.grey300.withValues(alpha: 0.3),
            blurRadius: 8,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: rooms.asMap().entries.map((entry) {
          final index = entry.key;
          final room  = entry.value;
          final color = AppColors.chartColors[index % AppColors.chartColors.length];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
            child: Row(
              children: [
                Text(room.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppDimensions.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            room.name,
                            style: AppTextStyles.titleSmall.copyWith(color: context.textPrimary),
                          ),
                          Text(
                            '${room.completedTasks}/${room.totalTasks}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXS),
                      AppProgressBar(value: room.progressPercent, height: 6, fillColor: color),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${room.progressInt}%',
                    style: AppTextStyles.labelMedium.copyWith(color: color),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}