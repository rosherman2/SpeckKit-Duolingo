import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/calculate_streak.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/unlock_achievement.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/update_points.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';
import 'package:speckkit_duolingo/features/progress_tracking/presentation/bloc/progress_event.dart';
import 'package:speckkit_duolingo/features/progress_tracking/presentation/bloc/progress_state.dart';

/// [BLoC] Manages progress tracking state and business logic.
///
/// Handles:
/// - Loading current progress
/// - Adding points
/// - Updating streaks
/// - Unlocking achievements
///
/// Purpose: Coordinate progress tracking UI and domain logic
///
/// Constitutional Requirement: Principle II - BLoC state management
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  /// [ProgressRepository] Repository for progress operations
  final ProgressRepository repository;

  /// [UpdatePoints] Use case for adding points
  final UpdatePoints updatePoints;

  /// [CalculateStreak] Use case for streak logic
  final CalculateStreak calculateStreak;

  /// [UnlockAchievement] Use case for unlocking achievements
  final UnlockAchievement unlockAchievement;

  /// Creates a ProgressBloc with required dependencies.
  ///
  /// Parameters:
  /// - repository: Progress repository
  /// - updatePoints: Points update use case
  /// - calculateStreak: Streak calculation use case
  ///- unlockAchievement: Achievement unlock use case
  ProgressBloc({
    required this.repository,
    required this.updatePoints,
    required this.calculateStreak,
    required this.unlockAchievement,
  }) : super(const ProgressInitial()) {
    // Use sequential transformer for data-mutating operations
    // Prevents race conditions when updating progress
    on<ProgressLoaded>(_onProgressLoaded, transformer: sequential());
    on<PointsAdded>(_onPointsAdded, transformer: sequential());
    on<StreakUpdated>(_onStreakUpdated, transformer: sequential());
    on<AchievementUnlocked>(_onAchievementUnlocked, transformer: sequential());
    on<ProgressReset>(_onProgressReset, transformer: sequential());

    // Retry event handlers (also sequential to prevent conflicts)
    on<RetryLoadProgress>(_onRetryLoadProgress, transformer: sequential());
    on<RetryAddPoints>(_onRetryAddPoints, transformer: sequential());
    on<RetryUpdateStreak>(_onRetryUpdateStreak, transformer: sequential());

    AppLogger.debug(
        'ProgressBloc',
        'constructor',
        () =>
            'ProgressBloc initialized with retry handlers and sequential transformers');
  }

  /// [Event Handler] Loads current progress from storage.
  Future<void> _onProgressLoaded(
    ProgressLoaded event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info(
        'ProgressBloc', '_onProgressLoaded', () => 'Loading user progress');

    emit(const ProgressLoading());

    final result = await repository.getUserProgress();

    result.fold(
      (failure) {
        AppLogger.error('ProgressBloc', '_onProgressLoaded',
            () => 'Failed to load progress: ${failure.runtimeType}');
        emit(const ProgressError(
          message: 'Failed to load progress. Please try again.',
          operationType: 'load',
          canRetry: true,
        ));
      },
      (progress) {
        AppLogger.info(
            'ProgressBloc',
            '_onProgressLoaded',
            () =>
                'Progress loaded: ${progress.totalPoints} points, ${progress.currentStreak} streak');
        emit(ProgressLoadedState(progress: progress));
      },
    );
  }

  /// [Event Handler] Adds points to user's total.
  Future<void> _onPointsAdded(
    PointsAdded event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info('ProgressBloc', '_onPointsAdded',
        () => 'Adding ${event.points} points');

    final currentProgress = await _getCurrentProgress();
    if (currentProgress == null) {
      emit(const ProgressError(message: 'Failed access current progress'));
      return;
    }

    final result = await updatePoints(event.points);

    result.fold(
      (failure) {
        AppLogger.error('ProgressBloc', '_onPointsAdded',
            () => 'Failed to add points: ${failure.runtimeType}');
        emit(ProgressError(
          message: 'Failed to add points. Please try again.',
          operationType: 'addPoints',
          retryContext: {'points': event.points},
          canRetry: true,
        ));
        emit(ProgressLoadedState(progress: currentProgress));
      },
      (updatedProgress) {
        AppLogger.info(
            'ProgressBloc',
            '_onPointsAdded',
            () =>
                'Points added successfully. New total: ${updatedProgress.totalPoints}');
        emit(ProgressUpdated(
          progress: updatedProgress,
          updateType: 'points',
        ));

        // Check for achievement unlocks
        _checkAndUnlockAchievements(currentProgress, updatedProgress);
      },
    );
  }

  /// [Event Handler] Updates user's practice streak.
  Future<void> _onStreakUpdated(
    StreakUpdated event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info(
        'ProgressBloc', '_onStreakUpdated', () => 'Updating practice streak');

    final currentProgress = await _getCurrentProgress();
    if (currentProgress == null) {
      emit(const ProgressError(message: 'Failed to access current progress'));
      return;
    }

    final result = await calculateStreak();

    result.fold(
      (failure) {
        AppLogger.error('ProgressBloc', '_onStreakUpdated',
            () => 'Failed to update streak: ${failure.runtimeType}');
        emit(const ProgressError(
          message: 'Failed to update streak. Please try again.',
          operationType: 'updateStreak',
          canRetry: true,
        ));
        emit(ProgressLoadedState(progress: currentProgress!));
      },
      (updatedProgress) {
        AppLogger.info('ProgressBloc', '_onStreakUpdated',
            () => 'Streak updated: ${updatedProgress.currentStreak} days');
        emit(ProgressUpdated(
          progress: updatedProgress,
          updateType: 'streak',
        ));

        // Check for streak achievements
        if (updatedProgress.currentStreak >= 7 &&
            !updatedProgress.unlockedAchievements.contains('week_warrior')) {
          add(const AchievementUnlocked(achievementId: 'week_warrior'));
        }
      },
    );
  }

  /// [Event Handler] Unlocks an achievement for the user.
  Future<void> _onAchievementUnlocked(
    AchievementUnlocked event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info('ProgressBloc', '_onAchievementUnlocked',
        () => 'Unlocking achievement: ${event.achievementId}');

    final result = await unlockAchievement(event.achievementId);

    result.fold(
      (failure) {
        AppLogger.error('ProgressBloc', '_onAchievementUnlocked',
            () => 'Failed to unlock achievement: ${failure.runtimeType}');
        // Don't show error to user, just log it
      },
      (updatedProgress) {
        AppLogger.info('ProgressBloc', '_onAchievementUnlocked',
            () => '🏆 Achievement ${event.achievementId} unlocked!');
        emit(AchievementUnlockedState(
          progress: updatedProgress,
          achievementId: event.achievementId,
        ));
      },
    );
  }

  /// [Event Handler] Resets all progress to initial state.
  Future<void> _onProgressReset(
    ProgressReset event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.warning(
        'ProgressBloc', '_onProgressReset', () => 'Resetting all progress');

    emit(const ProgressLoading());

    final result = await repository.resetProgress();

    result.fold(
      (failure) {
        AppLogger.error('ProgressBloc', '_onProgressReset',
            () => 'Failed to reset progress: ${failure.runtimeType}');
        emit(const ProgressError(message: 'Failed to reset progress'));
      },
      (initialProgress) {
        AppLogger.info('ProgressBloc', '_onProgressReset',
            () => 'Progress reset successfully');
        emit(ProgressLoadedState(progress: initialProgress));
      },
    );
  }

  /// [Helper] Gets current progress from repository.
  ///
  /// Returns: UserProgress or null if failed
  Future<UserProgress?> _getCurrentProgress() async {
    final result = await repository.getUserProgress();
    return result.fold(
      (failure) {
        AppLogger.error('ProgressBloc', '_getCurrentProgress',
            () => 'Failed to get current progress');
        return null;
      },
      (progress) => progress,
    );
  }

  /// [Helper] Checks if point total unlocked any achievements.
  void _checkAndUnlockAchievements(
    UserProgress oldProgress,
    UserProgress newProgress,
  ) {
    final points = newProgress.totalPoints;
    final unlocked = newProgress.unlockedAchievements;

    // Check each achievement threshold
    if (points >= 100 && !unlocked.contains('century_club')) {
      add(const AchievementUnlocked(achievementId: 'century_club'));
    }
    if (points >= 500 && !unlocked.contains('half_thousand')) {
      add(const AchievementUnlocked(achievementId: 'half_thousand'));
    }
    if (points >= 1000 && !unlocked.contains('millennium')) {
      add(const AchievementUnlocked(achievementId: 'millennium'));
    }
    if (points >= 5000 && !unlocked.contains('five_thousand_club')) {
      add(const AchievementUnlocked(achievementId: 'five_thousand_club'));
    }
  }

  /// [Event Handler] Retries loading progress after failure.
  ///
  /// Delegates to _onProgressLoaded to retry the operation.
  Future<void> _onRetryLoadProgress(
    RetryLoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info('ProgressBloc', '_onRetryLoadProgress',
        () => 'Retrying progress load after failure');

    // Delegate to original handler
    return _onProgressLoaded(const ProgressLoaded(), emit);
  }

  /// [Event Handler] Retries adding points after failure.
  ///
  /// Delegates to _onPointsAdded with the same points value.
  Future<void> _onRetryAddPoints(
    RetryAddPoints event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info('ProgressBloc', '_onRetryAddPoints',
        () => 'Retrying add points (${event.points}) after failure');

    // Delegate to original handler
    return _onPointsAdded(PointsAdded(points: event.points), emit);
  }

  /// [Event Handler] Retries updating streak after failure.
  ///
  /// Delegates to _onStreakUpdated to retry the operation.
  Future<void> _onRetryUpdateStreak(
    RetryUpdateStreak event,
    Emitter<ProgressState> emit,
  ) async {
    AppLogger.info('ProgressBloc', '_onRetryUpdateStreak',
        () => 'Retrying streak update after failure');

    // Delegate to original handler
    return _onStreakUpdated(const StreakUpdated(), emit);
  }

  @override
  Future<void> close() {
    AppLogger.debug('ProgressBloc', 'close', () => 'ProgressBloc closing');
    return super.close();
  }
}
