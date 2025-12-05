# BLoC State Management - Quick Reference Card

## **The Golden Rule: Always Reset State After Dialogs**

```dart
// After showing any dialog/modal:
showDialog(...);

Future.delayed(const Duration(milliseconds: 100), () {
  if (context.mounted) {
    context.read<MyBloc>().add(const ResetEvent());
  }
});
```

---

## **Event Transformers - When to Use**

| Pattern | When | Example |
|---------|------|---------|
| `restartable()` | Navigation, dialogs | Button clicks |
| `sequential()` | Data writes | Database updates |
| `droppable()` | Search/autocomplete | Text input |

---

## **Common Bugs & Instant Fixes**

| Bug | Fix |
|-----|-----|
| "Dialog won't show twice" | Add state reset after `showDialog()` |
| "Rapid clicks crash app" | Add `restartable()` transformer |
| "Context disposed error" | Add `if (context.mounted)` check |
| "State not updating" | Check Equatable `props` includes all fields |

---

## **Testing Checklist**

Before committing any clickable UI:

- [ ] Click button 10 times rapidly
- [ ] Verify logs show state resets
- [ ] No errors in console
- [ ] Memory profiler shows no leaks

---

For full details see:

- `bloc_state_management_rules.md` - Complete rules
- `testing_state_management.md` - Test strategies
