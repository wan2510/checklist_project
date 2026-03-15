import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/enums/priority_level.dart';
import '../../../core/enums/room_type.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/task.dart';
import '../../../di/injection_container.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../shared/dialogs/confirm_dialog.dart';
import '../../shared/widgets/loading_widget.dart';
import 'task_detail_viewmodel.dart';
import 'widgets/priority_selector.dart';
import 'widgets/progress_slider.dart';

class TaskDetailScreen extends StatefulWidget {
  final String?             taskId;
  final TaskDetailViewModel viewModel;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.viewModel,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _titleController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController        = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.taskId != null) {
        final repo = sl<TaskRepository>();
        final task = await repo.getTaskById(widget.taskId!);
        if (task != null) {
          widget.viewModel.initWithTask(task);
          _titleController.text       = task.title;
          _descriptionController.text = task.description;
          _noteController.text        = task.note;
        }
      } else {
        widget.viewModel.initNew();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<TaskDetailViewModel>(
        builder: (_, vm, __) => LoadingOverlay(
          isLoading: vm.isLoading,
          child:     _buildScaffold(vm),
        ),
      ),
    );
  }

  Widget _buildScaffold(TaskDetailViewModel vm) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: _buildAppBar(vm),
      body:   _buildBody(vm),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(TaskDetailViewModel vm) {
    return AppBar(
      backgroundColor: context.surfaceColor,
      elevation:       0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: context.textPrimary,
        ),
        onPressed: () => _onBack(vm),
      ),
      title: Text(
        'Chi tiết công việc',
        style: AppTextStyles.headlineSmall.copyWith(
          color: context.textPrimary,
        ),
      ),
      actions: [
        if (vm.isEditMode)
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.statusOverdue,
            ),
            onPressed: () => _onDelete(vm),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: context.dividerColor),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────
  Widget _buildBody(TaskDetailViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spaceSM),

          _buildSectionLabel(AppStrings.taskTitle),
          const SizedBox(height: AppDimensions.spaceSM),
          TextField(
            controller:         _titleController,
            onChanged:          vm.setTitle,
            textCapitalization: TextCapitalization.sentences,
            style: AppTextStyles.bodyLarge.copyWith(
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:  AppStrings.hintTaskName,
              filled:    true,
              fillColor: context.cardColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _buildSectionLabel(AppStrings.taskDescription),
          const SizedBox(height: AppDimensions.spaceSM),
          TextField(
            controller: _descriptionController,
            onChanged:  vm.setDescription,
            maxLines:   3,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:  AppStrings.hintDescription,
              filled:    true,
              fillColor: context.cardColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          Row(
            children: [
              Expanded(child: _buildRoomDropdown(vm)),
              const SizedBox(width: AppDimensions.spaceMD),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _buildDeadlineRow(vm),
          const SizedBox(height: AppDimensions.spaceLG),

          _buildReminderRow(vm),
          const SizedBox(height: AppDimensions.spaceXXL),

          _buildSectionLabel(AppStrings.taskPriority),
          const SizedBox(height: AppDimensions.spaceSM),
          PrioritySelector(
            selected:  vm.priority,
            onChanged: vm.setPriority,
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _buildSectionLabel(AppStrings.taskProgress),
          const SizedBox(height: AppDimensions.spaceSM),
          ProgressSlider(
            value:     vm.progressPercent,
            onChanged: vm.setProgress,
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _buildSectionLabel(AppStrings.taskNote),
          const SizedBox(height: AppDimensions.spaceSM),
          TextField(
            controller: _noteController,
            onChanged:  vm.setNote,
            maxLines:   3,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:  AppStrings.hintNote,
              filled:    true,
              fillColor: context.cardColor,
            ),
          ),
          const SizedBox(height: AppDimensions.space40),

          if (vm.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceLG),
              child: Text(
                vm.error!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.statusOverdue,
                ),
              ),
            ),

          _buildBottomButtons(vm),
          const SizedBox(height: AppDimensions.space40),
        ],
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.titleSmall.copyWith(
        color: AppColors.grey500,
      ),
    );
  }

  // ── Room dropdown ─────────────────────────────────────────────
  Widget _buildRoomDropdown(TaskDetailViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(AppStrings.taskRoom),
        const SizedBox(height: AppDimensions.spaceSM),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical:   AppDimensions.spaceXS,
          ),
          decoration: BoxDecoration(
            color:        context.cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoomType>(
              value:      vm.roomType,
              isExpanded: true,
              dropdownColor: context.cardColor,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.textPrimary,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size:  AppDimensions.iconMD,
                color: context.textPrimary,
              ),
              items: RoomType.values.map((r) => DropdownMenuItem(
                value: r,
                child: Row(
                  children: [
                    Text(r.iconPath,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: AppDimensions.spaceXS),
                    Expanded(
                      child: Text(
                        r.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )).toList(),
              onChanged: (v) {
                if (v != null) vm.setRoomType(v);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Priority dropdown ─────────────────────────────────────────
  Widget _buildPriorityDropdown(TaskDetailViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(AppStrings.taskPriority),
        const SizedBox(height: AppDimensions.spaceSM),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMD,
            vertical:   AppDimensions.spaceXS,
          ),
          decoration: BoxDecoration(
            color:        vm.priority.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(
              color: vm.priority.color.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PriorityLevel>(
              value:         vm.priority,
              isExpanded:    true,
              dropdownColor: context.cardColor,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.textPrimary,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size:  AppDimensions.iconMD,
                color: vm.priority.color,
              ),
              items: PriorityLevel.values.map((p) => DropdownMenuItem(
                value: p,
                child: Text(
                  p.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color:      p.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )).toList(),
              onChanged: (v) {
                if (v != null) vm.setPriority(v);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Deadline row ──────────────────────────────────────────────
  Widget _buildDeadlineRow(TaskDetailViewModel vm) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now().toUtc().add(const Duration(hours: 7));
        final picked = await showDatePicker(
          context:     context,
          initialDate: vm.deadline,
          firstDate:   now.subtract(const Duration(days: 365)),
          lastDate:    DateTime(2027),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary:   AppColors.primary,
                onPrimary: AppColors.white,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) vm.setDeadline(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceLG),
        decoration: BoxDecoration(
          color:        context.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primary,
              size:  AppDimensions.iconMD,
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.taskDeadline,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  Text(
                    AppStrings.taskDeadlineHint,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${vm.deadline.year}-'
                  '${vm.deadline.month.toString().padLeft(2, '0')}-'
                  '${vm.deadline.day.toString().padLeft(2, '0')}',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Reminder row ──────────────────────────────────────────────
  Widget _buildReminderRow(TaskDetailViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.alarm_outlined,
            color: AppColors.primary,
            size:  AppDimensions.iconMD,
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.taskReminder,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  AppStrings.taskReminderHint,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                if (vm.isReminderEnabled && vm.reminderTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${vm.reminderTime!.hour.toString().padLeft(2, '0')}:'
                          '${vm.reminderTime!.minute.toString().padLeft(2, '0')} AM',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value:     vm.isReminderEnabled,
            onChanged: vm.setReminderEnabled,
          ),
        ],
      ),
    );
  }

  // ── Bottom buttons ────────────────────────────────────────────
  Widget _buildBottomButtons(TaskDetailViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _onBack(vm),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: context.isDark
                    ? AppColors.grey600
                    : AppColors.grey300,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.close_rounded,
                  size:  AppDimensions.iconSM,
                  color: AppColors.grey500,
                ),
                const SizedBox(width: AppDimensions.spaceXS),
                Text(
                  AppStrings.actionCancel,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMD),

        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: vm.isLoading ? null : () => _onSave(vm),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded, size: AppDimensions.iconSM),
                const SizedBox(width: AppDimensions.spaceXS),
                Text(AppStrings.actionSave),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Handlers ──────────────────────────────────────────────────
  Future<void> _onSave(TaskDetailViewModel vm) async {
    final success = await vm.save();
    if (success && mounted) Navigator.of(context).pop(true);
  }

  Future<void> _onBack(TaskDetailViewModel vm) async {
    if (vm.hasChanges) {
      final confirmed = await ConfirmDialog.show(
        context,
        title:   'Hủy thay đổi?',
        content: 'Bạn có thay đổi chưa lưu. Bạn có muốn thoát không?',
      );
      if (!confirmed) return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _onDelete(TaskDetailViewModel vm) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:        'Xóa công việc?',
      content:      'Hành động này không thể hoàn lại.',
      confirmLabel: 'Xóa',
      isDangerous:  true,
    );
    if (confirmed) {
      final success = await vm.delete();
      if (success && mounted) Navigator.of(context).pop(true);
    }
  }
}