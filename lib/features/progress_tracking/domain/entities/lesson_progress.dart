import 'package:equatable/equatable.dart';

/// [Entity] Tracks user's progress within a specific language.
///
/// Manages:
/// - Which lessons have been completed
/// - Current active lesson
/// - Stars earned per completed lesson
///
/// Purpose: Track learning progress for each language separately
///
/// Domain Layer: Pure business logic
class LessonProgress extends Equatable {
  /// [String] Language being learning ('english' or 'hebrew')
  ///
  /// Rationale: Progress tracked separately per language
  final String language;

  /// [List<String>] IDs of lessons completed in this language
  ///
  /// Examples: ['lesson_1', 'lesson_2', 'lesson_3']
  /// Order doesn't matter, just completion status
  final List<String> completedLessonIds;

  /// [String] ID of lesson currently being worked on
  ///
  /// Null if no lesson started yet
  /// Example: 'lesson_4'
  final String? currentLessonId;

  /// [Map<String, int>] Stars earned per lesson (1-3 stars)
  ///
  /// Key: Lesson ID
  /// Value: Number of stars (1-3 based on accuracy)
  ///
  /// Examples:
  /// - {'lesson_1': 3, 'lesson_2': 2, 'lesson_3': 3}
  ///
  /// Rationale: Encourages replayability to improve scores
  final Map<String, int> starsEarned;

  /// Creates a LessonProgress entity.
  ///
  /// Parameters:
  /// - language: Which language this progress tracks
  /// - completedLessonIds: List of completed lesson IDs
  /// - currentLessonId: Currently active lesson ID (optional)
  /// - starsEarned: Map of lesson ID to star count
  const LessonProgress({
    required this.language,
    required this.completedLessonIds,
    this.currentLessonId,
    required this.starsEarned,
  });

  /// Creates a new LessonProgress with default values for a language.
  ///
  /// Parameters:
  /// - language: Which language to create progress for
  ///
  /// Returns: Fresh progress with no completed lessons
  factory LessonProgress.initial(String language) {
    return LessonProgress(
      language: language,
      completedLessonIds: const [],
      currentLessonId: null,
      starsEarned: const {},
    );
  }

  /// Creates a copy of this LessonProgress with specified fields updated.
  ///
  /// Parameters:
  /// - completedLessonIds: Updated completed lessons (optional)
  /// - currentLessonId: Updated current lesson (optional)
  /// - starsEarned: Updated stars map (optional)
  ///
  /// Returns: New LessonProgress instance with updated values
  LessonProgress copyWith({
    List<String>? completedLessonIds,
    String? currentLessonId,
    Map<String, int>? starsEarned,
  }) {
    return LessonProgress(
      language: language,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      starsEarned: starsEarned ?? this.starsEarned,
    );
  }

  /// Gets total number of lessons completed in this language.
  ///
  /// Returns: Count of completed lessons
  int get totalCompletedLessons => completedLessonIds.length;

  /// Gets total stars earned across all lessons in this language.
  ///
  /// Returns: Sum of all star values
  int get totalStars => starsEarned.values.fold(0, (sum, stars) => sum + stars);

  @override
  List<Object?> get props => [
        language,
        completedLessonIds,
        currentLessonId,
        starsEarned,
      ];
}
