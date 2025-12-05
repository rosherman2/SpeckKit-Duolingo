import 'package:flutter/material.dart';
import 'package:speckkit_duolingo/core/theme/colors.dart';

/// [StatelessWidget] Popup dialog for achievement unlock celebration.
///
/// Features:
/// - Achievement icon
/// - Name and description
/// - Celebration styling
/// - TODO: Add confetti animation in Phase 10
///
/// Purpose: Celebrate achievement unlocks
///
/// Navigation: Shown via showDialog when achievement unlocked
class AchievementPopup extends StatelessWidget {
  /// [String] Achievement ID
  final String achievementId;

  /// [String] Achievement name
  final String achievementName;

  /// [String] Achievement description
  final String achievementDescription;

  /// Creates an AchievementPopup.
  ///
  /// Parameters:
  /// - achievementId: Achievement ID
  /// - achievementName: Display name
  /// - achievementDescription: What was achieved
  const AchievementPopup({
    required this.achievementId,
    required this.achievementName,
    required this.achievementDescription,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientCelebration,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy icon
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                size: 48,
                color: AppColors.points,
              ),
            ),

            const SizedBox(height: 16),

            // "Achievement Unlocked!" text
            const Text(
              '🏆 Achievement Unlocked!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Achievement name
            Text(
              achievementName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Achievement description
            Text(
              achievementDescription,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Close button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.accentPink,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Awesome!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
