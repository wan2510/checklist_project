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
      // FIX: useSafeArea đảm bảo bottom sheet không bị ảnh hưởng
      // bởi system padding khi keyboard thay đổi chiều cao
      useSafeArea:        true,
      builder: (_) => AddTaskBottomSheet(onTaskAdded: onTaskAdded),
    );
  }

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  // ── TextField controller nằm trong outer widget ───────────────
  // KHÔNG bị ảnh hưởng bởi setState của _FormControls bên dưới
  final _titleController = TextEditingController();
  final _titleFocus      = FocusNode(); // FIX: explicit FocusNode
  bool  _isSaving        = false;

  final _formKey = GlobalKey<_FormControlsState>();

  late final TaskDetailViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = sl<TaskDetailViewModel>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  Future<void> _save({bool addMore = false}) async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);

    final form = _formKey.currentState!;
    final now  = DateTime.now();
    final task = Task(
      id:        '',
      title:     _titleController.text.trim(),
      roomType:  form.selectedRoom,
      priority:  form.selectedPriority,
      deadline:  form.deadline,
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
    final primary = Theme.of(context).colorScheme.primary;
    final isDark  = context.isDark;

    // KEY FIX: KHÔNG đọc MediaQuery.viewInsets.bottom trong build() này.
    // Việc đọc viewInsets ở đây sẽ gây rebuild mỗi khi bàn phím
    // tiếng Việt thay đổi chiều cao (hiện/ẩn suggestion bar)
    // → TextField mất IME context → mất dấu tiếng Việt.
    //
    // Thay vào đó, padding keyboard được xử lý bởi _KeyboardPadding
    // ở cuối Column — một widget tách biệt không ảnh hưởng TextField.

    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Nội dung chính — KHÔNG đọc MediaQuery ────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spaceLG,
              AppDimensions.spaceXXL,
              AppDimensions.spaceLG,
              AppDimensions.spaceLG,
            ),
            child: Column(
              mainAxisSize:       MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width:  40, height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.grey600 : AppColors.grey300,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXL),

                // Title
                Text(
                  'Thêm công việc nhanh',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLG),

                // ── TextField TÁCH BIỆT, không rebuild khi form thay đổi ──
                TextField(
                  controller:         _titleController,
                  focusNode:          _titleFocus,
                  autofocus:          true,
                  // FIX: tắt autocorrect/suggestions — quan trọng cho IME VN
                  autocorrect:        false,
                  enableSuggestions:  false,
                  textCapitalization: TextCapitalization.none,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: context.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText:  AppStrings.hintTaskName,
                    filled:    true,
                    fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
                    prefixIcon: Icon(Icons.edit_outlined,
                        color: isDark ? AppColors.grey500 : AppColors.grey400),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:   BorderSide(color: primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLG),

                // ── Form controls (room/priority/deadline) trong widget con ──
                // setState bên trong _FormControls KHÔNG ảnh hưởng TextField
                _FormControls(key: _formKey),
                const SizedBox(height: AppDimensions.spaceXXL),

                // ── Buttons ────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : () => _save(addMore: true),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.spaceMD),
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
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.spaceMD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                            : Text(AppStrings.actionAdd),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── FIX: Keyboard padding tách biệt ──────────────────
          // Chỉ widget này rebuild khi viewInsets thay đổi,
          // KHÔNG ảnh hưởng đến TextField bên trên.
          const _KeyboardPadding(),
        ],
      ),
    );
  }
}

// ── Widget chỉ đọc viewInsets — rebuild độc lập ──────────────────
class _KeyboardPadding extends StatelessWidget {
  const _KeyboardPadding();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).viewInsets.bottom);
  }
}

// ── Form controls (room, priority, deadline) ──────────────────────
// setState bên trong widget này KHÔNG rebuild TextField bên ngoài
class _FormControls extends StatefulWidget {
  const _FormControls({super.key});

  @override
  State<_FormControls> createState() => _FormControlsState();
}

class _FormControlsState extends State<_FormControls> {
  RoomType      selectedRoom     = RoomType.livingRoom;
  PriorityLevel selectedPriority = PriorityLevel.medium;
  DateTime      deadline         = DateTime.now().add(const Duration(days: 1));

  Future<void> _pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context:     context,
      initialDate: deadline,
      firstDate:   now,
      lastDate:    DateTime(2026, 12, 31),
    );
    if (picked != null) setState(() => deadline = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark   = context.isDark;
    final primary  = Theme.of(context).colorScheme.primary;
    final inputBg  = isDark ? AppColors.grey800 : AppColors.grey100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Phòng ──────────────────────────────────────────────
        Text('Phòng', style: AppTextStyles.titleSmall),
        const SizedBox(height: AppDimensions.spaceSM),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLG,
            vertical:   AppDimensions.spaceSM,
          ),
          decoration: BoxDecoration(
            color:        inputBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoomType>(
              value:         selectedRoom,
              isExpanded:    true,
              dropdownColor: isDark ? AppColors.grey800 : AppColors.white,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: isDark ? AppColors.grey400 : AppColors.grey600),
              style: AppTextStyles.bodyMedium.copyWith(
                  color: context.textPrimary),
              items: RoomType.values.map((room) => DropdownMenuItem(
                value: room,
                child: Row(children: [
                  Text(room.iconPath, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: AppDimensions.spaceSM),
                  Text(room.label, style: AppTextStyles.bodyMedium.copyWith(
                      color: context.textPrimary)),
                ]),
              )).toList(),
              onChanged: (v) {
                if (v != null) setState(() => selectedRoom = v);
              },
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLG),

        // ── Ưu tiên ────────────────────────────────────────────
        Text('Ưu tiên', style: AppTextStyles.titleSmall),
        const SizedBox(height: AppDimensions.spaceSM),
        Row(
          children: PriorityLevel.values.map((p) {
            final isSelected = selectedPriority == p;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedPriority = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:   const EdgeInsets.only(right: AppDimensions.spaceSM),
                  padding:  const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceSM),
                  decoration: BoxDecoration(
                    color: isSelected ? p.backgroundColor : inputBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                    border: isSelected
                        ? Border.all(color: p.color, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(p.label,
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
        ),
        const SizedBox(height: AppDimensions.spaceLG),

        // ── Hạn chót ───────────────────────────────────────────
        Text('Hạn chót', style: AppTextStyles.titleSmall),
        const SizedBox(height: AppDimensions.spaceSM),
        GestureDetector(
          onTap: () => _pickDeadline(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLG,
              vertical:   AppDimensions.spaceMD,
            ),
            decoration: BoxDecoration(
              color:        inputBg,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Row(children: [
              Icon(Icons.calendar_today_outlined,
                  size: AppDimensions.iconMD, color: primary),
              const SizedBox(width: AppDimensions.spaceMD),
              Text(
                '${deadline.day}/${deadline.month}/${deadline.year}',
                style: AppTextStyles.bodyMedium.copyWith(color: primary),
              ),
              const Spacer(),
              Icon(Icons.keyboard_arrow_right_rounded,
                  color: isDark ? AppColors.grey500 : AppColors.grey400),
            ]),
          ),
        ),
      ],
    );
  }
}