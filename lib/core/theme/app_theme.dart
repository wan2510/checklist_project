import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ── Helper: build TextTheme theo màu chữ ─────────────────────
  // Vì AppTextStyles không còn hardcode color, theme cần cấp màu
  // cho từng style tương ứng qua textTheme
  static TextTheme _buildTextTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      // Display / Headline / Title primary → primaryText
      displayLarge:  AppTextStyles.displayLarge.copyWith(color: primaryText),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: primaryText),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: primaryText),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: primaryText),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: primaryText),
      titleLarge:    AppTextStyles.titleLarge.copyWith(color: primaryText),
      titleMedium:   AppTextStyles.titleMedium.copyWith(color: primaryText),
      titleSmall:    AppTextStyles.titleSmall,   // giữ nguyên grey500
      bodyLarge:     AppTextStyles.bodyLarge.copyWith(color: primaryText),
      bodyMedium:    AppTextStyles.bodyMedium.copyWith(color: primaryText),
      bodySmall:     AppTextStyles.bodySmall,    // giữ nguyên grey500
      labelLarge:    AppTextStyles.labelLarge.copyWith(color: primaryText),
      labelMedium:   AppTextStyles.labelMedium,  // giữ nguyên grey500
      labelSmall:    AppTextStyles.labelSmall,   // giữ nguyên grey500
    );
  }

  // ── Light Theme ──────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary:          AppColors.primary,
        primaryContainer: AppColors.primaryLight.withValues(alpha: 0.15),
        secondary:        AppColors.secondary,
        surface:          AppColors.surfaceLight,
        onPrimary:        AppColors.white,
        onSurface:        AppColors.textPrimaryLight,
        error:            AppColors.statusOverdue,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // FIX: textTheme với màu chữ SÁNG → DefaultTextStyle đúng cho light mode
      textTheme: _buildTextTheme(
        AppColors.textPrimaryLight,
        AppColors.textSecondaryLight,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor:        AppColors.white,
        foregroundColor:        AppColors.textPrimaryLight,
        elevation:              0,
        scrolledUnderElevation: 1,
        centerTitle:            false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:          Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        color:     AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor:   AppColors.primary.withValues(alpha: 0.15),
        labelStyle:      AppTextStyles.labelMedium,
        side:            BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation:       0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:   const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.titleMedium,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle:       AppTextStyles.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: AppColors.grey100,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color:     AppColors.grey200,
        thickness: 1,
        space:     1,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.white
              : AppColors.grey400,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.grey300,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:     AppColors.white,
        selectedItemColor:   AppColors.primary,
        unselectedItemColor: AppColors.grey400,
        elevation:           8,
        type:                BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w400,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation:       4,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        side: const BorderSide(
          color: AppColors.grey400,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      fontFamily: 'Roboto',
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────
  static ThemeData get dark {
    return light.copyWith(
      brightness:             Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // FIX: textTheme với màu chữ TRẮNG → tất cả Text dùng AppTextStyles
      // sẽ tự động hiển thị trắng trong dark mode
      textTheme: _buildTextTheme(
        AppColors.textPrimaryDark,   // trắng nhạt
        AppColors.textSecondaryDark, // xám nhạt
      ),

      colorScheme: ColorScheme.dark(
        primary:          AppColors.primary,
        primaryContainer: AppColors.primaryDark.withValues(alpha: 0.3),
        secondary:        AppColors.secondary,
        surface:          AppColors.surfaceDark,
        onPrimary:        AppColors.white,
        onSurface:        AppColors.textPrimaryDark,
        error:            AppColors.statusOverdue,
      ),
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:          Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: light.cardTheme.copyWith(
        color: AppColors.cardDark,
      ),
      inputDecorationTheme: light.inputDecorationTheme.copyWith(
        fillColor: AppColors.grey800,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey600,
        ),
      ),
      bottomNavigationBarTheme: light.bottomNavigationBarTheme.copyWith(
        backgroundColor:     AppColors.surfaceDark,
        unselectedItemColor: AppColors.grey600,
      ),
      dividerTheme: const DividerThemeData(
        color:     AppColors.grey700,
        thickness: 1,
        space:     1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.white
              : AppColors.grey600,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.grey700,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : Colors.transparent,
        ),
        side: const BorderSide(
          color: AppColors.grey600,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // ── Helper: lighten a color ───────────────────────────────────
  // Tạo phiên bản sáng hơn của màu chủ đề để dùng trong gradient
  static Color lighten(Color color, [double amount = 0.2]) =>
      Color.lerp(color, Colors.white, amount)!;

  // ── Static methods cho app.dart ───────────────────────────────
  static ThemeData lightTheme([Color? primaryColor]) {
    if (primaryColor == null || primaryColor == AppColors.primary) {
      return light;
    }
    return light.copyWith(
      colorScheme: light.colorScheme.copyWith(primary: primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          elevation:       0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:   const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle:       AppTextStyles.labelLarge,
        ),
      ),
      inputDecorationTheme: light.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: light.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primaryColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
        elevation:       4,
      ),
      chipTheme: light.chipTheme.copyWith(
        selectedColor: primaryColor.withValues(alpha: 0.15),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? primaryColor
              : Colors.transparent,
        ),
        side: const BorderSide(color: AppColors.grey400, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.white : AppColors.grey400,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? primaryColor : AppColors.grey300,
        ),
      ),
    );
  }

  static ThemeData darkTheme([Color? primaryColor]) {
    if (primaryColor == null || primaryColor == AppColors.primary) {
      return dark;
    }
    return dark.copyWith(
      colorScheme: dark.colorScheme.copyWith(primary: primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          elevation:       0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:   const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle:       AppTextStyles.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: dark.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primaryColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
        elevation:       4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? AppColors.white : AppColors.grey600,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? primaryColor : AppColors.grey700,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? primaryColor : Colors.transparent,
        ),
        side: const BorderSide(color: AppColors.grey600, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}