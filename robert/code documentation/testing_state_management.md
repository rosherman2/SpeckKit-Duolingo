# Testing Strategies for State Management Issues

## **Critical Test Patterns for BLoC State Management**

---

## **1. Rapid-Fire Click Testing**

### **Manual Testing**

```dart
// Test Case: Rapid Dialog Trigger
void testRapidDialogClicks() {
  // 1. Click button 1 time
  // Expected: Dialog shows
  
  // 2. Dismiss dialog
  
  // 3. Click button 5-10 times rapidly
  // Expected: Dialog shows each time
  
  // 4. Monitor logs for:
  //    - "State reset to allow future dialogs"
  //    - No "Dialog already showing" warnings
  //    - No errors
}
```

### **Automated Testing**

```dart
testWidgets('Shows dialog on repeated rapid clicks', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // First click
  await tester.tap(find.byType(AboutButton));
  await tester.pump();
  expect(find.byType(AboutDialog), findsOneWidget);
  
  // Dismiss
  await tester.tap(find.text('Close'));
  await tester.pump();
  
  // Rapid clicks (simulate rapid-fire)
  for (int i = 0; i < 5; i++) {
    await tester.tap(find.byType(AboutButton));
    await tester.pump(Duration(milliseconds: 50)); // Fast clicks
  }
  
  // Should still work
  await tester.pump(Duration(milliseconds: 150));
  expect(find.byType(AboutDialog), findsOneWidget);
});
```

---

## **2. State Equality Testing**

### **BLoC Test for State Transitions**

```dart
blocTest<MenuBloc, MenuState>(
  'Emits MenuLoaded after dialog shown',
  build: () => MenuBloc(),
  act: (bloc) {
    bloc.add(NavigateToAbout());
    // Simulate state reset after dialog
    Future.delayed(Duration(milliseconds: 100), () {
      bloc.add(MenuStarted());
    });
  },
  expect: () => [
    MenuNavigating(route: 'about'),
    MenuLoaded(), // CRITICAL: Must return to loaded state
  ],
);

blocTest<MenuBloc, MenuState>(
  'Allows multiple dialog triggers',
  build: () => MenuBloc(),
  act: (bloc) async {
    bloc.add(NavigateToAbout());
    await Future.delayed(Duration(milliseconds: 100));
    bloc.add(MenuStarted()); // Reset
    
    await Future.delayed(Duration(milliseconds: 100));
    bloc.add(NavigateToAbout()); // Second trigger
  },
  expect: () => [
    MenuNavigating(route: 'about'),
    MenuLoaded(),
    MenuNavigating(route: 'about'), // Should trigger again!
  ],
);
```

---

## **3. Event Transformer Testing**

### **Test Restartable Transformer**

```dart
blocTest<MyBloc, MyState>(
  'Cancels previous event when using restartable',
  build: () => MyBloc(),
  act: (bloc) async {
    bloc.add(Event1());
    await Future.delayed(Duration(milliseconds: 10));
    bloc.add(Event2()); // Should cancel Event1
  },
  expect: () => [
    StateProcessing(),
    StateFinal(), // Only final state, Event1 was cancelled
  ],
);
```

### **Test Sequential Transformer**

```dart
blocTest<MyBloc, MyState>(
  'Processes events sequentially',
  build: () => MyBloc(),
  act: (bloc) {
    bloc.add(Event1());
    bloc.add(Event2());
    bloc.add(Event3());
  },
  expect: () => [
    StateProcessing1(),
    StateComplete1(),
    StateProcessing2(),
    StateComplete2(),
    StateProcessing3(),
    StateComplete3(),
  ],
);
```

---

## **4. Context.mounted Testing**

### **Widget Test for Disposed Context**

```dart
testWidgets('Handles disposed context gracefully', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Trigger async operation
  await tester.tap(find.byType(MyButton));
  await tester.pump(Duration(milliseconds: 50));
  
  // Navigate away (dispose widget)
  await tester.pageBack();
  await tester.pump();
  
  // Wait for delayed callback
  await tester.pump(Duration(milliseconds: 150));
  
  // Should not crash - context.mounted check prevents error
  expect(tester.takeException(), isNull);
});
```

---

## **5. Integration Testing Checklist**

### **Manual Test Scenarios**

#### **Scenario 1: Rapid Button Clicks**

```
Steps:
1. Launch app
2. Click "About" button 10 times rapidly
3. Verify dialog appears each time
4. Check logs for state resets
5. No errors in console

Pass Criteria:
✅ Dialog shows on every click
✅ No "context.read called after dispose" errors
✅ No UI freezes or crashes
```

#### **Scenario 2: Multiple Button Rapid Clicks**

```
Steps:
1. Click "About" 3 times rapidly
2. Immediately click "Settings" 3 times rapidly
3. Immediately click "Lessons" 3 times rapidly
4. Verify each shows appropriate dialog/response

Pass Criteria:
✅ Each button works independently
✅ No state conflicts between buttons
✅ All dialogs appear correctly
```

#### **Scenario 3: Dialog Dismiss During Rapid Clicks**

