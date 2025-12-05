import 'package:equatable/equatable.dart';

/// [Entity] Represents user's overall progress and gamification stats.
///
/// Tracks:
/// - Total points earned across all lessons
/// - Current and longest streaks
/// - Last practice date for streak calculation
/// - Unlocked achievement IDs
///
/// Purpose: Core entity for progress tracking and gamification
///
/// Domain Layer: Pure business logic, no implementation details
class UserProgress extends Equatable {
  /// [int] Total accumulated points from all completed lessons
  ///
  /// Rationale: Points motivate continued learning and unlock achievements
  /// Constraint: Must be >= 0
  final int totalPoints;

  /// [int] Number of consecutive days user has practiced
  ///
  /// Rationale: Encourages daily engagement
  /// Resets to 0 if user misses a day
  final int currentStreak;

  /// [int] Highest streak ever achieved by user
  ///
  /// Rationale: Provides long-term motivation goal
  final int longestStreak;

  /// [DateTime] Last date when user completed a lesson
  ///
  /// Rationale: Used to calculate if streak should continue or reset
  final DateTime lastPracticeDate;

  /// [List<String>] IDs of achievements unlocked by user
  ///
  /// Rationale: Tracks which achievements have been earned
  /// Examples: 'century_club', 'week_warrior', 'millennium'
  final List<String> unlockedAchievements;

  /// Creates a UserProgress entity.
  ///
  /// Parameters:
  /// - totalPoints: Total points earned (must be >= 0)
  /// - currentStreak: Current consecutive days
  /// - longestStreak: Best streak ever achieved
  /// - lastPracticeDate: Last lesson completion date
  /// - unlockedAchievements: List of unlocked achievement IDs
  const UserProgress({
    required this.totalPoints,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastPracticeDate,
    required this.unlockedAchievements,
  });

  /// Creates a new UserProgress with default values for first-time users.
  ///
  /// Returns: Fresh progress with 0 points, 0 streak, empty achievements
  factory UserProgress.initial() {
    return UserProgress(
      totalPoints: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastPracticeDate: DateTime.now(),
      unlockedAchievements: const [],
    );
  }

  /// Creates a copy of this UserProgress with specified fields updated.
  ///
  /// Parameters:
  /// - totalPoints: Updated total points (optional)
  /// - currentStreak: Updated current streak (optional)
  /// - longestStreak: Updated longest streak (optional)
  /// - lastPracticeDate: Updated last practice date (optional)
  /// - unlockedAchievements: Updated achievements list (optional)
  ///
  /// Returns: New UserProgress instance with updated values
  UserProgress copyWith({
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPracticeDate,
    List<String>? unlockedAchievements,
  }) {
    return UserProgress(
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }

  @override
  List<Object?> get props => [
        totalPoints,
        currentStreak,
        longestStreak,
        lastPracticeDate,
        unlockedAchievements,
      ];
}
