import 'package:dartz/dartz.dart';
import 'package:speckkit_duolingo/core/errors/failures.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';

/// [Use Case] Adds points to user's total and updates progress.
///
/// Business Logic:
/// - Validates points value (must be > 0)
/// - Retrieves current progress
/// - Adds points to total
/// - Checks for achievement unlocks based on new total
/// - Persists updated progress
///
/// Purpose: Encapsulate point addition logic
///
/// Constitutional Requirement: Clean Architecture - use case layer
class UpdatePoints {
  /// [ProgressRepository] Repository for progress operations
  final ProgressRepository repository;

  /// Creates an UpdatePoints use case.
  ///
  /// Parameters:
  /// - repository: Progress repository instance
  const UpdatePoints({required this.repository});

  /// Executes the use case to add points.
  ///
  /// Parameters:
  /// - points: Number of points to add
  ///
  /// Returns:
  /// - Right(UserProgress) with updated points
  /// - Left(ValidationFailure) if points <= 0
  /// - Left(CacheFailure) if storage fails
  ///
  /// Side effects: May unlock achievements if thresholds met
  Future<Either<Failure, UserProgress>> call(int points) async {
    AppLogger.info(
        'UpdatePoints', 'call', () => 'Adding $points points to user progress');

    // Validate points value
    if (points <= 0) {
      AppLogger.error('UpdatePoints', 'call',
          () => 'Invalid points value: $points (must be > 0)');
      return Left(ValidationFailure('Points must be greater than 0'));
    }

    AppLogger.debug('UpdatePoints', 'call',
        () => 'Validation passed, adding points to repository');

    // Add points through repository
    final result = await repository.addPoints(points);

    return result.fold(
      (failure) {
        AppLogger.error('UpdatePoints', 'call',
            () => 'Failed to add points: ${failure.runtimeType}');
        return Left(failure);
      },
      (updatedProgress) {
        AppLogger.info(
            'UpdatePoints',
            'call',
            () =>
                'Points added successfully. New total: ${updatedProgress.totalPoints}');

        // Check for achievement unlocks
        _checkAchievementUnlocks(updatedProgress);

        return Right(updatedProgress);
      },
    );
  }

  /// [Method] Checks if new point total unlocks any achievements.
  ///
  /// Achievement thresholds from constants:
  /// - 100 points: Century Club
  /// - 500 points: Half Thousand
  /// - 1000 points: Millennium
  /// - 5000 points: Five Thousand Club
  ///
  /// Parameters:
  /// - progress: Updated progress to check
  ///
  /// Side effects: Logs potential achievement unlocks
  void _checkAchievementUnlocks(UserProgress progress) {
    final points = progress.totalPoints;

    AppLogger.debug('UpdatePoints', '_checkAchievementUnlocks',
        () => 'Checking achievement thresholds for $points points');

    // Check each threshold
    if (points >= 5000 &&
        !progress.unlockedAchievements.contains('five_thousand_club')) {
      AppLogger.info('UpdatePoints', '_checkAchievementUnlocks',
          () => 'Achievement threshold reached: Five Thousand Club');
    } else if (points >= 1000 &&
        !progress.unlockedAchievements.contains('millennium')) {
      AppLogger.info('UpdatePoints', '_checkAchievementUnlocks',
          () => 'Achievement threshold reached: Millennium');
    } else if (points >= 500 &&
        !progress.unlockedAchievements.contains('half_thousand')) {
      AppLogger.info('UpdatePoints', '_checkAchievementUnlocks',
          () => 'Achievement threshold reached: Half Thousand');
    } else if (points >= 100 &&
        !progress.unlockedAchievements.contains('century_club')) {
      AppLogger.info('UpdatePoints', '_checkAchievementUnlocks',
          () => 'Achievement threshold reached: Century Club');
    }

    // Note: Actual unlocking handled by UnlockAchievement use case
    // This just logs potential unlocks for debugging
  }
}
