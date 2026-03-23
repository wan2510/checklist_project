import 'package:flutter/material.dart';

import '../../../core/enums/priority_level.dart';
import '../../../core/enums/room_type.dart';
import '../../../core/enums/task_status.dart';
import '../../../data/local/preferences/app_preferences.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/task/add_task_usecase.dart';
import '../../../domain/usecases/task/delete_task_usecase.dart';
import '../../../domain/usecases/task/update_task_usecase.dart';
import '../../../core/utils/notification_utils.dart';

class TaskDetailViewModel extends ChangeNotifier {
  final AddTaskUseCase    _addTask;
  final UpdateTaskUseCase _updateTask;
  final DeleteTaskUseCase _deleteTask;
  final AppPreferences    _prefs;

  TaskDetailViewModel({
    required AddTaskUseCase    addTask,
    required UpdateTaskUseCase updateTask,
    required DeleteTaskUseCase deleteTask,
    required AppPreferences    prefs,
  })  : _addTask    = addTask,
        _updateTask = updateTask,
        _deleteTask = deleteTask,
        _prefs      = prefs;

  // ── State ─────────────────────────────────────────────────────
  Task?         _originalTask;
  bool          _isLoading   = false;
  bool          _isSaved     = false;
  String?       _error;

  // ── Form state ────────────────────────────────────────────────
  String        _title             = '';
  String        _description       = '';
  RoomType      _roomType          = RoomType.livingRoom;
  PriorityLevel _priority          = PriorityLevel.medium;
  DateTime      _deadline          = DateTime.now().add(const Duration(days: 1));
  int           _progressPercent   = 0;
  bool          _isReminderEnabled = false;
  DateTime?     _reminderTime;
  String        _note              = '';

  // ── Getters ───────────────────────────────────────────────────
  bool          get isLoading          => _isLoading;
  bool          get isSaved            => _isSaved;
  String?       get error              => _error;
  bool          get isEditMode         => _originalTask != null;
  String        get title              => _title;
  String        get description        => _description;
  RoomType      get roomType           => _roomType;
  PriorityLevel get priority           => _priority;
  DateTime      get deadline           => _deadline;
  int           get progressPercent    => _progressPercent;
  bool          get isReminderEnabled  => _isReminderEnabled;
  DateTime?     get reminderTime       => _reminderTime;
  String        get note               => _note;

  TaskStatus get derivedStatus =>
      TaskStatus.fromProgress(_progressPercent);

  bool get hasChanges {
    if (_originalTask == null) return _title.isNotEmpty;
    return _title         != _originalTask!.title         ||
        _description   != _originalTask!.description   ||
        _roomType      != _originalTask!.roomType      ||
        _priority      != _originalTask!.priority      ||
        _deadline      != _originalTask!.deadline      ||
        _progressPercent != _originalTask!.progressPercent ||
        _isReminderEnabled != _originalTask!.isReminderEnabled ||
        _note          != _originalTask!.note;
  }

  // ── Init ──────────────────────────────────────────────────────
  void initWithTask(Task task) {
    _originalTask      = task;
    _title             = task.title;
    _description       = task.description;
    _roomType          = task.roomType;
    _priority          = task.priority;
    _deadline          = task.deadline;
    _progressPercent   = task.progressPercent;
    _isReminderEnabled = task.isReminderEnabled;
    _reminderTime      = task.reminderTime;
    _note              = task.note;
    notifyListeners();
  }

  void initNew() {
    _originalTask    = null;
    _title           = '';
    _description     = '';
    _roomType        = RoomType.livingRoom;
    _priority        = PriorityLevel.medium;
    _deadline        = DateTime.now().add(const Duration(days: 1));
    _progressPercent   = 0;
    _isReminderEnabled = false;
    _reminderTime      = null;
    _note              = '';
    notifyListeners();
  }

  // ── Setters ───────────────────────────────────────────────────
  void setTitle(String v)       { _title = v;       notifyListeners(); }
  void setDescription(String v) { _description = v; notifyListeners(); }
  void setRoomType(RoomType v)  { _roomType = v;    notifyListeners(); }
  void setPriority(PriorityLevel v) { _priority = v; notifyListeners(); }
  void setDeadline(DateTime v)  { _deadline = v;    notifyListeners(); }
  void setNote(String v)        { _note = v;        notifyListeners(); }

  void setProgress(int v) {
    _progressPercent = v.clamp(0, 100);
    notifyListeners();
  }

  void setReminderEnabled(bool v) {
    _isReminderEnabled = v;
    if (v && _reminderTime == null) {
      // Default: deadline - 1 hour
      _reminderTime = _deadline.subtract(const Duration(hours: 1));
    }
    notifyListeners();
  }

  void setReminderTime(DateTime v) {
    _reminderTime = v;
    notifyListeners();
  }

  // ── Save ──────────────────────────────────────────────────────
  Future<bool> save() async {
    if (_title.trim().isEmpty) {
      _error = 'Tên công việc không được để trống';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      final now = DateTime.now();

      if (isEditMode) {
        final updated = _originalTask!.copyWith(
          title:             _title.trim(),
          description:       _description,
          roomType:          _roomType,
          priority:          _priority,
          status:            derivedStatus,
          progressPercent:   _progressPercent,
          deadline:          _deadline,
          isReminderEnabled: _isReminderEnabled,
          reminderTime:      _reminderTime,
          note:              _note,
          updatedAt:         now,
        );
        await _updateTask(updated);
      } else {
        final task = Task(
          id:                '',
          title:             _title.trim(),
          description:       _description,
          roomType:          _roomType,
          priority:          _priority,
          status:            derivedStatus,
          progressPercent:   _progressPercent,
          deadline:          _deadline,
          isReminderEnabled: _isReminderEnabled,
          reminderTime:      _reminderTime,
          note:              _note,
          createdAt:         now,
          updatedAt:         now,
        );
        await _addTask(task);
      }

      // ── Schedule / cancel notification ───────────────────
      // Dùng id cố định: nếu edit mode dùng id task, nếu thêm mới dùng title+deadline hash
      // Phải lấy id SAU KHI _addTask/_updateTask đã chạy (task đã có id)
      final notifId = (_originalTask?.id ?? _title + _deadline.toString())
          .hashCode.abs();

      if (_isReminderEnabled && _reminderTime != null) {
        final reminder = _reminderTime!;
        // Nếu reminderTime đã qua hôm nay, đặt lại vào ngày mai cùng giờ
        final effectiveReminder = reminder.isBefore(DateTime.now())
            ? reminder.add(const Duration(days: 1))
            : reminder;

        await NotificationUtils.scheduleTaskReminder(
          id:          notifId,
          taskName:    _title.trim(),
          reminderTime: effectiveReminder,
        );
      } else {
        await NotificationUtils.cancelReminder(notifId);
      }

      _isSaved = true;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Add task (từ bottom sheet) ────────────────────────────────
  Future<void> addTask(Task task) async {
    await _addTask(task);
  }

  // ── Delete ────────────────────────────────────────────────────
  Future<bool> delete() async {
    if (_originalTask == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final notifId = (_originalTask!.id + _deadline.toString())
          .hashCode.abs();
      await _deleteTask(_originalTask!.id);
      await NotificationUtils.cancelReminder(notifId);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}