import 'package:equatable/equatable.dart';

/// [Entity] Represents an unlockable achievement/trophy.
///
/// Achievements reward users for milestones:
/// - Point milestones (100, 500, 1000, 5000 points)
/// - Streak milestones (7 days)
/// - Lesson completions
///
/// Purpose: Gamification element to motivate users
///
/// Domain Layer: Pure business logic
class Achievement extends Equatable {
  /// [String] Unique identifier for the achievement
  ///
  /// Examples: 'century_club', 'week_warrior', 'millennium'
  final String id;

  /// [String] Display name shown to user
  ///
  /// Examples: 'Century Club', 'Week Warrior', 'Millennium'
  final String name;

  /// [String] Brief description of achievement requirement
  ///
  /// Examples:
  /// - 'Earn 100 total points'
  /// - 'Practice for 7 days in a row'
  /// - 'Reach 1000 points'
  final String description;

  /// [String] Path to achievement icon asset
  ///
  /// Rationale: Visual representation makes achievements more rewarding
  /// Example: 'assets/images/achievements/century_club.png'
  final String iconPath;

  /// [DateTime] When this achievement was unlocked by user
  ///
  /// Null if not yet unlocked
  /// Used to display "Unlocked on [date]" in UI
  final DateTime? unlockedAt;

  /// [Map<String, dynamic>] Criteria required to unlock this achievement
  ///
  /// Examples:
  /// - {'type': 'points', 'value': 100}
  /// - {'type': 'streak', 'value': 7}
  /// - {'type': 'lessons', 'value': 10}
  ///
  /// Rationale: Flexible structure allows various achievement types
  final Map<String, dynamic> criteria;

  /// Creates an Achievement entity.
  ///
  /// Parameters:
  /// - id: Unique achievement identifier
  /// - name: Display name for user
  /// - description: What user needs to do
  /// - iconPath: Asset path to icon image
  /// - unlockedAt: When unlocked (null if locked)
  /// - criteria: Requirements to unlock
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    this.unlockedAt,
    required this.criteria,
  });

  /// Creates a copy of this Achievement with specified fields updated.
  ///
  /// Primarily used to set unlockedAt when achievement is earned.
  ///
  /// Parameters:
  /// - unlockedAt: When achievement was unlocked
  ///
  /// Returns: New Achievement instance with updated values
  Achievement copyWith({
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      criteria: criteria,
    );
  }

  /// Checks if this achievement is unlocked.
  ///
  /// Returns: True if unlockedAt is not null
  bool get isUnlocked => unlockedAt != null;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconPath,
        unlockedAt,
        criteria,
      ];
}
