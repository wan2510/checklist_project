import 'package:flutter/material.dart';
import '../../data/local/preferences/app_preferences.dart';
import '../../routes/app_routes.dart';

class SplashViewModel extends ChangeNotifier {
  final AppPreferences _prefs;

  SplashViewModel(this._prefs);

  bool get isFirstLaunch => _prefs.isFirstLaunch;

  /// Gọi sau 2.5s → trả về route tiếp theo
  Future<String> getNextRoute() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    return AppRoutes.welcome;
  }
}