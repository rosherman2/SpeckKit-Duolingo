import 'package:dartz/dartz.dart';
import 'package:speckkit_duolingo/core/errors/exceptions.dart';
import 'package:speckkit_duolingo/core/errors/failures.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/progress_tracking/data/datasources/progress_local_data_source.dart';
import 'package:speckkit_duolingo/features/progress_tracking/data/models/user_progress_model.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/achievement.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/lesson_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';

/// [Repository Implementation] Implements progress tracking operations.
///
/// Coordinates between domain layer and data sources.
/// Handles:
/// - Exception to Failure conversion
/// - Business logic for streaks and achievements
/// - Data persistence through local data source
///
/// Purpose: Implement repository contract from domain layer
///
/// Constitutional Requirement: Clean Architecture - repository layer
class ProgressRepositoryImpl implements ProgressRepository {
  /// [ProgressLocalDataSource] Local storage data source
  final ProgressLocalDataSource localDataSource;

  /// Creates a ProgressRepositoryImpl.
  ///
  /// Parameters:
  /// - localDataSource: Hive data source for storage
  const ProgressRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProgress>> getUserProgress() async {
    AppLogger.debug('ProgressRepositoryImpl', 'getUserProgress',
        () => 'Fetching user progress from data source');

    try {
      final progress = await localDataSource.getUserProgress();

      AppLogger.debug(
          'ProgressRepositoryImpl',
          'getUserProgress',
          () =>
              'Successfully retrieved progress: ${progress.totalPoints} points');

      return Right(progress);
    } on CacheException {
      AppLogger.error('ProgressRepositoryImpl', 'getUserProgress',
          () => 'Cache exception while reading progress');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserProgress>> addPoints(int points) async {
    AppLogger.debug(
        'ProgressRepositoryImpl', 'addPoints', () => 'Adding $points points');

    // Validate points
    if (points <= 0) {
      AppLogger.error('ProgressRepositoryImpl', 'addPoints',
          () => 'Validation failed: points must be > 0');
      return Left(ValidationFailure('Points must be greater than 0'));
    }

    try {
      // Get current progress
      final currentProgress = await localDataSource.getUserProgress();

      // Calculate new total
      final newTotal = currentProgress.totalPoints + points;

      AppLogger.info(
          'ProgressRepositoryImpl',
          'addPoints',
          () =>
              '$points points added. Total: $newTotal (was ${currentProgress.totalPoints})');

      // Create updated progress
      final updatedProgress = UserProgressModel.fromEntity(
        currentProgress.copyWith(totalPoints: newTotal),
      );

      // Save to storage
      await localDataSource.saveUserProgress(updatedProgress);

      AppLogger.debug('ProgressRepositoryImpl', 'addPoints',
          () => 'Progress saved successfully');

      return Right(updatedProgress);
    } on CacheException {
      AppLogger.error('ProgressRepositoryImpl', 'addPoints',
          () => 'Cache exception while adding points');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserProgress>> updateStreak() async {
    AppLogger.debug('ProgressRepositoryImpl', 'updateStreak',
        () => 'Calculating streak update');

    try {
      // Get current progress
      final currentProgress = await localDataSource.getUserProgress();

      final now = DateTime.now();
      final lastPractice = currentProgress.lastPracticeDate;

      // Calculate days difference
      final daysDifference = _daysBetween(lastPractice, now);

      AppLogger.debug(
          'ProgressRepositoryImpl',
          'updateStreak',
          () =>
              'Last practice: ${lastPractice.toIso8601String()}, Days since: $daysDifference');

      int newStreak;

      if (daysDifference == 0) {
        // Already practiced today, no change
        newStreak = currentProgress.currentStreak;
        AppLogger.debug('ProgressRepositoryImpl', 'updateStreak',
            () => 'Already practiced today, streak unchanged: $newStreak');
      } else if (daysDifference == 1) {
        // Practiced yesterday, increment streak
        newStreak = currentProgress.currentStreak + 1;
        AppLogger.info('ProgressRepositoryImpl', 'updateStreak',
            () => 'Practiced yesterday! Streak incremented: $newStreak');
      } else {
        // Missed day(s), reset to 1
        newStreak = 1;
        AppLogger.warning(
            'ProgressRepositoryImpl',
            'updateStreak',
            () =>
                'Missed ${daysDifference - 1} day(s). Streak reset to 1 (was ${currentProgress.currentStreak})');
      }

      // Update longest streak if needed
      final newLongest = newStreak > currentProgress.longestStreak
          ? newStreak
          : currentProgress.longestStreak;

      if (newLongest > currentProgress.longestStreak) {
        AppLogger.info('ProgressRepositoryImpl', 'updateStreak',
            () => '🔥 New personal record! Longest streak: $newLongest');
      }

      // Create updated progress
      final updatedProgress = UserProgressModel.fromEntity(
        currentProgress.copyWith(
          currentStreak: newStreak,
          longestStreak: newLongest,
          lastPracticeDate: now,
        ),
      );

      // Save to storage
      await localDataSource.saveUserProgress(updatedProgress);

      return Right(updatedProgress);
    } on CacheException {
      AppLogger.error('ProgressRepositoryImpl', 'updateStreak',
          () => 'Cache exception while updating streak');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserProgress>> unlockAchievement(
      String achievementId) async {
    AppLogger.debug('ProgressRepositoryImpl', 'unlockAchievement',
        () => 'Unlocking achievement: $achievementId');

    try {
      // Get current progress
      final currentProgress = await localDataSource.getUserProgress();

      // Check if already unlocked
      if (currentProgress.unlockedAchievements.contains(achievementId)) {
        AppLogger.warning('ProgressRepositoryImpl', 'unlockAchievement',
            () => 'Achievement already unlocked: $achievementId');
        return Left(ValidationFailure('Achievement already unlocked'));
      }

      // Add to unlocked list
      final updatedAchievements = [
        ...currentProgress.unlockedAchievements,
        achievementId,
      ];

      AppLogger.info('ProgressRepositoryImpl', 'unlockAchievement',
          () => '🏆 Achievement unlocked: $achievementId');

      // Create updated progress
      final updatedProgress = UserProgressModel.fromEntity(
        currentProgress.copyWith(unlockedAchievements: updatedAchievements),
      );

      // Save to storage
      await localDataSource.saveUserProgress(updatedProgress);

      return Right(updatedProgress);
    } on CacheException {
      AppLogger.error('ProgressRepositoryImpl', 'unlockAchievement',
          () => 'Cache exception while unlocking achievement');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, LessonProgress>> getLessonProgress(
      String language) async {
    AppLogger.debug('ProgressRepositoryImpl', 'getLessonProgress',
        () => 'Getting lesson progress for: $language');

    // TODO: Implement lesson progress storage when lessons are added
    // For now, return initial progress
    final progress = LessonProgress.initial(language);

    return Right(progress);
  }

  @override
  Future<Either<Failure, LessonProgress>> updateLessonProgress({
    required String language,
    required String lessonId,
    required int stars,
  }) async {
    AppLogger.debug(
        'ProgressRepositoryImpl',
        'updateLessonProgress',
        () =>
            'Updating lesson progress: $language, lesson $lessonId, $stars stars');

    // Validate stars
    if (stars < 1 || stars > 3) {
      AppLogger.error('ProgressRepositoryImpl', 'updateLessonProgress',
          () => 'Invalid stars value: $stars (must be 1-3)');
      return Left(ValidationFailure('Stars must be between 1 and 3'));
    }

    // TODO: Implement lesson progress storage when lessons are added
    // For now, return success
    return Right(LessonProgress.initial(language));
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAllAchievements() async {
    AppLogger.debug('ProgressRepositoryImpl', 'getAllAchievements',
        () => 'Loading all achievements');

    // TODO: Load from assets/data/achievements.json when assets are added
    // For now, return hardcoded achievements
    final achievements = _getHardcodedAchievements();

    return Right(achievements);
  }

  @override
  Future<Either<Failure, bool>> isAchievementUnlocked(
      String achievementId) async {
    try {
      final progress = await localDataSource.getUserProgress();
      final isUnlocked = progress.unlockedAchievements.contains(achievementId);

      AppLogger.debug('ProgressRepositoryImpl', 'isAchievementUnlocked',
          () => 'Achievement $achievementId unlocked: $isUnlocked');

      return Right(isUnlocked);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserProgress>> resetProgress() async {
    AppLogger.warning('ProgressRepositoryImpl', 'resetProgress',
        () => 'Resetting all progress');

    try {
      await localDataSource.deleteUserProgress();

      final initialProgress = UserProgressModel.fromEntity(
        UserProgress.initial(),
      );

      await localDataSource.saveUserProgress(initialProgress);

      AppLogger.info('ProgressRepositoryImpl', 'resetProgress',
          () => 'Progress reset to initial state');

      return Right(initialProgress);
    } on CacheException {
      AppLogger.error('ProgressRepositoryImpl', 'resetProgress',
          () => 'Failed to reset progress');
      return Left(CacheFailure());
    }
  }

  /// [Helper] Calculates days between two dates.
  ///
  /// Parameters:
  /// - from: Start date
  /// - to: End date
  ///
  /// Returns: Number of days difference (0 if same day)
  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  /// [Helper] Returns hardcoded achievements list.
  ///
  /// TODO: Load from assets/data/achievements.json
  ///
  /// Returns: List of available achievements
  List<Achievement> _getHardcodedAchievements() {
    return [
      const Achievement(
        id: 'century_club',
        name: 'Century Club',
        description: 'Earn 100 total points',
        iconPath: 'assets/images/achievements/century_club.png',
        criteria: {'type': 'points', 'value': 100},
      ),
      const Achievement(
        id: 'half_thousand',
        name: 'Half Thousand',
        description: 'Earn 500 total points',
        iconPath: 'assets/images/achievements/half_thousand.png',
        criteria: {'type': 'points', 'value': 500},
      ),
      const Achievement(
        id: 'millennium',
        name: 'Millennium',
        description: 'Reach 1000 points',
        iconPath: 'assets/images/achievements/millennium.png',
        criteria: {'type': 'points', 'value': 1000},
      ),
      const Achievement(
        id: 'five_thousand_club',
        name: 'Five Thousand Club',
        description: 'Earn 5000 total points',
        iconPath: 'assets/images/achievements/five_thousand.png',
        criteria: {'type': 'points', 'value': 5000},
      ),
      const Achievement(
        id: 'week_warrior',
        name: 'Week Warrior',
        description: 'Practice for 7 days in a row',
        iconPath: 'assets/images/achievements/week_warrior.png',
        criteria: {'type': 'streak', 'value': 7},
      ),
    ];
  }
}
