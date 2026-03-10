import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'core/utils/notification_utils.dart';
import 'data/local/database/app_database.dart';
// import 'data/local/database/seed/task_seed_data.dart';
import 'data/local/preferences/app_preferences.dart';
import 'di/injection_container.dart';
import 'presentation/settings/settings_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Orientation ───────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Timezone ──────────────────────────────────────────────────
  tz.initializeTimeZones();

  // ── Locale ────────────────────────────────────────────────────
  await initializeDateFormatting('vi_VN', null);

  // ── Notifications ─────────────────────────────────────────────
  await NotificationUtils.initialize();
  await NotificationUtils.requestPermission();

  // ── Dependency Injection ──────────────────────────────────────
  await setupDependencies();

//  // ── Seed data lần đầu ────────────────────────────────────────
//   await _seedDataIfFirstLaunch();
//
  runApp(
    ChangeNotifierProvider<SettingsViewModel>(
      create: (_) {
        final vm = sl<SettingsViewModel>();
        vm.init(); //  init trước, không await, không notify
        return vm;
      },
      child: const App(),
    ),
  );

//}

// Future<void> _seedDataIfFirstLaunch() async {
//   final prefs = sl<AppPreferences>();
//   final isFirst = await prefs.isFirstLaunch;
//   if (!isFirst) return;
//
//   try {
//     final db = sl<AppDatabase>();
//     await db.taskDao.insertTasks(TaskSeedData.samples);
//     await prefs.setIsFirstLaunch(false);
//     debugPrint('Seed data inserted: 9 tasks');
//   } catch (e) {
//     debugPrint('Seed error: $e');
//   }
}