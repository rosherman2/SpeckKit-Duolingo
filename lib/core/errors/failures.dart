import 'package:equatable/equatable.dart';

/// [Abstract Class] Base class for all failures in the application.
///
/// Failures represent errors that occur in the domain and data layers.
/// All failures extend Equatable for value equality comparisons.
///
/// Usage: Extend this class to create specific failure types.
/// Example:
/// ```dart
/// class NetworkFailure extends Failure {}
/// ```
abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

/// [Failure] Indicates a failure when accessing local cache or database.
///
/// This failure occurs when:
/// - Hive database operations fail
/// - SharedPreferences read/write fails
/// - Local file system access is denied
/// - Data corruption is detected
///
/// Enhanced with detailed error context for better debugging.
///
/// Purpose: Represents all local storage-related errors
class CacheFailure extends Failure {
  /// [String] Human-readable description of the error
  ///
  /// Examples:
  /// - "Failed to open Hive box 'progress_box'"
  /// - "Could not write to cache: Permission denied"
  /// - "Cache data corrupted"
  final String message;

  /// [String] Type of operation that failed
  ///
  /// Examples: 'read', 'write', 'delete', 'open'
  final String operation;

  /// [String?] Optional original exception message
  final String? originalException;

  /// Creates a CacheFailure with detailed error information.
  ///
  /// Parameters:
  /// - message: User-friendly error description
  /// - operation: What operation failed
  /// - originalException: Original exception message if available
  CacheFailure({
    this.message = 'Cache operation failed',
    this.operation = 'unknown',
    this.originalException,
  });

  @override
  List<Object?> get props => [message, operation, originalException];

  @override
  String toString() => 'CacheFailure($operation): $message'
      '${originalException != null ? ' | Original: $originalException' : ''}';
}

/// [Failure] Indicates a failure during data validation.
///
/// This failure occurs when:
/// - Entity validation rules are violated
/// - Data format is incorrect (e.g., invalid JSON)
/// - Required fields are missing
/// - Value constraints are not met (e.g., points < 0)
///
/// Purpose: Represents validation errors with optional message
class ValidationFailure extends Failure {
  /// [String] Human-readable description of the validation error
  ///
  /// Examples:
  /// - "Total points must be >= 0"
  /// - "Lesson ID cannot be empty"
  /// - "Required accuracy must be between 0.0 and 1.0"
  final String message;

  /// Creates a ValidationFailure with the given error message.
  ///
  /// Parameters:
  /// - message: Description of what validation failed
  ValidationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// [Failure] Indicates a failure when loading assets (audio, images, animations).
///
/// This failure occurs when:
/// - Audio file not found in assets
/// - Image file missing or corrupted
/// - Lottie animation JSON is invalid
/// - Asset path is incorrect
///
/// Purpose: Represents asset loading errors with path information
class AssetFailure extends Failure {
  /// [String] Path to the asset that failed to load
  ///
  /// Examples:
  /// - "assets/audio/sfx/button_tap.mp3"
  /// - "assets/animations/confetti.json"
  /// - "assets/images/background.webp"
  final String assetPath;

  /// Creates an AssetFailure for the given asset path.
  ///
  /// Parameters:
  /// - assetPath: Full path to the failed asset
  AssetFailure(this.assetPath);

  @override
  List<Object?> get props => [assetPath];
}

/// [Failure] Indicates a failure during audio playback.
///
/// This failure occurs when:
/// - Audio player initialization fails
/// - Playback is interrupted
/// - Audio format is not supported
/// - Device audio output is unavailable
///
/// Purpose: Represents audio playback errors with reason description
class PlaybackFailure extends Failure {
  /// [String] Human-readable description of the playback error
  ///
  /// Examples:
  /// - "Audio player not initialized"
  /// - "Unsupported audio format"
  /// - "Playback interrupted by system"
  final String reason;

  /// Creates a PlaybackFailure with the given reason.
  ///
  /// Parameters:
  /// - reason: Description of why playback failed
  PlaybackFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}
