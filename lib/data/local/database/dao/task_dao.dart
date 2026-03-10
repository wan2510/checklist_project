import 'package:floor/floor.dart';
import '../entities/task_entity.dart';

@dao
abstract class TaskDao {

  // ── Read ─────────────────────────────────────────────────────

  @Query('SELECT * FROM tasks ORDER BY deadline ASC')
  Future<List<TaskEntity>> getAllTasks();

  @Query('SELECT * FROM tasks ORDER BY deadline ASC')
  Stream<List<TaskEntity>> watchAllTasks();

  @Query('SELECT * FROM tasks WHERE id = :id LIMIT 1')
  Future<TaskEntity?> getTaskById(String id);

  @Query('SELECT * FROM tasks WHERE room_type = :roomType ORDER BY deadline ASC')
  Future<List<TaskEntity>> getTasksByRoom(String roomType);

  @Query('SELECT * FROM tasks WHERE room_type = :roomType ORDER BY deadline ASC')
  Stream<List<TaskEntity>> watchTasksByRoom(String roomType);

  @Query(
    'SELECT * FROM tasks '
        'WHERE deadline >= :startMs AND deadline < :endMs '
        'ORDER BY deadline ASC',
  )
  Future<List<TaskEntity>> getTasksByDateRange(int startMs, int endMs);

  @Query(
    "SELECT * FROM tasks "
        "WHERE status != 'done' AND deadline < :nowMs "
        "ORDER BY deadline ASC",
  )
  Future<List<TaskEntity>> getOverdueTasks(int nowMs);

  @Query(
    "SELECT * FROM tasks "
        "WHERE priority = 'high' "
        "ORDER BY deadline ASC",
  )
  Future<List<TaskEntity>> getHighPriorityTasks();

  @Query(
    'SELECT * FROM tasks '
        'WHERE status = :status '
        'ORDER BY deadline ASC',
  )
  Future<List<TaskEntity>> getTasksByStatus(String status);

  @Query(
    'SELECT * FROM tasks '
        'WHERE LOWER(title) LIKE :keyword OR LOWER(description) LIKE :keyword '
        'ORDER BY deadline ASC',
  )
  Future<List<TaskEntity>> searchTasks(String keyword);

  // ── Count ─────────────────────────────────────────────────────

  @Query('SELECT COUNT(*) FROM tasks')
  Future<int?> countAll();

  @Query("SELECT COUNT(*) FROM tasks WHERE status = 'done'")
  Future<int?> countCompleted();

  @Query("SELECT COUNT(*) FROM tasks WHERE status = 'inProgress'")
  Future<int?> countInProgress();

  @Query(
    "SELECT COUNT(*) FROM tasks "
        "WHERE status != 'done' AND deadline < :nowMs",
  )
  Future<int?> countOverdue(int nowMs);

  @Query(
    'SELECT COUNT(*) FROM tasks '
        'WHERE deadline >= :startMs AND deadline < :endMs',
  )
  Future<int?> countByDateRange(int startMs, int endMs);

  // ── Write ─────────────────────────────────────────────────────

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTask(TaskEntity task);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTasks(List<TaskEntity> tasks);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateTask(TaskEntity task);

  @delete
  Future<void> deleteTask(TaskEntity task);

  @Query('DELETE FROM tasks WHERE id = :id')
  Future<void> deleteTaskById(String id);

  @Query('DELETE FROM tasks')
  Future<void> deleteAllTasks();
}