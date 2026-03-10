class TetDateUtils {
  TetDateUtils._();

  /// Ngày Tết cố định cho các năm (Âm lịch → Dương lịch)
  static final Map<int, DateTime> _tetDates = {
    2024: DateTime(2024, 2, 10), // Giáp Thìn
    2025: DateTime(2025, 1, 29), // Ất Tỵ
    2026: DateTime(2026, 2, 17), // Bính Ngọ
    2027: DateTime(2027, 2, 6),  // Đinh Mùi
    2028: DateTime(2028, 1, 26), // Mậu Thân
    2029: DateTime(2029, 2, 13), // Kỷ Dậu
  };

  static final Map<int, String> _zodiacNames = {
    2024: 'Giáp Thìn',
    2025: 'Ất Tỵ',
    2026: 'Bính Ngọ',
    2027: 'Đinh Mùi',
    2028: 'Mậu Thân',
    2029: 'Kỷ Dậu',
  };

  static final Map<int, String> _zodiacAnimals = {
    2024: '🐉', // Rồng
    2025: '🐍', // Rắn
    2026: '🐴', // Ngựa
    2027: '🐐', // Dê
    2028: '🐒', // Khỉ
    2029: '🐓', // Gà
  };

  /// Lấy DateTime Tết sắp tới (chưa qua)
  static DateTime get nextTetDate {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final today = DateTime(now.year, now.month, now.day);

    // Tìm Tết gần nhất chưa qua
    final sorted = _tetDates.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (final entry in sorted) {
      if (!entry.value.isBefore(today)) {
        return entry.value;
      }
    }

    // Fallback: +1 năm
    return DateTime(now.year + 1, 2, 1);
  }

  static int get nextTetYear => nextTetDate.year;

  static String get tetName =>
      'Tết ${_zodiacNames[nextTetYear] ?? nextTetYear.toString()}';

  static String get tetAnimal =>
      _zodiacAnimals[nextTetYear] ?? '🏮';

  static String get tetFullTitle =>
      '${tetName} ${nextTetYear} ${tetAnimal}';

  static int get daysUntilTet {
    final now   = DateTime.now().toUtc().add(const Duration(hours: 7));
    final today = DateTime(now.year, now.month, now.day);
    final tet   = nextTetDate;
    final diff  = tet.difference(today).inDays;
    return diff < 0 ? 0 : diff;
  }

  static String get countdownLabel {
    final days = daysUntilTet;
    if (days == 0)  return 'Chúc mừng năm mới! 🎊';
    if (days == 1)  return 'Ngày mai là Tết rồi! 🎉';
    if (days <= 7)  return 'Còn $days ngày nữa là Tết!';
    if (days <= 30) return 'Còn $days ngày đến $tetName';
    return 'Còn $days ngày đến $tetName';
  }

  static double get timeElapsedPercent {
    final now       = DateTime.now().toUtc().add(const Duration(hours: 7));
    final prevTet   = DateTime(nextTetYear - 1, 2, 1);
    final total     = nextTetDate.difference(prevTet).inDays.toDouble();
    final elapsed   = now.difference(prevTet).inDays.toDouble();
    return (elapsed / total).clamp(0.0, 1.0);
  }
}