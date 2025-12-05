/// [Constants] Application-wide constant values.
///
/// Contains fixed values used throughout the app for consistency.
/// All constants should be documented with their purpose and rationale.
///
/// Purpose: Centralize configuration values to avoid magic numbers
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  /// [String] Application name displayed to users
  static const String appName = 'SpeckKit Duolingo';

  /// [String] Current version number (semver format)
  static const String version = '1.0.0';

  /// [String] App version alias for consistency
  static const String appVersion = version;

  /// [String] Build number (increments with each release)
  static const String buildNumber = '1';

  // Points System
  /// [int] Minimum points awarded for a correct answer
  ///
  /// Rationale: Ensures even easy questions provide meaningful progress
  static const int minPointsPerQuestion = 10;

  /// [int] Maximum points awarded for a correct answer
  ///
  /// Rationale: Rewards more difficult questions without excessive imbalance
  static const int maxPointsPerQuestion = 50;

  /// [int] Points required to unlock first achievement
  ///
  /// Rationale: Early milestone to encourage continued engagement
  static const int firstAchievementPoints = 100;

  /// [int] Points required for "Century Club" achievement
  static const int centuryClubPoints = 100;

  /// [int] Points required for "Half Thousand" achievement
  static const int halfThousandPoints = 500;

  /// [int] Points required for "Millennium" achievement
  static const int millenniumPoints = 1000;

  /// [int] Points required for "Five Thousand Club" achievement
  static const int fiveThousandPoints = 5000;

  // Streak System
  /// [int] Minimum streak required for "Week Warrior" achievement
  ///
  /// Rationale: 7 consecutive days is a significant commitment milestone
  static const int weekWarriorStreak = 7;

  /// [int] Streak milestone for special celebration
  static const int streakCelebrationThreshold = 5;

  // Lesson Configuration
  /// [int] Minimum number of exercises per lesson
  ///
  /// Rationale: Ensures sufficient practice without overwhelming users
  static const int minExercisesPerLesson = 5;

  /// [int] Maximum number of exercises per lesson
  static const int maxExercisesPerLesson = 10;

  /// [double] Required accuracy to earn 3 stars (100%)
  ///
  /// Rationale: Perfect score should be rewarded with maximum stars
  static const double threeStarAccuracy = 1.0;

  /// [double] Required accuracy to earn 2 stars (70%)
  ///
  /// Rationale: Above-average performance deserves good rating
  static const double twoStarAccuracy = 0.7;

  /// [double] Required accuracy to earn 1 star (50%)
  ///
  /// Rationale: Minimum passing grade to complete lesson
  static const double oneStarAccuracy = 0.5;

  // Performance Targets (from constitution)
  /// [int] Target frame rate for smooth animations
  ///
  /// Rationale: 60 FPS is standard for smooth mobile UI
  static const int targetFps = 60;

  /// [int] Maximum app cold start time in seconds
  ///
  /// Rationale: Users expect apps to launch quickly on modern devices
  static const int maxStartupSeconds = 3;

  /// [int] Maximum APK/IPA size in megabytes (uncompressed)
  ///
  /// Rationale: Keeps download size reasonable for users with limited data
  static const int maxAppSizeMb = 50;

  /// [int] Maximum peak memory usage in megabytes
  ///
  /// Rationale: Prevents crashes on mid-range devices
  static const int maxMemoryMb = 200;

  // Audio Configuration
  /// [int] Default sound effects volume (0-100)
  ///
  /// Rationale: 80% provides good feedback without being startling
  static const int defaultSfxVolume = 80;

  /// [int] Default music volume (0-100)
  ///
  /// Rationale: 60% allows music to set mood without overpowering SFX
  static const int defaultMusicVolume = 60;

  /// [int] Minimum volume value
  static const int minVolume = 0;

  /// [int] Maximum volume value
  static const int maxVolume = 100;

  // Supported Languages
  /// [List<String>] Languages available for learning
  ///
  /// Rationale: English and Hebrew are the MVP language offerings
  static const List<String> supportedLanguages = ['english', 'hebrew'];

  // Animation Durations (milliseconds)
  /// [int] Duration for standard screen transitions
  ///
  /// Rationale: 300ms is perceptible but not sluggish
  static const int transitionDuration = 300;

  /// [int] Duration for confetti celebration animation
  ///
  /// Rationale: 2 seconds allows full effect without feeling too long
  static const int confettiDuration = 2000;

  /// [int] Duration for points counter animation
  ///
  /// Rationale: 1 second provides satisfying count-up effect
  static const int pointsCounterDuration = 1000;

  // Lesson Content Limits
  /// [int] Target number of lessons per language (MVP)
  ///
  /// Rationale: 20-30 lessons provides substantial content for initial release
  static const int targetLessonsPerLanguage = 25;

  /// [int] Minimum lesson level (beginner)
  static const int minLessonLevel = 1;

  /// [int] Maximum lesson level (advanced)
  ///
  /// Rationale: 5 difficulty levels allows progressive complexity
  static const int maxLessonLevel = 5;
}
