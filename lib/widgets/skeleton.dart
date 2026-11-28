import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Pulsing placeholder shown while an image is loading
class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 0.9).animate(_controller),
      child: Container(
        color: dark ? AppColors.disabledPrimary : AppColors.lightBg,
      ),
    );
  }
}