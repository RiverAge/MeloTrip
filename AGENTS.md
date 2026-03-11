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

### Theme Color Rule (must follow)

- UI semantic colors must come from `Theme.of(context).colorScheme` (or `textTheme` derived colors).
- Do NOT hardcode fixed UI colors such as `Colors.white`, `Colors.black`, `Colors.white54`, `Colors.redAccent`, or `Color(0x...)` for normal widgets.
- Prefer theme-derived variants with alpha, e.g. `colorScheme.onSurfaceVariant.withValues(alpha: 0.7)`.
- Allowed exceptions:
  - Brand assets/colors explicitly required by product design (must be documented inline).
  - Non-UI/debug/demo-only code not visible to end users.

### Dart Wildcard Parameters

- When intentionally ignoring parameters, use `_` wildcard names.
- In the same parameter list, repeated `_` is valid and preferred:
  - Good: `(_, _) { ... }`
  - Avoid: `(_, __) { ... }` (triggers `unnecessary_underscores` lint)

### Dart Dot Shorthand

- Do NOT use dot shorthand in this project.
- Always use explicit qualified members for enums/static values (for example: `MainAxisSize.min`, `PlaylistMode.loop`, `Uri.parse(url)`).
- Reason: dot shorthand can fail in some contexts/toolchains (especially desktop builds) and reduce cross-environment compatibility.
- Keep full form for common cases like `Icons.*` and `Colors.*`.
- Always validate with `flutter analyze` after bulk replacements.

### Dart Import Path Style (must follow)

- **Always use `package:melo_trip/...` imports** for all project-internal imports
- **Do NOT use relative imports** (like `import 'file.dart'` or `import '../dir/file.dart'`)
- `package:` imports are required for:
  - All internal project files (e.g., `package:melo_trip/pages/...`, `package:melo_trip/provider/...`)
  - External packages (e.g., `package:flutter/material.dart`)
- Examples:
  - Good: `import 'package:melo_trip/pages/shared/initial/initial_page.dart';`
  - Good: `import 'package:melo_trip/provider/auth/auth.dart';`
  - Wrong: `import '../../shared/initial/initial_page.dart';`
  - Wrong: `import 'package:melo_trip/pages/shared/initial/initial_page.dart';` (when in same directory)

### Text Localization Rule (must follow)

- User-facing text must be localized via l10n (`.arb` + `AppLocalizations`).
- Do NOT hardcode visible copy in Dart widgets/pages (titles, labels, hints, toasts, dialog content, etc.).
- Exception: technical/internal-only strings not shown to end users (e.g., logs, debug keys, route IDs).

### File Size Rule (must follow)

- Avoid oversized source files; split by feature/section into parts/widgets/services.
- Preferred threshold: keep Dart files under 300 lines.
- Hard limit: files above 500 lines must be refactored before merge unless explicitly approved.
- For large UI pages, extract reusable sections into `parts/` with clear ownership.

### App Update Versioning (must follow)

- This project uses app update metadata based on `pubspec.yaml` `version` (`versionName+versionCode`).
- For every releasable change, bump both parts together:
  - `versionName` (before `+`) must increase (e.g. `1.0.0` -> `1.0.1`)
  - `versionCode` (after `+`) must increase monotonically (e.g. `+1` -> `+2`)
- Never reuse or decrease `versionCode`, otherwise update checks may fail or skip updates.
- Release semantic (must follow):
  - Formal release trigger phrase: only treat `部署更新` as a formal release request.
  - `推送更新` means normal push only (no automatic version bump, no automatic tag creation).
  - Default release flow (strict order):
    1) Update app version in `pubspec.yaml` (`versionName+versionCode`)
    2) Commit changes
    3) Create tag (must point to the release commit from step 2)
    4) Push branch and tags (prefer `git push origin --tags` to avoid per-tag command variance)
  - If user does not provide target version/tag:
    - Bump patch and build by +1 (example: `1.0.2+3` -> `1.0.3+4`)
    - Use next sequential tag from existing tags (example: `v0.0.8` -> `v0.0.9`)
  - If push fails, do not rewrite history or delete local tag/commit; report error and keep local state.

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

## Command Execution (Sandbox/Escalation)

- When running `flutter` / `dart` commands under escalation, prefer generic command forms and avoid appending specific file paths when possible.
- Preferred examples:
  - `flutter analyze`
  - `flutter test`
  - `dart analyze`
- Do NOT prepend temporary environment variables or wrapper flags to routine `flutter` / `dart` commands unless the user explicitly requests it or it is confirmed to be necessary to work around an environment issue.
  - Avoid examples such as `$env:DART_SUPPRESS_ANALYTICS='true'; flutter analyze` for normal project validation.
  - Prefer plain commands first, such as `flutter analyze` and `flutter test`.
- Use file-specific forms only when necessary for focused debugging (for example: isolating a single failing test).
- After completing code changes, run `flutter analyze` by default. If it cannot be run, explicitly report why.

## Testing Expectations

- After refactoring or modifying code, always do regression validation (at least run `flutter test` when feasible).
- For changed logic, add or update targeted tests for that area whenever reasonably possible, not only rely on existing tests.
- If a targeted test cannot be added (environment/framework limits or high setup cost), explicitly document why in the handoff.

## Architecture Boundaries

- Treat `lib/repository/` as data-access implementation detail.
- Pages/widgets must not import `package:melo_trip/repository/...` directly.
- Prefer reading a provider from `lib/provider/...` instead of depending on a concrete repository class in UI/service code.
- Repository implementation classes may remain public for Dart/library limitations, but should be consumed through provider boundaries unless there is a strong reason not to.
