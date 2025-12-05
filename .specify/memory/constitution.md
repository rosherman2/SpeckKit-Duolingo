<!--
Sync Impact Report:
- Version change: NONE → 1.0.0
- Modified principles: N/A (initial creation)
- Added sections: Core Principles (5), Performance Standards, Governance
- Removed sections: N/A
- Templates requiring updates:
  ✅ plan-template.md (Constitution Check section verified - no updates needed)
  ✅ spec-template.md (verified - aligns with constitution requirements)
  ✅ tasks-template.md (verified - aligns with constitution principles)
- Follow-up TODOs: None
-->

# SpeckKit-Duolingo Constitution

## Core Principles

### I. Clean Architecture (NON-NEGOTIABLE)

All code MUST follow Clean Architecture with strict layer separation. Features MUST be organized in feature-first modules with clear boundaries.

**Rationale**: Clean Architecture ensures maintainability, testability, and scalability for mobile games. Layer separation prevents coupling and enables parallel development.

**Requirements**:

- Feature modules MUST be self-contained (presentation → domain → data)
- Dependencies flow inward only (presentation → domain ← data)
- Domain layer MUST be pure Dart with zero Flutter dependencies
- Each layer has clear responsibilities: UI (presentation), business logic (domain), data access (data)

---

### II. State Management (BLoC Pattern)

All state management MUST use `flutter_bloc` with clear event/state separation. Direct widget state mutation is prohibited in feature logic.

**Rationale**: BLoC provides predictable state management with clear data flow, essential for complex game logic and debugging. Event-driven architecture prevents state inconsistencies.

**Requirements**:

- All feature state MUST be managed via BLoC (events → business logic → states)
- UI widgets MUST be stateless or use BLoC for state
- Events MUST be immutable and descriptive
- States MUST be immutable value objects
- Use `Equatable` for all events and states

---

### III. Observability & Debugging

All Flutter code MUST use structured logging via the project's `AppLogger` utility. Logging MUST have zero impact on production builds and use lazy evaluation for all messages.

**Rationale**: Mobile apps are difficult to debug remotely. Structured logging with file persistence enables diagnosing issues in development without affecting release performance.

**Usage Standards**:

Always log with explicit context:

```dart
AppLogger.debug('ClassName', 'methodName', () => 'message');
AppLogger.info('ClassName', 'methodName', () => 'message');
AppLogger.warning('ClassName', 'methodName', () => 'message');
AppLogger.error('ClassName', 'methodName', () => 'message');
```

**Key Requirements**:

- **Lazy Evaluation Required**: Use `() => 'message'` syntax - expensive computations only execute in debug mode
- **Explicit Context**: Always provide class name and method name strings
- **Appropriate Severity**:
  - `DEBUG`: Detailed flow (loops, conditionals, data transformations)
  - `INFO`: High-level events (user actions, state changes)
  - `WARNING`: Recoverable issues, deprecated usage
  - `ERROR`: Failures impacting functionality

**Guaranteed Behavior**:

- Production builds: Zero overhead, complete code elimination
- Debug builds: Logs to console AND local files
- Loop protection: Automatic throttling prevents spam

**Implementation Location**: `lib/core/utils/app_logger.dart`

---

### IV. Code Documentation Standards

All Dart/Flutter code MUST be self-documenting for developers with C++/Java backgrounds. Every class, method, function, and significant variable MUST have complete DartDoc comments. Code must be immediately understandable without deep Flutter expertise.

**Rationale**: Self-documenting code reduces onboarding time for developers with C++/Java backgrounds and prevents misunderstandings of Flutter-specific patterns. Consistent documentation standards ensure code maintainability and knowledge transfer.

**Documentation Requirements**:

**BALANCED VERBOSITY**:

- Every class, method, and function MUST have documentation
- Use concise but complete descriptions (2-3 sentences max)
- Essential info only - no unnecessary elaboration
- Think "C++ header comment" style

**STANDARD FORMATS**:

Methods/Functions:

```dart
/// [Brief description of what it does in one sentence].
/// [Additional behavior, return info, or important notes].
/// 
/// Parameters:
/// - [param1]: Description of parameter
/// - [param2]: Description of parameter
/// 
/// Throws: ExceptionType1, ExceptionType2
Future<ReturnType> methodName(Type param1, Type param2) async {
  // implementation
}
```

Classes:

