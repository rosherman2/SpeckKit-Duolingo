# Research: Technology Decisions & Best Practices

**Feature**: 001-duolingo-game  
**Date**: 2025-12-04  
**Purpose**: Resolve technology choices and establish best practices for Flutter mobile game development

## Research Tasks Completed

### 1. Local Storage Strategy

**Decision**: Use **Hive** for lesson progress and user data, **SharedPreferences** for settings

**Rationale**:

- Hive is lightweight, fast, and pure Dart (no native dependencies)
- Better performance than SQLite for key-value and small object storage
- NoSQL structure fits game data (progress, achievements, points) better than relational model
- Supports custom objects with type adapters (UserProgress, LessonState entities)
- SharedPreferences perfect for simple key-value settings (volume levels, toggles)

**Alternatives Considered**:

- **SQLite (sqflite)**: More overhead for simple lesson progress tracking; relational model unnecessary for game data
- **Firebase Local Persistence**: Overkill for offline-only app; adds unnecessary dependencies
- **JSON files**: No query capability, slower read/write, manual serialization burden

**Implementation Approach**:

```dart
// Hive boxes
- progressBox: Stores UserProgress objects
- lessonsBox: Stores completed lesson IDs and states
- achievementsBox: Stores unlocked achievements

// SharedPreferences keys
- sfx_volume: 0-100
- music_volume: 0-100
- notifications_enabled: bool
- selected_language: 'english' | 'hebrew'
```

---

### 2. Animation Libraries

**Decision**: Use **Lottie** for complex animations, **Flutter built-in animations** for transitions

**Rationale**:

- Lottie provides designer-friendly workflow (After Effects → JSON export)
- High-quality animations without custom code (confetti, fireworks, character animations)
- Smaller file sizes than video or GIF
- Flutter's `AnimationController` sufficient for page transitions and UI micro-interactions
- Rive considered but Lottie has larger ecosystem and more free assets

**Alternatives Considered**:

- **Rive**: More powerful for interactive animations but steeper learning curve; overkill for this MVP
- **Flare (deprecated)**: No longer maintained
- **Custom animations only**: Too time-consuming for Candy Crush-quality effects

**Implementation Approach**:

```dart
// Lottie for:
- Confetti explosion on lesson complete
- Fireworks for achievements
- Character celebrations
- Loading spinners

// Flutter AnimationController for:
- Page transitions (fade, slide, scale)
- Button press effects
- Points counter animation
- Progress bar fills
```

---

### 3. Audio Playback

**Decision**: Use **just_audio** package

**Rationale**:

- Better than `audioplayers`: more reliable, better performance, active maintenance
- Supports all required features: concurrent playback, volume control, looping, preloading
- Works consistently across iOS and Android
- Low latency for sound effects (critical for game feel)
- Can preload audio files to eliminate lag on first play

**Alternatives Considered**:

- **audioplayers**: Older, less reliable on iOS, more reported bugs
- **flutter_sound**: Overkill (designed for recording), heavier dependency
- **Native platform channels**: Too much maintenance burden for cross-platform support

**Implementation Approach**:

```dart
// AudioManager service
- Preload all SFX on app start
- Background music loop with fade in/out
- Pronunciation audio on-demand with caching
- Volume control via just_audio's setVolume()
- Concurrent playback for SFX + music + pronunciation
```

---

### 4. Right-to-Left (RTL) Text Support for Hebrew

**Decision**: Use Flutter's built-in **Directionality** widget and **intl** package

**Rationale**:

- Flutter has excellent RTL support out-of-the-box
- Directionality widget automatically handles text direction
- TextDirection.rtl for Hebrew, TextDirection.ltr for English
- No third-party dependencies needed
- Bidirectional text (mixed Hebrew/English) handled automatically

**Implementation Approach**:

```dart
// Wrap Hebrew lesson widgets with Directionality
Directionality(
  textDirection: TextDirection.rtl,
  child: LessonWidget(lesson: hebrewLesson),
)

// Font support
- Use Google Fonts with Hebrew glyphs (e.g., 'Assistant', 'Rubik')
- Ensure font weight and legibility on small screens
- Test on multiple device sizes
```

**Best Practices**:

- Always use `TextAlign.start` instead of `TextAlign.left` (direction-aware)
- Test UI layout in both LTR and RTL modes
- Icons that imply direction (arrows) should flip in RTL

---

### 5. Dependency Injection

**Decision**: Use **get_it** for service locator pattern

**Rationale**:

- Simple, clean, and aligns with Clean Architecture
- Register singletons for repositories, use cases, BLoCs
- No code generation required (unlike injectable or riverpod)
- Easy to test (can replace dependencies in tests)
- Lightweight and widely adopted in Flutter community

**Alternatives Considered**:

- **Provider**: More for state management than DI; less explicit for Clean Architecture
- **Riverpod**: Modern but complex for this use case; code generation overhead
- **injectable**: Requires build_runner; adds build time complexity

**Implementation Approach**:

```dart
// lib/core/di/injection.dart
final sl = GetIt.instance;

void initializeDependencies() {
  // Core utilities
  sl.registerLazySingleton<AppLogger>(() => AppLoggerImpl());
  
  // Data sources
  sl.registerLazySingleton<LessonLocalDataSource>(
    () => LessonLocalDataSourceImpl(hive: sl()),
  );
  
  // Repositories
  sl.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(localDataSource: sl()),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetLesson(repository: sl()));
  
  // BLoCs (factories, not singletons - new instance per page)
  sl.registerFactory(() => LessonBloc(getLesson: sl()));
}
```

