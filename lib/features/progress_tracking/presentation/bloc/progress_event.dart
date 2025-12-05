import 'package:equatable/equatable.dart';

/// [Event Base Class] Base class for all progress-related events.
///
/// Events represent user actions and system events in progress tracking.
abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

/// [Event] Triggered when progress screen is loaded.
///
/// Loads current progress from storage and displays to user.
class ProgressLoaded extends ProgressEvent {
  const ProgressLoaded();
}

/// [Event] User earned points from completing a lesson/exercise.
///
/// Triggers point addition and potential achievement unlocks.
class PointsAdded extends ProgressEvent {
  /// [int] Number of points earned
  final int points;

  /// Create a PointsAdded event.
  ///
  /// Parameters:
  /// - points: Points to add
  const PointsAdded({required this.points});

  @override
  List<Object?> get props => [points];
}

/// [Event] User completed a lesson, update streak.
///
/// Calculates if streak continues, increments, or resets.
class StreakUpdated extends ProgressEvent {
  const StreakUpdated();
}

/// [Event] Achievement criteria met, unlock for user.
///
/// Triggers achievement unlock popup and confetti.
class AchievementUnlocked extends ProgressEvent {
  /// [String] ID of achievement to unlock
  final String achievementId;

  /// Creates an AchievementUnlocked event.
  ///
  /// Parameters:
  /// - achievementId: Achievement to unlock
  const AchievementUnlocked({required this.achievementId});

  @override
  List<Object?> get props => [achievementId];
}

/// [Event] User requested progress reset.
///
/// Clears all progress data (for testing or user request).
class ProgressReset extends ProgressEvent {
  const ProgressReset();
}

/// [Event] Retry loading progress after failure.
///
/// Triggered when user taps retry button after load error.
class RetryLoadProgress extends ProgressEvent {
  const RetryLoadProgress();
}

/// [Event] Retry adding points after failure.
///
/// Re-attempts point addition with same value.
class RetryAddPoints extends ProgressEvent {
  /// [int] Number of points to retry adding
  final int points;

  /// Creates a RetryAddPoints event.
  ///
  /// Parameters:
  /// - points: Points that failed to add previously
  const RetryAddPoints({required this.points});

  @override
  List<Object?> get props => [points];
}

/// [Event] Retry updating streak after failure.
///
/// Re-attempts streak calculation.
class RetryUpdateStreak extends ProgressEvent {
  const RetryUpdateStreak();
}
