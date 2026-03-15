import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'core/utils/notification_utils.dart';
import 'di/injection_container.dart';
import 'presentation/settings/settings_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Orientation─────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Timezone ──────────────────────────
  tz.initializeTimeZones();

  // ── Locale────────────────────────────────
  await initializeDateFormatting('vi_VN', null);

  // ── Dependency Injection (DB + Prefs) ────────────
  // await trước runApp để DI sẵn sàng,
  // Notification init chuyển sang chạy song song
  await setupDependencies();

  // ── runApp ngay — SplashScreen sẽ hiện trong lúc chờ ─────────
  runApp(
    ChangeNotifierProvider<SettingsViewModel>(
      create: (_) {
        final vm = sl<SettingsViewModel>();
        vm.init(); // không await, không block UI
        return vm;
      },
      child: const App(),
    ),
  );

  // ── Notification init SAU khi UI đã render ────────────────────
  // Splash screen kéo dài 2.5s — đủ thời gian init notification
  await NotificationUtils.initialize();
  await NotificationUtils.requestPermission();
}