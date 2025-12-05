# Flutter BLoC State Management - Critical Patterns & Rules

## **CRITICAL RULE: State Reset After Non-Navigational Actions**

### **The Problem**
When using `BlocListener` with **Equatable** states, the listener only fires when the state *changes*. If you navigate to the same state twice (e.g., `MenuNavigating('about')` → `MenuNavigating('about')`), the listener won't trigger the second time.

### **When This Occurs**
- Showing dialogs (not route navigation)
- Opening bottom sheets
- Showing snackbars
- Any UI action that doesn't change the current route
- Repeated button clicks to the same destination

### **✅ MANDATORY PATTERN: Always Reset State After Dialogs/Modals**

```dart
// ❌ WRONG - State stays at MenuNavigating, subsequent clicks won't work
case 'dialog':
  showDialog(...);
  break;

// ✅ CORRECT - Reset state to allow future triggers
case 'dialog':
  showDialog(...);
  
  // Reset state after showing dialog
  Future.delayed(const Duration(milliseconds: 100), () {
    if (context.mounted) {
      context.read<MyBloc>().add(const ResetEvent());
    }
  });
  break;
```

### **When to Apply This Pattern**

✅ **ALWAYS** reset state after:
- `showDialog()`
- `showModalBottomSheet()`
- `showCupertinoDialog()`
- `ScaffoldMessenger.showSnackBar()`
- Any modal/overlay that doesn't navigate to a new route

❌ **NEVER** reset state after:
- `Navigator.push()` - Route handles state
- `Navigator.pushNamed()` - Route handles state
- Actual page navigation - Let navigation stack manage it

---

## **Rule #2: Event Transformers for User Input**

### **✅ MANDATORY: Use Event Transformers on All User-Triggered Events**

```dart
// ❌ WRONG - No transformer, rapid clicks stack up
on<ButtonClicked>(_onButtonClicked);

// ✅ CORRECT - Transformer prevents event flooding
on<ButtonClicked>(_onButtonClicked, transformer: restartable());
```

### **Transformer Types**

| Transformer | Use Case | Example |
|-------------|----------|---------|
| `restartable()` | Navigation, dialogs, modals | Button clicks, menu navigation |
| `sequential()` | Data mutations, API calls | Save data, update database |
| `droppable()` | Search, autocomplete | Typing in search field |
| `concurrent()` | Independent operations | Loading multiple resources |

### **When to Use Each**

**restartable()** ⭐ Most Common
- User navigation actions
- Dialog triggers
- Modal displays
- Cancel previous if new event arrives

**sequential()**
- Database writes
- State updates that must complete
- Prevent race conditions

**droppable()**
- Search as you type
- Autocomplete
- Drop new events if already processing

---

## **Rule #3: Context.mounted Check After Async**

### **✅ MANDATORY: Always check context.mounted after async gaps**

```dart
// ❌ WRONG - Widget might be disposed
Future.delayed(Duration(milliseconds: 100), () {
  context.read<MyBloc>().add(Event());
});

// ✅ CORRECT - Check if widget still exists
Future.delayed(Duration(milliseconds: 100), () {
  if (context.mounted) {
    context.read<MyBloc>().add(Event());
  }
});
```

---

## **Rule #4: BlocListener vs BlocBuilder**

### **Use BlocListener for Side Effects**
- Navigation
- Showing dialogs
- Displaying snackbars
- Analytics events

### **Use BlocBuilder for UI Rendering**
- Displaying data
- Conditional widget rendering
- Loading states

### **✅ CORRECT Pattern**

```dart
BlocListener<MyBloc, MyState>(
  listener: (context, state) {
    // Side effects only
    if (state is NavigationState) {
      Navigator.pushNamed(context, state.route);
    }
  },
  child: BlocBuilder<MyBloc, MyState>(
    builder: (context, state) {
      // UI rendering only
      if (state is LoadingState) return CircularProgressIndicator();
      return MyWidget();
    },
  ),
)
```

---

## **Rule #5: Equatable Props Must Include All Fields**

### **✅ MANDATORY: Include ALL fields that affect state equality**

```dart
// ❌ WRONG - Missing timestamp, all dialogs are "equal"
class ShowDialog extends MyState {
  final String dialogType;
  
  @override
  List<Object?> get props => [dialogType];
}

// ✅ OPTION 1: Add unique identifier
class ShowDialog extends MyState {
  final String dialogType;
  final DateTime timestamp; // Makes each instance unique
  
  @override
  List<Object?> get props => [dialogType, timestamp];
}

// ✅ OPTION 2: Reset state after action (PREFERRED)
// Use the state reset pattern instead
```

---

## **Rule #6: Prevent Rapid-Fire with Debounce/Throttle**

### **UI Level (Widget)**

```dart
// Add debounce to button
Timer? _debounce;

void _onButtonPressed() {
  if (_debounce?.isActive ?? false) return;
  
  _debounce = Timer(Duration(milliseconds: 300), () {
    context.read<MyBloc>().add(ButtonClicked());
  });
}
```

### **BLoC Level (Recommended)**

```dart
// Use event transformer
on<ButtonClicked>(
  _onButtonClicked,
  transformer: restartable(), // or droppable()
);
```

---

## **Rule #7: Logging for Debugging State Issues**

### **✅ ALWAYS log state transitions in development**

```dart
// Use BlocObserver for global logging
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.debug('BlocObserver', 'onTransition',
      () => '${bloc.runtimeType}: ${transition.currentState} → ${transition.nextState}');
  }
}
```

This helps identify:
- State not changing (equality issue)
- Events not firing
- Transformer behavior

---

## **Quick Checklist for Every User-Triggered Event**

When implementing a button/clickable element:

- [ ] Event transformer added? (`restartable()` or appropriate)
- [ ] State reset after dialog/modal? (if applicable)
- [ ] `context.mounted` check after async? (if applicable)
- [ ] All Equatable props include relevant fields?
- [ ] BlocListener for side effects, BlocBuilder for UI?
- [ ] Logging in place for debugging?

---

## **Common Pitfalls & Solutions**

| Problem | Symptom | Solution |
|---------|---------|----------|
| Dialog won't show twice | First click works, second click nothing | Add state reset after dialog |
| Rapid clicks stack up | Multiple dialogs/navigations | Add `restartable()` transformer |
| State changes don't trigger | Listener not firing | Check Equatable props |
| Context errors after navigation | "context.read called after dispose" | Check `context.mounted` |
| Race conditions | Inconsistent data state | Use `sequential()` transformer |

---

## **Testing Patterns**

See companion document: `testing_state_management.md`

---

**Constitutional Requirement**: These patterns are MANDATORY for all BLoC implementations
to ensure production-ready, bug-free state management.
