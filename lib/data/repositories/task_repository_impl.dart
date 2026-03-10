import 'package:uuid/uuid.dart';
import '../../core/enums/room_type.dart';
import '../../core/enums/task_status.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../local/database/dao/task_dao.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDao _taskDao;
  static const _uuid = Uuid();

  TaskRepositoryImpl(this._taskDao);

  // ── Helper: now VN milliseconds ──────────────────────────────
  int get _nowMs => DateTime.now()
      .toUtc()
      .add(const Duration(hours: 7))
      .millisecondsSinceEpoch;

  // ── Read ─────────────────────────────────────────────────────

  @override
  Future<List<Task>> getAllTasks() async {
    final entities = await _taskDao.getAllTasks();
    return TaskModel.fromEntityList(entities);
  }

  @override
  Stream<List<Task>> watchAllTasks() =>
      _taskDao.watchAllTasks().map(TaskModel.fromEntityList);

  @override
  Future<Task?> getTaskById(String id) async {
    final entity = await _taskDao.getTaskById(id);
    return entity != null ? TaskModel.fromEntity(entity) : null;
  }

  @override
  Future<List<Task>> getTasksByRoom(RoomType roomType) async {
    final entities = await _taskDao.getTasksByRoom(roomType.name);
    return TaskModel.fromEntityList(entities);
  }

  @override
  Stream<List<Task>> watchTasksByRoom(RoomType roomType) =>
      _taskDao
          .watchTasksByRoom(roomType.name)
          .map(TaskModel.fromEntityList);

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day)
        .millisecondsSinceEpoch;
    final end = start + const Duration(days: 1).inMilliseconds;
    final entities = await _taskDao.getTasksByDateRange(start, end);
    return TaskModel.fromEntityList(entities);
  }

  @override
  Future<List<Task>> getTodayTasks() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    return getTasksByDate(now);
  }

  @override
  Future<List<Task>> getThisWeekTasks() async {
    final now       = DateTime.now().toUtc().add(const Duration(hours: 7));
    final startWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final endWeek   = startWeek.add(const Duration(days: 7));

    final entities = await _taskDao.getTasksByDateRange(
      startWeek.millisecondsSinceEpoch,
      endWeek.millisecondsSinceEpoch,
    );
    return TaskModel.fromEntityList(entities);
  }

  @override
  Future<List<Task>> getOverdueTasks() async {
    final entities = await _taskDao.getOverdueTasks(_nowMs);
    return TaskModel.fromEntityList(entities);
  }

  @override
  Future<List<Task>> getHighPriorityTasks() async {
    final entities = await _taskDao.getHighPriorityTasks();
    return TaskModel.fromEntityList(entities);
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final entities = await _taskDao.getTasksByStatus(status.name);
    return TaskModel.fromEntityList(entities);
  }

  @override
  Future<List<Task>> searchTasks(String keyword) async {
    final kw       = '%${keyword.toLowerCase()}%';
    final entities = await _taskDao.searchTasks(kw);
    return TaskModel.fromEntityList(entities);
  }

  // ── Write ────────────────────────────────────────────────────

  @override
  Future<void> addTask(Task task) async {
    final taskWithId = task.copyWith(
      id:        _uuid.v4(),
      createdAt: DateTime.now().toUtc().add(const Duration(hours: 7)),
      updatedAt: DateTime.now().toUtc().add(const Duration(hours: 7)),
    );
    await _taskDao.insertTask(TaskModel.toEntity(taskWithId));
  }

  @override
  Future<void> updateTask(Task task) async {
    final updated = task.copyWith(
      updatedAt: DateTime.now().toUtc().add(const Duration(hours: 7)),
    );
    await _taskDao.updateTask(TaskModel.toEntity(updated));
  }

  @override
  Future<void> deleteTask(String id) =>
      _taskDao.deleteTaskById(id);

  @override
  Future<void> deleteAllTasks() => _taskDao.deleteAllTasks();
}