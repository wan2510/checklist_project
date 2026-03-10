import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/tet_date_utils.dart';
import '../../routes/app_routes.dart';
import '../settings/settings_viewmodel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve:  Curves.easeIn,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end:   Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve:  Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final settings  = context.watch<SettingsViewModel>();
    final name      = settings.displayName;
    final daysLeft  = TetDateUtils.daysUntilTet;
    final tetTitle  = TetDateUtils.tetFullTitle;
    final animal    = TetDateUtils.tetAnimal;

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
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // ── Mascot / Icon ──────────────────────────
                    Container(
                      width:  100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient:     AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXXL,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:      AppColors.primary.withValues(alpha: 0.35),
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
                    ),
                    const SizedBox(height: AppDimensions.spaceXXL),

                    // ── Greeting ───────────────────────────────
                    Text(
                      '${_greeting()},',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),

                    // ── User name ──────────────────────────────
                    Text(
                      name,
                      style: AppTextStyles.displayMedium.copyWith(
                        color:      AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMD),

                    Text(
                      'Sẵn sàng dọn nhà đón Tết chưa?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // ── Tet countdown card ─────────────────────
                    _buildCountdownCard(tetTitle, animal, daysLeft),

                    const Spacer(flex: 1),

                    // ── Enter button ───────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.go(AppRoutes.home),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spaceXL,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLG,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Vào ứng dụng',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spaceSM),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMD),

                    // ── Skip / Settings ────────────────────────
                    TextButton(
                      onPressed: () => context.push(AppRoutes.settings),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size:  AppDimensions.iconSM,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(width: AppDimensions.spaceXS),
                          Text(
                            'Cài đặt tên người dùng',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 1),

                    // ── Footer ─────────────────────────────────
                    Text(
                      '🏮  $tetTitle  🏮',
                      style: AppTextStyles.labelSmall.copyWith(
                        color:         AppColors.grey400,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceLG),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownCard(
      String tetTitle,
      String animal,
      int daysLeft,
      ) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient:     AppColors.bannerGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset:     const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Left ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sẵn sàng đón',
                  style: AppTextStyles.bodySmall.copyWith(
                    color:      AppColors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  tetTitle,
                  style: AppTextStyles.titleLarge.copyWith(
                    color:      AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSM),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Còn ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      '$daysLeft',
                      style: AppTextStyles.countdownNumber,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        ' Ngày',
                        style: AppTextStyles.titleLarge.copyWith(
                          color:      AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Right ─────────────────────────────────────────
          Container(
            width:  60,
            height: 60,
            decoration: BoxDecoration(
              color:        AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            ),
            child: Center(
              child: Text(
                animal,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}