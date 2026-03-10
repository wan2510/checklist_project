import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppPreferences {
  AppPreferences._(this._prefs);

  final SharedPreferences _prefs;

  // ── Keys ─────────────────────────────────────────────────────
  static const String _keyDarkMode        = 'dark_mode';
  static const String _keyThemeColor      = 'theme_color';
  static const String _keyNotificationOn  = 'notification_on';
  static const String _keyDefaultReminder = 'default_reminder';
  static const String _keySoundOn         = 'sound_on';
  static const String _keyIsFirstLaunch   = 'is_first_launch';
  static const String _keyTetYear         = 'tet_year';
  static const String _keyUserName        = 'user_name';
  static const String _keyBirthday        = 'user_birthday';

  // ── Factory ──────────────────────────────────────────────────
  static Future<AppPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences._(prefs);
  }

  // ── Dark Mode ─────────────────────────────────────────────────
  bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;

  Future<void> setDarkMode(bool value) =>
      _prefs.setBool(_keyDarkMode, value);

  // ── Theme Color ───────────────────────────────────────────────
  Color get themeColor {
    final value = _prefs.getInt(_keyThemeColor);
    return value != null ? Color(value) : AppColors.primary;
  }

  Future<void> setThemeColor(Color color) =>
      _prefs.setInt(_keyThemeColor, color.value);

  // ── Notifications ─────────────────────────────────────────────
  bool get isNotificationOn =>
      _prefs.getBool(_keyNotificationOn) ?? true;

  Future<void> setNotificationOn(bool value) =>
      _prefs.setBool(_keyNotificationOn, value);

  String get defaultReminderTime =>
      _prefs.getString(_keyDefaultReminder) ?? '08:00';

  Future<void> setDefaultReminderTime(String time) =>
      _prefs.setString(_keyDefaultReminder, time);

  bool get isSoundOn => _prefs.getBool(_keySoundOn) ?? false;

  Future<void> setSoundOn(bool value) =>
      _prefs.setBool(_keySoundOn, value);

  // ── First Launch ──────────────────────────────────────────────
  bool get isFirstLaunch =>
      _prefs.getBool(_keyIsFirstLaunch) ?? true;

  Future<void> setIsFirstLaunch(bool value) =>
      _prefs.setBool(_keyIsFirstLaunch, value);

  // ── Tết Year ──────────────────────────────────────────────────
  int get tetYear => _prefs.getInt(_keyTetYear) ?? 2026;

  Future<void> setTetYear(int year) =>
      _prefs.setInt(_keyTetYear, year);

  // ── User Name ─────────────────────────────────────────────────
  String get userName =>                          //  sync, không cần await
  _prefs.getString(_keyUserName) ?? '';

  Future<void> setUserName(String name) =>
      _prefs.setString(_keyUserName, name);

  // ── Birthday ──────────────────────────────────────────────────
  String get birthday =>                          //  sync, không cần await
  _prefs.getString(_keyBirthday) ?? '';

  Future<void> setBirthday(String date) =>
      _prefs.setString(_keyBirthday, date);

  // ── Clear all ─────────────────────────────────────────────────
  Future<void> clearAll() => _prefs.clear();
}