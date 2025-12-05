# Repository Contracts

**Feature**: 001-duolingo-game  
**Date**: 2025-12-04  
**Purpose**: Define repository interfaces for Clean Architecture domain layer

> **Note**: This is an offline-first mobile app with no server backend. These contracts define internal boundaries between domain and data layers, not external API contracts.

## Repository Interfaces

### 1. LessonRepository

**Purpose**: Provides access to lesson content and manages lesson completion state.

**Location**: `lib/features/lessons/domain/repositories/lesson_repository.dart`

**Interface**:

```dart
import 'package:dartz/dartz.dart';
import '../entities/lesson.dart';
import '../../../core/errors/failures.dart';

abstract class LessonRepository {
  /// Retrieves a lesson by its unique ID.
  /// Returns Either<Failure, Lesson> for error handling.
  ///
  /// Throws:
  /// - CacheFailure: If lesson data cannot be loaded from local storage
  Future<Either<Failure, Lesson>> getLessonById(String lessonId);

  /// Retrieves all available lessons for a given language.
  /// Lessons are ordered by level and sequence.
  ///
  /// Parameters:
  /// - language: LanguageType enum (english or hebrew)
  ///
  /// Returns: List of lessons or Failure
  Future<Either<Failure, List<Lesson>>> getLessonsByLanguage(String language);

  /// Marks a lesson as completed and persists the result.
  ///
  /// Parameters:
  /// - lessonId: ID of the completed lesson
  /// - stars: Stars earned (1-3 based on performance)
  /// - pointsEarned: Total points awarded for the lesson
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> markLessonCompleted({
    required String lessonId,
    required int stars,
    required int pointsEarned,
  });

  /// Checks if a lesson's prerequisites are met (all prerequisite lessons completed).
  ///
  /// Returns: true if lesson is unlocked, false if still locked
  Future<Either<Failure, bool>> isLessonUnlocked(String lessonId);
}
```

**Error Cases**:

- `CacheFailure`: Local data source cannot read lesson JSON
- `ValidationFailure`: Lesson data format is invalid

---

### 2. ProgressRepository

**Purpose**: Manages user progress tracking (points, streaks, achievements).

**Location**: `lib/features/progress_tracking/domain/repositories/progress_repository.dart`

**Interface**:

```dart
import 'package:dartz/dartz.dart';
import '../entities/user_progress.dart';
import '../entities/achievement.dart';
import '../../../core/errors/failures.dart';

abstract class ProgressRepository {
  /// Retrieves the current user's progress data.
  /// If no progress exists (first launch), returns default initial state.
  ///
  /// Returns: UserProgress or Failure
  Future<Either<Failure, UserProgress>> getUserProgress();

  /// Updates the user's total points after lesson completion.
  ///
  /// Parameters:
  /// - pointsToAdd: Points earned from completed lesson
  ///
  /// Returns: Updated UserProgress or Failure
  Future<Either<Failure, UserProgress>> addPoints(int pointsToAdd);

  /// Updates the user's streak based on current date.
  /// Increments streak if practiced today, resets if missed days.
  ///
  /// Returns: Updated UserProgress or Failure
  Future<Either<Failure, UserProgress>> updateStreak();

  /// Unlocks an achievement for the user.
  ///
  /// Parameters:
  /// - achievement: Achievement to unlock
  ///
  /// Returns: Updated UserProgress or Failure
  Future<Either<Failure, UserProgress>> unlockAchievement(Achievement achievement);

  /// Checks all achievement criteria and unlocks newly earned achievements.
  /// Called after significant events (lesson complete, points milestone).
  ///
  /// Returns: List of newly unlocked achievements or Failure
  Future<Either<Failure, List<Achievement>>> checkAndUnlockAchievements();

  /// Persists the current progress state to local storage.
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> saveProgress(UserProgress progress);
}
```

**Error Cases**:

- `CacheFailure`: Cannot read/write to local Hive database
- `ValidationFailure`: Progress data corrupted or invalid

---

### 3. AudioRepository

**Purpose**: Manages audio asset loading and playback control.

**Location**: `lib/features/audio_visual/domain/repositories/audio_repository.dart`

**Interface**:

