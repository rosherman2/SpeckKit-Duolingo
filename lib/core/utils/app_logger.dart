import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// [Service] Structured logging utility with file rotation and zero production impact.
///
/// Features:
/// - Four severity levels: debug, info, warning, error
/// - Lazy evaluation via Function() parameters (zero cost when disabled)
/// - Loop throttling (max 1 log per second per location)
/// - Dual output: human-readable console + JSON file
/// - File rotation (5MB max per file, keeps 5 most recent files)
/// - Thread-safe file writes
/// - Complete elimination in production via kDebugMode guards
///
/// Purpose: Provide structured logging for development without affecting production
///
/// Usage:
/// ```dart
/// AppLogger.debug('ClassName', 'methodName', () => 'Debug message');
/// AppLogger.info('ClassName', 'methodName', () => 'Info message');
/// AppLogger.warning('ClassName', 'methodName', () => 'Warning message');
/// AppLogger.error('ClassName', 'methodName', () => 'Error: \${error}');
/// ```
///
/// Constitutional Requirement: Principle III - Observability & Debugging
class AppLogger {
  static LogFormat _format = LogFormat.console;
  static int _maxFileSize = 5 * 1024 * 1024; // 5MB
  static int _maxFiles = 5;
  static File? _currentLogFile;
  static final Map<String, DateTime> _lastLogTimes = {};
  static bool _isInitialized = false;

  /// [Method] Initializes the logger with configuration.
  ///
  /// Must be called before any logging occurs (typically in main()).
  ///
  /// Parameters:
  /// - format: Output format (console or JSON)
  /// - maxFileSize: Maximum size per log file in bytes (default: 5MB)
  /// - maxFiles: Number of log files to keep (default: 5)
  ///
  /// Note: Initialization only occurs in debug mode (kDebugMode == true)
  static Future<void> initialize({
    required LogFormat format,
    int maxFileSize = 5 * 1024 * 1024,
    int maxFiles = 5,
  }) async {
    if (kDebugMode) {
      _format = format;
      _maxFileSize = maxFileSize;
      _maxFiles = maxFiles;

      try {
        final directory = await getApplicationDocumentsDirectory();
        final logsDir = Directory('${directory.path}/logs');

        // Create logs directory if it doesn't exist
        if (!await logsDir.exists()) {
          await logsDir.create(recursive: true);
        }

        // Create initial log file
        await _rotateLogFileIfNeeded();
        _isInitialized = true;

        info(
            'AppLogger', 'initialize', () => 'Logger initialized successfully');
      } catch (e) {
        // Fallback to console-only if file operations fail
        debugPrint(
            '[AppLogger] File initialization failed: $e. Using console-only mode.');
      }
    }
  }

