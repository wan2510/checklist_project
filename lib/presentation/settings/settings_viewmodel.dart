import 'package:flutter/material.dart';
import '../../data/local/preferences/app_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../data/local/database/app_database.dart';
import '../../di/injection_container.dart';

class SettingsViewModel extends ChangeNotifier {
  final AppPreferences _prefs;

  SettingsViewModel({required AppPreferences prefs}) : _prefs = prefs;

  // ── State ────────────────────────────────────────────────────
  bool   _isDarkMode       = false;
  Color  _themeColor       = AppColors.primary;
  bool   _isNotificationOn = true;
  bool   _isSoundOn        = false;
  String _defaultReminder  = '08:00';
  String _userName         = '';
  String _birthday         = '';

  // ── Getters ──────────────────────────────────────────────────
  bool   get isDarkMode       => _isDarkMode;
  Color  get themeColor       => _themeColor;
  bool   get isNotificationOn => _isNotificationOn;
  bool   get isSoundOn        => _isSoundOn;
  String get defaultReminder  => _defaultReminder;
  String get userName         => _userName;
  String get birthday         => _birthday;

  String get displayName =>
      _userName.isNotEmpty ? _userName : 'Bạn';

  // ── Init ─────────────────────────────────────────────────────
  Future<void> init() async {
    _isDarkMode       = _prefs.isDarkMode;
    _themeColor       = _prefs.themeColor;
    _isNotificationOn = _prefs.isNotificationOn;
    _isSoundOn        = _prefs.isSoundOn;
    _defaultReminder  = _prefs.defaultReminderTime;
    _userName         = _prefs.userName;
    _birthday         = _prefs.birthday;
  }

  // ── Dark Mode ────────────────────────────────────────────────
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setDarkMode(value);
    notifyListeners();
  }

  // ── Theme Color ──────────────────────────────────────────────
  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    await _prefs.setThemeColor(color);
    notifyListeners();
  }

  // ── Notifications ─────────────────────────────────────────────
  Future<void> setNotificationOn(bool value) async {
    _isNotificationOn = value;
    await _prefs.setNotificationOn(value);
    notifyListeners();
  }

  Future<void> setSoundOn(bool value) async {
    _isSoundOn = value;
    await _prefs.setSoundOn(value);
    notifyListeners();
  }

  Future<void> setDefaultReminder(String time) async {
    _defaultReminder = time;
    await _prefs.setDefaultReminderTime(time);
    notifyListeners();
  }

  // ── User profile ──────────────────────────────────────────────
  Future<void> setUserName(String v) async {
    _userName = v.trim();
    await _prefs.setUserName(v.trim());
    notifyListeners();
  }

  Future<void> setBirthday(String v) async {
    _birthday = v;
    await _prefs.setBirthday(v);
    notifyListeners();
  }

  // ── Clear all ─────────────────────────────────────────────────
  Future<void> clearAllData(VoidCallback onDone) async {
    final db = sl<AppDatabase>();
    await db.taskDao.deleteAllTasks();
    await _prefs.clearAll();
    onDone();
  }
}