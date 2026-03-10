import '../../core/enums/priority_level.dart';
import '../../core/enums/room_type.dart';
import '../../core/enums/task_status.dart';
import '../../domain/entities/task.dart';
import '../local/database/entities/task_entity.dart';

/// Mapper: TaskEntity (DB) ↔ Task (Domain)
class TaskModel {
  TaskModel._();

  // ── Entity → Domain ──────────────────────────────────────────
  static Task fromEntity(TaskEntity e) {
    return Task(
      id:                e.id,
      title:             e.title,
      description:       e.description,
      roomType:          RoomType.fromString(e.roomType),
      priority:          PriorityLevel.fromString(e.priority),
      status:            TaskStatus.fromString(e.status),
      progressPercent:   e.progressPercent,
      deadline:          DateTime.fromMillisecondsSinceEpoch(e.deadline),
      reminderTime:      e.reminderTime != null
          ? DateTime.fromMillisecondsSinceEpoch(e.reminderTime!)
          : null,
      isReminderEnabled: e.isReminderEnabled == 1,
      note:              e.note,
      createdAt:         DateTime.fromMillisecondsSinceEpoch(e.createdAt),
      updatedAt:         DateTime.fromMillisecondsSinceEpoch(e.updatedAt),
    );
  }

  // ── Domain → Entity ──────────────────────────────────────────
  static TaskEntity toEntity(Task t) {
    return TaskEntity(
      id:                t.id,
      title:             t.title,
      description:       t.description,
      roomType:          t.roomType.name,
      priority:          t.priority.name,
      status:            t.status.name,
      progressPercent:   t.progressPercent,
      deadline:          t.deadline.millisecondsSinceEpoch,
      reminderTime:      t.reminderTime?.millisecondsSinceEpoch,
      isReminderEnabled: t.isReminderEnabled ? 1 : 0,
      note:              t.note,
      createdAt:         t.createdAt.millisecondsSinceEpoch,
      updatedAt:         t.updatedAt.millisecondsSinceEpoch,
    );
  }

  // ── List helpers ─────────────────────────────────────────────
  static List<Task> fromEntityList(List<TaskEntity> list) =>
      list.map(fromEntity).toList();

  static List<TaskEntity> toEntityList(List<Task> list) =>
      list.map(toEntity).toList();
}