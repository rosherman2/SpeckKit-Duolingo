# Tasks: Duolingo-Style Language Learning Game

**Input**: Design documents from `/specs/001-duolingo-game/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are NOT explicitly requested in the specification, so this task list focuses on implementation only. Tests can be added later if needed.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter mobile**: `lib/`, `assets/`, `test/` at repository root
- Paths shown below follow Flutter Clean Architecture structure
- Features organized in `lib/features/<feature_name>/domain|data|presentation/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create Flutter project structure with lib/, assets/, test/ directories
- [x] T002 Initialize pubspec.yaml with dependencies: flutter_bloc ^8.1.3, equatable ^2.0.5, hive ^2.2.3, hive_flutter ^1.1.0, shared_preferences ^2.2.2, just_audio ^0.9.36, lottie ^2.7.0, get_it ^7.6.4, google_fonts ^6.1.0, dartz ^0.10.1, path_provider (latest)
- [x] T003 [P] Initialize dev dependencies in pubspec.yaml: bloc_test ^9.1.5, mockito ^5.4.4, build_runner, hive_generator
- [x] T004 [P] Configure analysis_options.yaml with DartDoc linting rules per constitution
- [x] T005 [P] Create .gitignore for Flutter project (build/, .dart_tool/, *.g.dart, etc.)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T006 Create core directory structure: lib/core/errors/, lib/core/utils/, lib/core/theme/, lib/core/di/
- [x] T007 [P] Create base Failure classes in lib/core/errors/failures.dart (CacheFailure, ValidationFailure, AssetFailure, PlaybackFailure)
- [x] T008 [P] Create base Exception classes in lib/core/errors/exceptions.dart (CacheException, ServerException, etc.)
- [x] T009 [P] Create AppLogger utility in lib/core/utils/app_logger.dart with structured logging, file rotation (5MB max, 5 files), and zero production impact using kDebugMode guards, lazy evaluation via Function() parameters, loop throttling (1 second per location), dual output (console + JSON file), LogFormat enum (console/json), severity levels (debug/info/warning/error), path_provider for log storage, and thread-safe file writes
- [x] T010 [P] Create constants file in lib/core/utils/constants.dart (app name, version, point values, etc.)
- [x] T011 Create Candy Crush-style theme in lib/core/theme/app_theme.dart with vibrant colors, gradients
- [x] T012 [P] Create color palette in lib/core/theme/colors.dart with primary/secondary/accent colors
- [x] T013 [P] Create animation constants in lib/core/theme/animations.dart (durations, curves)
- [x] T014 [P] Setup dependency injection in lib/core/di/injection.dart using get_it service locator
- [x] T015 [P] Create main.dart entry point with Hive initialization, AppLogger initialization, and dependency injection setup
- [x] T016 Create app.dart root widget with MaterialApp, theme, and routing setup
- [x] T017 [P] Create asset directory structure: assets/audio/sfx/, assets/audio/music/, assets/audio/pronunciation/english/, assets/audio/pronunciation/hebrew/, assets/images/, assets/animations/, assets/data/lessons/
- [x] T018 [P] Register all asset paths in pubspec.yaml under flutter: assets:

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - First Launch & Game Onboarding (Priority: P1) 🎯 MVP

**Goal**: Vibrant main menu with Candy Crush aesthetics, smooth animations, navigation to all features

**Independent Test**: Launch app, verify main menu displays with animations, all buttons functional (Start Learning, Settings, About), visual style matches Candy Crush aesthetic

### Implementation for User Story 1

