import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';

/// [StatelessWidget] Displays current practice streak with flame icon.
///
/// Features:
/// - Fire gradient icon
/// - Streak day count
/// - Motivational styling
///
/// Purpose: Encourage daily practice
///
/// Navigation: Displayed in main menu and progress screens
class StreakIndicator extends StatelessWidget {
  /// [int] Current streak in days
  final int streak;

  /// Creates a StreakIndicator.
  ///
  /// Parameters:
  /// - streak: Number of consecutive days
  const StreakIndicator({
    required this.streak,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientStreak,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentOrange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '$streak',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'day streak',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
