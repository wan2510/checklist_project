import 'package:equatable/equatable.dart';
import '../../core/enums/priority_level.dart';
import '../../core/enums/task_status.dart';
import '../../core/enums/room_type.dart';

class Task extends Equatable {
  final String        id;
  final String        title;
  final String        description;
  final RoomType      roomType;
  final PriorityLevel priority;
  final TaskStatus    status;
  final int           progressPercent; // 0 → 100
  final DateTime      deadline;
  final DateTime?     reminderTime;
  final bool          isReminderEnabled;
  final String        note;
  final DateTime      createdAt;
  final DateTime      updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description      = '',
    required this.roomType,
    this.priority         = PriorityLevel.medium,
    this.status           = TaskStatus.pending,
    this.progressPercent  = 0,
    required this.deadline,
    this.reminderTime,
    this.isReminderEnabled = false,
    this.note             = '',
    required this.createdAt,
    required this.updatedAt,
  });

  // ── Computed properties ──────────────────────────────────────

  bool get isCompleted  => status == TaskStatus.done;
  bool get isInProgress => status == TaskStatus.inProgress;
  bool get isPending    => status == TaskStatus.pending;

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    return deadline.isBefore(now);
  }

  bool get isToday {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    return deadline.year  == now.year  &&
        deadline.month == now.month &&
        deadline.day   == now.day;
  }

  bool get isThisWeek {
    final now       = DateTime.now().toUtc().add(const Duration(hours: 7));
    final startWeek = now.subtract(Duration(days: now.weekday - 1));
    final endWeek   = startWeek.add(const Duration(days: 6));
    return deadline.isAfter(startWeek.subtract(const Duration(days: 1))) &&
        deadline.isBefore(endWeek.add(const Duration(days: 1)));
  }

  bool get isHighPriority => priority == PriorityLevel.high;

  // ── CopyWith ─────────────────────────────────────────────────

  Task copyWith({
    String?        id,
    String?        title,
    String?        description,
    RoomType?      roomType,
    PriorityLevel? priority,
    TaskStatus?    status,
    int?           progressPercent,
    DateTime?      deadline,
    DateTime?      reminderTime,
    bool?          isReminderEnabled,
    String?        note,
    DateTime?      createdAt,
    DateTime?      updatedAt,
  }) {
    return Task(
      id:                id               ?? this.id,
      title:             title            ?? this.title,
      description:       description      ?? this.description,
      roomType:          roomType         ?? this.roomType,
      priority:          priority         ?? this.priority,
      status:            status           ?? this.status,
      progressPercent:   progressPercent  ?? this.progressPercent,
      deadline:          deadline         ?? this.deadline,
      reminderTime:      reminderTime     ?? this.reminderTime,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      note:              note             ?? this.note,
      createdAt:         createdAt        ?? this.createdAt,
      updatedAt:         updatedAt        ?? this.updatedAt,
    );
  }

  // ── Equatable ────────────────────────────────────────────────

  @override
  List<Object?> get props => [
    id, title, description, roomType, priority,
    status, progressPercent, deadline, reminderTime,
    isReminderEnabled, note, createdAt, updatedAt,
  ];

  @override
  String toString() =>
      'Task(id: $id, title: $title, status: ${status.name}, '
          'priority: ${priority.name}, room: ${roomType.name})';
}