```dart
/// [StatelessWidget/StatefulWidget/Service/Model] [What it does/represents].
/// [Additional context about purpose or behavior].
/// Purpose: [Why this class exists]
/// Navigation: [How user reaches it - for screens only]
class ClassName extends BaseClass {
  // implementation
}
```

**FLUTTER-SPECIFIC ANNOTATIONS**:

Always indicate widget type in brackets at the start:

- `[StatelessWidget]` - Immutable widget, no internal state
- `[StatefulWidget]` - Mutable widget with internal state management
- `[Provider]` - State management provider
- `[Service]` - Business logic service
- `[Model]` - Data model/entity

**ASYNC/FUTURE DOCUMENTATION**:

For all async methods:

```dart
/// Asynchronously [action description].
/// Await this method or use .then() callback.
/// 
/// Throws: NetworkException, TimeoutException
Future<User> getUser(String id) async { ... }
```

**ERROR HANDLING DOCUMENTATION**:

For critical methods (auth, payments, data persistence):

```dart
/// [Method description].
/// 
/// Exceptions:
/// - ExceptionType1: When/why it occurs
/// - ExceptionType2: When/why it occurs
```

For standard CRUD methods:

```dart
/// [Method description].
/// Throws: ExceptionType1, ExceptionType2
```

**CONSTANTS & CONFIGURATION**:

Always provide full rationale for magic numbers:

```dart
/// [What this constant controls].
/// [Why this specific value was chosen - rationale].
const Type constantName = value;
```

**INLINE COMMENTS FOR COMPLEX LOGIC**:

Add inline comments within method bodies for:

- Non-obvious algorithms or data transformations
- Flutter/Dart-specific idioms that differ from C++/Java conventions
- Business logic decisions with rationale
- Performance optimizations or workarounds

**Target Audience**: Developers with C++/Java experience but limited Flutter knowledge.

**Enforcement**:

- DartDoc linting MUST be enabled in `analysis_options.yaml`
- All code reviews MUST verify compliance
- No pull requests may be merged without complete documentation
- Run `dart doc` to verify zero documentation warnings

---

### V. Testing & Quality

All features MUST include widget tests for UI components. Critical game logic (scoring, collision detection, state transitions) MUST have unit tests.

**Rationale**: Mobile games require reliable UI rendering and game logic. Testing prevents regressions and ensures consistent user experience across devices.

**Requirements**:

- Widget tests MUST cover all interactive UI components
- Unit tests MUST cover all domain layer business logic
- Test coverage for critical paths MUST be maintained
- Use `bloc_test` for BLoC testing
- All tests MUST pass before merge

---

## Performance Standards

**Frame Rate**: Game screens MUST maintain 60 FPS during gameplay on mid-range devices (iPhone 11, Pixel 4a equivalent). Dropped frames not permitted in core game loops.

**Build Size**: Release APK/IPA MUST be under 50MB uncompressed. Use asset compression and code optimization.

**Memory**: Peak memory usage MUST stay under 200MB on target devices during active gameplay.

**Startup Time**: App cold start MUST complete within 3 seconds on mid-range devices.

**Rationale**: Mobile games demand smooth performance. Poor frame rates and high resource usage lead to uninstalls and negative reviews.

---

## Governance

This constitution supersedes all other development practices. All code changes MUST comply with the principles defined above.

**Amendment Process**:

- Amendments require documentation of rationale and impact
- Version number MUST be incremented per semantic versioning:
  - MAJOR: Backward-incompatible principle changes or removals
  - MINOR: New principles added or material expansions
  - PATCH: Clarifications, wording fixes, non-semantic refinements
- All dependent templates (spec, plan, tasks) MUST be updated to reflect changes

**Compliance Review**:

- All PRs MUST pass constitution compliance checks
- Code reviews MUST verify adherence to all principles
- Violations MUST be justified in `plan.md` Complexity Tracking section
- Unjustified complexity will be rejected

**Constitution Gates** (enforced in plan.md):

- ✅ Clean Architecture: Feature modules follow layer separation
- ✅ BLoC State Management: All state uses flutter_bloc
- ✅ Logging: AppLogger used with lazy evaluation
- ✅ Documentation: Complete DartDoc for all public APIs
- ✅ Testing: Widget tests and unit tests present
- ✅ Performance: Meets frame rate, size, and memory targets

**Version**: 1.0.0 | **Ratified**: 2025-12-04 | **Last Amended**: 2025-12-04
