import 'package:dartz/dartz.dart';
import 'package:speckkit_duolingo/core/errors/failures.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/achievement.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/lesson_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';

/// [Repository Interface] Contract for progress tracking data operations.
///
/// Defines operations for:
/// - Retrieving and updating user progress
/// - Managing points and streaks
/// - Unlocking achievements
/// - Tracking lesson progress
///
/// Purpose: Abstract data layer from domain layer
///
/// Constitutional Requirement: Clean Architecture - repository pattern
abstract class ProgressRepository {
  /// Retrieves current user progress from storage.
  ///
  /// Returns:
  /// - Right(UserProgress) on success
  /// - Left(CacheFailure) if storage access fails
  ///
  /// Used by: All use cases to get current state
  Future<Either<Failure, UserProgress>> getUserProgress();

  /// Adds points to user's total and saves to storage.
  ///
  /// Parameters:
  /// - points: Number of points to add (must be > 0)
  ///
  /// Returns:
  /// - Right(UserProgress) with updated points
  /// - Left(CacheFailure) if storage fails
  /// - Left(ValidationFailure) if points <= 0
  ///
  /// Side effects: May trigger achievement unlocks
  Future<Either<Failure, UserProgress>> addPoints(int points);

  /// Updates user's streak based on current date.
  ///
  /// Logic:
  /// - If practiced today already: no change
  /// - If practiced yesterday: increment streak
  /// - If missed day(s): reset streak to 1
  ///
  /// Returns:
  /// - Right(UserProgress) with updated streak
  /// - Left(CacheFailure) if storage fails
  ///
  /// Used by: CalculateStreak use case after lesson completion
  Future<Either<Failure, UserProgress>> updateStreak();

  /// Unlocks an achievement for the user.
  ///
  /// Parameters:
  /// - achievementId: ID of achievement to unlock
  ///
  /// Returns:
  /// - Right(UserProgress) with achievement added
  /// - Left(CacheFailure) if storage fails
  /// - Left(ValidationFailure) if already unlocked
  ///
  /// Side effects: Sets unlockedAt timestamp
  Future<Either<Failure, UserProgress>> unlockAchievement(String achievementId);

  /// Retrieves lesson progress for a specific language.
  ///
  /// Parameters:
  /// - language: 'english' or 'hebrew'
  ///
  /// Returns:
  /// - Right(LessonProgress) for that language
  /// - Left(CacheFailure) if storage fails
  ///
  /// If no progress exists, returns initial/empty progress
  Future<Either<Failure, LessonProgress>> getLessonProgress(String language);

  /// Updates lesson progress after lesson completion.
  ///
  /// Parameters:
  /// - language: Which language the lesson belongs to
  /// - lessonId: ID of completed lesson
  /// - stars: Stars earned (1-3)
  ///
  /// Returns:
  /// - Right(LessonProgress) with updated completion
  /// - Left(CacheFailure) if storage fails
  /// - Left(ValidationFailure) if stars not in 1-3 range
  ///
  /// Side effects: Adds to completedLessonIds, updates starsEarned map
  Future<Either<Failure, LessonProgress>> updateLessonProgress({
    required String language,
    required String lessonId,
    required int stars,
  });

  /// Retrieves list of all available achievements.
  ///
  /// Returns:
  /// - Right(List<Achievement>) with all achievements
  /// - Left(AssetFailure) if achievement data can't be loaded
  ///
  /// Note: Achievement definitions stored as asset JSON
  Future<Either<Failure, List<Achievement>>> getAllAchievements();

  /// Checks if user has unlocked a specific achievement.
  ///
  /// Parameters:
  /// - achievementId: ID to check
  ///
  /// Returns:
  /// - Right(true) if unlocked
  /// - Right(false) if locked
  /// - Left(CacheFailure) if storage fails
  Future<Either<Failure, bool>> isAchievementUnlocked(String achievementId);

  /// Resets all progress (for testing or user request).
  ///
  /// Returns:
  /// - Right(UserProgress) with initial values
  /// - Left(CacheFailure) if storage fails
  ///
  /// Warning: Destructive operation
  Future<Either<Failure, UserProgress>> resetProgress();
}
