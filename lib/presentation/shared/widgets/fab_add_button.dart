import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class FabAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String?      tooltip;

  const FabAddButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Thêm công việc',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed:       onPressed,
      tooltip:         tooltip,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation:       4,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add_rounded,
        size:  AppDimensions.fabIconSize,
        color: AppColors.white,
      ),
    );
  }
}