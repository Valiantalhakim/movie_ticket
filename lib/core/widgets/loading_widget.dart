import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    super.key,
    this.height = 112,
    this.borderRadius = 20,
  });

  final double height;
  final double borderRadius;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.2 + (_controller.value * 2.4), -0.3),
              end: Alignment(1.2 + (_controller.value * 2.4), 0.3),
              colors: const [
                AppColors.surface,
                AppColors.surfaceAlt,
                AppColors.surface,
              ],
            ),
          ),
        );
      },
    );
  }
}