- [x] T019 [P] [US1] Create feature directory structure: lib/features/main_menu/domain/, lib/features/main_menu/data/, lib/features/main_menu/presentation/
- [x] T020 [P] [US1] Create MenuBloc events in lib/features/main_menu/presentation/bloc/menu_event.dart (MenuStarted, NavigateToLessons, NavigateToSettings, NavigateToAbout)
- [x] T021 [P] [US1] Create MenuBloc states in lib/features/main_menu/presentation/bloc/menu_state.dart (MenuInitial, MenuLoaded, MenuNavigating)
- [x] T022 [US1] Implement MenuBloc in lib/features/main_menu/presentation/bloc/menu_bloc.dart with event handling and state transitions
- [x] T023 [US1] Create MainMenuPage in lib/features/main_menu/presentation/pages/main_menu_page.dart with BlocProvider and BlocBuilder
- [x] T024 [P] [US1] Create MenuButton widget in lib/features/main_menu/presentation/widgets/menu_button.dart with tap animation and sound effect
- [x] T025 [P] [US1] Create PointsDisplay widget in lib/features/main_menu/presentation/widgets/points_display.dart with animated counter
- [x] T026 [P] [US1] Create AnimatedBackground widget in lib/features/main_menu/presentation/widgets/animated_background.dart with particle effects or gradient animation
- [x] T027 [P] [US1] Create AboutDialog widget in lib/features/main_menu/presentation/widgets/about_dialog.dart with app info, version, credits
- [x] T028 [P] [US1] Add placeholder Lottie animation files in assets/animations/ (menu_background.json, button_bounce.json)
- [x] T029 [P] [US1] Add placeholder SFX in assets/audio/sfx/ (button_tap.mp3)
- [x] T030 [US1] Integrate main menu route in lib/app.dart with navigation setup

**Checkpoint**: Main menu fully functional with animations, serving as app entry point

---

## Phase 4: User Story 4 - Progress Tracking & Points System (Priority: P1)

**Goal**: Track points, streaks, achievements with persistence

**Independent Test**: Complete 3 lessons, verify points accumulate and persist across app restarts

**Note**: This is prioritized before lessons because lesson completion depends on progress tracking

### Implementation for User Story 4

- [x] T031 [P] [US4] Create feature directory: lib/features/progress_tracking/domain/entities/, lib/features/progress_tracking/domain/usecases/, lib/features/progress_tracking/domain/repositories/
- [x] T032 [P] [US4] Create UserProgress entity in lib/features/progress_tracking/domain/entities/user_progress.dart (totalPoints, currentStreak, longestStreak, lastPracticeDate, unlockedAchievements)
- [x] T033 [P] [US4] Create Achievement entity in lib/features/progress_tracking/domain/entities/achievement.dart (id, name, description, iconPath, unlockedAt, criteria)
- [x] T034 [P] [US4] Create LessonProgress entity in lib/features/progress_tracking/domain/entities/lesson_progress.dart (language, completedLessonIds, currentLessonId, starsEarned)
- [x] T035 [P] [US4] Create ProgressRepository interface in lib/features/progress_tracking/domain/repositories/progress_repository.dart (getUserProgress, addPoints, updateStreak, unlockAchievement, etc.)
- [x] T036 [P] [US4] Create UpdatePoints use case in lib/features/progress_tracking/domain/usecases/update_points.dart
- [x] T037 [P] [US4] Create CalculateStreak use case in lib/features/progress_tracking/domain/usecases/calculate_streak.dart with streak reset logic
- [x] T038 [P] [US4] Create UnlockAchievement use case in lib/features/progress_tracking/domain/usecases/unlock_achievement.dart
- [x] T039 [P] [US4] Create UserProgressModel in lib/features/progress_tracking/data/models/user_progress_model.dart extending UserProgress with fromJson/toJson
- [x] T040 [P] [US4] Create ProgressLocalDataSource in lib/features/progress_tracking/data/datasources/progress_local_data_source.dart using Hive for storage
- [x] T041 [US4] Create ProgressRepositoryImpl in lib/features/progress_tracking/data/repositories/progress_repository_impl.dart implementing ProgressRepository
- [x] T042 [P] [US4] Create ProgressBloc events in lib/features/progress_tracking/presentation/bloc/progress_event.dart (PointsAdded, StreakUpdated, AchievementUnlocked)
- [x] T043 [P] [US4] Create ProgressBloc states in lib/features/progress_tracking/presentation/bloc/progress_state.dart (ProgressLoading, ProgressLoaded, ProgressUpdated)
- [x] T044 [US4] Implement ProgressBloc in lib/features/progress_tracking/presentation/bloc/progress_bloc.dart
- [x] T045 [P] [US4] Create PointsCounter widget in lib/features/progress_tracking/presentation/widgets/points_counter.dart with animated count-up effect
- [x] T046 [P] [US4] Create StreakIndicator widget in lib/features/progress_tracking/presentation/widgets/streak_indicator.dart with flame icon
- [x] T047 [P] [US4] Create AchievementPopup widget in lib/features/progress_tracking/presentation/widgets/achievement_popup.dart with confetti animation
- [x] T048 [US4] Register ProgressRepository and use cases in lib/core/di/injection.dart
- [x] T049 [US4] Initialize Hive box for progress in main.dart (progressBox)

