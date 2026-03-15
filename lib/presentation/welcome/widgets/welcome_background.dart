import 'dart:math' as math;

import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF1EB),
            Color(0xFFFFF6EE),
            Color(0xFFFFFAF0),
          ],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
          stops:  [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// ── Floating petals ───────────────────────────────────────────────
class WelcomeFloatingPetals extends StatelessWidget {
  final AnimationController petalController;

  const WelcomeFloatingPetals({
    super.key,
    required this.petalController,
  });

  static const _petals = [
    _PetalData(left: 0.15, delay: 0.0,  size: 14, emoji: '🌸'),
    _PetalData(left: 0.35, delay: 0.2,  size: 10, emoji: '✿'),
    _PetalData(left: 0.65, delay: 0.5,  size: 12, emoji: '🌸'),
    _PetalData(left: 0.80, delay: 0.75, size: 8,  emoji: '✾'),
    _PetalData(left: 0.50, delay: 0.9,  size: 10, emoji: '✿'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _petals.map((p) => _buildPetal(context, p)).toList(),
    );
  }

  Widget _buildPetal(BuildContext context, _PetalData p) {
    return AnimatedBuilder(
      animation: petalController,
      builder: (_, __) {
        final progress = (petalController.value + p.delay) % 1.0;
        final screenH  = MediaQuery.of(context).size.height;
        final screenW  = MediaQuery.of(context).size.width;
        final top      = progress * screenH;
        final wobble   = math.sin(progress * math.pi * 4) * 20;

        return Positioned(
          top:  top,
          left: screenW * p.left + wobble,
          child: Opacity(
            opacity: (progress < 0.1)
                ? progress / 0.1
                : (progress > 0.9)
                ? (1 - progress) / 0.1
                : 0.25,
            child: Transform.rotate(
              angle: progress * math.pi * 2,
              child: Text(
                p.emoji,
                style: TextStyle(fontSize: p.size.toDouble()),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PetalData {
  final double left;
  final double delay;
  final int    size;
  final String emoji;

  const _PetalData({
    required this.left,
    required this.delay,
    required this.size,
    required this.emoji,
  });
}