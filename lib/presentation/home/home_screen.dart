import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../shared/dialogs/add_task_bottom_sheet.dart';
import '../shared/widgets/app_progress_bar.dart';
import '../shared/widgets/fab_add_button.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/section_header.dart';
import 'home_viewmodel.dart';
import 'widgets/countdown_banner.dart';
import 'widgets/explore_grid.dart';
import 'widgets/quick_stats_row.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;
  const HomeScreen({super.key, required this.viewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {

  // ── Entrance animations ──────────────────────────────────────
  late final AnimationController _entranceCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  // ── Lantern swing animations ─────────────────────────────────
  late final AnimationController _lanternCtrl;
  late final Animation<double>   _lanternSwing;

  @override
  void initState() {
    super.initState();

    // Entrance: fade + slide up khi màn hình load
    _entranceCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim  = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    // Đèn lồng lắc nhẹ
    _lanternCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _lanternSwing = Tween<double>(begin: -0.07, end: 0.07)
        .animate(CurvedAnimation(parent: _lanternCtrl, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.init();
      _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _lanternCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: context.bgColor,
          body: vm.isLoading
              ? const LoadingWidget(message: 'Đang tải dữ liệu...')
              : _buildBody(vm),
          floatingActionButton: FabAddButton(
            onPressed: () => AddTaskBottomSheet.show(
              context,
              onTaskAdded: vm.refresh,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HomeViewModel vm) {
    return RefreshIndicator(
      color:     Theme.of(context).colorScheme.primary,
      onRefresh: vm.refresh,
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(vm),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.spaceLG),

                // ── Entrance animation bọc toàn bộ nội dung ───
                FadeTransition(
                  opacity: _fadeAnim,
                  child:   SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CountdownBanner(daysLeft: vm.daysUntilTet),
                        const SizedBox(height: AppDimensions.spaceXXL),

                        _buildOverallProgress(vm),
                        const SizedBox(height: AppDimensions.spaceXXL),

                        // ── Thống kê nhanh ──────────────────
                        _buildSectionRow(
                          title:    AppStrings.quickStats,
                          action:   AppStrings.viewAll,
                          onAction: () => context.go(AppRoutes.allTasks),
                        ),
                        const SizedBox(height: AppDimensions.spaceLG),
                        QuickStatsRow(
                          todayCount:        vm.todayCount,
                          highPriorityCount: vm.highPriorityCount,
                          overdueCount:      vm.overdueCount,
                        ),
                        const SizedBox(height: AppDimensions.spaceXXL),

                        // ── Khám phá ────────────────────────
                        _buildSectionRow(title: AppStrings.explore),
                        const SizedBox(height: AppDimensions.spaceLG),
                        _buildExploreWithDeco(vm),
                        const SizedBox(height: AppDimensions.spaceXXL),

                        // ── Câu quote Tết ──────────────────
                        _buildQuoteCard(vm),
                        const SizedBox(height: AppDimensions.spaceLG),

                        // ── Tips Tết nhỏ ───────────────────
                        _buildTetTipsRow(),
                        const SizedBox(height: AppDimensions.space80),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar với đèn lồng ──────────────────────────────────────
  Widget _buildSliverAppBar(HomeViewModel vm) {
    final primary = Theme.of(context).colorScheme.primary;
    final pLight  = Color.lerp(primary, Colors.white, 0.25)!;

    return SliverAppBar(
      floating:        true,
      snap:            true,
      backgroundColor: context.bgColor,
      elevation:       0,
      titleSpacing:    AppDimensions.screenPaddingH,
      title: Row(
        children: [
          // Icon gradient theo theme
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, pLight],
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: const Icon(Icons.cleaning_services_rounded,
                color: AppColors.white, size: 20),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Text(
            AppStrings.homeTitle,
            style: AppTextStyles.headlineMedium.copyWith(
                color: context.textPrimary),
          ),
        ],
      ),
      actions: [
        // ── Đèn lồng nhỏ lắc lư ──
        AnimatedBuilder(
          animation: _lanternSwing,
          builder: (_, __) => Transform.rotate(
            angle:  _lanternSwing.value,
            origin: const Offset(0, -12),
            child:  _MiniLantern(color: primary),
          ),
        ),
        const SizedBox(width: 6),
        AnimatedBuilder(
          animation: _lanternSwing,
          builder: (_, __) => Transform.rotate(
            angle:  -_lanternSwing.value * 0.7,
            origin: const Offset(0, -12),
            child:  _MiniLantern(
              color:  AppColors.secondary,
              scale:  0.85,
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: Icon(Icons.settings_outlined, color: context.textPrimary),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }

  // ── Section row (title + optional action) ────────────────────
  Widget _buildSectionRow({
    required String title,
    String?         action,
    VoidCallback?   onAction,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        // Accent bar
        Container(
          width:  3,
          height: 16,
          decoration: BoxDecoration(
            color:        primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSM),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
              color: context.textPrimary),
        ),
        const Spacer(),
        if (action != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: AppTextStyles.labelMedium.copyWith(color: primary),
            ),
          ),
      ],
    );
  }

  // ── Overall progress card ────────────────────────────────────
  Widget _buildOverallProgress(HomeViewModel vm) {
    final primary = Theme.of(context).colorScheme.primary;
    final percent = vm.stats.completionPercent;
    final done    = vm.stats.completedTasks;
    final total   = vm.stats.totalTasks;
    final overdue = vm.overdueCount;
    final isDone  = percent == 100;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: context.isDark
                ? Colors.black26
                : AppColors.grey300.withValues(alpha: 0.4),
            blurRadius: 10,
            offset:     const Offset(0, 3),
          ),
        ],
        // Viền gradient nhẹ khi hoàn thành
        border: isDone
            ? Border.all(
          color: AppColors.statusDone.withValues(alpha: 0.4),
          width: 1.5,
        )
            : Border.all(
          color: context.dividerColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Label với icon
              HugeIcon(
                icon:  HugeIcons.strokeRoundedTarget01,
                color: isDone ? AppColors.statusDone : primary,
                size:  16,
              ),
              const SizedBox(width: AppDimensions.spaceXS),
              Text(
                AppStrings.overallProgress,
                style: AppTextStyles.titleSmall.copyWith(
                  color:         context.isDark ? AppColors.grey400 : AppColors.grey500,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // Percent badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color:        (isDone ? AppColors.statusDone : primary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '$percent%',
                  style: AppTextStyles.labelMedium.copyWith(
                    color:      isDone ? AppColors.statusDone : primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Progress bar với animation
          AppProgressBar(
            value:     percent / 100,
            height:    8,
            fillColor: isDone ? AppColors.statusDone : primary,
            animated:  true,
          ),
          const SizedBox(height: AppDimensions.spaceMD),

          // Footer row
          Row(
            children: [
              // Done count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:        context.isDark
                      ? AppColors.grey800
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  '$done / $total ${AppStrings.taskDone}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color:      context.isDark ? AppColors.grey400 : AppColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              if (overdue > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 13, color: AppColors.statusOverdue),
                    const SizedBox(width: 3),
                    Text(
                      '$overdue quá hạn',
                      style: AppTextStyles.bodySmall.copyWith(
                        color:      AppColors.statusOverdue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              if (isDone)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 14, color: AppColors.statusDone),
                    const SizedBox(width: 3),
                    Text(
                      'Hoàn thành!',
                      style: AppTextStyles.bodySmall.copyWith(
                        color:      AppColors.statusDone,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quote card Tết ───────────────────────────────────────────
  Widget _buildQuoteCard(HomeViewModel vm) {
    final primary    = Theme.of(context).colorScheme.primary;
    final daysLeft   = vm.daysUntilTet;
    final isUrgent   = daysLeft <= 7;
    final isNear     = daysLeft <= 15;

    // Câu quote thay đổi theo số ngày còn lại
    final quote = isUrgent
        ? '🔥 Chỉ còn $daysLeft ngày! Nước rút thôi nào!'
        : isNear
        ? '⏰ Còn $daysLeft ngày nữa là Tết. Cố lên một chút nhé!'
        : AppStrings.homeQuote;

    final quoteColor = isUrgent
        ? AppColors.statusOverdue
        : isNear
        ? AppColors.secondary
        : primary;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color:        context.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: quoteColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width:  32,
            height: 32,
            decoration: BoxDecoration(
              color:        quoteColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Center(
              child: HugeIcon(
                icon:  HugeIcons.strokeRoundedQuoteDown,
                color: quoteColor,
                size:  16,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),
          Expanded(
            child: Text(
              quote,
              style: AppTextStyles.bodySmall.copyWith(
                color:     context.isDark ? AppColors.grey400 : AppColors.grey600,
                height:    1.65,
                fontStyle: isUrgent || isNear ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Explore grid với hoa trang trí xung quanh ───────────────
  Widget _buildExploreWithDeco(HomeViewModel vm) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ExploreGrid(
          onRoomList: () => context.go(AppRoutes.roomList),
          onAllTasks: () => context.go(AppRoutes.allTasks),
          onCalendar: () => context.go(AppRoutes.calendar),
          onReport:   () => context.go(AppRoutes.report),
        ),
        // Hoa đào góc trên phải
        const Positioned(
          top:   -8,
          right: -6,
          child: _TetFlower(size: 28, color: Color(0xFFFFB6C1), rotation: 0.3),
        ),
        // Hoa mai góc dưới trái
        const Positioned(
          bottom: -6,
          left:   -4,
          child: _TetFlower(size: 22, color: Color(0xFFFFD700), rotation: -0.5),
        ),
        // Hoa đào nhỏ giữa-phải
        const Positioned(
          top:   80,
          right: -8,
          child: _TetFlower(size: 18, color: Color(0xFFFF9BB5), rotation: 1.1),
        ),
      ],
    );
  }

  // ── Tips nhỏ cuối trang ──────────────────────────────────────
  Widget _buildTetTipsRow() {
    final primary = Theme.of(context).colorScheme.primary;
    final tips = [
      ('🌸', 'Dọn từ\ntrên xuống'),
      ('🌿', 'Thông thoáng\ncửa sổ'),
      ('✨', 'Bắt đầu\ntừ phòng khách'),
    ];
    return Row(
      children: tips.map((tip) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withValues(alpha: 0.06),
                  primary.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end:   Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              border: Border.all(
                color: primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tip.$1, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                Text(
                  tip.$2,
                  style: AppTextStyles.bodySmall.copyWith(
                    color:     context.isDark ? AppColors.grey400 : AppColors.grey600,
                    height:    1.4,
                    fontSize:  10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

}

// ── Mini lantern widget ───────────────────────────────────────────
class _MiniLantern extends StatelessWidget {
  final Color  color;
  final double scale;

  const _MiniLantern({required this.color, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final w = 14.0 * scale;
    final h = 20.0 * scale;

    return SizedBox(
      width:  w + 4,
      height: h + 8,
      child: CustomPaint(painter: _LanternPainter(color: color, scale: scale)),
    );
  }
}

class _LanternPainter extends CustomPainter {
  final Color  color;
  final double scale;
  const _LanternPainter({required this.color, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    // Sợi dây treo
    paint.color = color.withValues(alpha: 0.5);
    paint.strokeWidth = 1.0;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h * 0.18), paint);
    paint.style = PaintingStyle.fill;

    // Thân đèn
    paint.color = color;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.5),
        width:  w * 0.78,
        height: h * 0.6,
      ),
      Radius.circular(w * 0.3),
    );
    canvas.drawRRect(body, paint);

    // Highlight trên đèn
    paint.color = Colors.white.withValues(alpha: 0.25);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.42, h * 0.38),
        width:  w * 0.2,
        height: h * 0.15,
      ),
      paint,
    );

    // Vạch ngang trang trí
    paint.color = Colors.white.withValues(alpha: 0.15);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.8 * scale;
    canvas.drawLine(
      Offset(w * 0.25, h * 0.5),
      Offset(w * 0.75, h * 0.5),
      paint,
    );

    // Tua rua cuối đèn
    paint.style = PaintingStyle.fill;
    paint.color = AppColors.secondary.withValues(alpha: 0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.82),
        width:  w * 0.22,
        height: h * 0.14,
      ),
      paint,
    );

    // Chỉ tua rua
    paint.color = AppColors.secondary.withValues(alpha: 0.6);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.8 * scale;
    canvas.drawLine(
      Offset(w / 2, h * 0.89),
      Offset(w / 2, h * 0.98),
      paint,
    );
  }

  @override
  bool shouldRepaint(_LanternPainter old) =>
      old.color != color || old.scale != scale;
}


// ── Hoa tết trang trí tĩnh ────────────────────────────────────────
class _TetFlower extends StatelessWidget {
  final double size;
  final Color  color;
  final double rotation;

  const _TetFlower({
    required this.size,
    required this.color,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: CustomPaint(
        size: Size(size, size),
        painter: _FlowerPainter(color: color),
      ),
    );
  }
}

class _FlowerPainter extends CustomPainter {
  final Color color;
  const _FlowerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color  = color.withValues(alpha: 0.75)
      ..style  = PaintingStyle.fill;
    final cx = size.width  / 2;
    final cy = size.height / 2;
    final r  = size.width  * 0.38;

    // 5 cánh hoa
    for (int i = 0; i < 5; i++) {
      final angle = i * math.pi * 2 / 5 - math.pi / 2;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -r),
          width:  r * 0.65,
          height: r,
        ),
        paint,
      );
      canvas.restore();
    }
    // Nhụy
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.1,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_FlowerPainter old) => old.color != color;
}