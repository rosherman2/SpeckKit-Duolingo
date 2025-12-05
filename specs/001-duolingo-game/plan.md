# Implementation Plan: Duolingo-Style Language Learning Game

**Branch**: `001-duolingo-game` | **Date**: 2025-12-04 | **Spec**: [spec.md](file:///c:/Development/flutter_projects/SpeckKit-Duolingo/specs/001-duolingo-game/spec.md)
**Input**: Feature specification from `/specs/001-duolingo-game/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build a modern Duolingo-style language learning game with Candy Crush aesthetics for iOS and Android. The app teaches English and Hebrew through interactive lessons with gamification (points, streaks, achievements), vibrant animations, and sound effects. No server backend required for initial stage - fully offline-capable with local data persistence.

**Technical Approach**: Flutter mobile app using Clean Architecture, BLoC state management, and feature-first module organization per project constitution.

## Technical Context

**Language/Version**: Dart 3.2+ / Flutter 3.16+  
**Primary Dependencies**: `flutter_bloc` (state management), `equatable` (value equality), `shared_preferences` (settings persistence), `hive` or `sqflite` (local lesson data storage), `audioplayers` (sound effects/pronunciation), `lottie` or `rive` (animations)  
**Storage**: Local-only (Hive/SQLite for lesson progress, SharedPreferences for settings)  
**Testing**: `flutter_test` (widget tests), `bloc_test` (BLoC testing), `mockito` (mocks for unit tests)  
**Target Platform**: iOS 13+ and Android 7.0+ (API level 24+)  
**Project Type**: Mobile (Flutter) - feature-first Clean Architecture structure  
**Performance Goals**:

- 60 FPS during all animations and gameplay
- Cold start < 3 seconds on mid-range devices (iPhone 11, Pixel 4a)
- Smooth lesson map scrolling and transitions

**Constraints**:

- APK/IPA size < 50MB uncompressed
- Peak memory < 200MB during active gameplay
- Full offline functionality (no network dependency after install)
- Right-to-left (RTL) text support for Hebrew
- Audio must be high quality but compressed

**Scale/Scope**:

- Initial release: 20-30 lessons per language (English, Hebrew)
- 5-10 exercises per lesson
- 4 exercise types: multiple choice, fill-in-blank, matching, listening
- ~100-200 audio pronunciation files
- Target: single-player offline experience for MVP

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ Principle I: Clean Architecture (NON-NEGOTIABLE)

**Requirement**: All code must follow Clean Architecture with strict layer separation. Features must be organized in feature-first modules.

**Compliance**:

- Feature modules: `main_menu/`, `lessons/`, `progress_tracking/`, `settings/`, `audio_visual/`
- Each feature has: `presentation/` (UI, BLoC) → `domain/` (use cases, entities) → `data/` (repositories, data sources)
- Domain layer will be pure Dart (no Flutter imports)
- Examples:
  - `lib/features/lessons/domain/entities/lesson.dart` - pure Dart entity
  - `lib/features/lessons/domain/usecases/get_lesson.dart` - pure business logic
  - `lib/features/lessons/data/repositories/lesson_repository_impl.dart` - data access
  - `lib/features/lessons/presentation/bloc/lesson_bloc.dart` - state management
  - `lib/features/lessons/presentation/pages/lesson_page.dart` - UI

**Status**: ✅ PASS - Clean Architecture enforced

---

### ✅ Principle II: State Management (BLoC Pattern)

**Requirement**: All state management must use `flutter_bloc` with clear event/state separation.

**Compliance**:

- All features will use BLoC: `LessonBloc`, `ProgressBloc`, `SettingsBloc`, `MenuBloc`
- Events: `LessonStarted`, `AnswerSubmitted`, `LessonCompleted`
- States: `LessonLoading`, `LessonLoaded`, `LessonInProgress`, `LessonCompleted`
- All events/states use `Equatable` for value equality
- No direct widget state mutation for business logic

**Status**: ✅ PASS - BLoC pattern enforced

---

### ✅ Principle III: Observability & Debugging

**Requirement**: All code must use structured logging via `AppLogger` utility with lazy evaluation and zero production overhead.

**Compliance**:

- Implement `lib/core/utils/app_logger.dart` in Phase 0
- Usage in all features: `AppLogger.debug('LessonBloc', 'onAnswerSubmitted', () => 'Answer: \$answer')`
- Severity levels used appropriately (DEBUG for iteration, INFO for events, ERROR for failures)
- Production builds: complete elimination via `kDebugMode` guards

**Status**: ✅ PASS - Logging standard enforced

---

### ✅ Principle IV: Code Documentation Standards

**Requirement**: All Dart/Flutter code must have complete DartDoc comments for developers with C++/Java backgrounds.

**Compliance**:

- All classes documented with `[StatelessWidget]`, `[Service]`, `[Model]` annotations
- All methods have parameter docs and exception documentation
- Async methods explicitly note await requirements
- Constants include rationale for values
- Example format enforced:

  ```dart
  /// [StatelessWidget] Displays a single exercise question with answer options.
  /// Rebuilds when parent lesson state changes via BLoC.
  /// Purpose: Present exercise UI and capture user input
  class ExerciseWidget extends StatelessWidget { ... }
  ```

**Status**: ✅ PASS - Documentation standards enforced

---

### ✅ Principle V: Testing & Quality

**Requirement**: All features must include widget tests for UI and unit tests for critical game logic.

**Compliance**:

- Widget tests for: `MainMenuPage`, `LessonPage`, `ProgressPage`, `SettingsPage`
- Unit tests for: scoring logic, streak calculation, points accumulation, lesson progression
- BLoC tests using `bloc_test` for all state transitions
- Test coverage for P1 user stories before deployment

**Status**: ✅ PASS - Testing requirements met

---

### ✅ Performance Standards

**Requirement**: 60 FPS, <50MB size, <200MB memory, <3s startup

**Compliance**:

- Animations use `AnimationController` with vsync for 60 FPS
- Asset optimization: compressed audio (MP3/AAC), optimized images (WebP), vector graphics (SVG)
- Lazy loading of lesson content to reduce memory footprint
- Splash screen with async initialization for fast perceived startup
- Profile mode testing on target devices (iPhone 11, Pixel 4a) before release

**Status**: ✅ PASS - Performance targets achievable

---

**Constitution Compliance Summary**: ✅ ALL GATES PASSED - No violations

## Project Structure

### Documentation (this feature)

```text
specs/001-duolingo-game/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── errors/
│   │   ├── failures.dart          # Base failure types
│   │   └── exceptions.dart        # Data layer exceptions
│   ├── utils/
│   │   ├── app_logger.dart        # [Phase 0] Logging utility
│   │   └── constants.dart         # App-wide constants
│   ├── theme/
│   │   ├── app_theme.dart         # Candy Crush-style theme
│   │   ├── colors.dart            # Vibrant color palette
│   │   └── animations.dart        # Reusable animation configs
│   └── di/
│       └── injection.dart         # Dependency injection setup
│
├── features/
│   ├── main_menu/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── main_menu_page.dart
│   │       └── widgets/
│   │           ├── menu_button.dart
│   │           ├── points_display.dart
│   │           └── animated_background.dart
│   │
│   ├── lessons/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── lesson.dart
│   │   │   │   └── exercise.dart
│   │   │   ├── repositories/
│   │   │   │   └── lesson_repository.dart  # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── get_lesson.dart
│   │   │       ├── submit_answer.dart
│   │   │       └── complete_lesson.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── lesson_model.dart
│   │   │   │   └── exercise_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── lesson_local_data_source.dart
│   │   │   │   └── lesson_json_data_source.dart
│   │   │   └── repositories/
│   │   │       └── lesson_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── lesson_bloc.dart
│   │       │   ├── lesson_event.dart
│   │       │   └── lesson_state.dart
│   │       ├── pages/
│   │       │   ├── lesson_map_page.dart
│   │       │   ├── lesson_page.dart
│   │       │   └── lesson_complete_page.dart
│   │       └── widgets/
│   │           ├── exercise_widget.dart
│   │           ├── multiple_choice_widget.dart
│   │           ├── fill_blank_widget.dart
│   │           ├── matching_widget.dart
│   │           └── listening_widget.dart
│   │
│   ├── progress_tracking/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user_progress.dart
│   │   │   │   └── achievement.dart
│   │   │   ├── repositories/
│   │   │   │   └── progress_repository.dart
│   │   │   └── usecases/
│   │   │       ├── update_points.dart
│   │   │       ├── calculate_streak.dart
│   │   │       └── unlock_achievement.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_progress_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── progress_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── progress_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │           ├── points_counter.dart
│   │           ├── streak_indicator.dart
│   │           └── achievement_popup.dart
│   │
│   ├── settings/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── settings_page.dart
│   │           └── about_dialog.dart
│   │
│   └── audio_visual/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── audio_asset.dart
│       │   ├── repositories/
│       │   │   └── audio_repository.dart
│       │   └── usecases/
│       │       ├── play_sound_effect.dart
│       │       └── play_pronunciation.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── audio_local_data_source.dart
│       │   └── repositories/
│       │       └── audio_repository_impl.dart
│       └── presentation/
│           ├── managers/
│           │   ├── audio_manager.dart
│           │   └── animation_manager.dart
│           └── widgets/
│               ├── confetti_animation.dart
│               ├── fireworks_animation.dart
│               └── particle_effect.dart

assets/
├── audio/
│   ├── sfx/
│   │   ├── button_tap.mp3
│   │   ├── correct_answer.mp3
│   │   ├── wrong_answer.mp3
│   │   ├── lesson_complete.mp3
│   │   └── achievement.mp3
│   ├── music/
│   │   └── menu_background.mp3
│   └── pronunciation/
│       ├── english/
│       │   ├── word_001.mp3
│       │   └── ...
│       └── hebrew/
│           ├── word_001.mp3
│           └── ...
│
├── images/
│   ├── backgrounds/
│   ├── icons/
│   └── animations/  # Lottie/Rive files
│
└── data/
    ├── lessons/
    │   ├── english_lessons.json
    │   └── hebrew_lessons.json
    └── exercises/
        ├── english_exercises.json
        └── hebrew_exercises.json

test/
├── features/
│   ├── lessons/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── get_lesson_test.dart
│   │   │       └── submit_answer_test.dart
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── lesson_repository_impl_test.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── lesson_bloc_test.dart
│   │       └── pages/
│   │           └── lesson_page_test.dart
│   ├── progress_tracking/
│   └── settings/
└── core/
    └── utils/
        └── app_logger_test.dart
```

**Structure Decision**: Using Flutter mobile structure (Option 3 adapted) with feature-first Clean Architecture. Each feature module is self-contained with domain/data/presentation layers. Core utilities and theme are shared across features. Assets organized by type (audio, images, data) for easy management.

## Complexity Tracking

No constitution violations - this section is empty as all gates passed.

---

## Next Steps

This plan is ready for Phase 0 (Research) and Phase 1 (Design) execution. The following artifacts will be generated:

1. **Phase 0**: `research.md` - Technology decisions, best practices, architecture patterns
2. **Phase 1**: `data-model.md` - Entity definitions and relationships
3. **Phase 1**: `contracts/` - (Optional for offline app - may be minimal or N/A)
4. **Phase 1**: `quickstart.md` - Development environment setup and running instructions
5. **Phase 2**: `tasks.md` - Generated by `/speckit.tasks` command (separate workflow)
