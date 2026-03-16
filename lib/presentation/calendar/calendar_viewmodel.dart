import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/task/get_all_tasks_usecase.dart';
import '../../domain/usecases/task/get_tasks_by_date_usecase.dart';
import '../../core/enums/priority_level.dart';

class CalendarViewModel extends ChangeNotifier {
  final GetTasksByDateUseCase _getTasksByDate;
  final GetAllTasksUseCase    _getAllTasks;

  CalendarViewModel({
    required GetTasksByDateUseCase getTasksByDate,
    required GetAllTasksUseCase    getAllTasks,
  })  : _getTasksByDate = getTasksByDate,
        _getAllTasks     = getAllTasks;

  // ── State ─────────────────────────────────────────────────────
  DateTime          _focusedDay    = DateTime.now()
  ;
  DateTime?         _selectedDay;
  List<Task>        _selectedTasks = [];
  Map<String, List<Task>> _taskMap = {}; // key: "yyyy-MM-dd"
  bool              _isLoading     = true;
  bool              _isSheetLoading = false;
  bool              _isAgendaView  = false;
  String?           _error;

  // ── Getters ───────────────────────────────────────────────────
  DateTime   get focusedDay     => _focusedDay;
  DateTime?  get selectedDay    => _selectedDay;
  List<Task> get selectedTasks  => _selectedTasks;
  bool       get isLoading      => _isLoading;
  bool       get isSheetLoading => _isSheetLoading;
  bool       get isAgendaView   => _isAgendaView;
  String?    get error          => _error;

  /// Lấy tasks cho một ngày (dùng trong calendar marker)
  List<Task> tasksForDay(DateTime day) {
    final key = _dayKey(day);
    return _taskMap[key] ?? [];
  }

  /// Kiểm tra ngày có task ưu tiên cao không
  bool hasHighPriority(DateTime day) =>
      tasksForDay(day).any((t) => t.priority == PriorityLevel.high);

  /// Kiểm tra ngày có deadline không
  bool hasDeadline(DateTime day) =>
      tasksForDay(day).isNotEmpty;

  /// Agenda: tất cả tasks sắp tới (từ hôm nay)
  List<MapEntry<DateTime, List<Task>>> get agendaEntries {
    final now    = DateTime.now();
    final today  = DateTime(now.year, now.month, now.day);

    return _taskMap.entries
        .where((e) {
      final parts = e.key.split('-');
      final date  = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      return !date.isBefore(today) && e.value.isNotEmpty;
    })
        .map((e) {
      final parts = e.key.split('-');
      return MapEntry(
        DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        ),
        e.value,
      );
    })
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }

  // ── Init ──────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      final allTasks = await _getAllTasks();
      _buildTaskMap(allTasks);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _buildTaskMap(List<Task> tasks) {
    _taskMap = {};
    for (final task in tasks) {
      final key = _dayKey(task.deadline);
      _taskMap.putIfAbsent(key, () => []).add(task);
    }
  }

  // ── Select day ────────────────────────────────────────────────
  Future<void> selectDay(DateTime day) async {
    _selectedDay    = day;
    _isSheetLoading = true;
    notifyListeners();

    try {
      _selectedTasks = await _getTasksByDate(day);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isSheetLoading = false;
      notifyListeners();
    }
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  void toggleView() {
    _isAgendaView = !_isAgendaView;
    notifyListeners();
  }

  Future<void> refresh() => init();

  // ── Helper ────────────────────────────────────────────────────
  String _dayKey(DateTime dt) =>
      '${dt.year}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')}';
}