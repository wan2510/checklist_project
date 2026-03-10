import 'package:flutter/material.dart';

import '../../../core/enums/room_type.dart';
import '../../../core/enums/task_status.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../domain/usecases/task/delete_task_usecase.dart';
import '../../../domain/usecases/task/get_tasks_by_room_usecase.dart';
import '../../../domain/usecases/task/toggle_task_complete_usecase.dart';

enum RoomDetailTab { all, pending, inProgress, done }

class RoomDetailViewModel extends ChangeNotifier {
  final GetTasksByRoomUseCase    _getTasksByRoom;
  final TaskRepository           _taskRepository;
  final ToggleTaskCompleteUseCase _toggleTaskComplete;
  final DeleteTaskUseCase         _deleteTask;

  RoomDetailViewModel({
    required GetTasksByRoomUseCase    getTasksByRoom,
    required TaskRepository           watchTasksByRoom,
    required ToggleTaskCompleteUseCase toggleTaskComplete,
    required DeleteTaskUseCase         deleteTask,
  })  : _getTasksByRoom    = getTasksByRoom,
        _taskRepository    = watchTasksByRoom,
        _toggleTaskComplete = toggleTaskComplete,
        _deleteTask         = deleteTask;

  // ── State ────────────────────────────────────────────────────
  List<Task>      _allTasks   = [];
  RoomDetailTab   _activeTab  = RoomDetailTab.all;
  RoomType?       _roomType;
  bool            _isLoading  = true;
  String?         _error;

  // ── Getters ──────────────────────────────────────────────────
  bool          get isLoading  => _isLoading;
  String?       get error      => _error;
  RoomDetailTab get activeTab  => _activeTab;
  RoomType?     get roomType   => _roomType;

  List<Task> get filteredTasks {
    switch (_activeTab) {
      case RoomDetailTab.all:
        return _allTasks;
      case RoomDetailTab.pending:
        return _allTasks
            .where((t) => t.status == TaskStatus.pending)
            .toList();
      case RoomDetailTab.inProgress:
        return _allTasks
            .where((t) => t.status == TaskStatus.inProgress)
            .toList();
      case RoomDetailTab.done:
        return _allTasks
            .where((t) => t.status == TaskStatus.done)
            .toList();
    }
  }

  int get totalTasks     => _allTasks.length;
  int get completedTasks => _allTasks.where((t) => t.isCompleted).length;
  int get progressPercent =>
      totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();

  int tabCount(RoomDetailTab tab) {
    switch (tab) {
      case RoomDetailTab.all:
        return _allTasks.length;
      case RoomDetailTab.pending:
        return _allTasks.where((t) => t.status == TaskStatus.pending).length;
      case RoomDetailTab.inProgress:
        return _allTasks.where((t) => t.status == TaskStatus.inProgress).length;
      case RoomDetailTab.done:
        return _allTasks.where((t) => t.status == TaskStatus.done).length;
    }
  }

  // ── Init ─────────────────────────────────────────────────────
  Future<void> init(RoomType roomType) async {
    _roomType  = roomType;
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      _allTasks = await _getTasksByRoom(roomType);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Tab ──────────────────────────────────────────────────────
  void setTab(RoomDetailTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  // ── Actions ──────────────────────────────────────────────────
  Future<void> toggleComplete(Task task) async {
    await _toggleTaskComplete(task);
    if (_roomType != null) await init(_roomType!);
  }

  Future<void> deleteTask(Task task) async {
    await _deleteTask(task.id);
    if (_roomType != null) await init(_roomType!);
  }

  Future<void> refresh() async {
    if (_roomType != null) await init(_roomType!);
  }
}