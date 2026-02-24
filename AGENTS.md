# Agent Guidelines for MeloTrip

## Code Style and Best Practices

### Flutter Color API Usage

**IMPORTANT**: Do NOT use the deprecated `withOpacity()` method.

❌ **Wrong (Deprecated):**
```dart
color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
```

✅ **Correct (Current API):**
```dart
color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
```

### Reason
- `withOpacity()` has been deprecated in newer Flutter versions
- `withValues(alpha: )` is the recommended replacement
- This applies to all Color objects in the codebase

