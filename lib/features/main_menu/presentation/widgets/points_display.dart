import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/animations.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';

/// [StatefulWidget] Displays user's total points with animated counter.
///
/// Features:
/// - Animated count-up effect when points change
/// - Golden coin icon for visual appeal
/// - Prominent display with shadow for emphasis
/// - Smooth easing animation
///
/// Purpose: Show user's points balance in the main menu
///
/// Navigation: Displayed in MainMenuPage header
class PointsDisplay extends StatefulWidget {
  /// Creates a PointsDisplay widget showing the given points.
  ///
  /// Parameters:
  /// - points: User's current total points
  const PointsDisplay({
    required this.points,
    super.key,
  });

  /// [int] Current total points to display
  final int points;

  @override
  State<PointsDisplay> createState() => _PointsDisplayState();
}

/// [State] Manages PointsDisplay's animation state.
///
/// Handles the animated count-up effect when points value changes.
class _PointsDisplayState extends State<PointsDisplay>
    with SingleTickerProviderStateMixin {
  /// [AnimationController] Controls the count-up animation timing
  late AnimationController _controller;

  /// [Animation<int>] Animates the displayed points value
  late Animation<int> _pointsAnimation;

  /// [int] Previous points value for animation start
  int _previousPoints = 0;

  @override
  void initState() {
    super.initState();
    _previousPoints = widget.points;

    // Initialize animation controller with verySlow duration for satisfying count-up
    _controller = AnimationController(
      duration: AppAnimations.verySlow,
      vsync: this,
    );

    // Create points animation from previous to current value
    _pointsAnimation = IntTween(
      begin: _previousPoints,
      end: widget.points,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(PointsDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate when points value changes
    if (oldWidget.points != widget.points) {
      _previousPoints = oldWidget.points;

      // Update animation range
      _pointsAnimation = IntTween(
        begin: _previousPoints,
        end: widget.points,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: AppAnimations.easeOut,
        ),
      );

      // Restart animation
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.points.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Coin icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.points,
                  AppColors.star,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Animated points counter
          AnimatedBuilder(
            animation: _pointsAnimation,
            builder: (context, child) {
              return Text(
                _pointsAnimation.value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          // "Points" label
          const Text(
            'Points',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
