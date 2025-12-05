# Quickstart Guide: Development Setup

**Feature**: 001-duolingo-game  
**Date**: 2025-12-04  
**Purpose**: Get the development environment set up and run the Duolingo-style language learning game

## Prerequisites

### Required Software

1. **Flutter SDK** (3.16.0 or higher)
   - Download from: <https://flutter.dev/docs/get-started/install>
   - Verify installation: `flutter --version`
   - Run `flutter doctor` to check for issues

2. **Dart SDK** (3.2.0 or higher)
   - Included with Flutter SDK
   - Verify: `dart --version`

3. **IDE** (Choose one)
   - **Android Studio** (recommended for Android development)
     - Install Flutter and Dart plugins
   - **VS Code**
     - Install Flutter and Dart extensions
   - **IntelliJ IDEA**
     - Install Flutter and Dart plugins

4. **iOS Development** (macOS only)
   - Xcode 15.0+
   - CocoaPods: `sudo gem install cocoapods`
   - iOS Simulator or physical iPhone (iOS 13+)

5. **Android Development**
   - Android Studio
   - Android SDK (API level 24+ / Android 7.0+)
   - Android Emulator or physical Android device

### Verify Setup

```bash
# Check Flutter installation and connected devices
flutter doctor -v

# Expected output: No issues for target platforms (iOS/Android)
```

---

## Installation Steps

### 1. Clone the Repository

```bash
cd c:\Development\flutter_projects\SpeckKit-Duolingo
git checkout 001-duolingo-game
```

### 2. Install Dependencies

```bash
# Install all Flutter packages
flutter pub get

# Verify no dependency conflicts
flutter pub deps
```

### 3. Generate Code (if using code generation)

```bash
# For Hive type adapters (if using generated adapters)
flutter packages pub run build_runner build

# Watch mode for continuous generation during development
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

### 4. Configure IDE

**For VS Code:**
Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Debug)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "Flutter (Profile)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "flutterMode": "profile"
    },
    {
      "name": "Flutter (Release)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "flutterMode": "release"
    }
  ]
}
```

**For Android Studio:**

- Open project in Android Studio
- Select target device from device dropdown
- Click Run (green play button)

---

## Project Structure Overview

```
lib/
├── main.dart              # App entry point
├── app.dart               # Root widget with routing
├── core/                  # Shared utilities
│   ├── di/                # Dependency injection
│   ├── errors/            # Error handling
│   ├── theme/             # App theme
│   └── utils/             # Utilities (AppLogger, constants)
└── features/              # Feature modules
    ├── main_menu/         # Main menu feature
    ├── lessons/           # Lessons feature
    ├── progress_tracking/ # Progress tracking
    ├── settings/          # Settings
    └── audio_visual/      # Audio & animations

assets/
├── audio/                 # Sound effects, music, pronunciation
├── images/                # Images and icons
├── animations/            # Lottie/Rive animation files
└── data/                  # Lesson JSON data

test/
├── features/              # Feature tests
└── core/                  # Core utility tests
```

---

## Running the App

### On iOS Simulator

```bash
# List available iOS simulators
flutter devices

# Run on specific simulator
flutter run -d "iPhone 15 Pro"

# Or just run on default device
flutter run
```

### On Android Emulator

```bash
# List available Android emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator_id>

# Run on emulator
flutter run -d emulator-5554
```

### On Physical Device

**iOS:**

1. Connect iPhone via USB
2. Trust the computer on device
3. Select device in Xcode or IDE
4. Run: `flutter run`

**Android:**

1. Enable Developer Options on device (tap Build Number 7 times)
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

### Hot Reload During Development

- **Hot Reload**: Press `r` in terminal (preserves state)
- **Hot Restart**: Press `R` in terminal (resets state)
- **Quit**: Press `q` in terminal

---

## Testing

### Run All Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Specific Tests

```bash
# Run tests for a specific feature
flutter test test/features/lessons/

# Run a single test file
flutter test test/features/lessons/domain/usecases/get_lesson_test.dart

# Run with verbose output
flutter test --verbose
```

### Widget Tests

```bash
# Run only widget tests (convention: files ending in _widget_test.dart)
flutter test test/ --name="Widget"
```

### BLoC Tests

```bash
# Run BLoC-specific tests
flutter test test/ --name="Bloc"
```

---

## Asset Management

### Adding New Audio Files

1. Place audio file in appropriate directory:
   - SFX: `assets/audio/sfx/`
   - Music: `assets/audio/music/`
   - Pronunciation: `assets/audio/pronunciation/<language>/`

2. Register in `pubspec.yaml` (if directory not already listed):

   ```yaml
   flutter:
     assets:
       - assets/audio/sfx/new_sound.mp3
   ```

3. Reference in code:

   ```dart
   const String sfxPath = 'assets/audio/sfx/new_sound.mp3';
   ```

### Adding New Images

1. Place image in `assets/images/`
2. Use WebP format for best compression
3. Register in `pubspec.yaml`
4. Reference: `'assets/images/icon.webp'`

### Adding New Lottie Animations