**Checkpoint**: Progress tracking fully functional, ready to integrate with lessons

---

## Phase 5: User Story 2 - Learning English (Priority: P1)

**Goal**: Core lesson functionality with exercises, points, animations

**Independent Test**: Complete English lesson with 5 exercises, verify points awarded, celebratory animations display

### Implementation for User Story 2

- [ ] T050 [P] [US2] Create feature directory: lib/features/lessons/domain/entities/, lib/features/lessons/domain/usecases/, lib/features/lessons/domain/repositories/
- [ ] T051 [P] [US2] Create Lesson entity in lib/features/lessons/domain/entities/lesson.dart (id, language, level, title, description, exercises, requiredAccuracy, pointValue, prerequisiteIds)
- [ ] T052 [P] [US2] Create Exercise entity in lib/features/lessons/domain/entities/exercise.dart (id, type enum, questionText, answerOptions, correctAnswer, points, questionAudio optional)
- [ ] T053 [P] [US2] Create LessonRepository interface in lib/features/lessons/domain/repositories/lesson_repository.dart (getLessonById, getLessonsByLanguage, markLessonCompleted, isLessonUnlocked)
- [ ] T054 [P] [US2] Create GetLesson use case in lib/features/lessons/domain/usecases/get_lesson.dart
- [ ] T055 [P] [US2] Create SubmitAnswer use case in lib/features/lessons/domain/usecases/submit_answer.dart with correctness validation
- [ ] T056 [P] [US2] Create CompleteLesson use case in lib/features/lessons/domain/usecases/complete_lesson.dart coordinating with ProgressRepository
- [ ] T057 [P] [US2] Create LessonModel in lib/features/lessons/data/models/lesson_model.dart with fromJson/toJson
- [ ] T058 [P] [US2] Create ExerciseModel in lib/features/lessons/data/models/exercise_model.dart with fromJson/toJson
- [ ] T059 [P] [US2] Create LessonLocalDataSource in lib/features/lessons/data/datasources/lesson_local_data_source.dart reading from JSON assets
- [ ] T060 [US2] Create LessonRepositoryImpl in lib/features/lessons/data/repositories/lesson_repository_impl.dart
- [ ] T061 [P] [US2] Create LessonBloc events in lib/features/lessons/presentation/bloc/lesson_event.dart (LessonStarted, AnswerSubmitted, LessonCompleted, NextExercise)
- [ ] T062 [P] [US2] Create LessonBloc states in lib/features/lessons/presentation/bloc/lesson_state.dart (LessonLoading, LessonLoaded, ExerciseInProgress, AnswerCorrect, AnswerIncorrect, LessonCompleted)
- [ ] T063 [US2] Implement LessonBloc in lib/features/lessons/presentation/bloc/lesson_bloc.dart with exercise flow and point calculation
- [ ] T064 [P] [US2] Create LessonMapPage in lib/features/lessons/presentation/pages/lesson_map_page.dart with Candy Crush-style level progression
- [ ] T065 [P] [US2] Create LessonPage in lib/features/lessons/presentation/pages/lesson_page.dart with exercise iteration
- [ ] T066 [P] [US2] Create LessonCompletePage in lib/features/lessons/presentation/pages/lesson_complete_page.dart with victory screen, stars, points summary
- [ ] T067 [P] [US2] Create ExerciseWidget parent in lib/features/lessons/presentation/widgets/exercise_widget.dart dispatching to specific exercise types
- [ ] T068 [P] [US2] Create MultipleChoiceWidget in lib/features/lessons/presentation/widgets/multiple_choice_widget.dart
- [ ] T069 [P] [US2] Create FillBlankWidget in lib/features/lessons/presentation/widgets/fill_blank_widget.dart with text input
- [ ] T070 [P] [US2] Create MatchingWidget in lib/features/lessons/presentation/widgets/matching_widget.dart with drag-and-drop or tapping pairs
- [ ] T071 [P] [US2] Create ListeningWidget in lib/features/lessons/presentation/widgets/listening_widget.dart with audio playback button
- [ ] T072 [P] [US2] Create sample English lessons JSON in assets/data/lessons/english_lessons.json (3-5 lessons minimum for testing)
- [ ] T073 [P] [US2] Create sample English exercises JSON in assets/data/exercises/english_exercises.json
- [ ] T074 [P] [US2] Add celebratory Lottie animations in assets/animations/ (fireworks.json, confetti.json, stars.json)
- [ ] T075 [P] [US2] Add correct/wrong answer SFX in assets/audio/sfx/ (correct_answer.mp3, wrong_answer.mp3, lesson_complete.mp3)
- [ ] T076 [US2] Register LessonRepository and use cases in lib/core/di/injection.dart
- [ ] T077 [US2] Add lesson routes to lib/app.dart (lesson map, lesson page, lesson complete)

