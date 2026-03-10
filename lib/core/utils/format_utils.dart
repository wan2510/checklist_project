import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();

  /// "45/100 việc" → "45 / 100 việc hoàn thành"
  static String taskProgress(int done, int total) =>
      '$done / $total việc';

  /// 0.45 → "45%"
  static String percent(double value) =>
      '${(value * 100).toInt()}%';

  /// int 45 → "45%"
  static String percentInt(int value) => '$value%';

  /// Format số liệu thống kê
  static String statNumber(int value) =>
      NumberFormat('#,###').format(value);

  /// "08:00 AM"
  static String timeOfDay(DateTime dt) =>
      DateFormat('hh:mm a').format(dt);

  /// "20 tháng 1" – dùng trong list
  static String shortDate(DateTime dt) =>
      DateFormat('dd MMMM', 'vi_VN').format(dt);

  /// "HÔM NAY · 20 THÁNG CHẠP" – dùng trong group header
  static String groupHeader(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.day == now.day &&
        dt.month == now.month &&
        dt.year == now.year;

    final dateStr = DateFormat('dd MMMM', 'vi_VN').format(dt).toUpperCase();
    if (isToday) return 'HÔM NAY · $dateStr';

    final tomorrow = now.add(const Duration(days: 1));
    final isTomorrow = dt.day == tomorrow.day &&
        dt.month == tomorrow.month &&
        dt.year == tomorrow.year;
    if (isTomorrow) return 'NGÀY MAI · $dateStr';

    return dateStr;
  }

  /// Lời động viên dựa trên % hoàn thành
  static String motivationMessage(int percent) {
    if (percent < 50) return 'Cố lên! Tết đang đến gần! 🎉';
    if (percent < 80) return 'Tuyệt vời! Sắp xong rồi! 💪';
    return 'Xuất sắc! Nhà bạn sẵn sàng đón Tết! 🏮';
  }
}