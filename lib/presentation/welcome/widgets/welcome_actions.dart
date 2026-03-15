import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

// ── Enter button ──────────────────────────────────────────────────
class WelcomeCtaButton extends StatefulWidget {
  final VoidCallback onPressed;

  const WelcomeCtaButton({super.key, required this.onPressed});

  @override
  State<WelcomeCtaButton> createState() => _WelcomeCtaButtonState();
}

class _WelcomeCtaButtonState extends State<WelcomeCtaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // FIX: dùng theme primary thay vì hardcode đỏ
    final primary     = Theme.of(context).colorScheme.primary;
    final primaryDark = Color.lerp(primary, Colors.black, 0.12)!;

    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale:    _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width:  double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _pressed
                  ? [primaryDark, primary]
                  : [primary, Color.lerp(primary, Colors.white, 0.15)!],
              begin: Alignment.topLeft,
              end:   Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: _pressed
                ? []
                : [
              BoxShadow(
                color:      primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset:     const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vào ứng dụng',
                style: TextStyle(
                  color:         Colors.white,
                  fontSize:      17,
                  fontWeight:    FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width:  28,
                height: 28,
                decoration: BoxDecoration(
                  color:        Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size:  16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Settings link ─────────────────────────────────────────────────
class WelcomeSettingsLink extends StatelessWidget {
  final VoidCallback onPressed;

  const WelcomeSettingsLink({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.settings_outlined,
            size:  15,
            color: primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Text(
            'Cài đặt tên người dùng',
            style: TextStyle(
              color:    primary.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────
class WelcomeFooter extends StatelessWidget {
  final String tetTitle;

  const WelcomeFooter({super.key, required this.tetTitle});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color:        primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏮', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                tetTitle.toUpperCase(),
                style: TextStyle(
                  color:         primary.withValues(alpha: 0.8),
                  fontSize:      10,
                  fontWeight:    FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 6),
              const Text('🏮', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '✸',
          style: TextStyle(
            color:    primary.withValues(alpha: 0.3),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}