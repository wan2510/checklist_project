import 'package:flutter/material.dart';

class WelcomeCountdownCard extends StatelessWidget {
  final String            tetTitle;
  final String            animal;
  final int               daysLeft;
  final double            progressPercent;
  final Animation<double> floatAnim;

  const WelcomeCountdownCard({
    super.key,
    required this.tetTitle,
    required this.animal,
    required this.daysLeft,
    required this.progressPercent,
    required this.floatAnim,
  });

  @override
  Widget build(BuildContext context) {
    // FIX: dùng theme primary thay vì hardcode đỏ
    final primary      = Theme.of(context).colorScheme.primary;
    final primaryLight = Color.lerp(primary, Colors.white, 0.25)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:        primary.withValues(alpha: 0.35),
            blurRadius:   20,
            offset:       const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Gradient bg
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primaryLight],
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                ),
              ),
            ),

            // Decorative circles
            Positioned(
              top:   -30,
              right: -20,
              child: Container(
                width:  120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left:   -20,
              child: Container(
                width:  140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Confetti dots
            Positioned(
              bottom: 12,
              right:  80,
              child: Container(
                width:  6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF2C94C).withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              top:   20,
              right: 140,
              child: Container(
                width:  4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopRow(primary),
                  const SizedBox(height: 8),
                  _buildTetTitle(),
                  const SizedBox(height: 12),
                  _buildCountdown(),
                  const SizedBox(height: 12),
                  _buildProgressBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(Color primary) {
    return Row(
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color:        Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time_rounded,
                size:  11,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                'Sự kiện sắp tới',
                style: TextStyle(
                  color:      Colors.white.withValues(alpha: 0.9),
                  fontSize:   10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Animal icon with float
        AnimatedBuilder(
          animation: floatAnim,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, floatAnim.value * 0.4),
            child: Container(
              width:  50,
              height: 50,
              decoration: BoxDecoration(
                color:        Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  animal,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTetTitle() {
    return Text(
      tetTitle,
      style: const TextStyle(
        color:         Colors.white,
        fontSize:      18,
        fontWeight:    FontWeight.w800,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildCountdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Còn ',
          style: TextStyle(
            color:    Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
          ),
        ),
        Text(
          '$daysLeft',
          style: const TextStyle(
            color:         Colors.white,
            fontSize:      56,
            fontWeight:    FontWeight.w900,
            height:        1.0,
            letterSpacing: -2,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            ' Ngày',
            style: TextStyle(
              color:      Colors.white,
              fontSize:   20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value:           progressPercent,
              minHeight:       4,
              backgroundColor: Colors.white.withValues(alpha: 0.65),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(progressPercent * 100).round()}% Năm cũ',
          style: TextStyle(
            color:    Colors.white.withValues(alpha: 0.75),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}