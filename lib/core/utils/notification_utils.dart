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

    await androidPlugin?.requestNotificationsPermission();
  }

  // ── Lên lịch nhắc nhở cho một task ───────────────────────────
  static Future<void> scheduleTaskReminder({
    required int      id,
    required String   taskName,
    required DateTime reminderTime,
  }) async {
    final tz.Location vnLocation = tz.getLocation('Asia/Ho_Chi_Minh');
    final tz.TZDateTime scheduledTime =
    tz.TZDateTime.from(reminderTime, vnLocation);

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