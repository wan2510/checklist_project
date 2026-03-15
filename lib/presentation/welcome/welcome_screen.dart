import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/utils/tet_date_utils.dart';
import '../../routes/app_routes.dart';
import '../settings/settings_viewmodel.dart';
import 'widgets/welcome_actions.dart';
import 'widgets/welcome_app_icon.dart';
import 'widgets/welcome_background.dart';
import 'widgets/welcome_countdown_card.dart';
import 'widgets/welcome_greeting.dart';
import 'widgets/welcome_top_deco.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {

  // ── Animation controllers ─────────────────────────────────────
  late AnimationController _mainController;
  late AnimationController _floatController;
  late AnimationController _petalController;

  // ── Animations ────────────────────────────────────────────────
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _cardSlideAnim;
  late Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Entrance
    _mainController = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _mainController,
      curve:  const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end:   Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve:  const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve:  const Interval(0.1, 0.6, curve: Curves.elasticOut),
      ),
    );
    _cardSlideAnim = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve:  const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    _btnAnim = CurvedAnimation(
      parent: _mainController,
      curve:  const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    // Float (loop)
    _floatController = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Petals (loop)
    _petalController = AnimationController(
      vsync:    this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatController.dispose();
    _petalController.dispose();
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
    final daysLeft  = TetDateUtils.daysUntilTet;
    final tetTitle  = TetDateUtils.tetFullTitle;
    final animal    = TetDateUtils.tetAnimal;
    final progress  = TetDateUtils.timeElapsedPercent;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background ───────────────────────────────────────
          const WelcomeBackground(),

          // ── Floating petals ──────────────────────────────────
          WelcomeFloatingPetals(petalController: _petalController),

          // ── Top flower decoration ────────────────────────────
          const WelcomeTopDeco(),

          // ── Red envelopes ────────────────────────────────────
          WelcomeRedEnvelopes(floatAnim: _floatAnim),

          // ── Main content ─────────────────────────────────────
          SafeArea(
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

                      WelcomeAppIcon(
                        scaleAnim: _scaleAnim,
                        floatAnim: _floatAnim,
                      ),
                      const SizedBox(height: AppDimensions.spaceXXL),

                      WelcomeGreeting(
                        greeting: _greeting(),
                        name:     settings.displayName,
                      ),

                      const Spacer(flex: 1),

                      // Card slide-up animation
                      AnimatedBuilder(
                        animation: _cardSlideAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _cardSlideAnim.value),
                          child: Opacity(
                            opacity: (1 - _cardSlideAnim.value / 60)
                                .clamp(0.0, 1.0),
                            child: child,
                          ),
                        ),
                        child: WelcomeCountdownCard(
                          tetTitle:        tetTitle,
                          animal:          animal,
                          daysLeft:        daysLeft,
                          progressPercent: progress,
                          floatAnim:       _floatAnim,
                        ),
                      ),

                      const Spacer(flex: 1),

                      FadeTransition(
                        opacity: _btnAnim,
                        child: WelcomeCtaButton(
                          onPressed: () => context.go(AppRoutes.home),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMD),

                      FadeTransition(
                        opacity: _btnAnim,
                        child: WelcomeSettingsLink(
                          onPressed: () => context.push(AppRoutes.settings),
                        ),
                      ),

                      const Spacer(flex: 1),

                      FadeTransition(
                        opacity: _btnAnim,
                        child: WelcomeFooter(tetTitle: tetTitle),
                      ),
                      const SizedBox(height: AppDimensions.spaceLG),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}