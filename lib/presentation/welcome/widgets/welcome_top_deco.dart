import 'package:flutter/material.dart';

// ── Top flower decoration ─────────────────────────────────────────
class WelcomeTopDeco extends StatelessWidget {
  const WelcomeTopDeco({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:   0,
      left:  0,
      right: 0,
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            Positioned(
              top:  -10,
              left: -20,
              child: Transform.rotate(
                angle: -0.2,
                child: _buildBranch(isLeft: true),
              ),
            ),
            Positioned(
              top:   -10,
              right: -20,
              child: Transform.rotate(
                angle: 0.2,
                child: _buildBranch(isLeft: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranch({required bool isLeft}) {
    return Stack(
      children: [
        Text(
          isLeft ? '🌸' : '🌼',
          style: const TextStyle(fontSize: 52),
        ),
        Positioned(
          top:  30,
          left: isLeft ? 20 : -10,
          child: Text(
            isLeft ? '🌺' : '🌸',
            style: TextStyle(
              fontSize: 36,
              color:    Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        Positioned(
          top:  60,
          left: isLeft ? -5 : 15,
          child: Text(
            isLeft ? '🌸' : '🌺',
            style: const TextStyle(fontSize: 28),
          ),
        ),
        Positioned(
          top:  90,
          left: isLeft ? 25 : 0,
          child: Text(
            '✿',
            style: TextStyle(
              fontSize: 20,
              color:    isLeft
                  ? const Color(0xFFFF85A1).withValues(alpha:0.6)
                  : const Color(0xFFFFD700).withValues(alpha:0.6),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Red envelopes ─────────────────────────────────────────────────
class WelcomeRedEnvelopes extends StatelessWidget {
  final Animation<double> floatAnim;

  const WelcomeRedEnvelopes({
    super.key,
    required this.floatAnim,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -8,
      top:   MediaQuery.of(context).size.height * 0.35,
      child: AnimatedBuilder(
        animation: floatAnim,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, floatAnim.value * 0.5),
          child: Column(
            children: [
              _buildEnvelope(size: 36, angle: 0.15),
              const SizedBox(height: 8),
              _buildEnvelope(size: 28, angle: -0.1),
              const SizedBox(height: 8),
              _buildEnvelope(size: 22, angle: 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvelope({required double size, required double angle}) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width:  size,
        height: size * 1.3,
        decoration: BoxDecoration(
          color:        const Color(0xFFD93045),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFF2C94C),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withValues(alpha:0.15),
              blurRadius: 4,
              offset:     const Offset(1, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '🧧',
            style: TextStyle(fontSize: size * 0.5),
          ),
        ),
      ),
    );
  }
}