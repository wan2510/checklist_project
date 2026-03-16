import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../shared/dialogs/add_task_bottom_sheet.dart';
import '../../shared/widgets/app_progress_bar.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/fab_add_button.dart';
import '../../shared/widgets/loading_widget.dart';
import '../room_list_viewmodel.dart';
import 'widgets/room_card.dart';

class RoomListScreen extends StatefulWidget {
  final RoomListViewModel viewModel;

  const RoomListScreen({super.key, required this.viewModel});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
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
      child: Consumer<RoomListViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor:          context.bgColor,
            resizeToAvoidBottomInset: false,
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

  Widget _buildBody(RoomListViewModel vm) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [_buildSliverAppBar(vm)],
      body: vm.isLoading
          ? const LoadingWidget(message: 'Đang tải danh sách phòng...')
          : _buildContent(vm),
    );
  }

  Widget _buildSliverAppBar(RoomListViewModel vm) {
    return SliverAppBar(
      pinned:          true,
      backgroundColor: context.surfaceColor,
      elevation:       0,
      expandedHeight:  0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size:  AppDimensions.iconMD,
          color: context.textPrimary,
        ),
        onPressed: () => context.go(AppRoutes.home),
      ),
      title: Text(
        'Danh sách theo phòng',
        style: AppTextStyles.headlineSmall.copyWith(color: context.textPrimary),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: context.textPrimary),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: context.textPrimary),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: context.dividerColor),
      ),
    );
  }

  Widget _buildContent(RoomListViewModel vm) {
    return RefreshIndicator(
      color:     Theme.of(context).colorScheme.primary, // FIX
      onRefresh: vm.refresh,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchBar(vm),
                const SizedBox(height: AppDimensions.spaceLG),
                _buildZoneHeader(vm),
                const SizedBox(height: AppDimensions.spaceLG),

                if (vm.filteredRooms.isEmpty)
                  EmptyStateWidget.noResults()
                else
                  ...vm.filteredRooms.map((room) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spaceMD),
                    child: RoomCard(
                      room:  room,
                      onTap: () => context.push(
                        AppRoutes.roomDetailPath(room.type.name),
                      ),
                    ),
                  )),

                const SizedBox(height: AppDimensions.spaceLG),
                _buildOverallSummary(vm),
                const SizedBox(height: AppDimensions.space80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(RoomListViewModel vm) {
    return TextField(
      controller: _searchController,
      onChanged:  vm.onSearch,
      style: AppTextStyles.bodyMedium.copyWith(color: context.textPrimary),
      decoration: InputDecoration(
        hintText:   AppStrings.hintSearchRoom,
        filled:     true,
        fillColor:  context.cardColor,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey400),
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

  Widget _buildZoneHeader(RoomListViewModel vm) {
    final primary = Theme.of(context).colorScheme.primary; // FIX

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.roomsZone,
              style: AppTextStyles.titleLarge.copyWith(color: context.textPrimary),
            ),
            Text(
              AppStrings.roomsUntilTet,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        // FIX: badge "N Phòng" theo theme
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical:   AppDimensions.spaceXS,
          ),
          decoration: BoxDecoration(
            color:        primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text(
            '${vm.filteredRooms.length} Phòng',
            style: AppTextStyles.badgeText.copyWith(color: primary),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallSummary(RoomListViewModel vm) {
    final percent = vm.totalTasks == 0
        ? 0
        : ((vm.completedTasks / vm.totalTasks) * 100).round();

    // FIX: gradient tóm tắt theo theme
    final primary      = Theme.of(context).colorScheme.primary;
    final primaryDark  = Color.lerp(primary, Colors.black, 0.15)!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryDark],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.white,
                size:  AppDimensions.iconMD,
              ),
              const SizedBox(width: AppDimensions.spaceSM),
              Text(
                AppStrings.overallSummary,
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            'Bạn đã hoàn thành $percent% công việc. '
                'Hãy ưu tiên các khu vực có badge đỏ nhé!',
            style: AppTextStyles.bodySmall.copyWith(
              color:  AppColors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          AppProgressBar(
            value:           percent / 100,
            height:          6,
            fillColor:       AppColors.white,
            backgroundColor: AppColors.white.withValues(alpha: 0.3),
            animated:        false,
          ),
        ],
      ),
    );
  }
}