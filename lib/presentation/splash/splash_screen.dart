import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/tet_date_utils.dart';
import '../../routes/app_routes.dart';
import 'splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  final SplashViewModel viewModel;

  const SplashScreen({super.key, required this.viewModel});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double>   _fadeAnim;
  late final Animation<double>   _scaleAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startFlow();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve:  const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:  const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end:   Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve:  const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  Future<void> _startFlow() async {
    final nextRoute = await widget.viewModel.getNextRoute();
    if (!mounted) return;
    context.go(nextRoute);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:  double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF5F5),
              Color(0xFFFFEBEB),
              Color(0xFFFFF8E7),
            ],
            begin: Alignment.topLeft,
            end:   Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative blobs ──────────────────────────────
            _buildDecorativeBlob(
              top:    -60,
              right:  -40,
              size:   200,
              color:  AppColors.primary.withOpacity(0.08),
            ),
            _buildDecorativeBlob(
              bottom: -80,
              left:   -60,
              size:   240,
              color:  AppColors.secondary.withOpacity(0.1),
            ),
            _buildDecorativeBlob(
              top:    120,
              left:   -30,
              size:   120,
              color:  AppColors.accent.withOpacity(0.07),
            ),

            // ── Tet decoration top ────────────────────────────
            Positioned(
              top:   0,
              left:  0,
              right: 0,
              child: _buildTetDecorationTop(),
            ),

            // ── Main content ──────────────────────────────────
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── App icon ─────────────────────────────
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: _buildAppIcon(),
                      ),
                      const SizedBox(height: AppDimensions.spaceXXL),

                      // ── App name ──────────────────────────────
                      Text(
                        AppStrings.appSlogan,
                        style: AppTextStyles.displayMedium.copyWith(
                          color:       AppColors.primary,
                          fontWeight:  FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      // ── Subtitle ──────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space40,
                        ),
                        child: Text(
                          AppStrings.appDescription,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color:  AppColors.grey500,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space48),

                      // ── Loading indicator ─────────────────────
                      _buildLoadingIndicator(),
                      const SizedBox(height: AppDimensions.spaceLG),
                      Text(
                        AppStrings.splashLoading,
                        style: AppTextStyles.labelSmall.copyWith(
                          color:         AppColors.grey400,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom decoration ─────────────────────────────
            Positioned(
              bottom: AppDimensions.space40,
              left:   0,
              right:  0,
              child: _buildBottomDecoration(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sub widgets ───────────────────────────────────────────────

  Widget _buildAppIcon() {
    return Container(
      width:  100,
      height: 100,
      decoration: BoxDecoration(
        gradient:     AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        boxShadow: [
          BoxShadow(
            color:      AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset:     const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.cleaning_services_rounded,
        size:  52,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width:  140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: TweenAnimationBuilder<double>(
          tween:    Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 2200),
          curve:    Curves.easeInOut,
          builder:  (_, value, __) => LinearProgressIndicator(
            value:            value,
            minHeight:        3,
            backgroundColor:  AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeBlob({
    double? top, double? bottom, double? left, double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top:    top,
      bottom: bottom,
      left:   left,
      right:  right,
      child: Container(
        width:  size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTetDecorationTop() {
    return Container(
      height: 160,
      child: Stack(
        children: [
          Positioned(
            top:   10,
            right: 20,
            child: Text('🌸', style: TextStyle(fontSize: 40)),
          ),
          Positioned(
            top:  30,
            left: 30,
            child: Text('🌺', style: TextStyle(fontSize: 32)),
          ),
          Positioned(
            top:   60,
            right: 60,
            child: Text('🧧', style: TextStyle(fontSize: 28)),
          ),
          Positioned(
            top:  80,
            left: 80,
            child: Text('✨', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDecoration() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏮', style: TextStyle(fontSize: 20)),
            const SizedBox(width: AppDimensions.spaceSM),
            Text(
              'TẾT ${TetDateUtils.nextTetYear} • ${TetDateUtils.tetName.toUpperCase()}',
              style: AppTextStyles.labelSmall.copyWith(
                color:         AppColors.grey400,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSM),
            const Text('🏮', style: TextStyle(fontSize: 20)),
          ],
        ),
      ],
    );
  }
}