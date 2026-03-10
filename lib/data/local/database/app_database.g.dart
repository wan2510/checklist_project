// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TaskDao? _taskDaoInstance;

  RoomDao? _roomDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tasks` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `room_type` TEXT NOT NULL, `priority` TEXT NOT NULL, `status` TEXT NOT NULL, `progress_percent` INTEGER NOT NULL, `deadline` INTEGER NOT NULL, `reminder_time` INTEGER, `is_reminder_enabled` INTEGER NOT NULL, `note` TEXT NOT NULL, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `rooms` (`id` TEXT NOT NULL, `room_type` TEXT NOT NULL, `custom_name` TEXT, `sort_order` INTEGER NOT NULL, `created_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TaskDao get taskDao {
    return _taskDaoInstance ??= _$TaskDao(database, changeListener);
  }

  @override
  RoomDao get roomDao {
    return _roomDaoInstance ??= _$RoomDao(database, changeListener);
  }
}

class _$TaskDao extends TaskDao {
  _$TaskDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _taskEntityInsertionAdapter = InsertionAdapter(
            database,
            'tasks',
            (TaskEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'room_type': item.roomType,
                  'priority': item.priority,
                  'status': item.status,
                  'progress_percent': item.progressPercent,
                  'deadline': item.deadline,
                  'reminder_time': item.reminderTime,
                  'is_reminder_enabled': item.isReminderEnabled,
                  'note': item.note,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _taskEntityUpdateAdapter = UpdateAdapter(
            database,
            'tasks',
            ['id'],
            (TaskEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'room_type': item.roomType,
                  'priority': item.priority,
                  'status': item.status,
                  'progress_percent': item.progressPercent,
                  'deadline': item.deadline,
                  'reminder_time': item.reminderTime,
                  'is_reminder_enabled': item.isReminderEnabled,
                  'note': item.note,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _taskEntityDeletionAdapter = DeletionAdapter(
            database,
            'tasks',
            ['id'],
            (TaskEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'room_type': item.roomType,
                  'priority': item.priority,
                  'status': item.status,
                  'progress_percent': item.progressPercent,
                  'deadline': item.deadline,
                  'reminder_time': item.reminderTime,
                  'is_reminder_enabled': item.isReminderEnabled,
                  'note': item.note,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TaskEntity> _taskEntityInsertionAdapter;

  final UpdateAdapter<TaskEntity> _taskEntityUpdateAdapter;

  final DeletionAdapter<TaskEntity> _taskEntityDeletionAdapter;

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return _queryAdapter.queryList('SELECT * FROM tasks ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int));
  }

  @override
  Stream<List<TaskEntity>> watchAllTasks() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM tasks ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int),
        queryableName: 'tasks',
        isView: false);
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    return _queryAdapter.query('SELECT * FROM tasks WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int),
        arguments: [id]);
  }

  @override
  Future<List<TaskEntity>> getTasksByRoom(String roomType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tasks WHERE room_type = ?1 ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int),
        arguments: [roomType]);
  }

  @override
  Stream<List<TaskEntity>> watchTasksByRoom(String roomType) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM tasks WHERE room_type = ?1 ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int),
        arguments: [roomType],
        queryableName: 'tasks',
        isView: false);
  }

  @override
  Future<List<TaskEntity>> getTasksByDateRange(
    int startMs,
    int endMs,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tasks WHERE deadline >= ?1 AND deadline < ?2 ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(id: row['id'] as String, title: row['title'] as String, description: row['description'] as String, roomType: row['room_type'] as String, priority: row['priority'] as String, status: row['status'] as String, progressPercent: row['progress_percent'] as int, deadline: row['deadline'] as int, reminderTime: row['reminder_time'] as int?, isReminderEnabled: row['is_reminder_enabled'] as int, note: row['note'] as String, createdAt: row['created_at'] as int, updatedAt: row['updated_at'] as int),
        arguments: [startMs, endMs]);
  }

  @override
  Future<List<TaskEntity>> getOverdueTasks(int nowMs) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tasks WHERE status != \"done\" AND deadline < ?1 ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(id: row['id'] as String, title: row['title'] as String, description: row['description'] as String, roomType: row['room_type'] as String, priority: row['priority'] as String, status: row['status'] as String, progressPercent: row['progress_percent'] as int, deadline: row['deadline'] as int, reminderTime: row['reminder_time'] as int?, isReminderEnabled: row['is_reminder_enabled'] as int, note: row['note'] as String, createdAt: row['created_at'] as int, updatedAt: row['updated_at'] as int),
        arguments: [nowMs]);
  }

  @override
  Future<List<TaskEntity>> getHighPriorityTasks() async {
    return _queryAdapter.queryList(
        'SELECT * FROM tasks WHERE priority = \"high\" ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int));
  }

  @override
  Future<List<TaskEntity>> getTasksByStatus(String status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tasks WHERE status = ?1 ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            roomType: row['room_type'] as String,
            priority: row['priority'] as String,
            status: row['status'] as String,
            progressPercent: row['progress_percent'] as int,
            deadline: row['deadline'] as int,
            reminderTime: row['reminder_time'] as int?,
            isReminderEnabled: row['is_reminder_enabled'] as int,
            note: row['note'] as String,
            createdAt: row['created_at'] as int,
            updatedAt: row['updated_at'] as int),
        arguments: [status]);
  }

  @override
  Future<List<TaskEntity>> searchTasks(String keyword) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tasks WHERE LOWER(title) LIKE ?1 OR LOWER(description) LIKE ?1 ORDER BY deadline ASC',
        mapper: (Map<String, Object?> row) => TaskEntity(id: row['id'] as String, title: row['title'] as String, description: row['description'] as String, roomType: row['room_type'] as String, priority: row['priority'] as String, status: row['status'] as String, progressPercent: row['progress_percent'] as int, deadline: row['deadline'] as int, reminderTime: row['reminder_time'] as int?, isReminderEnabled: row['is_reminder_enabled'] as int, note: row['note'] as String, createdAt: row['created_at'] as int, updatedAt: row['updated_at'] as int),
        arguments: [keyword]);
  }

  @override
  Future<int?> countAll() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM tasks',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> countCompleted() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM tasks WHERE status = \"done\"',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> countInProgress() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM tasks WHERE status = \"inProgress\"',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> countOverdue(int nowMs) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM tasks WHERE status != \"done\" AND deadline < ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [nowMs]);
  }

  @override
  Future<int?> countByDateRange(
    int startMs,
    int endMs,
  ) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM tasks WHERE deadline >= ?1 AND deadline < ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [startMs, endMs]);
  }

  @override
  Future<void> deleteTaskById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM tasks WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllTasks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM tasks');
  }

  @override
  Future<void> insertTask(TaskEntity task) async {
    await _taskEntityInsertionAdapter.insert(task, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTasks(List<TaskEntity> tasks) async {
    await _taskEntityInsertionAdapter.insertList(
        tasks, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await _taskEntityUpdateAdapter.update(task, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTask(TaskEntity task) async {
    await _taskEntityDeletionAdapter.delete(task);
  }
}

class _$RoomDao extends RoomDao {
  _$RoomDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _roomEntityInsertionAdapter = InsertionAdapter(
            database,
            'rooms',
            (RoomEntity item) => <String, Object?>{
                  'id': item.id,
                  'room_type': item.roomType,
                  'custom_name': item.customName,
                  'sort_order': item.sortOrder,
                  'created_at': item.createdAt
                },
            changeListener),
        _roomEntityUpdateAdapter = UpdateAdapter(
            database,
            'rooms',
            ['id'],
            (RoomEntity item) => <String, Object?>{
                  'id': item.id,
                  'room_type': item.roomType,
                  'custom_name': item.customName,
                  'sort_order': item.sortOrder,
                  'created_at': item.createdAt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RoomEntity> _roomEntityInsertionAdapter;

  final UpdateAdapter<RoomEntity> _roomEntityUpdateAdapter;

  @override
  Future<List<RoomEntity>> getAllRooms() async {
    return _queryAdapter.queryList(
        'SELECT * FROM rooms ORDER BY sort_order ASC',
        mapper: (Map<String, Object?> row) => RoomEntity(
            id: row['id'] as String,
            roomType: row['room_type'] as String,
            customName: row['custom_name'] as String?,
            sortOrder: row['sort_order'] as int,
            createdAt: row['created_at'] as int));
  }

  @override
  Stream<List<RoomEntity>> watchAllRooms() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM rooms ORDER BY sort_order ASC',
        mapper: (Map<String, Object?> row) => RoomEntity(
            id: row['id'] as String,
            roomType: row['room_type'] as String,
            customName: row['custom_name'] as String?,
            sortOrder: row['sort_order'] as int,
            createdAt: row['created_at'] as int),
        queryableName: 'rooms',
        isView: false);
  }

  @override
  Future<RoomEntity?> getRoomByType(String roomType) async {
    return _queryAdapter.query(
        'SELECT * FROM rooms WHERE room_type = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => RoomEntity(
            id: row['id'] as String,
            roomType: row['room_type'] as String,
            customName: row['custom_name'] as String?,
            sortOrder: row['sort_order'] as int,
            createdAt: row['created_at'] as int),
        arguments: [roomType]);
  }

  @override
  Future<void> deleteRoomById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM rooms WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllRooms() async {
    await _queryAdapter.queryNoReturn('DELETE FROM rooms');
  }

  @override
  Future<void> insertRoom(RoomEntity room) async {
    await _roomEntityInsertionAdapter.insert(room, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertRooms(List<RoomEntity> rooms) async {
    await _roomEntityInsertionAdapter.insertList(
        rooms, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateRoom(RoomEntity room) async {
    await _roomEntityUpdateAdapter.update(room, OnConflictStrategy.replace);
  }
}
