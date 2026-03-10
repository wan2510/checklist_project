import 'package:equatable/equatable.dart';
import 'room.dart';

/// Thống kê tổng thể cho màn hình báo cáo
class ProgressStats extends Equatable {
  final int          totalTasks;
  final int          completedTasks;
  final int          inProgressTasks;
  final int          overdueTasks;
  final List<Room>   roomStats;
  final Map<String, int> weeklyCompleted; // key: "dd/MM", value: số việc
  final double       avgMinutesPerTask;

  const ProgressStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.overdueTasks,
    required this.roomStats,
    required this.weeklyCompleted,
    this.avgMinutesPerTask = 45,
  });

  // ── Computed ─────────────────────────────────────────────────

  int get pendingTasks =>
      totalTasks - completedTasks - inProgressTasks;

  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  int get completionPercent =>
      (completionRate * 100).round();

  String get motivationMessage {
    if (completionPercent < 50) return 'Cố lên! Tết đang đến gần! 🎉';
    if (completionPercent < 80) return 'Tuyệt vời! Sắp xong rồi! 💪';
    return 'Xuất sắc! Nhà bạn sẵn sàng đón Tết! 🏮';
  }

  static ProgressStats get empty => const ProgressStats(
    totalTasks:      0,
    completedTasks:  0,
    inProgressTasks: 0,
    overdueTasks:    0,
    roomStats:       [],
    weeklyCompleted: {},
  );

  // ── Equatable ────────────────────────────────────────────────

  @override
  List<Object?> get props => [
    totalTasks, completedTasks, inProgressTasks,
    overdueTasks, roomStats, weeklyCompleted, avgMinutesPerTask,
  ];
}