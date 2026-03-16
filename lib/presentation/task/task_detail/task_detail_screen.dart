import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/enums/priority_level.dart';
import '../../../core/enums/room_type.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../shared/dialogs/confirm_dialog.dart';
import '../../shared/widgets/loading_widget.dart';
import 'task_detail_viewmodel.dart';
import 'widgets/priority_selector.dart';
import 'widgets/progress_slider.dart';

/// GIẢI PHÁP TIẾNG VIỆT:
/// Màn hình này KHÔNG dùng ChangeNotifierProvider / Consumer / Selector.
/// Tất cả giá trị được copy vào local state khi init.
/// setState() chỉ gọi khi user thay đổi room/priority/deadline/slider/reminder
/// — các thứ KHÔNG phải TextField → IME không bị ngắt.
/// TextField chỉ dùng controller thuần, không liên kết gì với VM khi đang gõ.
/// Khi save/back → mới đọc controller.text và ghi vào VM một lần duy nhất.
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
  // ── Text controllers (không bao giờ rebuild) ──────────────────
  final _titleController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController        = TextEditingController();

  // FIX TIẾNG VIỆT: FocusNode tường minh → survive setState rebuild
  final _titleFocus       = FocusNode();
  final _descriptionFocus = FocusNode();
  final _noteFocus        = FocusNode();

  // ── Local state — thay đổi bằng setState() bình thường ───────
  // setState() KHÔNG ảnh hưởng TextField vì chúng không đọc state này
  RoomType      _roomType          = RoomType.livingRoom;
  PriorityLevel _priority          = PriorityLevel.medium;
  DateTime      _deadline          = DateTime.now()
      .add(const Duration(days: 1));
  int           _progressPercent   = 0;
  bool          _isReminderEnabled = false;
  DateTime?     _reminderTime;
  bool          _isLoading         = false;
  bool          _isEditMode        = false;
  String?       _error;

  TaskDetailViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.taskId != null) {
        final repo = sl<TaskRepository>();
        final task = await repo.getTaskById(widget.taskId!);
        if (task != null && mounted) {
          _vm.initWithTask(task);
          setState(() {
            _titleController.text       = task.title;
            _descriptionController.text = task.description;
            _noteController.text        = task.note;
            _roomType          = task.roomType;
            _priority          = task.priority;
            _deadline          = task.deadline;
            _progressPercent   = task.progressPercent;
            _isReminderEnabled = task.isReminderEnabled;
            _reminderTime      = task.reminderTime;
            _isEditMode        = true;
          });
        }
      } else {
        _vm.initNew();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  // Ghi local state → VM, gọi trước save/back
  void _syncToVM() {
    _vm.setTitle(_titleController.text);
    _vm.setDescription(_descriptionController.text);
    _vm.setNote(_noteController.text);
    _vm.setRoomType(_roomType);
    _vm.setPriority(_priority);
    _vm.setDeadline(_deadline);
    _vm.setProgress(_progressPercent);
    _vm.setReminderEnabled(_isReminderEnabled);
    if (_reminderTime != null) _vm.setReminderTime(_reminderTime!);
  }

  @override
  Widget build(BuildContext context) {
    // KHÔNG có ChangeNotifierProvider / Consumer / Selector
    // → không có gì rebuild màn hình khi VM thay đổi
    return Scaffold(
      backgroundColor:          context.bgColor,
      resizeToAvoidBottomInset: false, // FIX: tắt resize → Scaffold không rebuild khi keyboard thay đổi chiều cao
      appBar: _buildAppBar(),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child:     _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final primary = Theme.of(context).colorScheme.primary;
    return AppBar(
      backgroundColor: context.surfaceColor,
      elevation:       0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: context.textPrimary),
        onPressed: _onBack,
      ),
      title: Text(
        'Chi tiết công việc',
        style: AppTextStyles.headlineSmall.copyWith(
            color: context.textPrimary),
      ),
      actions: [
        if (_isEditMode)
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.statusOverdue),
            onPressed: _onDelete,
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: context.dividerColor),
      ),
    );
  }

  Widget _buildBody() {
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.spaceSM),

          _label(AppStrings.taskTitle),
          const SizedBox(height: AppDimensions.spaceSM),
          // TextField KHÔNG có onChanged, KHÔNG liên kết Provider
          TextField(
            controller:         _titleController,
            focusNode:          _titleFocus,
            autocorrect:        false,
            enableSuggestions:  false,
            textCapitalization: TextCapitalization.none,
            style: AppTextStyles.bodyLarge.copyWith(
                color: context.textPrimary),
            decoration: InputDecoration(
              hintText:  AppStrings.hintTaskName,
              filled:    true,
              fillColor: context.cardColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _label(AppStrings.taskDescription),
          const SizedBox(height: AppDimensions.spaceSM),
          TextField(
            controller:        _descriptionController,
            focusNode:         _descriptionFocus,
            autocorrect:       false,
            enableSuggestions: false,
            maxLines:          3,
            style: AppTextStyles.bodyMedium.copyWith(
                color: context.textPrimary),
            decoration: InputDecoration(
              hintText:  AppStrings.hintDescription,
              filled:    true,
              fillColor: context.cardColor,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          // Room + Priority — dùng local setState, không ảnh hưởng TextField
          Row(
            children: [
              Expanded(child: _buildRoomDropdown()),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(child: _buildPriorityDropdown()),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _buildDeadlineRow(primary),
          const SizedBox(height: AppDimensions.spaceLG),
          _buildReminderRow(primary),
          const SizedBox(height: AppDimensions.spaceXXL),

          _label(AppStrings.taskPriority),
          const SizedBox(height: AppDimensions.spaceSM),
          PrioritySelector(
            selected:  _priority,
            onChanged: (p) => setState(() => _priority = p),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _label(AppStrings.taskProgress),
          const SizedBox(height: AppDimensions.spaceSM),
          ProgressSlider(
            value:     _progressPercent,
            onChanged: (v) => setState(() => _progressPercent = v),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          _label(AppStrings.taskNote),
          const SizedBox(height: AppDimensions.spaceSM),
          TextField(
            controller:        _noteController,
            focusNode:         _noteFocus,
            autocorrect:       false,
            enableSuggestions: false,
            maxLines:          3,
            style: AppTextStyles.bodyMedium.copyWith(
                color: context.textPrimary),
            decoration: InputDecoration(
              hintText:  AppStrings.hintNote,
              filled:    true,
              fillColor: context.cardColor,
            ),
          ),
          const SizedBox(height: AppDimensions.space40),

          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceLG),
              child: Text(_error!,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.statusOverdue)),
            ),

          _buildBottomButtons(primary),
          const SizedBox(height: AppDimensions.space40),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: AppTextStyles.titleSmall);

  Widget _buildRoomDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(AppStrings.taskRoom),
        const SizedBox(height: AppDimensions.spaceSM),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMD,
              vertical:   AppDimensions.spaceXS),
          decoration: BoxDecoration(
            color:        context.cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoomType>(
              value:         _roomType,
              isExpanded:    true,
              dropdownColor: context.cardColor,
              style: AppTextStyles.bodyMedium.copyWith(
                  color: context.textPrimary),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  size: AppDimensions.iconMD,
                  color: context.textPrimary),
              items: RoomType.values.map((r) => DropdownMenuItem(
                value: r,
                child: Row(children: [
                  Text(r.iconPath, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: AppDimensions.spaceXS),
                  Expanded(child: Text(r.label,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: context.textPrimary),
                      overflow: TextOverflow.ellipsis)),
                ]),
              )).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _roomType = v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(AppStrings.taskPriority),
        const SizedBox(height: AppDimensions.spaceSM),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMD,
              vertical:   AppDimensions.spaceXS),
          decoration: BoxDecoration(
            color:        _priority.backgroundColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(
                color: _priority.color.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PriorityLevel>(
              value:         _priority,
              isExpanded:    true,
              dropdownColor: context.cardColor,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  size: AppDimensions.iconMD, color: _priority.color),
              items: PriorityLevel.values.map((p) => DropdownMenuItem(
                value: p,
                child: Text(p.label,
                    style: AppTextStyles.bodySmall.copyWith(
                        color: p.color, fontWeight: FontWeight.w600)),
              )).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _priority = v);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineRow(Color primary) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context:     context,
          initialDate: _deadline,
          firstDate:   now.subtract(const Duration(days: 365)),
          lastDate:    DateTime(2027),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: ColorScheme.light(
                  primary: primary, onPrimary: AppColors.white),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _deadline = picked);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceLG),
        decoration: BoxDecoration(
          color:        context.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined,
              color: primary, size: AppDimensions.iconMD),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.taskDeadline,
                  style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey500)),
              Text(AppStrings.taskDeadlineHint,
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey400)),
            ],
          )),
          Text(
            '${_deadline.year}-'
                '${_deadline.month.toString().padLeft(2, '0')}-'
                '${_deadline.day.toString().padLeft(2, '0')}',
            style: AppTextStyles.titleMedium.copyWith(color: primary),
          ),
        ]),
      ),
    );
  }

  Widget _buildReminderRow(Color primary) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Row(children: [
        Icon(Icons.alarm_outlined, color: primary,
            size: AppDimensions.iconMD),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.taskReminder,
                style: AppTextStyles.titleMedium.copyWith(
                    color: context.textPrimary)),
            Text(AppStrings.taskReminderHint,
                style: AppTextStyles.bodySmall),
            if (_isReminderEnabled && _reminderTime != null)
              Text(
                '${_reminderTime!.hour.toString().padLeft(2,'0')}:'
                    '${_reminderTime!.minute.toString().padLeft(2,'0')}',
                style: AppTextStyles.labelMedium.copyWith(color: primary),
              ),
          ],
        )),
        Switch(
          value:     _isReminderEnabled,
          onChanged: (v) => setState(() {
            _isReminderEnabled = v;
            if (v && _reminderTime == null) {
              _reminderTime = _deadline.subtract(
                  const Duration(hours: 1));
            }
          }),
        ),
      ]),
    );
  }

  Widget _buildBottomButtons(Color primary) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _onBack,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: context.isDark
                      ? AppColors.grey600 : AppColors.grey300),
              padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceMD),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMD)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.close_rounded,
                    size: AppDimensions.iconSM,
                    color: AppColors.grey500),
                const SizedBox(width: AppDimensions.spaceXS),
                Text(AppStrings.actionCancel,
                    style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.grey500)),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceMD),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceMD),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMD)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded,
                    size: AppDimensions.iconSM),
                const SizedBox(width: AppDimensions.spaceXS),
                Text(AppStrings.actionSave),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    _syncToVM();
    setState(() { _isLoading = true; _error = null; });
    final success = await _vm.save();
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() { _isLoading = false; _error = _vm.error; });
    }
  }

  Future<void> _onBack() async {
    _syncToVM();
    if (_vm.hasChanges) {
      final confirmed = await ConfirmDialog.show(
        context,
        title:   'Hủy thay đổi?',
        content: 'Bạn có thay đổi chưa lưu. Bạn có muốn thoát không?',
      );
      if (!confirmed) return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _onDelete() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:        'Xóa công việc?',
      content:      'Hành động này không thể hoàn lại.',
      confirmLabel: 'Xóa',
      isDangerous:  true,
    );
    if (confirmed) {
      setState(() => _isLoading = true);
      final success = await _vm.delete();
      if (success && mounted) Navigator.of(context).pop(true);
    }
  }
}