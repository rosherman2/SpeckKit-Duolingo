import 'package:hive_flutter/hive_flutter.dart';
import 'package:speckkit_duolingo/core/errors/exceptions.dart';
import 'package:speckkit_duolingo/core/utils/app_logger.dart';
import 'package:speckkit_duolingo/features/progress_tracking/data/models/user_progress_model.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';

/// [Data Source Interface] Contract for local progress storage operations.
///
/// Defines CRUD operations for progress data using Hive.
abstract class ProgressLocalDataSource {
  /// Retrieves user progress from Hive.
  ///
  /// Returns: UserProgressModel
  /// Throws: CacheException if Hive access fails
  Future<UserProgressModel> getUserProgress();

  /// Saves user progress to Hive.
  ///
  /// Parameters:
  /// - progress: Progress model to save
  ///
  /// Throws: CacheException if save fails
  Future<void> saveUserProgress(UserProgressModel progress);

  /// Deletes all stored progress (reset).
  ///
  /// Throws: CacheException if deletion fails
  Future<void> deleteUserProgress();
}

/// [Data Source Implementation] Hive-based progress storage.
///
/// Uses Hive for fast, local key-value storage of progress data.
/// All operations wrapped in try-catch with logging.
///
/// Purpose: Persist user progress across app sessions
///
/// Constitutional Requirement: Local storage using Hive
class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  /// [String] Hive box name for progress storage
  static const String _progressBoxName = 'progress_box';

  /// [String] Key for user progress in Hive box
  static const String _userProgressKey = 'user_progress';

  /// [Box?] Cached reference to the opened Hive box
  ///
  /// Opened once during first operation and kept open for better performance.
  Box<dynamic>? _box;

  /// Gets the Hive box, opening it if not already open.
  ///
  /// Optimized to open box once and cache the reference.
  ///
  /// Returns: Open Hive box for progress storage
  Future<Box<dynamic>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }

    AppLogger.debug('ProgressLocalDataSource', '_getBox',
        () => 'Opening Hive box: $_progressBoxName');

    _box = await Hive.openBox<dynamic>(_progressBoxName);

    return _box!;
  }

  /// Retrieves user progress from Hive storage.
  ///
  /// Returns: UserProgressModel from storage or initial if not found
  ///
  /// Throws: CacheException if Hive operations fail
  @override
  Future<UserProgressModel> getUserProgress() async {
    AppLogger.debug('ProgressLocalDataSource', 'getUserProgress',
        () => 'Reading user progress from Hive');

    try {
      final box = await Hive.openBox<dynamic>(_progressBoxName);

      final jsonData = box.get(_userProgressKey) as Map<dynamic, dynamic>?;

      if (jsonData == null) {
        AppLogger.info('ProgressLocalDataSource', 'getUserProgress',
            () => 'No saved progress found, returning initial progress');

        // Return initial progress for first-time users
        return UserProgressModel.fromEntity(UserProgress.initial());
      }

      AppLogger.debug('ProgressLocalDataSource', 'getUserProgress',
          () => 'Successfully read progress from Hive');

      // Convert dynamic map to String keys
      final stringKeyMap = Map<String, dynamic>.from(jsonData);

      return UserProgressModel.fromJson(stringKeyMap);
    } catch (e, stackTrace) {
      AppLogger.error('ProgressLocalDataSource', 'getUserProgress',
          () => 'Failed to read progress: $e\nStack: $stackTrace');
      throw CacheException(
        message: 'Failed to read user progress from Hive',
        details: e.toString(),
      );
    }
  }

  /// Saves user progress to Hive storage.
  ///
  /// Parameters:
  /// - progress: Progress model to persist
  ///
  /// Throws: CacheException if Hive operations fail
  @override
  Future<void> saveUserProgress(UserProgressModel progress) async {
    AppLogger.debug(
        'ProgressLocalDataSource',
        'saveUserProgress',
        () =>
            'Saving user progress to Hive: ${progress.totalPoints} points, ${progress.currentStreak} streak');

    try {
      final box = await Hive.openBox<dynamic>(_progressBoxName);

      final jsonData = progress.toJson();

      await box.put(_userProgressKey, jsonData);

      AppLogger.debug('ProgressLocalDataSource', 'saveUserProgress',
          () => 'Successfully saved progress to Hive');
    } catch (e, stackTrace) {
      AppLogger.error('ProgressLocalDataSource', 'saveUserProgress',
          () => 'Failed to save progress: $e\nStack: $stackTrace');
      throw CacheException();
    }
  }

  /// Deletes all stored progress from Hive.
  ///
  /// Used for reset functionality or testing.
  ///
  /// Throws: CacheException if Hive operations fail
  @override
  Future<void> deleteUserProgress() async {
    AppLogger.warning('ProgressLocalDataSource', 'deleteUserProgress',
        () => 'Deleting all user progress from Hive');

    try {
      final box = await Hive.openBox<dynamic>(_progressBoxName);

      await box.delete(_userProgressKey);

      AppLogger.info('ProgressLocalDataSource', 'deleteUserProgress',
          () => 'Successfully deleted progress from Hive');
    } catch (e, stackTrace) {
      AppLogger.error('ProgressLocalDataSource', 'deleteUserProgress',
          () => 'Failed to delete progress: $e\nStack: $stackTrace');
      throw CacheException();
    }
  }
}
