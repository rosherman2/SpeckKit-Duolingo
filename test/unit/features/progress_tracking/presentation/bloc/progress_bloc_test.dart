import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speckkit_duolingo/core/errors/failures.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/entities/user_progress.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/repositories/progress_repository.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/calculate_streak.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/unlock_achievement.dart';
import 'package:speckkit_duolingo/features/progress_tracking/domain/usecases/update_points.dart';
import 'package:speckkit_duolingo/features/progress_tracking/presentation/bloc/progress_bloc.dart';
import 'package:speckkit_duolingo/features/progress_tracking/presentation/bloc/progress_event.dart';
import 'package:speckkit_duolingo/features/progress_tracking/presentation/bloc/progress_state.dart';

/// Mock classes for testing
class MockProgressRepository extends Mock implements ProgressRepository {}

class MockUpdatePoints extends Mock implements UpdatePoints {}

class MockCalculateStreak extends Mock implements CalculateStreak {}

class MockUnlockAchievement extends Mock implements UnlockAchievement {}

/// [Test Suite] ProgressBloc unit tests
///
/// Tests all BLoC functionality including:
/// - Initial state
/// - Loading progress
/// - Adding points
/// - Updating streaks
/// - Error handling
/// - Retry mechanisms
void main() {
  late ProgressBloc bloc;
  late MockProgressRepository mockRepository;
  late MockUpdatePoints mockUpdatePoints;
  late MockCalculateStreak mockCalculateStreak;
  late MockUnlockAchievement mockUnlockAchievement;

  /// Test data
  final tUserProgress = UserProgress(
    totalPoints: 100,
    currentStreak: 5,
    longestStreak: 10,
    lastPracticeDate: DateTime(2025, 1, 1),
    unlockedAchievements: const ['century_club'],
  );

  setUp(() {
    mockRepository = MockProgressRepository();
    mockUpdatePoints = MockUpdatePoints();
    mockCalculateStreak = MockCalculateStreak();
    mockUnlockAchievement = MockUnlockAchievement();

    bloc = ProgressBloc(
      repository: mockRepository,
      updatePoints: mockUpdatePoints,
      calculateStreak: mockCalculateStreak,
      unlockAchievement: mockUnlockAchievement,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProgressBloc -', () {
    test('initial state is ProgressInitial', () {
      expect(bloc.state, equals(const ProgressInitial()));
    });

    group('ProgressLoaded event', () {
      blocTest<ProgressBloc, ProgressState>(
        'emits [ProgressLoading, ProgressLoadedState] when loading succeeds',
        build: () {
          when(() => mockRepository.getUserProgress())
              .thenAnswer((_) async => Right(tUserProgress));
          return bloc;
        },
        act: (bloc) => bloc.add(const ProgressLoaded()),
        expect: () => [
          const ProgressLoading(),
          ProgressLoadedState(progress: tUserProgress),
        ],
        verify: (_) {
          verify(() => mockRepository.getUserProgress()).called(1);
        },
      );

      blocTest<ProgressBloc, ProgressState>(
        'emits [ProgressLoading, ProgressError] when loading fails',
        build: () {
          when(() => mockRepository.getUserProgress())
              .thenAnswer((_) async => Left(CacheFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const ProgressLoaded()),
        expect: () => [
          const ProgressLoading(),
          const ProgressError(
            message: 'Failed to load progress. Please try again.',
            operationType: 'load',
            canRetry: true,
          ),
        ],
      );
    });

    group('PointsAdded event', () {
      blocTest<ProgressBloc, ProgressState>(
        'emits [ProgressUpdated] when points are added successfully',
        build: () {
          when(() => mockRepository.getUserProgress())
              .thenAnswer((_) async => Right(tUserProgress));
          when(() => mockUpdatePoints(50)).thenAnswer(
              (_) async => Right(tUserProgress.copyWith(totalPoints: 150)));
          return bloc;
        },
        act: (bloc) => bloc.add(const PointsAdded(points: 50)),
        expect: () => [
          ProgressUpdated(
            progress: tUserProgress.copyWith(totalPoints: 150),
            updateType: 'points',
          ),
        ],
      );

      blocTest<ProgressBloc, ProgressState>(
        'emits [ProgressError] when adding points fails',
        build: () {
          when(() => mockRepository.getUserProgress())
              .thenAnswer((_) async => Right(tUserProgress));
          when(() => mockUpdatePoints(50))
              .thenAnswer((_) async => Left(CacheFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const PointsAdded(points: 50)),
        expect: () => [
          const ProgressError(
            message: 'Failed to add points. Please try again.',
            operationType: 'addPoints',
            retryContext: {'points': 50},
            canRetry: true,
          ),
          ProgressLoadedState(progress: tUserProgress),
        ],
      );
    });

    group('RetryLoadProgress event', () {
      blocTest<ProgressBloc, ProgressState>(
        'retries loading and succeeds',
        build: () {
          when(() => mockRepository.getUserProgress())
              .thenAnswer((_) async => Right(tUserProgress));
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryLoadProgress()),
        expect: () => [
          const ProgressLoading(),
          ProgressLoadedState(progress: tUserProgress),
        ],
      );
    });
  });
}
