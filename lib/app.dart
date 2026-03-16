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
    // FIX TIẾNG VIỆT:
    // Tách select isDarkMode và themeColor thành 2 Selector độc lập.
    // Mỗi Selector chỉ rebuild _MaterialAppWrapper khi đúng giá trị đó thay đổi.
    // Quan trọng: Selector so sánh bằng == trước khi rebuild.
    // Trước đây dùng context.select trong cùng 1 build() → bất kỳ notify nào
    // từ SettingsViewModel cũng có thể trigger rebuild MaterialApp → IME mất.
    return Selector2<SettingsViewModel, SettingsViewModel, _ThemeConfig>(
      selector: (_, vm, __) => _ThemeConfig(
        isDark:     vm.isDarkMode,
        themeColor: vm.themeColor,
      ),
      // shouldRebuild: chỉ rebuild khi isDark hoặc themeColor thực sự thay đổi
      shouldRebuild: (prev, next) =>
      prev.isDark != next.isDark ||
          prev.themeColor != next.themeColor,
      builder: (_, config, __) => MaterialApp.router(
        title:                      'Dọn Nhà Đón Tết',
        debugShowCheckedModeBanner: false,

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

        theme:      AppTheme.lightTheme(config.themeColor),
        darkTheme:  AppTheme.darkTheme(config.themeColor),
        themeMode:  config.isDark ? ThemeMode.dark : ThemeMode.light,

        routerConfig: AppRouter.router,
      ),
    );
  }
}

// Value object để Selector2 so sánh đúng
class _ThemeConfig {
  final bool  isDark;
  final Color themeColor;

  const _ThemeConfig({required this.isDark, required this.themeColor});

  @override
  bool operator ==(Object other) =>
      other is _ThemeConfig &&
          other.isDark == isDark &&
          other.themeColor == themeColor;

  @override
  int get hashCode => Object.hash(isDark, themeColor);
}