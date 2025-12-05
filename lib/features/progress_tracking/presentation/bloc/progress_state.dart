import 'package:equatable/equatable.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';

/// [State Base Class] Base class for all progress-related states.
///
/// States represent different conditions of the progress UI.
abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

/// [State] Initial state before progress is loaded.
class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

/// [State] Progress is being loaded from storage.
class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

/// [State] Progress loaded successfully.
///
/// Displays current points, streak, and achievements.
class ProgressLoadedState extends ProgressState {
  /// [UserProgress] Current user progress
  final UserProgress progress;

  /// Creates a ProgressLoadedState.
  ///
  /// Parameters:
  /// - progress: Current progress to display
  const ProgressLoadedState({required this.progress});

  @override
  List<Object?> get props => [progress];
}

/// [State] Progress was updated (points added, streak changed).
///
/// Triggers UI animations for the update.
class ProgressUpdated extends ProgressState {
  /// [UserProgress] Updated progress
  final UserProgress progress;

  /// [String] Type of update ('points', 'streak', 'achievement')
  ///
  /// Used to determine which animation to show
  final String updateType;

  /// Creates a ProgressUpdated state.
  ///
  /// Parameters:
  /// - progress: Updated progress
  /// - updateType: What was updated
  const ProgressUpdated({
    required this.progress,
    required this.updateType,
  });

  @override
  List<Object?> get props => [progress, updateType];
}

/// [State] Achievement was unlocked, show celebration.
///
/// Triggers achievement popup with confetti animation.
class AchievementUnlockedState extends ProgressState {
  /// [UserProgress] Progress with new achievement
  final UserProgress progress;

  /// [String] ID of unlocked achievement
  final String achievementId;

  /// Creates an AchievementUnlockedState.
  ///
  /// Parameters:
  /// - progress: Updated progress
  /// - achievementId: Which achievement was unlocked
  const AchievementUnlockedState({
    required this.progress,
    required this.achievementId,
  });

  @override
  List<Object?> get props => [progress, achievementId];
}

/// [State] Error occurred while loading/updating progress.
///
/// Enhanced with retry capability and error context.
class ProgressError extends ProgressState {
  /// [String] Error message to display
  final String message;

  /// [String] Type of operation that failed
  ///
  /// Values: 'load', 'addPoints', 'updateStreak', 'reset'
  /// Used to determine which retry event to trigger
  final String operationType;

  /// [Map<String, dynamic>] Optional context for retry
  ///
  /// Contains operation-specific data needed for retry:
  /// - For 'addPoints': {'points': int}
  /// - For other operations: empty map
  final Map<String, dynamic> retryContext;

  /// [bool] Whether this error is retryable
  ///
  /// True for transient errors (network, cache)
  /// False for validation errors
  final bool canRetry;

  /// Creates a ProgressError state.
  ///
  /// Parameters:
  /// - message: Error description for user
  /// - operationType: What operation failed
  /// - retryContext: Data needed to retry operation
  /// - canRetry: Whether retry is possible
  const ProgressError({
    required this.message,
    this.operationType = 'unknown',
    this.retryContext = const {},
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [message, operationType, retryContext, canRetry];
}