**Checkpoint**: English lessons fully functional, integrates with progress tracking

---

## Phase 6: User Story 6 - Language Selection & About (Priority: P2)

**Goal**: Switch between English and Hebrew, view app info

**Independent Test**: Switch from English to Hebrew, verify lesson map updates

**Note**: Implemented before Hebrew lessons to enable language selection infrastructure

### Implementation for User Story 6

- [ ] T078 [P] [US6] Create LanguageSelection entity in lib/core/utils/language_selection.dart (selectedLanguage enum, availableLanguages list)
- [ ] T079 [P] [US6] Create LanguageBloc events in lib/features/main_menu/presentation/bloc/language_event.dart (LanguageChanged)
- [ ] T080 [P] [US6] Create LanguageBloc states in lib/features/main_menu/presentation/bloc/language_state.dart (LanguageLoading, LanguageLoaded)
- [ ] T081 [US6] Implement LanguageBloc in lib/features/main_menu/presentation/bloc/language_bloc.dart with SharedPreferences persistence
- [ ] T082 [P] [US6] Create LanguageSelectionDialog widget in lib/features/main_menu/presentation/widgets/language_selection_dialog.dart with English/Hebrew options and flag icons
- [ ] T083 [US6] Update MainMenuPage to show language selection button and integrate LanguageBloc
- [ ] T084 [US6] Update LessonMapPage to filter lessons by selected language from LanguageBloc state

**Checkpoint**: Language selection functional, ready for Hebrew lessons implementation

---

## Phase 7: User Story 3 - Learning Hebrew (Priority: P2)

**Goal**: Hebrew lessons with RTL rendering and pronunciation

**Independent Test**: Start Hebrew lesson, verify RTL text, Hebrew characters legible, audio plays

### Implementation for User Story 3

- [ ] T085 [P] [US3] Create sample Hebrew lessons JSON in assets/data/lessons/hebrew_lessons.json (3-5 lessons minimum)
- [ ] T086 [P] [US3] Create sample Hebrew exercises JSON in assets/data/exercises/hebrew_exercises.json
- [ ] T087 [P] [US3] Add Hebrew font support in pubspec.yaml using google_fonts (e.g., Assistant, Rubik with Hebrew glyphs)
- [ ] T088 [P] [US3] Add Hebrew pronunciation audio files in assets/audio/pronunciation/hebrew/ (at least 10-20 sample words)
- [ ] T089 [US3] Update ExerciseWidget to wrap Hebrew content with Directionality(textDirection: TextDirection.rtl) when lesson.language == hebrew
- [ ] T090 [US3] Update MultipleChoiceWidget to support RTL layout for Hebrew text
- [ ] T091 [US3] Update FillBlankWidget to support RTL text input for Hebrew
- [ ] T092 [US3] Update MatchingWidget to support RTL layout for Hebrew pairs
- [ ] T093 [US3] Update ListeningWidget to play Hebrew pronunciation audio
- [ ] T094 [US3] Update LessonMapPage theming to show culturally appropriate Hebrew aesthetics when Hebrew is selected
- [ ] T095 [US3] Test Hebrew text rendering on multiple device sizes (small phones, tablets)

**Checkpoint**: Hebrew lessons fully functional with proper RTL support

---

## Phase 8: User Story 5 - App Configuration & Settings (Priority: P3)

**Goal**: User customization (volume, notifications)

**Independent Test**: Adjust sound volume to 0%, verify no sound plays in lessons

### Implementation for User Story 5

