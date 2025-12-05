import 'package:get_it/get_it.dart';
import 'package:speckkit_duolingo/features/progress_tracking/data/datasources/progress_local_data_source.dart';
import 'package:speckkit_duolingo/features/progress_tracking/data/repositories/progress_repository_impl.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/calculate_streak.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/unlock_achievement.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/update_points.dart';
import 'package:speckkit_duolingo/features/progress_tracking/presentation/bloc/progress_bloc.dart';

/// [Service Locator] Dependency injection container using GetIt.
///
/// Provides centralized registration and retrieval of dependencies.
/// Follows the Service Locator pattern for Clean Architecture.
///
/// Usage:
/// ```dart
/// // Register dependencies at app startup
/// await initializeDependencies();
///
/// // Retrieve dependencies
/// final repository = sl<LessonRepository>();
/// ```
///
/// Purpose: Decouple component creation from usage, enable testability
///
/// Constitutional Requirement: Supports Clean Architecture layer separation
final sl = GetIt.instance;

/// [Function] Initializes all app dependencies in the correct order.
///
/// Must be called at app startup before any features are used.
/// Registers dependencies from bottom-up: Data → Domain → Presentation
///
/// Registration order:
/// 1. Core utilities (AppLogger)
/// 2. External dependencies (Hive, SharedPreferences)
/// 3. Data sources
/// 4. Repositories5. Use cases
/// 6. BLoCs (as factories for new instances per screen)
///
/// Note: This will be expanded as features are implemented in subsequent phases
///
/// Returns: Future that completes when all dependencies are registered
Future<void> initializeDependencies() async {
  // Core utilities
  // AppLogger is static, no registration needed

  // ===== Progress Tracking Feature =====

  // Data sources
  sl.registerLazySingleton<ProgressLocalDataSource>(
    () => ProgressLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => UpdatePoints(repository: sl()));
  sl.registerLazySingleton(() => CalculateStreak(repository: sl()));
  sl.registerLazySingleton(() => UnlockAchievement(repository: sl()));

  // BLoCs (as factories for new instances per screen)
  sl.registerFactory(
    () => ProgressBloc(
      repository: sl(),
      updatePoints: sl(),
      calculateStreak: sl(),
      unlockAchievement: sl(),
    ),
  );

  // TODO: Register lesson feature dependencies when implemented
  // TODO: Register audio feature dependencies when implemented
}
