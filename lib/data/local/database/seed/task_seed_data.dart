// import 'package:uuid/uuid.dart';
// import '../entities/task_entity.dart';
//
// /// Dữ liệu mẫu để test UI — gọi một lần khi first launch
// class TaskSeedData {
//   TaskSeedData._();
//
//   static const _uuid = Uuid();
//
//   static int _dt(int year, int month, int day, {int hour = 8}) =>
//       DateTime(year, month, day, hour).millisecondsSinceEpoch;
//
//   static int get _now =>
//       DateTime.now().millisecondsSinceEpoch;
//
//   static List<TaskEntity> get samples => [
//     // ── Phòng thờ ─────────────────────────────────────────────
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Lau dọn bàn thờ gia tiên',
//       description:       'Dùng nước thơm lau sạch các bát hương, đồ đồng và sắp xếp lại mâm ngũ quả đón Tết.',
//       roomType:          'altar',
//       priority:          'high',
//       status:            'pending',
//       progressPercent:   0,
//       deadline:          _dt(2026, 1, 25, hour: 9),
//       isReminderEnabled: 1,
//       reminderTime:      _dt(2026, 1, 25, hour: 8),
//       note:              'Cần mua thêm nhang và nến đỏ mới.',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//
//     // ── Phòng khách ───────────────────────────────────────────
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Giặt rèm cửa phòng khách',
//       description:       'Tháo rèm, giặt máy và phơi khô trước khi treo lại.',
//       roomType:          'livingRoom',
//       priority:          'medium',
//       status:            'inProgress',
//       progressPercent:   65,
//       deadline:          _dt(2026, 1, 27, hour: 10),
//       isReminderEnabled: 0,
//       reminderTime:      null,
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Mua hoa đào trang trí',
//       description:       'Ra chợ hoa mua cành đào đẹp trang trí phòng khách.',
//       roomType:          'livingRoom',
//       priority:          'high',
//       status:            'pending',
//       progressPercent:   0,
//       deadline:          _dt(2026, 1, 27, hour: 8),
//       isReminderEnabled: 1,
//       reminderTime:      _dt(2026, 1, 27, hour: 7),
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Sắp xếp lại tủ trưng bày',
//       description:       'Lau chùi và sắp xếp đồ vật trang trí trong tủ kính.',
//       roomType:          'livingRoom',
//       priority:          'low',
//       status:            'done',
//       progressPercent:   100,
//       deadline:          _dt(2026, 1, 24, hour: 14),
//       isReminderEnabled: 0,
//       reminderTime:      null,
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Hút bụi toàn bộ thảm',
//       description:       'Hút bụi thảm phòng khách và lối đi.',
//       roomType:          'livingRoom',
//       priority:          'medium',
//       status:            'inProgress',
//       progressPercent:   30,
//       deadline:          _dt(2026, 1, 28, hour: 15),
//       isReminderEnabled: 0,
//       reminderTime:      null,
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//
//     // ── Bếp ──────────────────────────────────────────────────
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Vệ sinh bếp và lò nướng',
//       description:       'Tẩy rửa bếp gas, lò nướng và khu vực nấu ăn.',
//       roomType:          'kitchen',
//       priority:          'high',
//       status:            'pending',
//       progressPercent:   0,
//       deadline:          _dt(2026, 1, 26, hour: 9),
//       isReminderEnabled: 1,
//       reminderTime:      _dt(2026, 1, 26, hour: 8),
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//
//     // ── Phòng khách (cửa kính) ────────────────────────────────
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Chùi rửa cửa kính',
//       description:       'Lau sạch toàn bộ cửa kính bằng nước lau kính chuyên dụng.',
//       roomType:          'livingRoom',
//       priority:          'medium',
//       status:            'pending',
//       progressPercent:   0,
//       deadline:          _dt(2026, 1, 21, hour: 8),
//       isReminderEnabled: 0,
//       reminderTime:      null,
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//
//     // ── Phòng ngủ ─────────────────────────────────────────────
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Giặt chăn ga gối',
//       description:       'Giặt toàn bộ chăn ga gối đệm và phơi khô.',
//       roomType:          'bedroom',
//       priority:          'medium',
//       status:            'done',
//       progressPercent:   100,
//       deadline:          _dt(2026, 1, 22, hour: 10),
//       isReminderEnabled: 0,
//       reminderTime:      null,
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//
//     // ── Quá hạn (để test overdue UI) ─────────────────────────
//     TaskEntity(
//       id:                _uuid.v4(),
//       title:             'Mua sắm dụng cụ vệ sinh',
//       description:       'Mua chổi, cây lau nhà, nước tẩy rửa.',
//       roomType:          'other',
//       priority:          'high',
//       status:            'pending',
//       progressPercent:   0,
//       deadline:          _dt(2025, 12, 20, hour: 9),
//       isReminderEnabled: 0,
//       reminderTime:      null,
//       note:              '',
//       createdAt:         _now,
//       updatedAt:         _now,
//     ),
//   ];
// }