- [ ] T096 [P] [US5] Create SettingsPreferences entity in lib/features/settings/domain/entities/settings_preferences.dart (soundEffectsVolume, musicVolume, notificationsEnabled)
- [ ] T097 [P] [US5] Create SettingsRepository interface in lib/features/settings/domain/repositories/settings_repository.dart (getSettings, setSoundEffectsVolume, setMusicVolume, setNotificationsEnabled, saveSettings)
- [ ] T098 [P] [US5] Create SettingsRepositoryImpl in lib/features/settings/data/repositories/settings_repository_impl.dart using SharedPreferences
- [ ] T099 [P] [US5] Create SettingsBloc events in lib/features/settings/presentation/bloc/settings_event.dart (SettingsLoaded, SoundVolumeChanged, MusicVolumeChanged, NotificationsToggled)
- [ ] T100 [P] [US5] Create SettingsBloc states in lib/features/settings/presentation/bloc/settings_state.dart (SettingsLoading, SettingsLoaded)
- [ ] T101 [US5] Implement SettingsBloc in lib/features/settings/presentation/bloc/settings_bloc.dart
- [ ] T102 [US5] Create SettingsPage in lib/features/settings/presentation/pages/settings_page.dart with sliders and toggles
- [ ] T103 [US5] Update AudioManager to respect volume settings from SettingsBloc state
- [ ] T104 [US5] Register SettingsRepository in lib/core/di/injection.dart
- [ ] T105 [US5] Add settings route to lib/app.dart

**Checkpoint**: Settings fully functional, volumes applied to audio playback

---

## Phase 9: Audio & Visual Effects (Cross-Cutting)

**Purpose**: Implement audio playback and visual effects used across all stories

**Note**: Can be developed in parallel with user stories, but needed before final integration

- [ ] T106 [P] Create feature directory: lib/features/audio_visual/domain/entities/, lib/features/audio_visual/domain/usecases/, lib/features/audio_visual/domain/repositories/
- [ ] T107 [P] Create AudioAsset entity in lib/features/audio_visual/domain/entities/audio_asset.dart (id, type enum, filePath, language optional, duration, isPreloaded)
- [ ] T108 [P] Create AudioRepository interface in lib/features/audio_visual/domain/repositories/audio_repository.dart (preloadSoundEffects, playSoundEffect, playMusic, stopMusic, playPronunciation, dispose)
- [ ] T109 [P] Create PlaySoundEffect use case in lib/features/audio_visual/domain/usecases/play_sound_effect.dart
- [ ] T110 [P] Create PlayPronunciation use case in lib/features/audio_visual/domain/usecases/play_pronunciation.dart
- [ ] T111 Create AudioLocalDataSource in lib/features/audio_visual/data/datasources/audio_local_data_source.dart using just_audio package
- [ ] T112 Create AudioRepositoryImpl in lib/features/audio_visual/data/repositories/audio_repository_impl.dart
- [ ] T113 [P] Create AudioManager in lib/features/audio_visual/presentation/managers/audio_manager.dart as singleton managing just_audio players
- [ ] T114 [P] Create AnimationManager in lib/features/audio_visual/presentation/managers/animation_manager.dart for centralized animation configs
- [ ] T115 [P] Create ConfettiAnimation widget in lib/features/audio_visual/presentation/widgets/confetti_animation.dart using Lottie
- [ ] T116 [P] Create FireworksAnimation widget in lib/features/audio_visual/presentation/widgets/fireworks_animation.dart using Lottie
- [ ] T117 [P] Create ParticleEffect widget in lib/features/audio_visual/presentation/widgets/particle_effect.dart for custom particle systems
- [ ] T118 [P] Add background music file in assets/audio/music/ (menu_background.mp3)
- [ ] T119 [P] Add English pronunciation samples in assets/audio/pronunciation/english/ (20-30 common words)
- [ ] T120 Register AudioRepository and use cases in lib/core/di/injection.dart
- [ ] T121 Initialize AudioManager in main.dart with preloaded SFX

