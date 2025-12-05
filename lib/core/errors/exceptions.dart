/// [Exception Class] Base class for all exceptions in the data layer.
///
/// Exceptions are thrown in the data layer and caught by repositories,
/// which convert them to Failures for the domain layer.
///
/// Purpose: Distinguish data layer errors from domain layer failures
///
/// Usage: Extend this class for specific exception types.
/// Example:
/// ```dart
/// class NetworkException implements Exception {}
/// ```
class ServerException implements Exception {}

/// [Exception Class] Thrown when local cache/database operations fail.
///
/// This exception is thrown when:
/// - Hive box operations fail
/// - SharedPreferences operations fail
/// - Local file operations fail
/// - Database is corrupted or locked
///
/// Enhanced with detailed error context for debugging.
///
/// Purpose: Indicate cache-related errors in data layer
///
/// Caught by: Repository implementations
/// Converted to: CacheFailure
class CacheException implements Exception {
  /// [String] Human-readable error message
  final String message;

  /// [String?] Original exception details
  final String? details;

  /// Creates a CacheException with optional message and details.
  ///
  /// Parameters:
  /// - message: Description of what went wrong
  /// - details: Original exception message if available
  const CacheException({
    this.message = 'Cache operation failed',
    this.details,
  });

  @override
  String toString() => 'CacheException: $message'
      '${details != null ? ' | Details: $details' : ''}';
}

/// [Exception Class] Thrown when asset loading fails in data sources.
///
/// This exception is thrown when:
/// - JSON asset parsing fails
/// - Audio file cannot be loaded
/// - Image asset is missing
/// - Asset path is invalid
///
/// Purpose: Indicate asset-related errors in data layer
///
/// Caught by: Repository implementations
/// Converted to: AssetFailure
class AssetException implements Exception {
  /// [String] Path to the asset that caused the exception
  final String assetPath;

  /// Creates an AssetException with the problematic asset path.
  ///
  /// Parameters:
  /// - assetPath: Full path to the asset that failed
  const AssetException(this.assetPath);
}

/// [Exception Class] Thrown when audio playback operations fail in data layer.
///
/// This exception is thrown when:
/// - just_audio player throws an error
/// - Audio file format is unsupported
/// - Audio initialization fails
/// - Playback is interrupted by system
///
/// Purpose: Indicate audio playback errors in data layer
///
/// Caught by: AudioRepository implementation
/// Converted to: PlaybackFailure
class PlaybackException implements Exception {
  /// [String] Reason for the playback failure
  final String reason;

  /// Creates a PlaybackException with the failure reason.
  ///
  /// Parameters:
  /// - reason: Description of what went wrong
  const PlaybackException(this.reason);
}

/// [Exception Class] Thrown when data validation fails in data layer.
///
/// This exception is thrown when:
/// - JSON deserialization fails
/// - Data model validation fails
/// - Type conversion fails
/// - Required fields are missing
///
/// Purpose: Indicate validation errors in data layer
///
/// Caught by: Repository implementations
/// Converted to: ValidationFailure
class ValidationException implements Exception {
  /// [String] Description of the validation error
  final String message;

  /// Creates a ValidationException with the error message.
  ///
  /// Parameters:
  /// - message: What validation failed
  const ValidationException(this.message);
}
