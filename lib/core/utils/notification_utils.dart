import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationUtils {
  NotificationUtils._();

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // ── Khởi tạo ─────────────────────────────────────────────────
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS:     iosSettings,
    );

    await _plugin.initialize(settings);
  }

  // ── Xin quyền (Android 13+) ───────────────────────────────────
  static Future<void> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    // Xin quyền hiển thị notification (Android 13+)
    await androidPlugin?.requestNotificationsPermission();

    // Nếu từ chối, app sẽ tự dùng inexact alarm làm fallback
    try {
      await androidPlugin?.requestExactAlarmsPermission();
    } catch (_) {
      // Một số phiên bản cũ của plugin không có method này — bỏ qua
    }
  }

  // ── Lên lịch nhắc nhở cho một task ───────────────────────────
  static Future<void> scheduleTaskReminder({
    required int      id,
    required String   taskName,
    required DateTime reminderTime,
  }) async {
    // Guard: không schedule nếu thời gian đã qua
    if (reminderTime.isBefore(DateTime.now())) {
      debugPrint('[Notification] Skipped: reminderTime is in the past ($reminderTime)');
      return;
    }

    final tz.Location vnLocation = tz.getLocation('Asia/Ho_Chi_Minh');
    final tz.TZDateTime scheduledTime =
    tz.TZDateTime.from(reminderTime, vnLocation);

    debugPrint('[Notification] Scheduling "$taskName" at $reminderTime (id=$id)');

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'task_reminders',
      'Nhắc nhở công việc',
      channelDescription: 'Thông báo nhắc nhở các công việc dọn nhà',
      importance: Importance.high,
      priority:   Priority.high,
      actions:    <AndroidNotificationAction>[
        AndroidNotificationAction('complete', 'Đánh dấu hoàn thành'),
        AndroidNotificationAction('snooze',   'Nhắc tôi sau'),
      ],
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    try {
      // Thử exact alarm trước (cần quyền SCHEDULE_EXACT_ALARM trên Android 12+)
      await _plugin.zonedSchedule(
        id,
        '⏰ Nhắc nhở: $taskName',
        'Đừng quên hoàn thành công việc này để đón Tết!',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      // Fallback: inexact alarm — không cần quyền đặc biệt
      // Thông báo có thể trễ vài phút nhưng vẫn hoạt động
      await _plugin.zonedSchedule(
        id,
        '⏰ Nhắc nhở: $taskName',
        'Đừng quên hoàn thành công việc này để đón Tết!',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // ── Hủy một notification ──────────────────────────────────────
  static Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  // ── Hủy tất cả ───────────────────────────────────────────────
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}