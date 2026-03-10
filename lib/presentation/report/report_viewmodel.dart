import 'package:flutter/material.dart';

import '../../domain/entities/progress_stats.dart';
import '../../domain/usecases/room/get_overall_progress_usecase.dart';
import '../../domain/usecases/room/watch_overall_stats_usecase.dart';

class ReportViewModel extends ChangeNotifier {
  final GetOverallProgressUseCase _getOverallProgress;
  final WatchOverallStatsUseCase  _watchOverallStats;

  ReportViewModel({
    required GetOverallProgressUseCase getOverallProgress,
    required WatchOverallStatsUseCase  watchOverallStats,
  })  : _getOverallProgress = getOverallProgress,
        _watchOverallStats  = watchOverallStats;

  // ── State ─────────────────────────────────────────────────────
  ProgressStats _stats     = ProgressStats.empty;
  bool          _isLoading = true;
  String?       _error;

  // ── Getters ───────────────────────────────────────────────────
  ProgressStats get stats     => _stats;
  bool          get isLoading => _isLoading;
  String?       get error     => _error;

  int    get totalTasks      => _stats.totalTasks;
  int    get completedTasks  => _stats.completedTasks;
  int    get inProgressTasks => _stats.inProgressTasks;
  int    get overdueTasks    => _stats.overdueTasks;
  int    get completionPct   => _stats.completionPercent;
  String get motivationMsg   => _stats.motivationMessage;
  double get avgMinutes      => _stats.avgMinutesPerTask;

  /// Pie chart data: [done, inProgress, pending]
  List<double> get pieData => [
    _stats.completedTasks.toDouble(),
    _stats.inProgressTasks.toDouble(),
    (_stats.totalTasks - _stats.completedTasks - _stats.inProgressTasks)
        .toDouble().clamp(0, double.infinity),
  ];

  /// Bar chart: weekly completed (7 ngày)
  List<MapEntry<String, int>> get weeklyData =>
      _stats.weeklyCompleted.entries.toList();

  /// Room distribution data
  List<MapEntry<String, double>> get roomPieData =>
      _stats.roomStats
          .where((r) => r.totalTasks > 0)
          .map((r) => MapEntry(r.name, r.totalTasks.toDouble()))
          .toList();

  // ── Init ──────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      _stats = await _getOverallProgress();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => init();
}