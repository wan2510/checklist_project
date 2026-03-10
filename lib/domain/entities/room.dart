import 'package:equatable/equatable.dart';
import '../../core/enums/room_type.dart';

class Room extends Equatable {
  final String   id;
  final RoomType type;
  final int      totalTasks;
  final int      completedTasks;
  final int      overdueTasks;

  const Room({
    required this.id,
    required this.type,
    this.totalTasks     = 0,
    this.completedTasks = 0,
    this.overdueTasks   = 0,
  });

  // ── Computed properties ──────────────────────────────────────

  String get name    => type.label;
  String get emoji   => type.iconPath;

  double get progressPercent =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  int get progressInt =>
      totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();

  int get remainingTasks => totalTasks - completedTasks;

  bool get isCompleted =>
      totalTasks > 0 && completedTasks == totalTasks;

  bool get hasOverdue => overdueTasks > 0;

  // ── CopyWith ─────────────────────────────────────────────────

  Room copyWith({
    String?   id,
    RoomType? type,
    int?      totalTasks,
    int?      completedTasks,
    int?      overdueTasks,
  }) {
    return Room(
      id:             id             ?? this.id,
      type:           type           ?? this.type,
      totalTasks:     totalTasks     ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      overdueTasks:   overdueTasks   ?? this.overdueTasks,
    );
  }

  // ── Equatable ────────────────────────────────────────────────

  @override
  List<Object?> get props =>
      [id, type, totalTasks, completedTasks, overdueTasks];

  @override
  String toString() =>
      'Room(type: ${type.name}, $completedTasks/$totalTasks tasks)';
}