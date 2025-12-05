import 'package:dartz/dartz.dart';
import 'package:speckkit_duolingo/core/errors/failures.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';

/// [Use Case] Calculates and updates user's practice streak.
///
/// Business Logic:
/// - Retrieves current progress with last practice date
/// - Compares last practice date with today
/// - If practiced today: no change
/// - If practiced yesterday: increment streak, update longest if needed
/// - If missed days: reset streak to 1
/// - Updates last practice date to today
///
/// Purpose: Encourage daily practice through streak gamification
///
/// Constitutional Requirement: Clean Architecture - use case layer
class CalculateStreak {
  /// [ProgressRepository] Repository for progress operations
  final ProgressRepository repository;

  /// Creates a CalculateStreak use case.
  ///
  /// Parameters:
  /// - repository: Progress repository instance
  const CalculateStreak({required this.repository});

  /// Executes the use case to calculate and update streak.
  ///
  /// Returns:
  /// - Right(UserProgress) with updated streak
  /// - Left(CacheFailure) if storage fails
  ///
  /// Side effects:
  /// - Updates currentStreak
  /// - Updates longestStreak if new record
  /// - Sets lastPracticeDate to now
  Future<Either<Failure, UserProgress>> call() async {
    AppLogger.info(
        'CalculateStreak', 'call', () => 'Calculating streak update');

    // Update streak through repository
    final result = await repository.updateStreak();

    return result.fold(
      (failure) {
        AppLogger.error('CalculateStreak', 'call',
            () => 'Failed to update streak: ${failure.runtimeType}');
        return Left(failure);
      },
      (updatedProgress) {
        _logStreakUpdate(updatedProgress);
        _checkStreakAchievements(updatedProgress);
        return Right(updatedProgress);
      },
    );
  }

  /// [Method] Logs the streak update details.
  ///
  /// Parameters:
  /// - progress: Updated progress with new streak
  void _logStreakUpdate(UserProgress progress) {
    AppLogger.info(
        'CalculateStreak',
        '_logStreakUpdate',
        () =>
            'Streak updated: ${progress.currentStreak} days (longest: ${progress.longestStreak})');

    if (progress.currentStreak == progress.longestStreak &&
        progress.currentStreak > 1) {
      AppLogger.info('CalculateStreak', '_logStreakUpdate',
          () => 'New personal record! ${progress.currentStreak} days');
    }

    if (progress.currentStreak == 1 && progress.longestStreak > 1) {
      AppLogger.warning(
          'CalculateStreak',
          '_logStreakUpdate',
          () =>
              'Streak reset to 1 (previous longest: ${progress.longestStreak})');
    }
  }

  /// [Method] Checks if streak unlocks any achievements.
  ///
  /// Achievement thresholds:
  /// - 7 days: Week Warrior
  ///
  /// Parameters:
  /// - progress: Updated progress to check
  void _checkStreakAchievements(UserProgress progress) {
    final streak = progress.currentStreak;

    AppLogger.debug('CalculateStreak', '_checkStreakAchievements',
        () => 'Checking streak achievements for $streak days');

    if (streak >= 7 &&
        !progress.unlockedAchievements.contains('week_warrior')) {
      AppLogger.info('CalculateStreak', '_checkStreakAchievements',
          () => 'Achievement threshold reached: Week Warrior (7 day streak)');
    }

    // Note: Actual unlocking handled by UnlockAchievement use case
  }
}
