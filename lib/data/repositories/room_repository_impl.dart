import 'package:flutter/cupertino.dart';

import '../../domain/entities/progress_stats.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../../core/enums/room_type.dart';
import '../local/database/dao/task_dao.dart';
import '../local/database/dao/room_dao.dart';
import '../models/room_model.dart';
import '../models/progress_stats_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomDao  _roomDao;
  final TaskDao  _taskDao;

  RoomRepositoryImpl(this._roomDao, this._taskDao);

  // ── Read ─────────────────────────────────────────────────────

  @override
  Future<List<Room>> getAllRooms() async {
    try {
      debugPrint('>>> getAllRooms: start');
      final allTasks = await _taskDao.getAllTasks();
      debugPrint('>>> getAllRooms: got ${allTasks.length} tasks');
      final nowMs = DateTime.now()
          .toUtc()
          .add(const Duration(hours: 7))
          .millisecondsSinceEpoch;

      final rooms = RoomType.values.map((type) {
        final roomTasks = allTasks
            .where((t) => t.roomType == type.name)
            .toList();
        final completed = roomTasks
            .where((t) => t.status == 'done')
            .length;
        final overdue = roomTasks
            .where((t) => t.status != 'done' && t.deadline < nowMs)
            .length;

        return Room(
          id:             type.name,
          type:           type,
          totalTasks:     roomTasks.length,
          completedTasks: completed,
          overdueTasks:   overdue,
        );
      }).toList();

      debugPrint('>>> getAllRooms: returning ${rooms.length} rooms');
      return rooms;

    } catch (e, stack) {
      debugPrint('>>> getAllRooms ERROR: $e');
      debugPrint('>>> $stack');
      return [];   // ← trả về list rỗng thay vì throw
    }
  }

  @override
  Future<Room?> getRoomByType(RoomType type) async {
    final rooms = await getAllRooms();
    try {
      return rooms.firstWhere((r) => r.type == type);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ProgressStats> getOverallStats() async {
    final allTasks = await _taskDao.getAllTasks();
    return ProgressStatsModel.fromTaskEntities(allTasks);
  }

  // ── Stream ───────────────────────────────────────────────────

  @override
  Stream<List<Room>> watchAllRooms() =>
      _taskDao.watchAllTasks().asyncMap((_) => getAllRooms());

  @override
  Stream<ProgressStats> watchOverallStats() =>
      _taskDao
          .watchAllTasks()
          .map(ProgressStatsModel.fromTaskEntities);
}