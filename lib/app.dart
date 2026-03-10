import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'presentation/settings/settings_viewmodel.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<SettingsViewModel, bool>(
          (vm) => vm.isDarkMode,
    );
    final themeColor = context.select<SettingsViewModel, Color>(
          (vm) => vm.themeColor,
    );

    return MaterialApp.router(
      title:                      'Dọn Nhà Đón Tết',
      debugShowCheckedModeBanner: false,

      // ── Localization ──────────────────────────────────────
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Theme ─────────────────────────────────────────────
      theme:     AppTheme.lightTheme(themeColor),
      darkTheme: AppTheme.darkTheme(themeColor),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // ── Router ────────────────────────────────────────────
      routerConfig: AppRouter.router,
    );
  }
}