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

### Dart Wildcard Parameters

- When intentionally ignoring parameters, use `_` wildcard names.
- In the same parameter list, repeated `_` is valid and preferred:
  - Good: `(_, _) { ... }`
  - Avoid: `(_, __) { ... }` (triggers `unnecessary_underscores` lint)

### Dart Dot Shorthand

- Prefer dot shorthand when the context type is clear and compile-safe.
- Good examples:
  - Enum values: `mainAxisSize: .min`, `playlistMode == .loop`
  - Static members with clear context: `Uri uri = .parse(url)`
- Do not force replacement where context type does not own the member.
  - Keep full form for common cases like `Icons.*` and `Colors.*`
- Always validate with `flutter analyze` after bulk replacements.

### App Update Versioning (must follow)

- This project uses app update metadata based on `pubspec.yaml` `version` (`versionName+versionCode`).
- For every releasable change, bump both parts together:
  - `versionName` (before `+`) must increase (e.g. `1.0.0` -> `1.0.1`)
  - `versionCode` (after `+`) must increase monotonically (e.g. `+1` -> `+2`)
- Never reuse or decrease `versionCode`, otherwise update checks may fail or skip updates.

## File Editing Safety

### 1) Encoding and BOM Safety (must follow)

- For text files always read/write as UTF-8 explicitly.
- Do NOT use `Set-Content -Encoding utf8` for these files, because it may introduce BOM/encoding issues across environments.
- Prefer `apply_patch` for normal edits.
- If scripting is required in PowerShell, use .NET APIs:
  - Read: `[System.IO.File]::ReadAllText(path, [System.Text.Encoding]::UTF8)`
  - Write UTF-8 **without BOM**: `[System.IO.File]::WriteAllText(path, text, (New-Object System.Text.UTF8Encoding($false)))`
- If preserving original BOM is required, detect it first from bytes, then write back with the same BOM setting.

### 2) Generated Files Policy (must follow)

- Never manually edit generated files.
- Examples:
  - `*.g.dart`
  - `*.freezed.dart`
  - `lib/l10n/app_localizations*.dart`
- Only update source files, then regenerate:
  - l10n: `flutter gen-l10n`
  - codegen: `dart run build_runner build --delete-conflicting-outputs`