  /// [Method] Logs a debug message (lowest severity).
  ///
  /// Use for: Detailed information during development, loop iterations, state changes
  ///
  /// Parameters:
  /// - className: Name of the class logging the message
  /// - methodName: Name of the method logging the message
  /// - messageFn: Lazy function that returns the message string
  ///
  /// Note: Only evaluated and logged in debug builds (kDebugMode == true)
  ///
  /// Example:
  /// ```dart
  /// AppLogger.debug('LessonBloc', 'onAnswerSubmitted', () => 'Answer: \$answer');
  /// ```
  static void debug(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode) {
      _log('DEBUG', className, methodName, messageFn);
    }
  }

  /// [Method] Logs an info message (informational events).
  ///
  /// Use for: Important events, user actions, feature usage
  ///
  /// Parameters:
  /// - className: Name of the class logging the message
  /// - methodName: Name of the method logging the message
  /// - messageFn: Lazy function that returns the message string
  ///
  /// Note: Only evaluated and logged in debug builds (kDebugMode == true)
  ///
  /// Example:
  /// ```dart
  /// AppLogger.info('LessonBloc', 'onLessonCompleted', () => 'Lesson \$id completed');
  /// ```
  static void info(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode) {
      _log('INFO', className, methodName, messageFn);
    }
  }

  /// [Method] Logs a warning message (potential issues).
  ///
  /// Use for: Deprecated API usage, recoverable errors, unexpected conditions
  ///
  /// Parameters:
  /// - className: Name of the class logging the message
  /// - methodName: Name of the method logging the message
  /// - messageFn: Lazy function that returns the message string
  ///
  /// Note: Only evaluated and logged in debug builds (kDebugMode == true)
  ///
  /// Example:
  /// ```dart
  /// AppLogger.warning('AudioManager', 'playSound', () => 'Audio file not found: \$path');
  /// ```
  static void warning(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode) {
      _log('WARNING', className, methodName, messageFn);
    }
  }

  /// [Method] Logs an error message (highest severity).
  ///
  /// Use for: Exceptions, failures, critical errors
  ///
  /// Parameters:
  /// - className: Name of the class logging the message
  /// - methodName: Name of the method logging the message
  /// - messageFn: Lazy function that returns the message string
  ///
  /// Note: Only evaluated and logged in debug builds (kDebugMode == true)
  ///
  /// Example:
  /// ```dart
  /// AppLogger.error('ProgressRepository', 'getUserProgress', () => 'Failed: \$error');
  /// ```
  static void error(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode) {
      _log('ERROR', className, methodName, messageFn);
    }
  }

  /// [Internal Method] Core logging implementation with throttling and dual output.
  ///
  /// Handles:
  /// - Location-based throttling (1 second minimum between logs from same location)
  /// - Message evaluation (only if not throttled)
  /// - Dual output (console + file)
  /// - Error handling (falls back to console if file write fails)
  ///
  /// Parameters:
  /// - level: Severity level (DEBUG, INFO, WARNING, ERROR)
  /// - className: Class name
  /// - methodName: Method name
  /// - messageFn: Lazy function that returns the message
  static void _log(
    String level,
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode) {
      final location = '$className.$methodName';
      final now = DateTime.now();

      // Throttling: Check if we've logged from this location in the last second
      if (_lastLogTimes.containsKey(location)) {
        final lastTime = _lastLogTimes[location]!;
        if (now.difference(lastTime).inSeconds < 1) {
          // Throttled - skip this log
          return;
        }
      }

      // Update last log time for this location
      _lastLogTimes[location] = now;

      // Evaluate message (only if not throttled)
      final message = messageFn();

      // Write to console
      _writeToConsole(level, className, methodName, message, now);

      // Write to file (if initialized)
      if (_isInitialized) {
        _writeToFile(level, className, methodName, message, now, false);
      }
    }
  }

  /// [Internal Method] Writes log entry to console in human-readable format.
  ///
  /// Format: [timestamp] [LEVEL] className.methodName: message
  /// Example: [2025-12-04 18:30:45.123] [DEBUG] MyClass.myMethod: Processing item 5
  ///
  /// Parameters:
  /// - level: Severity level
  /// - className: Class name
  /// - methodName: Method name
  /// - message: Log message
  /// - timestamp: When the log occurred
  static void _writeToConsole(
    String level,
    String className,
    String methodName,
    String message,
    DateTime timestamp,
  ) {
    final formattedTime = _formatTimestamp(timestamp);
    final logEntry =
        '[$formattedTime] [$level] $className.$methodName: $message';
    debugPrint(logEntry);
  }

  /// [Internal Method] Writes log entry to file with rotation support.
  ///
  /// Handles:
  /// - Format selection (console vs JSON)
  /// - File rotation if size limit exceeded
  /// - Error handling (falls back to console on failure)
  ///
  /// Parameters:
  /// - level: Severity level
  /// - className: Class name
  /// - methodName: Method name
  /// - message: Log message
  /// - timestamp: When the log occurred
  /// - throttled: Whether this log was throttled
  static void _writeToFile(
    String level,
    String className,
    String methodName,
    String message,
    DateTime timestamp,
    bool throttled,
  ) {
    try {
      // Check if rotation is needed
      _rotateLogFileIfNeeded();

      if (_currentLogFile == null) return;

      String logEntry;
      if (_format == LogFormat.json) {
        // JSON format
        final logObject = {
          'timestamp': timestamp.toIso8601String(),
          'severity': level,
          'class': className,
          'method': methodName,
          'message': message,
          'throttled': throttled,
        };
        logEntry = '${jsonEncode(logObject)}\n';
      } else {
        // Console format (human-readable)
        final formattedTime = _formatTimestamp(timestamp);
        logEntry =
            '[$formattedTime] [$level] $className.$methodName: $message\n';
      }

      // Thread-safe write (synchronous for simplicity in this implementation)
      _currentLogFile!.writeAsStringSync(logEntry, mode: FileMode.append);
    } catch (e) {
      // Fallback to console if file write fails
      debugPrint('[AppLogger] File write failed: $e');
    }
  }

  /// [Internal Method] Rotates log file if size limit exceeded.
  ///
  /// Creates a new log file with timestamp-based naming.
  /// Deletes oldest files if total count exceeds maxFiles.
  ///
  /// File naming: app_log_YYYY_MM_DD_HH_mm_ss.log
  ///
  /// Throws: Exception if file operations fail (caught by caller)
  static Future<void> _rotateLogFileIfNeeded() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/logs');

      // Check if current file needs rotation
      if (_currentLogFile != null && await _currentLogFile!.exists()) {
        final fileSize = await _currentLogFile!.length();
        if (fileSize < _maxFileSize) {
          return; // No rotation needed
        }
      }

      // Create new log file with timestamp
      final now = DateTime.now();
      final timestamp = _formatFilenameTimestamp(now);
      final newLogFile = File('${logsDir.path}/app_log_$timestamp.log');
      await newLogFile.create();
      _currentLogFile = newLogFile;

      // Clean up old log files
      await _cleanupOldLogFiles(logsDir);
    } catch (e) {
      debugPrint('[AppLogger] Log rotation failed: $e');
    }
  }

  /// [Internal Method] Deletes oldest log files if count exceeds maxFiles.
  ///
  /// Keeps only the most recent N files (sorted by filename/timestamp).
  ///
  /// Parameters:
  /// - logsDir: Directory containing log files
  ///
  /// Throws: Exception if file operations fail (caught by caller)
  static Future<void> _cleanupOldLogFiles(Directory logsDir) async {
    final logFiles = logsDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.log'))
        .toList();

    // Sort by filename (timestamp-based names sort chronologically)
    logFiles.sort((a, b) => a.path.compareTo(b.path));

    // Delete oldest files if count exceeds limit
    if (logFiles.length > _maxFiles) {
      final filesToDelete = logFiles.take(logFiles.length - _maxFiles);
      for (final file in filesToDelete) {
        try {
          await file.delete();
        } catch (e) {
          debugPrint('[AppLogger] Failed to delete old log file: $e');
        }
      }
    }
  }

  /// [Internal Method] Formats timestamp for console output.
  ///
  /// Format: YYYY-MM-DD HH:mm:ss.SSS
  /// Example: 2025-12-04 18:30:45.123
  ///
  /// Parameters:
  /// - timestamp: DateTime to format
  ///
  /// Returns: Formatted timestamp string
  static String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${_pad(timestamp.month)}-${_pad(timestamp.day)} '
        '${_pad(timestamp.hour)}:${_pad(timestamp.minute)}:${_pad(timestamp.second)}'
        '.${_padMilliseconds(timestamp.millisecond)}';
  }

  /// [Internal Method] Formats timestamp for log filenames.
  ///
  /// Format: YYYY_MM_DD_HH_mm_ss
  /// Example: 2025_12_04_18_30_45
  ///
  /// Parameters:
  /// - timestamp: DateTime to format
  ///
  /// Returns: Formatted timestamp string suitable for filenames
  static String _formatFilenameTimestamp(DateTime timestamp) {
    return '${timestamp.year}_${_pad(timestamp.month)}_${_pad(timestamp.day)}_'
        '${_pad(timestamp.hour)}_${_pad(timestamp.minute)}_${_pad(timestamp.second)}';
  }

  /// [Internal Method] Pads single-digit numbers with leading zero.
  ///
  /// Parameters:
  /// - value: Number to pad (0-99)
  ///
  /// Returns: Padded string (e.g., "05", "12")
  static String _pad(int value) => value.toString().padLeft(2, '0');

  /// [Internal Method] Pads milliseconds with leading zeros.
  ///
  /// Parameters:
  /// - value: Milliseconds to pad (0-999)
  ///
  /// Returns: Padded string (e.g., "005", "123")
  static String _padMilliseconds(int value) => value.toString().padLeft(3, '0');
}

/// [Enum] Log output format options.
///
/// Values:
/// - console: Human-readable format for console output
/// - json: JSON format for structured logging and parsing
enum LogFormat {
  /// Human-readable format: [timestamp] [LEVEL] className.methodName: message
  console,

  /// JSON format: {"timestamp": "...", "severity": "...", "class": "...", "method": "...", "message": "..."}
  json,
}