1. Download Lottie JSON from LottieFiles or export from After Effects
2. Optimize JSON with LottieFiles optimizer
3. Place in `assets/animations/`
4. Load in widget:

   ```dart
   Lottie.asset('assets/animations/confetti.json')
   ```

---

## Common Development Tasks

### Initialize Hive Database

```dart
// In main.dart before runApp()
await Hive.initFlutter();
await Hive.openBox('progressBox');
await Hive.openBox('lessonsBox');
```

### Register Dependency Injection

```dart
// In lib/core/di/injection.dart
void initializeDependencies() {
  // Register all services, repositories, use cases, BLoCs
  // Call this in main.dart before runApp()
}
```

### Add New Feature Module

1. Create feature directory: `lib/features/new_feature/`
2. Add subdirectories: `domain/`, `data/`, `presentation/`
3. Create entities in `domain/entities/`
4. Create use cases in `domain/usecases/`
5. Create BLoC in `presentation/bloc/`
6. Register dependencies in `core/di/injection.dart`

### Add New Lesson Content

1. Edit `assets/data/lessons/<language>_lessons.json`
2. Add lesson object with exercises
3. Hot reload to see changes (no rebuild needed)

---

## Debugging Tips

### Performance Profiling

```bash
# Run in profile mode
flutter run --profile

# Enable performance overlay in app
# (Add to MaterialApp: showPerformanceOverlay: true)
```

### Check FPS

```dart
// In main.dart or app.dart
MaterialApp(
  showPerformanceOverlay: true, // Shows FPS overlay
  ...
)
```

### Debug Logging

```dart
// Use AppLogger for structured logging (visible in debug mode only)
AppLogger.debug('ClassName', 'methodName', () => 'Debug message');
AppLogger.info('ClassName', 'methodName', () => 'Info message');
AppLogger.error('ClassName', 'methodName', () => 'Error message');
```

### Flutter DevTools

```bash
# Run app in debug mode
flutter run

# Open DevTools (shown in terminal output)
# Or manually: flutter pub global run devtools
```

Use DevTools for:

- Widget Inspector (view widget tree)
- Performance view (timeline profiling)
- Memory view (track allocations)
- Network view (track HTTP requests - minimal for offline app)

---

## Build for Release

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)

```bash
# Build Android App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA

```bash
# Build iOS release
flutter build ios --release

# Open Xcode for signing and archiving
open ios/Runner.xcworkspace
```

**iOS Archive Steps:**

1. Open workspace in Xcode
2. Select "Generic iOS Device" as target
3. Product → Archive
4. Distribute to App Store or export for TestFlight

---

## Troubleshooting

### Issue: `flutter doctor` shows Android license issues

**Solution:**

```bash
flutter doctor --android-licenses
# Accept all licenses
```

### Issue: CocoaPods installation fails on iOS

**Solution:**

```bash
cd ios
pod repo update
pod install
cd ..
flutter clean
flutter run
```

### Issue: Hot reload not working

**Solution:**

```bash
# Full rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: Hive database corrupted

**Solution:**

```bash
# Clear app data and reinstall
flutter clean
# On device: Clear app data in Settings
flutter run
```

### Issue: Audio not playing

**Solution:**

- Verify audio file paths in `pubspec.yaml`
- Check file exists in `assets/audio/`
- Ensure `just_audio` package is initialized
- Test with different audio format (MP3 vs AAC)

### Issue: RTL text not rendering correctly (Hebrew)

**Solution:**

```dart
// Wrap Hebrew content with Directionality
Directionality(
  textDirection: TextDirection.rtl,
  child: YourWidget(),
)

// Ensure font supports Hebrew glyphs
```

### Issue: Out of memory during development

**Solution:**

- Close unused apps/emulators
- Reduce emulator RAM allocation
- Use physical device instead of emulator
- Dispose resources properly (AnimationControllers, BLoCs)

---

## Environment Variables (Optional)

For different build flavors (dev, staging, prod):

**Create** `lib/core/config/env_config.dart`:

```dart
enum BuildFlavor { dev, staging, prod }

class EnvironmentConfig {
  static BuildFlavor flavor = BuildFlavor.dev;
  
  static bool get isDebug => flavor == BuildFlavor.dev;
  static bool get enableLogging => flavor != BuildFlavor.prod;
}
```

---

## Next Steps

1. ✅ Verify all prerequisites installed
2. ✅ Run `flutter doctor` (all green)
3. ✅ Install dependencies: `flutter pub get`
4. ✅ Run app: `flutter run`
5. ✅ Verify main menu appears with animations
6. ✅ Run tests: `flutter test`
7. 🚀 Start implementing features from `tasks.md`

---

## Useful Commands Reference

```bash
# Clean build artifacts
flutter clean

# Update dependencies
flutter pub upgrade

# Analyze code for issues
flutter analyze

# Format code
dart format lib/ test/

# Check outdated packages
flutter pub outdated

# Run specific device
flutter run -d <device_id>

# Build release mode for performance testing
flutter run --release
```

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Hive Database](https://docs.hivedb.dev/)
- [just_audio Package](https://pub.dev/packages/just_audio)
- [Lottie for Flutter](https://pub.dev/packages/lottie)

---

**Quickstart Complete** - Development environment ready for implementation phase.
