import '../entities/task.dart';
import '../../core/enums/room_type.dart';
import '../../core/enums/task_status.dart';
import '../../core/enums/priority_level.dart';

/// Abstract interface — Data layer phải implement
abstract class TaskRepository {

  // ── Read ─────────────────────────────────────────────────────

  /// Lấy tất cả task, sắp xếp theo deadline tăng dần
  Future<List<Task>> getAllTasks();

  /// Lấy task theo phòng
  Future<List<Task>> getTasksByRoom(RoomType roomType);

  /// Lấy task trong một ngày cụ thể (deadline trùng ngày)
  Future<List<Task>> getTasksByDate(DateTime date);

  /// Lấy task hôm nay (theo giờ VN)
  Future<List<Task>> getTodayTasks();

  /// Lấy task tuần này
  Future<List<Task>> getThisWeekTasks();

  /// Lấy task quá hạn
  Future<List<Task>> getOverdueTasks();

  /// Lấy task ưu tiên cao
  Future<List<Task>> getHighPriorityTasks();

  /// Lấy task theo trạng thái
  Future<List<Task>> getTasksByStatus(TaskStatus status);

  /// Tìm kiếm task theo từ khóa (title, description)
  Future<List<Task>> searchTasks(String keyword);

  /// Lấy một task theo id
  Future<Task?> getTaskById(String id);

  // ── Write ────────────────────────────────────────────────────

  /// Thêm task mới
  Future<void> addTask(Task task);

  /// Cập nhật task
  Future<void> updateTask(Task task);

  /// Xóa task theo id
  Future<void> deleteTask(String id);

  /// Xóa tất cả task
  Future<void> deleteAllTasks();

  // ── Stream (reactive) ────────────────────────────────────────

  /// Stream toàn bộ task — ViewModel lắng nghe real-time
  Stream<List<Task>> watchAllTasks();

  /// Stream task theo phòng
  Stream<List<Task>> watchTasksByRoom(RoomType roomType);
}