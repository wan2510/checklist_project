import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Múi giờ Việt Nam GMT+7
  // Removed: Flutter uses device local timezone automatically

  /// Thời điểm hiện tại theo giờ VN
  static DateTime get nowVN =>
      DateTime.now();

  // ── Boolean checks ───────────────────────────────────────────

  bool get isToday {
    final now = DateTimeExtensions.nowVN;
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTimeExtensions.nowVN.add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isYesterday {
    final yesterday = DateTimeExtensions.nowVN.subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isOverdue {
    final now = DateTimeExtensions.nowVN;
    return isBefore(now) && !isToday;
  }

  bool get isThisWeek {
    final now = DateTimeExtensions.nowVN;
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  bool get isWithin3Days {
    final now = DateTimeExtensions.nowVN;
    final diff = difference(now).inDays;
    return diff >= 0 && diff <= 3;
  }

  // ── Formatting ───────────────────────────────────────────────

  /// "25 Tháng Chạp" hoặc "20 tháng 1, 2026"
  String toVNDateString() {
    return DateFormat('dd MMMM, yyyy', 'vi_VN').format(this);
  }

  /// "25 Tháng Chạp" (ngắn)
  String toVNShortDate() {
    return DateFormat('dd MMMM', 'vi_VN').format(this);
  }

  /// "08:00 AM"
  String toTimeString() {
    return DateFormat('hh:mm a').format(this);
  }

  /// "Hôm nay" / "Ngày mai" / "Hôm qua" / date string
  String toRelativeString() {
    if (isToday)     return 'Hôm nay';
    if (isTomorrow)  return 'Ngày mai';
    if (isYesterday) return 'Hôm qua';
    return toVNShortDate();
  }

  /// Hiển thị deadline: "Hôm nay · 09:00" hoặc "25 Tháng Chạp · 08:00"
  String toDeadlineDisplay() {
    final datePart = toRelativeString();
    final timePart = DateFormat('HH:mm').format(this);
    return '$datePart · $timePart';
  }

  // ── Countdown đến Tết ────────────────────────────────────────

  /// Số ngày còn lại đến Tết (truyền vào ngày Tết)
  int daysUntil(DateTime target) {
    final now = DateTimeExtensions.nowVN;
    final diff = DateTime(target.year, target.month, target.day)
        .difference(DateTime(now.year, now.month, now.day));
    return diff.inDays;
  }

  // ── Grouping ─────────────────────────────────────────────────

  /// Key để group theo ngày: "2026-01-20"
  String get dayKey =>
      '${year.toString().padLeft(4, '0')}-'
          '${month.toString().padLeft(2, '0')}-'
          '${day.toString().padLeft(2, '0')}';
}