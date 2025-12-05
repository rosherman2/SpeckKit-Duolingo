import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';

/// [StatefulWidget] Animated gradient background with smooth color transitions.
///
/// Creates a vibrant animated background using:
/// - Animated gradient with smooth color transitions
/// - Continuous animation loop
/// - Candy Crush-style vibrant colors
///
/// Purpose: Provide engaging visual background for main menu
///
/// Navigation: Used as background layer in MainMenuPage
///
/// Note: For performance, particle effects can be added later using Lottie
class AnimatedBackground extends StatefulWidget {
  /// Creates an AnimatedBackground widget.
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

/// [State] Manages AnimatedBackground's continuous animation.
///
/// Handles smooth gradient color transitions that loop indefinitely.
class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  /// [AnimationController] Controls the gradient animation timing
  late AnimationController _controller;

  /// [Animation<double>] Progress value from 0.0 to 1.0 for gradient shift
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create animation controller with 10-second duration for smooth effect
    // Uses repeat mode for continuous animation
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true); // Reverse animation creates seamless loop

    // Create animation with linear curve for smooth progression
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// [Method] Calculates gradient colors based on animation progress.
  ///
  /// Interpolates between multiple vibrant colors to create
  /// a continuously shifting gradient effect.
  ///
  /// Parameters:
  /// - progress: Animation progress from 0.0 to 1.0
  ///
  /// Returns: List of colors for the current gradient state
  List<Color> _getGradientColors(double progress) {
    // Define color stops for vibrant gradient animation
    // Using Candy Crush-inspired vibrant colors
    if (progress < 0.33) {
      // Blue to Purple transition
      return [
        AppColors.primary,
        AppColors.accent,
      ];
    } else if (progress < 0.66) {
      // Purple to Pink transition
      return [
        AppColors.accent,
        AppColors.accentPink,
      ];
    } else {
      // Pink to Blue transition (loops back to start)
      return [
        AppColors.accentPink,
        AppColors.primary,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final colors = _getGradientColors(_animation.value);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          // Add subtle overlay for depth
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        );
      },
    );
  }
}
