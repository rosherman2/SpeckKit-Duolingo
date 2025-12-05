import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/animations.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';

/// [StatefulWidget] Animated points counter for lesson completion.
///
/// Features:
/// - Counts up from old value to new value
/// - Golden coin icon\n/// - Smooth easing animation
///
/// Purpose: Celebrate points earned with satisfying count-up
///
/// Navigation: Used in lesson completion screen
class PointsCounter extends StatefulWidget {
  /// [int] Starting points value
  final int startValue;

  /// [int] Ending points value
  final int endValue;

  /// Creates a PointsCounter widget.
  ///
  /// Parameters:
  /// - startValue: Points before
  /// - endValue: Points after earning more
  const PointsCounter({
    required this.startValue,
    required this.endValue,
    super.key,
  });

  @override
  State<PointsCounter> createState() => _PointsCounterState();
}

class _PointsCounterState extends State<PointsCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppAnimations.verySlow,
      vsync: this,
    );

    _animation = IntTween(
      begin: widget.startValue,
      end: widget.endValue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars,
              color: AppColors.points,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              '+${_animation.value - widget.startValue}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.points,
              ),
            ),
          ],
        );
      },
    );
  }
}
