import 'package:dartz/dartz.dart';
import 'package:speckkit_duolingo/core/errors/failures.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';

/// [Use Case] Unlocks an achievement for the user.
///
/// Business Logic:
/// - Validates achievement ID exists
/// - Checks if already unlocked
/// - Sets unlock timestamp
/// - Persists to storage
/// - Triggers celebration UI
///
/// Purpose: Handle achievement unlock logic
///
/// Constitutional Requirement: Clean Architecture - use case layer
class UnlockAchievement {
  /// [ProgressRepository] Repository for progress operations
  final ProgressRepository repository;

  /// Creates an UnlockAchievement use case.
  ///
  /// Parameters:
  /// - repository: Progress repository instance
  const UnlockAchievement({required this.repository});

  /// Executes the use case to unlock an achievement.
  ///
  /// Parameters:
  /// - achievementId: ID of achievement to unlock
  ///
  /// Returns:
  /// - Right(UserProgress) with achievement added
  /// - Left(ValidationFailure) if already unlocked
  /// - Left(CacheFailure) if storage fails
  ///
  /// Side effects: Triggers Achievement celebration popup in UI
  Future<Either<Failure, UserProgress>> call(String achievementId) async {
    AppLogger.info('UnlockAchievement', 'call',
        () => 'Unlocking achievement: $achievementId');

    // Get current progress to check if already unlocked
    final progressResult = await repository.getUserProgress();

    return progressResult.fold(
      (failure) {
        AppLogger.error('UnlockAchievement', 'call',
            () => 'Failed to get user progress: ${failure.runtimeType}');
        return Left(failure);
      },
      (currentProgress) async {
        // Check if already unlocked
        if (currentProgress.unlockedAchievements.contains(achievementId)) {
          AppLogger.warning('UnlockAchievement', 'call',
              () => 'Achievement $achievementId already unlocked');
          return Left(ValidationFailure('Achievement already unlocked'));
        }

        AppLogger.debug('UnlockAchievement', 'call',
            () => 'Achievement not yet unlocked, proceeding with unlock');

        // Unlock achievement through repository
        final result = await repository.unlockAchievement(achievementId);

        return result.fold(
          (failure) {
            AppLogger.error('UnlockAchievement', 'call',
                () => 'Failed to unlock achievement: ${failure.runtimeType}');
            return Left(failure);
          },
          (updatedProgress) {
            AppLogger.info(
                'UnlockAchievement',
                'call',
                () =>
                    'Achievement $achievementId unlocked successfully! Total achievements: ${updatedProgress.unlockedAchievements.length}');

            _logAchievementDetails(achievementId);

            return Right(updatedProgress);
          },
        );
      },
    );
  }

  /// [Method] Logs achievement unlock details for debugging.
  ///
  /// Parameters:
  /// - achievementId: ID of unlocked achievement
  void _logAchievementDetails(String achievementId) {
    // Map achievement IDs to display names
    final achievementNames = {
      'century_club': 'Century Club (100 points)',
      'half_thousand': 'Half Thousand (500 points)',
      'millennium': 'Millennium (1000 points)',
      'five_thousand_club': 'Five Thousand Club (5000 points)',
      'week_warrior': 'Week Warrior (7 day streak)',
    };

    final name = achievementNames[achievementId] ?? achievementId;

    AppLogger.info('UnlockAchievement', '_logAchievementDetails',
        () => '🏆 Achievement Unlocked: $name');
  }
}
