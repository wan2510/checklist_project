import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../shared/dialogs/confirm_dialog.dart';
import 'settings_viewmodel.dart';
import 'widgets/color_picker_row.dart';
import 'widgets/settings_section.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({super.key, required this.viewModel});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {

  // ── Theme reveal animation ────────────────────────────────────
  late final AnimationController _revealCtrl;
  late final Animation<double>   _revealAnim;
  bool       _isAnimating       = false;
  bool       _revealDark        = false;
  bool?      _optimisticDark;            // FIX 1: giá trị switch ngay lập tức
  ThemeData? _targetTheme;               // theme đích  (Layer 2)
  ThemeData? _frozenTheme;               // theme CŨ bị đóng băng (Layer 1)

  void _handleDarkModeToggle(bool newValue) {
    final vm          = context.read<SettingsViewModel>();
    final frozenTheme = Theme.of(context);
    final targetTheme = newValue
        ? AppTheme.darkTheme(vm.themeColor)
        : AppTheme.lightTheme(vm.themeColor);

    setState(() {
      _isAnimating    = true;
      _revealDark     = newValue;
      _targetTheme    = targetTheme;
      _frozenTheme    = frozenTheme;
      // FIX 1: Bật switch ngay lập tức — không đợi animation xong
      _optimisticDark = newValue;
    });

    _revealCtrl.forward(from: 0).then((_) {
      // progress = 1.0 → Layer 2 che toàn màn hình → gọi setDarkMode
      vm.setDarkMode(newValue);

      // Layer 2 đang ở progress=1.0 → che toàn màn hình
      // Đợi scaffold thật paint xong với theme mới rồi xóa overlay tức thì
      // (không dùng AnimatedOpacity — nó tạo trạng thái trung gian gây flash)
      WidgetsBinding.instance.addPostFrameCallback((_) {   // frame N+1
        WidgetsBinding.instance.addPostFrameCallback((_) { // frame N+2: scaffold paint
          WidgetsBinding.instance.addPostFrameCallback((_) { // frame N+3: xóa an toàn
            if (!mounted) return;
            setState(() {
              _isAnimating    = false;
              _optimisticDark = null;
              _frozenTheme    = null;
              _targetTheme    = null;
            });
            _revealCtrl.reset();
          });
        });
      });
    });
  }

  Future<void> _showEditNameDialog(SettingsViewModel vm) async {
    final controller = TextEditingController(text: vm.userName);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardColor,                    // ✅
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        title: Text(
          'Tên người dùng',
          style: TextStyle(color: context.textPrimary),        // ✅
        ),
        content: TextField(
          controller:         controller,
          autofocus:          true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: context.textPrimary),        // ✅
          decoration: const InputDecoration(
            hintText:   'Nhập tên của bạn...',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              await vm.setUserName(controller.text);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBirthdayPicker(SettingsViewModel vm) async {
    final picked = await showDatePicker(
      context:     context,
      initialDate: DateTime(2000, 1, 1),
      firstDate:   DateTime(1940),
      lastDate:    DateTime.now(),
      helpText:    'Chọn ngày sinh',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary:   AppColors.primary,
            onPrimary: AppColors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
      await vm.setBirthday(formatted);
    }
  }

  @override
  void initState() {
    super.initState();
    _revealCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _revealAnim = CurvedAnimation(
      parent: _revealCtrl,
      curve:  Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.init();
    });
  }

  @override
  void dispose() {
    _revealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<SettingsViewModel>(
        builder: (_, vm, __) {
          // Không animate → render bình thường
          if (!_isAnimating || _targetTheme == null || _frozenTheme == null) {
            return Scaffold(
              backgroundColor: context.bgColor,
              body: _buildBody(vm),
            );
          }

          // ── Đang animate: 2 layer Scaffold chồng nhau ────────
          return Stack(
            children: [
              // Layer 1 — theme CŨ bị đóng băng (snapshot từ _frozenTheme)
              // FIX: bọc trong Theme(_frozenTheme) nên KHÔNG bị ảnh hưởng
              // khi MaterialApp đổi themeMode → không flash
              Theme(
                data: _frozenTheme!,
                child: Scaffold(
                  backgroundColor: _frozenTheme!.scaffoldBackgroundColor,
                  body: _buildBody(vm, _frozenTheme),
                ),
              ),

              // Layer 2 — theme mới, clip dần theo hướng
              AnimatedBuilder(
                animation: _revealAnim,
                builder: (_, __) => ClipRect(
                  clipper: _DirectionalClipper(
                    progress: _revealAnim.value,
                    fromTop:  _revealDark,
                  ),
                  // Theme bọc TOÀN BỘ Scaffold — không chỉ body
                  child: Theme(
                    data: _targetTheme!,
                    child: Scaffold(
                      backgroundColor:
                      _targetTheme!.scaffoldBackgroundColor,
                      body: _buildBody(vm, _targetTheme),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(SettingsViewModel vm, [ThemeData? themeOverride]) {
    // FIX 2: Đọc isDark từ themeOverride (không phải context)
    // → icon và màu sắc của từng layer đúng với theme của layer đó
    final effectiveIsDark = themeOverride != null
        ? themeOverride.brightness == Brightness.dark
        : context.isDark;
    // FIX 1: dùng _optimisticDark cho switch value nếu đang animate
    final switchValue = _optimisticDark ?? vm.isDarkMode;

    return Column(
      children: [
        _buildPlainAppBar(themeOverride),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spaceSM),

                // ── User profile ───────────────────────────────────
                SettingsSection(
                  title: 'CÀI ĐẶT NGƯỜI DÙNG',
                  children: [
                    SettingsTile(
                      icon:        Icons.person_outline_rounded,
                      iconColor:   AppColors.primary,
                      iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                      title:       'Tên người dùng',
                      subtitle:    vm.userName.isNotEmpty
                          ? vm.userName
                          : 'Chưa đặt tên',
                      onTap: () => _showEditNameDialog(vm),
                    ),
                    SettingsTile(
                      icon:        Icons.cake_outlined,
                      iconColor:   AppColors.secondary,
                      iconBgColor: AppColors.secondary.withValues(alpha: 0.1),
                      title:       'Ngày sinh',
                      subtitle:    vm.birthday.isNotEmpty
                          ? vm.birthday
                          : 'Chưa cài đặt',
                      onTap: () => _showBirthdayPicker(vm),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                // ── Notifications ──────────────────────────────────
                SettingsSection(
                  title: AppStrings.settingsNotification,
                  children: [
                    SettingsToggleTile(
                      icon:        Icons.notifications_outlined,
                      iconColor:   AppColors.primary,
                      iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                      title:       AppStrings.settingsAllowNotif,
                      subtitle:    AppStrings.settingsAllowNotifSub,
                      value:       vm.isNotificationOn,
                      onChanged:   vm.setNotificationOn,
                    ),
                    SettingsToggleTile(
                      icon:        Icons.alarm_outlined,
                      iconColor:   AppColors.secondary,
                      iconBgColor: AppColors.secondary.withValues(alpha: 0.1),
                      title:       AppStrings.settingsDefaultReminder,
                      subtitle:    AppStrings.settingsDefaultReminderSub,
                      value:       true,
                      onChanged:   (_) => _showTimePicker(vm),
                    ),
                    SettingsToggleTile(
                      icon:        Icons.volume_up_outlined,
                      iconColor:   AppColors.accent,
                      iconBgColor: AppColors.accent.withValues(alpha: 0.1),
                      title:       AppStrings.settingsSound,
                      subtitle:    AppStrings.settingsSoundSub,
                      value:       vm.isSoundOn,
                      onChanged:   vm.setSoundOn,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                // ── UI ─────────────────────────────────────────────
                SettingsSection(
                  title: AppStrings.settingsUI,
                  children: [
                    SettingsToggleTile(
                      icon:        Icons.dark_mode_outlined,
                      // FIX 2: màu icon theo theme của layer đang render
                      iconColor:   effectiveIsDark
                          ? AppColors.white
                          : AppColors.grey700,
                      iconBgColor: effectiveIsDark
                          ? AppColors.grey700
                          : AppColors.grey200,
                      title:       AppStrings.settingsDarkMode,
                      subtitle:    AppStrings.settingsDarkModeSub,
                      // FIX 1: switch bật ngay lập tức
                      value:       switchValue,
                      onChanged:   _handleDarkModeToggle,
                    ),
                    ColorPickerRow(
                      selected:  vm.themeColor,
                      onChanged: vm.setThemeColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                // ── Data ───────────────────────────────────────────
                SettingsSection(
                  title: AppStrings.settingsData,
                  children: [
                    SettingsTile(
                      icon:        Icons.cloud_upload_outlined,
                      iconColor:   AppColors.statusInProgress,
                      iconBgColor: AppColors.statusInProgress.withValues(alpha: 0.1),
                      title:       AppStrings.settingsBackup,
                      subtitle:    AppStrings.settingsBackupSub,
                      onTap:       () => _showComingSoon('Sao lưu & Phục hồi'),
                    ),
                    SettingsTile(
                      icon:        Icons.file_download_outlined,
                      iconColor:   AppColors.statusDone,
                      iconBgColor: AppColors.statusDone.withValues(alpha: 0.1),
                      title:       AppStrings.settingsExport,
                      subtitle:    AppStrings.settingsExportSub,
                      onTap:       () => _showComingSoon('Xuất dữ liệu'),
                    ),
                    SettingsTile(
                      icon:        Icons.refresh_rounded,
                      iconColor:   AppColors.secondary,
                      iconBgColor: AppColors.secondary.withValues(alpha: 0.1),
                      title:       AppStrings.settingsRefresh,
                      subtitle:    AppStrings.settingsRefreshSub,
                      onTap:       () => _confirmRefresh(vm),
                    ),
                    SettingsTile(
                      icon:        Icons.delete_forever_outlined,
                      iconColor:   AppColors.statusOverdue,
                      iconBgColor: AppColors.statusOverdue.withValues(alpha: 0.1),
                      title:       AppStrings.settingsDeleteAll,
                      subtitle:    AppStrings.settingsDeleteAllSub,
                      isDanger:    true,
                      onTap:       () => _confirmDeleteAll(vm),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                // ── About ──────────────────────────────────────────
                SettingsSection(
                  title: AppStrings.settingsAbout,
                  children: [
                    SettingsTile(
                      icon:        Icons.menu_book_outlined,
                      iconColor:   AppColors.accent,
                      iconBgColor: AppColors.accent.withValues(alpha: 0.1),
                      title:       AppStrings.settingsGuide,
                      subtitle:    AppStrings.settingsGuideSub,
                      onTap:       () => _showComingSoon('Hướng dẫn sử dụng'),
                    ),
                    SettingsTile(
                      icon:        Icons.chat_bubble_outline_rounded,
                      iconColor:   AppColors.primary,
                      iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                      title:       AppStrings.settingsFeedback,
                      subtitle:    AppStrings.settingsFeedbackSub,
                      onTap:       () => _showComingSoon('Liên hệ & Góp ý'),
                    ),
                    SettingsTile(
                      icon:        Icons.info_outline_rounded,
                      iconColor:   AppColors.grey600,
                      iconBgColor: context.isDark
                          ? AppColors.grey700
                          : AppColors.grey200,                     // ✅
                      title:       AppStrings.settingsVersion,
                      subtitle:    null,
                      trailing:    _buildVersionBadge(),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXXL),

                _buildFooter(),
                const SizedBox(height: AppDimensions.space80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildPlainAppBar([ThemeData? themeOverride]) {
    final theme        = themeOverride ?? Theme.of(context);
    final isDark       = theme.brightness == Brightness.dark;
    final surfaceColor = theme.scaffoldBackgroundColor;
    final textColor    = theme.appBarTheme.foregroundColor
        ?? (isDark ? Colors.white : const Color(0xFF1A1A1A));
    final dividerColor = theme.dividerColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Safe area top
        SizedBox(height: MediaQuery.of(context).padding.top),
        Container(
          color: surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: textColor, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                AppStrings.settingsTitle,
                style: AppTextStyles.headlineSmall.copyWith(color: textColor),
              ),
            ],
          ),
        ),
        Container(height: 1, color: dividerColor),
      ],
    );
  }

  // ── Version badge ─────────────────────────────────────────────
  Widget _buildVersionBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.settingsVersionValue,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceSM,
            vertical:   2,
          ),
          decoration: BoxDecoration(
            color:        AppColors.statusDone.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text(
            AppStrings.settingsNewVersion,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.statusDone,
            ),
          ),
        ),
      ],
    );
  }

  // ── Footer ────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width:  52,
            height: 52,
            decoration: BoxDecoration(
              gradient:     AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: const Icon(
              Icons.cleaning_services_rounded,
              color: AppColors.white,
              size:  28,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMD),
          Text(
            AppStrings.appName,
            style: AppTextStyles.titleLarge.copyWith(
              color: context.textPrimary,                      // ✅
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Text(
            AppStrings.settingsFooter,
            style: AppTextStyles.bodySmall.copyWith(
              color:     AppColors.grey500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Handlers ──────────────────────────────────────────────────

  Future<void> _showTimePicker(SettingsViewModel vm) async {
    final parts   = vm.defaultReminder.split(':');
    final initial = TimeOfDay(
      hour:   int.tryParse(parts[0]) ?? 8,
      minute: int.tryParse(parts[1]) ?? 0,
    );

    final picked = await showTimePicker(
      context:     context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary:   AppColors.primary,
            onPrimary: AppColors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final timeStr =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
      await vm.setDefaultReminder(timeStr);
    }
  }

  Future<void> _confirmRefresh(SettingsViewModel vm) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:        'Làm mới ứng dụng?',
      content:      'Thao tác này sẽ xóa cache và tải lại dữ liệu. '
          'Dữ liệu của bạn sẽ không bị mất.',
      confirmLabel: 'Làm mới',
    );
    if (confirmed && mounted) {
      _showSnackBar('✅ Đã làm mới ứng dụng!');
    }
  }

  Future<void> _confirmDeleteAll(SettingsViewModel vm) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:        '🗑️ Xóa tất cả dữ liệu?',
      content:      'Toàn bộ công việc, tiến độ và cài đặt sẽ bị xóa '
          'vĩnh viễn. Hành động này KHÔNG THỂ hoàn lại!',
      confirmLabel: 'Xóa tất cả',
      isDangerous:  true,
    );
    if (confirmed) {
      await vm.clearAllData(() {
        if (mounted) {
          _showSnackBar('🗑️ Đã xóa toàn bộ dữ liệu.');
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }
  }

  void _showComingSoon(String feature) {
    showModalBottomSheet(
      context:         context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ComingSoonSheet(feature: feature),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(message),
        backgroundColor: AppColors.grey800,
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        margin: const EdgeInsets.all(AppDimensions.spaceLG),
      ),
    );
  }
}

// ── Coming soon bottom sheet ──────────────────────────────────────
class _ComingSoonSheet extends StatelessWidget {
  final String feature;

  const _ComingSoonSheet({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,                       // ✅
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:  40,
            height: 4,
            decoration: BoxDecoration(
              color:        context.isDark
                  ? AppColors.grey600
                  : AppColors.grey300,                         // ✅
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          Container(
            width:  72,
            height: 72,
            decoration: BoxDecoration(
              gradient:     AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: const Icon(
              Icons.rocket_launch_outlined,
              color: AppColors.white,
              size:  36,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLG),

          Text(
            'Tính năng sắp ra mắt!',
            style: AppTextStyles.headlineSmall.copyWith(
              color: context.textPrimary,                      // ✅
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            '"$feature" đang được phát triển và sẽ có mặt '
                'trong phiên bản tiếp theo. Cảm ơn bạn đã chờ đợi! 🚀',
            style: AppTextStyles.bodyMedium.copyWith(
              color:  AppColors.grey500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXXL),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
              ),
              child: const Text('Đã hiểu'),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
        ],
      ),
    );
  }
}

// ── Directional reveal clipper ────────────────────────────────────
// fromTop=true  → clip mở rộng từ trên xuống (chế độ tối bao xuống)
// fromTop=false → clip mở rộng từ dưới lên  (chế độ sáng bao lên)
class _DirectionalClipper extends CustomClipper<Rect> {
  final double progress; // 0.0 → 1.0
  final bool   fromTop;

  const _DirectionalClipper({
    required this.progress,
    required this.fromTop,
  });

  @override
  Rect getClip(Size size) {
    final revealH = size.height * progress;
    if (fromTop) {
      // Bắt đầu từ đỉnh, ăn dần xuống
      return Rect.fromLTWH(0, 0, size.width, revealH);
    } else {
      // Bắt đầu từ đáy, ăn dần lên
      return Rect.fromLTWH(
          0, size.height - revealH, size.width, revealH);
    }
  }

  @override
  bool shouldReclip(_DirectionalClipper old) =>
      old.progress != progress || old.fromTop != fromTop;
}