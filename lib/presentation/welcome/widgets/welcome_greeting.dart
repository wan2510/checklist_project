import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class WelcomeGreeting extends StatelessWidget {
  final String greeting;
  final String name;

  const WelcomeGreeting({
    super.key,
    required this.greeting,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          greeting,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF8E6B6B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: AppTextStyles.displayMedium.copyWith(
            color:         const Color(0xFFD93045),
            fontWeight:    FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sẵn sàng dọn nhà đón Tết chưa?\nMột năm mới sung túc đang chờ đợi.',
          style: AppTextStyles.bodySmall.copyWith(
            color:  const Color(0xFF8E6B6B),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}