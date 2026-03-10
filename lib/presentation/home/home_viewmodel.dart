import 'package:flutter/material.dart';

import '../../domain/entities/progress_stats.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/room/get_overall_progress_usecase.dart';
import '../../domain/usecases/room/watch_overall_stats_usecase.dart';
import '../../domain/usecases/task/get_today_tasks_usecase.dart';
import '../../domain/usecases/task/get_overdue_tasks_usecase.dart';
import '../../core/utils/tet_date_utils.dart';

class HomeViewModel extends ChangeNotifier {
  final GetOverallProgressUseCase _getOverallProgress;
  final WatchOverallStatsUseCase  _watchOverallStats;
  final GetTodayTasksUseCase      _getTodayTasks;
  final GetOverdueTasksUseCase    _getOverdueTasks;

  HomeViewModel({
    required GetOverallProgressUseCase getOverallProgress,
    required WatchOverallStatsUseCase  watchOverallStats,
    required GetTodayTasksUseCase      getTodayTasks,
    required GetOverdueTasksUseCase    getOverdueTasks,
  })  : _getOverallProgress = getOverallProgress,
        _watchOverallStats  = watchOverallStats,
        _getTodayTasks      = getTodayTasks,
        _getOverdueTasks    = getOverdueTasks;

  // ── State ────────────────────────────────────────────────────
  ProgressStats _stats        = ProgressStats.empty;
  List<Task>    _todayTasks   = [];
  List<Task>    _overdueTasks = [];
  bool          _isLoading    = true;
  String?       _error;

  // ── Getters ──────────────────────────────────────────────────
  ProgressStats get stats        => _stats;
  List<Task>    get todayTasks   => _todayTasks;
  List<Task>    get overdueTasks => _overdueTasks;
  bool          get isLoading    => _isLoading;
  String?       get error        => _error;

  int    get daysUntilTet     => TetDateUtils.daysUntilTet;
  String get countdownLabel   => TetDateUtils.countdownLabel;
  int    get todayCount       => _todayTasks.length;
  int    get overdueCount     => _overdueTasks.length;
  int    get highPriorityCount =>
      _stats.roomStats.fold(0, (sum, r) => sum + r.overdueTasks);

  // ── Init ─────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadStats(),
        _loadTodayTasks(),
        _loadOverdueTasks(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadStats() async {
    _stats = await _getOverallProgress();
  }

  Future<void> _loadTodayTasks() async {
    _todayTasks = await _getTodayTasks();
  }

  Future<void> _loadOverdueTasks() async {
    _overdueTasks = await _getOverdueTasks();
  }

  Future<void> refresh() => init();
}