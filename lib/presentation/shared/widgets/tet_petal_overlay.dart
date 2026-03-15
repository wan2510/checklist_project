import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Overlay hoa đào / hoa mai rơi cho không khí Tết.
/// Dùng: bọc bên ngoài Scaffold hoặc đặt trong Stack.
class TetPetalOverlay extends StatefulWidget {
  final Widget child;

  const TetPetalOverlay({super.key, required this.child});

  @override
  State<TetPetalOverlay> createState() => _TetPetalOverlayState();
}

class _TetPetalOverlayState extends State<TetPetalOverlay>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final List<_Petal> _petals;
  final _random = math.Random();

  // Số cánh hoa — đủ tạo không khí mà không nặng
  static const _petalCount = 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _petals = List.generate(_petalCount, (_) => _Petal.random(_random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Petal layer — IgnorePointer để không chặn tap
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => CustomPaint(
                painter: _PetalPainter(
                  petals:   _petals,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Data model ───────────────────────────────────────────────────
class _Petal {
  final double startX;   // 0.0–1.0 của chiều rộng màn hình
  final double delay;    // 0.0–1.0 offset pha
  final double speed;    // tốc độ rơi (0.5–1.5)
  final double size;     // 8–18 px
  final double drift;    // lắc ngang
  final bool   isDao;    // true = đào (hồng), false = mai (vàng)
  final double rotation; // vòng quay ban đầu

  const _Petal({
    required this.startX,
    required this.delay,
    required this.speed,
    required this.size,
    required this.drift,
    required this.isDao,
    required this.rotation,
  });

  factory _Petal.random(math.Random rng) => _Petal(
    startX:   rng.nextDouble(),
    delay:    rng.nextDouble(),
    speed:    0.5 + rng.nextDouble() * 1.0,
    size:     10 + rng.nextDouble() * 10,
    drift:    (rng.nextDouble() - 0.5) * 60,
    isDao:    rng.nextBool(),
    rotation: rng.nextDouble() * math.pi * 2,
  );
}

// ── Painter ──────────────────────────────────────────────────────
class _PetalPainter extends CustomPainter {
  final List<_Petal> petals;
  final double       progress; // 0.0–1.0, repeating

  const _PetalPainter({required this.petals, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final petal in petals) {
      // Mỗi cánh có pha riêng để không rơi cùng lúc
      final t = (progress * petal.speed + petal.delay) % 1.0;

      final x = petal.startX * size.width
          + petal.drift * math.sin(t * math.pi * 2);
      final y = -petal.size + t * (size.height + petal.size * 2);

      final opacity = _calcOpacity(t);
      if (opacity <= 0) continue;

      final angle  = petal.rotation + t * math.pi * 3;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      _drawPetal(canvas, petal.size, petal.isDao, opacity);
      canvas.restore();
    }
  }

  // Fade in ở trên, fade out ở cuối màn hình
  double _calcOpacity(double t) {
    if (t < 0.08) return t / 0.08;
    if (t > 0.85) return (1.0 - t) / 0.15;
    return 0.65; // tương đối mờ để không distracting
  }

  void _drawPetal(Canvas canvas, double size, bool isDao, double opacity) {
    final color = isDao
        ? Color.fromRGBO(255, 182, 193, opacity) // hồng đào
        : Color.fromRGBO(255, 215,   0, opacity); // vàng mai

    final paint = Paint()
      ..color  = color
      ..style  = PaintingStyle.fill;

    // Vẽ hình cánh hoa đơn giản bằng 5 oval
    final petalSize = size * 0.45;
    for (int i = 0; i < 5; i++) {
      canvas.save();
      canvas.rotate(i * math.pi * 2 / 5);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -petalSize),
          width:  petalSize * 0.7,
          height: petalSize,
        ),
        paint,
      );
      canvas.restore();
    }

    // Nhụy hoa
    final centerPaint = Paint()
      ..color = isDao
          ? Color.fromRGBO(255, 105, 135, opacity)
          : Color.fromRGBO(255, 160,  20, opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size * 0.12, centerPaint);
  }

  @override
  bool shouldRepaint(_PetalPainter old) => old.progress != progress;
}