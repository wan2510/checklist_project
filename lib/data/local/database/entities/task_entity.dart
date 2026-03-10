import 'package:floor/floor.dart';

@Entity(tableName: 'tasks')
class TaskEntity {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'title')
  final String title;

  @ColumnInfo(name: 'description')
  final String description;

  @ColumnInfo(name: 'room_type')
  final String roomType; // RoomType.name

  @ColumnInfo(name: 'priority')
  final String priority; // PriorityLevel.name

  @ColumnInfo(name: 'status')
  final String status; // TaskStatus.name

  @ColumnInfo(name: 'progress_percent')
  final int progressPercent;

  @ColumnInfo(name: 'deadline')
  final int deadline; // millisecondsSinceEpoch

  @ColumnInfo(name: 'reminder_time')
  final int? reminderTime; // millisecondsSinceEpoch, nullable

  @ColumnInfo(name: 'is_reminder_enabled')
  final int isReminderEnabled; // 0 = false, 1 = true (SQLite không có bool)

  @ColumnInfo(name: 'note')
  final String note;

  @ColumnInfo(name: 'created_at')
  final int createdAt; // millisecondsSinceEpoch

  @ColumnInfo(name: 'updated_at')
  final int updatedAt; // millisecondsSinceEpoch

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.roomType,
    required this.priority,
    required this.status,
    required this.progressPercent,
    required this.deadline,
    this.reminderTime,
    required this.isReminderEnabled,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}