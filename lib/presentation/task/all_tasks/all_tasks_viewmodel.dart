import 'package:flutter/material.dart';

import '../../../core/enums/priority_level.dart';
import '../../../core/enums/task_status.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/task/delete_task_usecase.dart';
import '../../../domain/usecases/task/get_all_tasks_usecase.dart';
import '../../../domain/usecases/task/get_overdue_tasks_usecase.dart';
import '../../../domain/usecases/task/get_today_tasks_usecase.dart';
import '../../../domain/usecases/task/search_tasks_usecase.dart';
import '../../../domain/usecases/task/toggle_task_complete_usecase.dart';
import '../../../domain/usecases/task/watch_all_tasks_usecase.dart';

// ── Filter tabs ───────────────────────────────────────────────
enum TaskFilterTab { all, today, thisWeek, overdue, highPriority }

// ── Sort options ──────────────────────────────────────────────
enum TaskSortOption { deadline, priority, room, progress }

class AllTasksViewModel extends ChangeNotifier {
  final GetAllTasksUseCase        _getAllTasks;
  final WatchAllTasksUseCase      _watchAllTasks;
  final GetTodayTasksUseCase      _getTodayTasks;
  final GetOverdueTasksUseCase    _getOverdueTasks;
  final SearchTasksUseCase        _searchTasks;
  final ToggleTaskCompleteUseCase _toggleTaskComplete;
  final DeleteTaskUseCase         _deleteTask;

  AllTasksViewModel({
    required GetAllTasksUseCase        getAllTasks,
    required WatchAllTasksUseCase      watchAllTasks,
    required GetTodayTasksUseCase      getTodayTasks,
    required GetOverdueTasksUseCase    getOverdueTasks,
    required SearchTasksUseCase        searchTasks,
    required ToggleTaskCompleteUseCase toggleTaskComplete,
    required DeleteTaskUseCase         deleteTask,
  })  : _getAllTasks        = getAllTasks,
        _watchAllTasks      = watchAllTasks,
        _getTodayTasks      = getTodayTasks,
        _getOverdueTasks    = getOverdueTasks,
        _searchTasks        = searchTasks,
        _toggleTaskComplete = toggleTaskComplete,
        _deleteTask         = deleteTask;

  // ── State ─────────────────────────────────────────────────────
  List<Task>      _allTasks    = [];
  List<Task>      _displayList = [];
  TaskFilterTab   _activeFilter = TaskFilterTab.all;
  TaskSortOption  _sortOption   = TaskSortOption.deadline;
  String          _searchQuery  = '';
  bool            _isLoading    = true;
  bool            _isSearching  = false;
  String?         _error;

  // ── Getters ───────────────────────────────────────────────────
  List<Task>     get displayList  => _displayList;
  TaskFilterTab  get activeFilter => _activeFilter;
  TaskSortOption get sortOption   => _sortOption;
  String         get searchQuery  => _searchQuery;
  bool           get isLoading    => _isLoading;
  bool           get isSearching  => _isSearching;
  String?        get error        => _error;

  int get overdueCount =>
      _allTasks.where((t) => t.isOverdue).length;

  /// Group tasks theo ngày deadline
  Map<String, List<Task>> get groupedByDate {
    final Map<String, List<Task>> grouped = {};
    for (final task in _displayList) {
      final key = _groupKey(task.deadline);
      grouped.putIfAbsent(key, () => []).add(task);
    }
    return grouped;
  }

  String _groupKey(DateTime dt) {
    final now      = DateTime.now().toUtc().add(const Duration(hours: 7));
    final today    = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDay  = DateTime(dt.year, dt.month, dt.day);

    if (taskDay.isBefore(today))   return 'QUÁ HẠN';
    if (taskDay == today)          return 'HÔM NAY · ${_formatDate(dt)}';
    if (taskDay == tomorrow)       return 'NGÀY MAI · ${_formatDate(dt)}';
    return _formatDate(dt).toUpperCase();
  }

  String _formatDate(DateTime dt) =>
      '${dt.day} THÁNG ${dt.month}';

  // ── Init ──────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      _allTasks = await _getAllTasks();
      _applyFilterAndSort();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Filter ────────────────────────────────────────────────────
  Future<void> setFilter(TaskFilterTab filter) async {
    _activeFilter = filter;
    _searchQuery  = '';
    _isLoading    = true;
    notifyListeners();

    try {
      switch (filter) {
        case TaskFilterTab.all:
          _allTasks = await _getAllTasks();
          break;
        case TaskFilterTab.today:
          _allTasks = await _getTodayTasks();
          break;
        case TaskFilterTab.thisWeek:
          _allTasks = await _getAllTasks();
          _allTasks = _allTasks.where((t) => t.isThisWeek).toList();
          break;
        case TaskFilterTab.overdue:
          _allTasks = await _getOverdueTasks();
          break;
        case TaskFilterTab.highPriority:
          _allTasks = await _getAllTasks();
          _allTasks = _allTasks
              .where((t) => t.priority == PriorityLevel.high)
              .toList();
          break;
      }
      _applyFilterAndSort();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Sort ──────────────────────────────────────────────────────
  void setSort(TaskSortOption option) {
    _sortOption = option;
    _applyFilterAndSort();
    notifyListeners();
  }

  // ── Search ────────────────────────────────────────────────────
  Future<void> onSearch(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _isSearching = false;
      await setFilter(_activeFilter);
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _displayList = await _searchTasks(query);
      _sortList(_displayList);
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // ── Apply filter + sort ───────────────────────────────────────
  void _applyFilterAndSort() {
    _displayList = List.from(_allTasks);
    _sortList(_displayList);
  }

  void _sortList(List<Task> list) {
    switch (_sortOption) {
      case TaskSortOption.deadline:
        list.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case TaskSortOption.priority:
        list.sort((a, b) =>
            a.priority.sortOrder.compareTo(b.priority.sortOrder));
        break;
      case TaskSortOption.room:
        list.sort((a, b) =>
            a.roomType.label.compareTo(b.roomType.label));
        break;
      case TaskSortOption.progress:
        list.sort((a, b) =>
            b.progressPercent.compareTo(a.progressPercent));
        break;
    }
  }

  // ── Actions ───────────────────────────────────────────────────
  Future<void> toggleComplete(Task task) async {
    await _toggleTaskComplete(task);
    await init();
  }

  Future<void> deleteTask(Task task) async {
    await _deleteTask(task.id);
    await init();
  }

  Future<void> refresh() => init();

  String sortLabel(TaskSortOption opt) {
    switch (opt) {
      case TaskSortOption.deadline:  return 'Theo deadline';
      case TaskSortOption.priority:  return 'Theo ưu tiên';
      case TaskSortOption.room:      return 'Theo phòng';
      case TaskSortOption.progress:  return 'Theo % hoàn thành';
    }
  }

  String filterLabel(TaskFilterTab filter) {
    switch (filter) {
      case TaskFilterTab.all:          return 'Tất cả';
      case TaskFilterTab.today:        return 'Hôm nay';
      case TaskFilterTab.thisWeek:     return 'Tuần này';
      case TaskFilterTab.overdue:      return 'Quá hạn';
      case TaskFilterTab.highPriority: return 'Ưu tiên cao';
    }
  }
}