**Checkpoint**: Audio and visual effects ready for integration into all features

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T122 [P] Add comprehensive DartDoc comments to all public classes and methods per constitution standards
- [ ] T123 [P] Add AppLogger calls to all BLoC event handlers and use cases with appropriate severity levels
- [ ] T124 [P] Optimize Lottie animation files for size (compress JSON, remove unused layers)
- [ ] T125 [P] Compress all audio files to meet <50MB total app size target (use MP3 at 128kbps for SFX, AAC at 96kbps for music)
- [ ] T126 [P] Convert all images to WebP format for optimal compression
- [ ] T127 [P] Run flutter analyze and fix all linting warnings
- [ ] T128 [P] Run dart format on all Dart files for consistent formatting
- [ ] T129 Test app startup time on target devices (must be <3 seconds cold start)
- [ ] T130 Profile app with Flutter DevTools to verify 60 FPS during animations
- [ ] T131 Check peak memory usage during gameplay (<200MB target)
- [ ] T132 Verify APK/IPA size is <50MB uncompressed
- [ ] T133 Test offline functionality (disable network, verify all features work)
- [ ] T134 Test on multiple device sizes (small phone, large phone, tablet) for both orientations
- [ ] T135 Test Hebrew RTL rendering on real devices
- [ ] T136 Verify all audio files play correctly on iOS and Android
- [ ] T137 Run quickstart.md validation to ensure all setup steps work

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational (Phase 2)
- **User Story 4 (Phase 4)**: Depends on Foundational (Phase 2) - implements BEFORE lessons because lessons depend on progress
- **User Story 2 (Phase 5)**: Depends on Foundational (Phase 2) AND User Story 4 (Phase 4)
- **User Story 6 (Phase 6)**: Depends on Foundational (Phase 2) - needed before Hebrew lessons for language selection
- **User Story 3 (Phase 7)**: Depends on Foundational (Phase 2), User Story 2 (Phase 5), AND User Story 6 (Phase 6)
- **User Story 5 (Phase 8)**: Depends on Foundational (Phase 2) AND Audio/Visual (Phase 9)
- **Audio/Visual (Phase 9)**: Depends on Foundational (Phase 2) - Can run in parallel with user stories
- **Polish (Phase 10)**: Depends on all desired user stories being complete

### Within Each User Story

- Models/Entities before use cases
- Use cases before repositories
- Repositories before BLoCs
- BLoCs before UI pages/widgets
- Core implementation before integration

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- US1, US4, US6, and Audio/Visual (Phase 9) can start in parallel after Foundational completes
- Within each user story, tasks marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 2 (English Lessons)

```bash
# Launch all entity creation tasks together:
Task: "Create Lesson entity in lib/features/lessons/domain/entities/lesson.dart"
Task: "Create Exercise entity in lib/features/lessons/domain/entities/exercise.dart"

# After entities, launch all use case tasks together:
Task: "Create GetLesson use case"
Task: "Create SubmitAnswer use case"
Task: "Create CompleteLesson use case"

# Launch all widget tasks together:
Task: "Create MultipleChoiceWidget"
Task: "Create FillBlankWidget"
Task: "Create MatchingWidget"
Task: "Create ListeningWidget"
```

---

## Implementation Strategy

### MVP First (P1 User Stories Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - includes AppLogger)
3. Complete Phase 3: User Story 1 (Main Menu)
4. Complete Phase 4: User Story 4 (Progress Tracking)
5. Complete Phase 5: User Story 2 (English Lessons)
6. Complete Phase 9: Audio/Visual (for full experience)
7. **STOP and VALIDATE**: Test MVP with US1+US2+US4 + Audio
8. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add US1 (Main Menu) → Test independently → Deploy/Demo
3. Add US4 (Progress) + US2 (Lessons) → Test independently → Deploy/Demo (MVP!)
4. Add US6 (Language Selection) + US3 (Hebrew) → Test independently → Deploy/Demo
5. Add US5 (Settings) → Test independently → Deploy/Demo
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (Main Menu)
   - Developer B: User Story 4 (Progress Tracking)
   - Developer C: Audio/Visual (Phase 9)
3. After US4 completes:
   - Developer B moves to User Story 2 (Lessons)
4. After US1, US2, US4, Audio complete:
   - Developer A: User Story 6 (Language Selection)
   - Developer B: User Story 3 (Hebrew Lessons)
   - Developer C: User Story 5 (Settings)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
- Logger (T009) is critical foundational task - must be completed before starting user stories

---

**Total Tasks**: 137 tasks
**Task Count Per Story**:

- Setup: 5 tasks
- Foundational: 13 tasks (including AppLogger T009)
- US1 (Main Menu): 12 tasks
- US4 (Progress): 19 tasks
- US2 (English Lessons): 28 tasks
- US6 (Language Selection): 7 tasks
- US3 (Hebrew): 11 tasks
- US5 (Settings): 10 tasks
- Audio/Visual: 16 tasks
- Polish: 16 tasks

**Parallel Opportunities**: 85+ tasks marked [P] for parallel execution
**MVP Scope**: User Stories 1, 2, 4 + Audio/Visual = ~78 tasks for fully functional English learning game
