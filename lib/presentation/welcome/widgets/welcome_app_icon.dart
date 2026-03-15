import 'package:flutter/material.dart';

class WelcomeAppIcon extends StatelessWidget {
  final Animation<double> scaleAnim;
  final Animation<double> floatAnim;

  const WelcomeAppIcon({
    super.key,
    required this.scaleAnim,
    required this.floatAnim,
  });

  @override
  Widget build(BuildContext context) {
    // FIX: dùng theme primary thay vì hardcode đỏ
    final primary     = Theme.of(context).colorScheme.primary;
    final primaryDark = Color.lerp(primary, Colors.black, 0.15)!;

    return AnimatedBuilder(
      animation: floatAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, floatAnim.value * 0.6),
        child: child,
      ),
      child: ScaleTransition(
        scale: scaleAnim,
        child: Container(
          width:  90,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primaryDark],
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color:      primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset:     const Offset(0, 8),
              ),
              BoxShadow(
                color:      Colors.white.withValues(alpha: 0.3),
                blurRadius: 4,
                offset:     const Offset(-2, -2),
              ),
            ],
          ),
          child: const Icon(
            Icons.cleaning_services_rounded,
            size:  44,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}