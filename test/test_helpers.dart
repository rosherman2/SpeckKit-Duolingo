import 'package:flutter_test/flutter_test.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/achievement.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/lesson_progress.dart';

/// [Test Helpers] Common test data and utilities for all tests.
///
/// Provides:
/// - Predefined test entities
/// - Common test dates
/// - Helper functions for test setup
///
/// Purpose: Reduce duplication across test files

/// Common test dates
final kTestDate = DateTime(2025, 1, 1);
final kTestDateYesterday = DateTime(2024, 12, 31);
final kTestDateTomorrow = DateTime(2025, 1, 2);

/// Test UserProgress with default values
final tUserProgress = UserProgress(
  totalPoints: 100,
  currentStreak: 5,
  longestStreak: 10,
  lastPracticeDate: kTestDate,
  unlockedAchievements: const ['century_club'],
);

/// Test UserProgress with no progress
final tUserProgressInitial = UserProgress.initial();

/// Test UserProgress with max streak
final tUserProgressMaxStreak = UserProgress(
  totalPoints: 1000,
  currentStreak: 30,
  longestStreak: 30,
  lastPracticeDate: kTestDate,
  unlockedAchievements: const [
    'century_club',
    'half_thousand',
    'millennium',
    'week_warrior',
  ],
);

/// Test Achievement - Century Club
const tAchievementCenturyClub = Achievement(
  id: 'century_club',
  name: 'Century Club',
  description: 'Earn 100 total points',
  iconPath: 'assets/images/achievements/century_club.png',
  criteria: {'type': 'points', 'value': 100},
);

/// Test Achievement - Week Warrior
const tAchievementWeekWarrior = Achievement(
  id: 'week_warrior',
  name: 'Week Warrior',
  description: 'Practice for 7 days in a row',
  iconPath: 'assets/images/achievements/week_warrior.png',
  criteria: {'type': 'streak', 'value': 7},
);

/// Test LessonProgress for English
final tLessonProgressEnglish = LessonProgress(
  language: 'english',
  completedLessonIds: const ['lesson_1', 'lesson_2'],
  currentLessonId: 'lesson_3',
  starsEarned: const {'lesson_1': 3, 'lesson_2': 2},
);

/// Test LessonProgress initial state
final tLessonProgressInitial = LessonProgress.initial('english');

/// Helper function to create UserProgress with custom points
UserProgress createUserProgressWithPoints(int points) {
  return UserProgress(
    totalPoints: points,
    currentStreak: 5,
    longestStreak: 10,
    lastPracticeDate: kTestDate,
    unlockedAchievements: const [],
  );
}

/// Helper function to create UserProgress with custom streak
UserProgress createUserProgressWithStreak(
    int currentStreak, int longestStreak) {
  return UserProgress(
    totalPoints: 100,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    lastPracticeDate: kTestDate,
    unlockedAchievements: const [],
  );
}

/// Helper function to verify equality with better error messages
void expectProgressEquals(UserProgress actual, UserProgress expected) {
  expect(actual.totalPoints, expected.totalPoints,
      reason: 'totalPoints mismatch');
  expect(actual.currentStreak, expected.currentStreak,
      reason: 'currentStreak mismatch');
  expect(actual.longestStreak, expected.longestStreak,
      reason: 'longestStreak mismatch');
  expect(actual.unlockedAchievements, expected.unlockedAchievements,
      reason: 'unlockedAchievements mismatch');
}
