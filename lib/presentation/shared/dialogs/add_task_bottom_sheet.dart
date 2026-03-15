import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/enums/priority_level.dart';
import '../../../core/enums/room_type.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../di/injection_container.dart';
import '../../../domain/entities/task.dart';
import '../../task/task_detail/task_detail_viewmodel.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final VoidCallback? onTaskAdded;

  const AddTaskBottomSheet({super.key, this.onTaskAdded});

  static Future<void> show(
      BuildContext context, {
        VoidCallback? onTaskAdded,
      }) {
    return showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder: (_) => AddTaskBottomSheet(onTaskAdded: onTaskAdded),
    );
  }

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  RoomType      _selectedRoom     = RoomType.livingRoom;
  PriorityLevel _selectedPriority = PriorityLevel.medium;
  DateTime      _deadline = DateTime.now()
      .toUtc()
      .add(const Duration(hours: 7, days: 1));
  bool _isSaving = false;

  late final TaskDetailViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = sl<TaskDetailViewModel>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final picked = await showDatePicker(
      context:     context,
      initialDate: _deadline,
      firstDate:   now,
      lastDate:    DateTime(2026, 12, 31),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save({bool addMore = false}) async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);

    final now  = DateTime.now().toUtc().add(const Duration(hours: 7));
    final task = Task(
      id:        '',
      title:     _titleController.text.trim(),
      roomType:  _selectedRoom,
      priority:  _selectedPriority,
      deadline:  _deadline,
      createdAt: now,
      updatedAt: now,
    );

    await _vm.addTask(task);
    widget.onTaskAdded?.call();

    if (!mounted) return;
    if (addMore) {
      setState(() { _titleController.clear(); _isSaving = false; });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    final primary   = Theme.of(context).colorScheme.primary;
    final cardColor = context.cardColor;
    final isDark    = context.isDark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spaceLG,
        AppDimensions.spaceXXL,
        AppDimensions.spaceLG,
        AppDimensions.spaceLG + bottomPad,
      ),
      decoration: BoxDecoration(
        // FIX: dark mode background
        color: cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ────────────────────────────────────────────
          Center(
            child: Container(
              width:  40,
              height: 4,
              decoration: BoxDecoration(
                // FIX: handle màu tối hơn trong dark mode
                color:        isDark ? AppColors.grey600 : AppColors.grey300,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // ── Title ──────────────────────────────────────────────
          Text(
            'Thêm công việc nhanh',
            style: AppTextStyles.headlineSmall.copyWith(
              color: context.textPrimary, // FIX
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Task name input ────────────────────────────────────
          TextField(
            controller:         _titleController,
            autofocus:          true,
            textCapitalization: TextCapitalization.sentences,
            // FIX: text màu đúng
            style: AppTextStyles.bodyLarge.copyWith(
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:  AppStrings.hintTaskName,
              filled:    true,
              // FIX: input nền dark mode
              fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
              prefixIcon: Icon(
                Icons.edit_outlined,
                color: isDark ? AppColors.grey500 : AppColors.grey400,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Room ──────────────────────────────────────────────
          _buildLabel('Phòng'),
          const SizedBox(height: AppDimensions.spaceSM),
          _buildRoomSelector(isDark, primary),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Priority ──────────────────────────────────────────
          _buildLabel('Ưu tiên'),
          const SizedBox(height: AppDimensions.spaceSM),
          _buildPrioritySelector(isDark),
          const SizedBox(height: AppDimensions.spaceLG),

          // ── Deadline ──────────────────────────────────────────
          _buildLabel('Hạn chót'),
          const SizedBox(height: AppDimensions.spaceSM),
          _buildDeadlineRow(isDark, primary),
          const SizedBox(height: AppDimensions.spaceXXL),

          // ── Actions ───────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => _save(addMore: true),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primary), // FIX: theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceMD,
                    ),
                  ),
                  child: Text(
                    AppStrings.actionAddContinue,
                    style: AppTextStyles.titleMedium.copyWith(color: primary),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMD),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () => _save(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary, // FIX: theme
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceMD,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width:  20,
                    height: 20,
                    child:  CircularProgressIndicator(
                      color: AppColors.white, strokeWidth: 2,
                    ),
                  )
                      : Text(AppStrings.actionAdd),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
    text,
    style: AppTextStyles.titleSmall,
  );

  Widget _buildRoomSelector(bool isDark, Color primary) {
    final bgColor = isDark ? AppColors.grey800 : AppColors.grey100;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical:   AppDimensions.spaceSM,
      ),
      decoration: BoxDecoration(
        color:        bgColor, // FIX
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RoomType>(
          value:         _selectedRoom,
          isExpanded:    true,
          // FIX: dropdown background + text theo dark mode
          dropdownColor: isDark ? AppColors.grey800 : AppColors.white,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.textPrimary, // FIX
          ),
          items: RoomType.values.map((room) {
            return DropdownMenuItem(
              value: room,
              child: Row(
                children: [
                  Text(room.iconPath, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: AppDimensions.spaceSM),
                  Text(
                    room.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.textPrimary, // FIX
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedRoom = v);
          },
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(bool isDark) {
    final unselectedBg = isDark ? AppColors.grey800 : AppColors.grey100;

    return Row(
      children: PriorityLevel.values.map((p) {
        final isSelected = _selectedPriority == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin:   const EdgeInsets.only(right: AppDimensions.spaceSM),
              padding:  const EdgeInsets.symmetric(vertical: AppDimensions.spaceSM),
              decoration: BoxDecoration(
                color: isSelected ? p.backgroundColor : unselectedBg, // FIX
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                border: isSelected
                    ? Border.all(color: p.color, width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  p.label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color:      isSelected ? p.color : AppColors.grey500,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeadlineRow(bool isDark, Color primary) {
    return GestureDetector(
      onTap: _pickDeadline,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLG,
          vertical:   AppDimensions.spaceMD,
        ),
        decoration: BoxDecoration(
          color:        isDark ? AppColors.grey800 : AppColors.grey100, // FIX
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size:  AppDimensions.iconMD,
              color: primary, // FIX: theme
            ),
            const SizedBox(width: AppDimensions.spaceMD),
            Text(
              '${_deadline.day}/${_deadline.month}/${_deadline.year}',
              style: AppTextStyles.bodyMedium.copyWith(color: primary), // FIX
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: isDark ? AppColors.grey500 : AppColors.grey400, // FIX
            ),
          ],
        ),
      ),
    );
  }
}