```
Steps:
1. Click "About" button
2. While dialog is showing, click "About" 5 more times
3. Dismiss dialog
4. Click "About" again

Pass Criteria:
✅ Only one dialog shows at a time
✅ After dismiss, button works normally
✅ No stacked dialogs
```

#### **Scenario 4: Long-Running Operations**

```
Steps:
1. Trigger operation that takes >2 seconds
2. Click same button multiple times during operation
3. Verify only one operation runs

Pass Criteria:
✅ Event transformer prevents duplicate operations
✅ UI shows single loading indicator
✅ Only one result processed
```

---

## **6. Automated Test Coverage Goals**

### **Unit Tests (BLoC Logic)**

- ✅ Every event has a test
- ✅ Every state transition tested
- ✅ Event transformers validated
- ✅ Error states tested
- ✅ State reset logic tested

**Target Coverage: 90%+**

### **Widget Tests (UI Behavior)**

- ✅ Button tap triggers correct event
- ✅ BlocListener responds to states
- ✅ BlocBuilder renders correctly
- ✅ Dialog shows/dismisses properly
- ✅ Context.mounted checks work

**Target Coverage: 80%+**

### **Integration Tests (End-to-End)**

- ✅ Complete user flows
- ✅ Multi-step interactions
- ✅ Navigation sequences
- ✅ Error recovery paths

**Target Coverage: Critical paths only**

---

## **7. Performance Testing**

### **Event Flooding Test**

```dart
test('Handles event flooding gracefully', () async {
  final bloc = MyBloc();
  
  // Fire 100 events rapidly
  for (int i = 0; i < 100; i++) {
    bloc.add(RapidEvent(i));
  }
  
  await Future.delayed(Duration(seconds: 1));
  
  // Verify:
  // - No memory leaks
  // - Transformer dropped/cancelled excess events
  // - Final state is correct
  
  bloc.close();
});
```

### **Memory Leak Test**

```dart
test('No memory leaks with rapid state changes', () async {
  final List<MyBloc> blocs = [];
  
  // Create 100 blocs
  for (int i = 0; i < 100; i++) {
    final bloc = MyBloc();
    bloc.add(SomeEvent());
    blocs.add(bloc);
  }
  
  // Close all
  for (final bloc in blocs) {
    await bloc.close();
  }
  
  // Run GC and verify memory released
  // (Use memory profiler tools)
});
```

---

## **8. Logging-Based Testing**

### **Log Pattern Verification**

```dart
// Expected log sequence for successful dialog flow
void verifyDialogFlow(List<String> logs) {
  expect(logs, contains('Button tapped: About'));
  expect(logs, contains('received NavigateToAbout'));
  expect(logs, contains('Showing about dialog'));
  expect(logs, contains('State reset to allow future dialogs'));
  expect(logs, contains('About dialog dismissed'));
}

// Anti-pattern detection
void checkForIssues(List<String> logs) {
  // Should NOT see these patterns
  expect(logs, isNot(contains('Dialog already showing')));
  expect(logs, isNot(contains('context.read called after dispose')));
  expect(logs, isNot(contains('setState called after dispose')));
}
```

---

## **9. Regression Test Suite**

### **Create Test Suite for Known Issues**

```dart
group('Regression Tests - State Management', () {
  // Issue: Dialog won't show twice
  testWidgets('REG-001: Repeated dialog triggers work', (tester) async {
    // Test the exact scenario that was broken
  });
  
  // Issue: Rapid clicks crash app  
  testWidgets('REG-002: Rapid clicks handled gracefully', (tester) async {
    // Test rapid-fire scenario
  });
  
  // Add more as issues are discovered and fixed
});
```

---

## **10. CI/CD Integration**

### **Automated Test Pipeline**

```yaml
# .github/workflows/tests.yml
name: State Management Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      
      # Unit tests
      - run: flutter test --coverage
      
      # Widget tests with rapid-fire scenarios
      - run: flutter test test/widget/rapid_click_test.dart
      
      # Integration tests
      - run: flutter drive --target=test_driver/app.dart
      
      # Coverage report
      - run: genhtml coverage/lcov.info -o coverage/html
```

---

## **Quick Testing Checklist**

Before marking a feature complete:

- [ ] Rapid-click test (10 clicks in 2 seconds)
- [ ] State reset confirmed in logs
- [ ] No "context disposed" errors
- [ ] Event transformer working (logs show cancellation)
- [ ] All BLoC tests passing
- [ ] Widget tests cover happy + error paths
- [ ] Integration test for critical flow
- [ ] No memory leaks (profiler check)

---

## **Tools & Setup**

### **Required Packages**

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mocktail: ^1.0.1
  integration_test:
    sdk: flutter
```

### **Recommended Tools**

- **Flutter DevTools**: Memory profiler, performance
- **AppLogger**: Runtime state tracking
- **BlocObserver**: Global BLoC monitoring
- **Sentry/Crashlytics**: Production error tracking

---

**Use these patterns to catch state management issues BEFORE production!**
