class AppRoutes {
  AppRoutes._();

  static const String splash      = '/';
  static const welcome    = '/welcome';
  static const String home        = '/home';
  static const String roomList    = '/rooms';
  static const String roomDetail  = '/rooms/:roomType';
  static const String allTasks    = '/tasks';
  static const String taskDetail  = '/tasks/detail';
  static const String taskAdd     = '/tasks/add';
  static const String calendar    = '/calendar';
  static const String report      = '/report';
  static const String settings    = '/settings';

  // ── Helper build path ─────────────────────────────────────────
  static String roomDetailPath(String roomType) => '/rooms/$roomType';

  static String taskDetailPath(String taskId) =>
      '/tasks/detail?taskId=$taskId';
}