---

### 6. Asset Management & Optimization

**Decision**: Organize assets by type, use asset_generator for declarations, compress all media

**Rationale**:

- Clear asset organization prevents clutter
- Automatic generation of asset constants prevents typos
- Compression critical for <50MB target (WebP for images, MP3 for audio)
- Lazy loading of lesson audio reduces startup time

**Asset Optimization Strategy**:

```
Images:
- Use WebP format (better compression than PNG, smaller than JPEG)
- SVG for icons and vector graphics (resolution-independent)
- Compress with tools like TinyPNG/Squoosh before adding

Audio:
- MP3 format at 128kbps for SFX (sufficient quality, small size)
- AAC format at 96kbps for music (better quality-to-size ratio)
- Mono for SFX, stereo only for music
- Normalize audio levels to prevent volume inconsistencies

Fonts:
- Subset fonts to include only Latin + Hebrew characters
- Use variable fonts where possible (one file, multiple weights)

Lottie Animations:
- Optimize JSON files (remove unused layers, compress with tools)
- Limit animation complexity (fewer shapes, shorter duration)
```

**Implementation Approach**:

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/audio/sfx/
    - assets/audio/music/
    - assets/audio/pronunciation/english/
    - assets/audio/pronunciation/hebrew/
    - assets/images/
    - assets/animations/
    - assets/data/lessons/
    - assets/data/exercises/
```

---

### 7. Testing Strategy

**Decision**: Widget tests for UI, unit tests for domain logic, BLoC tests for state management

**Rationale**:

- Constitution requires widget tests for UI and unit tests for critical logic
- BLoC pattern makes testing easier (isolated business logic)
- Mockito for mocking repositories and data sources
- bloc_test package simplifies BLoC testing with built-in matchers

**Testing Pyramid**:

```
Unit Tests (60%)
- All use cases (GetLesson, SubmitAnswer, UpdatePoints, etc.)
- Scoring logic, streak calculation, points accumulation
- Repository implementations (with mocked data sources)

Widget Tests (30%)
- MainMenuPage, LessonPage, SettingsPage
- Exercise widgets (MultipleChoice, FillBlank, Matching, Listening)
- Points counter, streak indicator, achievement popup

BLoC Tests (10%)
- LessonBloc state transitions
- ProgressBloc event handling
- SettingsBloc state persistence
```

**Tools**:

- `flutter_test` - built-in testing framework
- `bloc_test` - BLoC-specific testing helpers
- `mockito` - mock generation for repositories
- `golden_toolkit` - visual regression testing (optional)

---

## Technology Stack Summary

| Category | Decision | Package/Version |
|----------|----------|-----------------|
| Language | Dart | 3.2+ |
| Framework | Flutter | 3.16+ |
| State Management | BLoC | `flutter_bloc: ^8.1.3` |
| Value Equality | Equatable | `equatable: ^2.0.5` |
| Local Storage (Data) | Hive | `hive: ^2.2.3`, `hive_flutter: ^1.1.0` |
| Local Storage (Settings) | SharedPreferences | `shared_preferences: ^2.2.2` |
| Audio Playback | just_audio | `just_audio: ^0.9.36` |
| Animations | Lottie | `lottie: ^2.7.0` |
| Dependency Injection | GetIt | `get_it: ^7.6.4` |
| Testing | Flutter Test + BLoC Test | `bloc_test: ^9.1.5`, `mockito: ^5.4.4` |
| Fonts | Google Fonts | `google_fonts: ^6.1.0` |
| Logging | Custom AppLogger | (implementation in lib/core/utils/) |

---

## Best Practices Established

### 1. Project Organization

- Feature-first structure (lessons/, progress_tracking/, settings/, etc.)
- Each feature has complete Clean Architecture layers (domain/data/presentation)
- Shared code in `core/` (errors, utils, theme, DI)

### 2. Code Style

- DartDoc comments required for all public APIs (per constitution)
- Flutter widget type annotations: `[StatelessWidget]`, `[StatefulWidget]`
- Explicit parameter documentation for methods
- Constants include rationale for values

### 3. Performance

- Lazy load lesson content (don't load all 30 lessons at startup)
- Preload only current lesson's audio files
- Use `const` constructors wherever possible
- Dispose resources properly (AnimationControllers, AudioPlayers, BLoCs)

### 4. Error Handling

- Use Dartz `Either<Failure, Success>` for repository return types
- Domain layer defines abstract `Failure` classes
- Data layer throws exceptions, repository catches and converts to Failures
- Presentation layer handles Failures with user-friendly messages

### 5. Offline-First

- All lesson data bundled in assets (JSON files)
- No network calls required for core functionality
- Progress saved locally with Hive (immediate persistence)
- App fully functional without internet connection

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Asset size exceeds 50MB limit | High | Aggressive compression, lazy loading, subset fonts |
| RTL text rendering issues | Medium | Early testing on real devices, use Flutter's built-in RTL support |
| Audio latency on button press | Medium | Preload all SFX, use just_audio with low buffer settings |
| 60 FPS not maintained in animations | High | Profile in release mode, optimize Lottie files, reduce particle count |
| Memory usage exceeds 200MB | Medium | Dispose resources, lazy load content, monitor with DevTools |

---

## Research Complete

All technology decisions finalized. No `NEEDS CLARIFICATION` items remain. Ready to proceed to Phase 1 (Design).