```dart
import 'package:dartz/dartz.dart';
import '../entities/audio_asset.dart';
import '../../../core/errors/failures.dart';

abstract class AudioRepository {
  /// Preloads critical audio assets (SFX) at app startup.
  /// This ensures instant playback with no latency.
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> preloadSoundEffects();

  /// Plays a sound effect by ID.
  ///
  /// Parameters:
  /// - sfxId: ID of the sound effect (e.g., 'button_tap', 'correct_answer')
  /// - volume: Volume level 0.0-1.0
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> playSoundEffect({
    required String sfxId,
    required double volume,
  });

  /// Plays background music with looping.
  ///
  /// Parameters:
  /// - musicId: ID of the music track
  /// - volume: Volume level 0.0-1.0
  /// - loop: Whether to loop the track
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> playMusic({
    required String musicId,
    required double volume,
    bool loop = true,
  });

  /// Stops currently playing background music.
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> stopMusic();

  /// Plays pronunciation audio for a word/phrase.
  ///
  /// Parameters:
  /// - pronunciationId: ID of the pronunciation file
  /// - language: Language of the pronunciation
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> playPronunciation({
    required String pronunciationId,
    required String language,
  });

  /// Disposes all audio players and releases resources.
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> dispose();
}
```

**Error Cases**:

- `AssetFailure`: Audio file not found or failed to load
- `PlaybackFailure`: Audio player error during playback

---

### 4. SettingsRepository

**Purpose**: Manages user preferences and app settings.

**Location**: `lib/features/settings/domain/repositories/settings_repository.dart`

**Interface**:

```dart
import 'package:dartz/dartz.dart';
import '../entities/settings_preferences.dart';
import '../../../core/errors/failures.dart';

abstract class SettingsRepository {
  /// Retrieves the user's saved preferences.
  /// If no preferences exist, returns default settings.
  ///
  /// Returns: SettingsPreferences or Failure
  Future<Either<Failure, SettingsPreferences>> getSettings();

  /// Updates sound effects volume.
  ///
  /// Parameters:
  /// - volume: Volume level 0-100
  ///
  /// Returns: Updated SettingsPreferences or Failure
  Future<Either<Failure, SettingsPreferences>> setSoundEffectsVolume(int volume);

  /// Updates background music volume.
  ///
  /// Parameters:
  /// - volume: Volume level 0-100
  ///
  /// Returns: Updated SettingsPreferences or Failure
  Future<Either<Failure, SettingsPreferences>> setMusicVolume(int volume);

  /// Toggles daily practice reminder notifications.
  ///
  /// Parameters:
  /// - enabled: true to enable, false to disable
  ///
  /// Returns: Updated SettingsPreferences or Failure
  Future<Either<Failure, SettingsPreferences>> setNotificationsEnabled(bool enabled);

  /// Persists settings to SharedPreferences.
  ///
  /// Parameters:
  /// - settings: SettingsPreferences to save
  ///
  /// Returns: Success (Unit) or Failure
  Future<Either<Failure, Unit>> saveSettings(SettingsPreferences settings);
}
```

**Error Cases**:

- `CacheFailure`: Cannot read/write to SharedPreferences
- `ValidationFailure`: Invalid volume values (not 0-100)

---

## Failure Types

**Location**: `lib/core/errors/failures.dart`

```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Failure when local cache/database operation fails
class CacheFailure extends Failure {}

/// Failure when data validation fails
class ValidationFailure extends Failure {
  final String message;
  ValidationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure when asset loading fails
class AssetFailure extends Failure {
  final String assetPath;
  AssetFailure(this.assetPath);

  @override
  List<Object?> get props => [assetPath];
}

/// Failure when audio playback fails
class PlaybackFailure extends Failure {
  final String reason;
  PlaybackFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}
```

---

## Usage in Use Cases

**Example**: GetLesson use case

```dart
class GetLesson {
  final LessonRepository repository;

  GetLesson({required this.repository});

  Future<Either<Failure, Lesson>> call(String lessonId) async {
    return await repository.getLessonById(lessonId);
  }
}
```

**Example**: AddPoints use case

```dart
class AddPoints {
  final ProgressRepository repository;

  AddPoints({required this.repository});

  Future<Either<Failure, UserProgress>> call(int points) async {
    return await repository.addPoints(points);
  }
}
```

---

## Implementation Notes

1. **Dartz Either**: Used for functional error handling
   - `Left(Failure)`: Error case
   - `Right(Value)`: Success case

2. **Unit Type**: Represents void in functional programming
   - Used for operations that succeed but don't return data
   - Example: `Future<Either<Failure, Unit>>` for save operations

3. **Repository Pattern**: Abstracts data sources
   - Domain layer depends on abstract interfaces
   - Data layer implements concrete classes
   - Easy to mock for testing

4. **No Network Layer**: All data local (JSON assets + Hive database)
   - No HTTP clients, no API calls
   - Repositories read from local data sources only

---

**Contracts Complete** - Repository interfaces defined for all features.
