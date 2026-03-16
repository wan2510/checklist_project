import '../../domain/entities/progress_stats.dart';
import '../../domain/entities/room.dart';
import '../../core/enums/room_type.dart';
import '../local/database/entities/task_entity.dart';

/// Tính toán ProgressStats từ raw TaskEntity list
class ProgressStatsModel {
  ProgressStatsModel._();

  static ProgressStats fromTaskEntities(List<TaskEntity> tasks) {
    final nowMs = DateTime.now()

        .millisecondsSinceEpoch;

    final total         = tasks.length;
    final completed     = tasks.where((t) => t.status == 'done').length;
    final inProgress    = tasks.where((t) => t.status == 'inProgress').length;
    final overdue       = tasks
        .where((t) => t.status != 'done' && t.deadline < nowMs)
        .length;
    // FIX: tính số task ưu tiên cao chưa hoàn thành
    final highPriority  = tasks
        .where((t) => t.priority == 'high' && t.status != 'done')
        .length;

    // ── Room stats ─────────────────────────────────────────────
    final roomStats = <Room>[];
    for (final type in RoomType.values) {
      final roomTasks = tasks.where((t) => t.roomType == type.name).toList();
      if (roomTasks.isEmpty) continue;

      final roomCompleted = roomTasks.where((t) => t.status == 'done').length;
      final roomOverdue   = roomTasks
          .where((t) => t.status != 'done' && t.deadline < nowMs)
          .length;

      roomStats.add(Room(
        id:             type.name,
        type:           type,
        totalTasks:     roomTasks.length,
        completedTasks: roomCompleted,
        overdueTasks:   roomOverdue,
      ));
    }

    // ── Weekly completed (7 ngày gần nhất) ────────────────────
    final weeklyCompleted = <String, int>{};
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final day      = now.subtract(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day)
          .millisecondsSinceEpoch;
      final dayEnd   = dayStart + const Duration(days: 1).inMilliseconds;

      final key   = '${day.day}/${day.month}';
      final count = tasks
          .where((t) =>
      t.status == 'done' &&
          t.updatedAt >= dayStart &&
          t.updatedAt < dayEnd)
          .length;

      weeklyCompleted[key] = count;
    }

    return ProgressStats(
      totalTasks:        total,
      completedTasks:    completed,
      inProgressTasks:   inProgress,
      overdueTasks:      overdue,
      roomStats:         roomStats,
      weeklyCompleted:   weeklyCompleted,
    );
  }
}