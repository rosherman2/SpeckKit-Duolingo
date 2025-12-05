# Testing Guide for Duolingo-Style Game

This directory contains all tests for the project, organized by type and feature.

## Directory Structure

```
test/
├── unit/                      # Unit tests (isolated component testing)
│   ├── core/                 # Core utilities tests
│   │   └── utils/           # AppLogger, constants tests
│   └── features/            # Feature-specific tests
│       └── progress_tracking/
│           ├── domain/      # Domain layer tests
│           │   └── usecases/  # Use case tests
│           └── presentation/  # Presentation layer tests
│               └── bloc/      # BLoC tests
├── widget/                    # Widget/Component tests
└── integration/              # Integration tests

```

## Test Types

### Unit Tests

- **Purpose**: Test individual classes/methods in isolation
- **Tools**: `flutter_test`, `mocktail`
- **Example**: Testing a use case with mocked repository

### Widget Tests

- **Purpose**: Test UI components and interactions
- **Tools**: `flutter_test`, `bloc_test`
- **Example**: Testing a button's tap behavior

### Integration Tests

- **Purpose**: Test complete user flows
- **Tools**: `integration_test` package
- **Example**: Testing lesson completion flow end-to-end

## Running Tests

### Run all tests

```bash
flutter test
```

### Run specific test file

```bash
flutter test test/unit/features/progress_tracking/presentation/bloc/progress_bloc_test.dart
```

### Run tests with coverage

```bash
flutter test --coverage
```

### View coverage report

```bash
genhtml coverage/lcov.info -o coverage/html
```

## Writing Tests

### BLoC Tests Example

```dart
blocTest<MyBloc, MyState>(
  'description of what is being tested',
  build: () {
    // Setup mocks
    when(() => mockRepo.method()).thenAnswer((_) async => result);
    return myBloc;
  },
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [
    ExpectedState1(),
    ExpectedState2(),
  ],
  verify: (_) {
    verify(() => mockRepo.method()).called(1);
  },
);
```

### Use Case Tests Example

```dart
test('should return UserProgress when repository call succeeds', () async {
  // Arrange
  when(() => mockRepo.getUserProgress())
      .thenAnswer((_) async => Right(tUserProgress));
  
  // Act
  final result = await useCase();
  
  // Assert
  expect(result, equals(Right(tUserProgress)));
  verify(() => mockRepo.getUserProgress()).called(1);
});
```

## Test Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: Cover all interactive widgets
- **Integration Tests**: Cover main user flows

## Best Practices

1. **AAA Pattern**: Arrange, Act, Assert
2. **One assertion per test**: Keep tests focused
3. **Descriptive names**: Test names should explain what is being tested
4. **Mock dependencies**: Use `mocktail` for clean mocking
5. **Test edge cases**: Don't just test happy paths
6. **Use test groups**: Organize related tests together

## Mocking

We use `mocktail` for mocking because it:

- Doesn't require code generation
- Has cleaner syntax than `mockito`
- Works well with null safety

```dart
class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();
when(() => mockRepo.method()).thenAnswer((_) async => result);
```

## Constitutional Compliance

All tests must:

- Follow Clean Architecture layers
- Test business logic independently
- Mock external dependencies
- Include comprehensive logging verification
- Maintain zero production impact

## Next Steps

1. Add tests for all use cases
2. Add widget tests for all UI components
3. Add integration tests for main user flows
4. Set up CI/CD test automation
