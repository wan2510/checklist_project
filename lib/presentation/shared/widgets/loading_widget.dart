import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool    fullScreen;

  const LoadingWidget({
    super.key,
    this.message,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          color:       AppColors.primary,
          strokeWidth: 3,
        ),
        if (message != null) ...[
          const SizedBox(height: AppDimensions.spaceLG),
          Text(
            message!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
          ),
        ],
      ],
    );

    if (fullScreen) {
      return Scaffold(
        body: Center(child: content),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space40),
        child: content,
      ),
    );
  }
}

/// Overlay loading (dùng khi đang save/delete)
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool   isLoading;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color:       AppColors.white,
                strokeWidth: 3,
              ),
            ),
          ),
      ],
    );
  }
}