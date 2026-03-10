import '../entities/room.dart';
import '../entities/progress_stats.dart';
import '../../core/enums/room_type.dart';

/// Abstract interface — Data layer phải implement
abstract class RoomRepository {

  // ── Read ─────────────────────────────────────────────────────

  /// Lấy tất cả phòng kèm thống kê tiến độ
  Future<List<Room>> getAllRooms();

  /// Lấy một phòng theo type
  Future<Room?> getRoomByType(RoomType type);

  /// Lấy thống kê tổng thể (dùng cho Home + Report)
  Future<ProgressStats> getOverallStats();

  // ── Stream ───────────────────────────────────────────────────

  /// Stream tất cả phòng — reactive update khi task thay đổi
  Stream<List<Room>> watchAllRooms();

  /// Stream thống kê tổng thể
  Stream<ProgressStats> watchOverallStats();
}