import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';

/// [Model] Data layer implementation of UserProgress entity.
///
/// Extends UserProgress with JSON serialization/deserialization.
/// Handles conversion between Dart objects and JSON for Hive storage.
///
/// Purpose: Bridge between domain entities and data persistence
///
/// Constitutional Requirement: Clean Architecture - data models
class UserProgressModel extends UserProgress {
  /// Creates a UserProgressModel.
  ///
  /// Parameters match parent UserProgress entity
  const UserProgressModel({
    required super.totalPoints,
    required super.currentStreak,
    required super.longestStreak,
    required super.lastPracticeDate,
    required super.unlockedAchievements,
  });

  /// Creates a UserProgressModel from UserProgress entity.
  ///
  /// Parameters:
  /// - progress: Domain entity to convert
  ///
  /// Returns: Data model with same values
  factory UserProgressModel.fromEntity(UserProgress progress) {
    return UserProgressModel(
      totalPoints: progress.totalPoints,
      currentStreak: progress.currentStreak,
      longestStreak: progress.longestStreak,
      lastPracticeDate: progress.lastPracticeDate,
      unlockedAchievements: progress.unlockedAchievements,
    );
  }

  /// Creates a UserProgressModel from JSON map.
  ///
  /// Parameters:
  /// - json: JSON map from Hive storage
  ///
  /// Returns: UserProgressModel instance
  ///
  /// Throws: Exception if JSON format is invalid
  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      totalPoints: json['totalPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastPracticeDate: DateTime.parse(
        json['lastPracticeDate'] as String? ?? DateTime.now().toIso8601String(),
      ),
      unlockedAchievements: (json['unlockedAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  /// Converts this model to JSON map for storage.
  ///
  /// Returns: JSON-serializable map
  ///
  /// Used by: Hive data source for persistence
  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastPracticeDate': lastPracticeDate.toIso8601String(),
      'unlockedAchievements': unlockedAchievements,
    };
  }

  /// Creates a new UserProgressModel with updated values.
  ///
  /// Parameters match parent copyWith method
  ///
  /// Returns: New UserProgressModel instance
  @override
  UserProgressModel copyWith({
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPracticeDate,
    List<String>? unlockedAchievements,
  }) {
    return UserProgressModel(
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }
}
