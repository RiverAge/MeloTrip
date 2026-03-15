# Agent Guidelines for MeloTrip

## Quick Rules

- Use `package:melo_trip/...` imports for all project-internal Dart imports. Do not use relative imports.
- User-facing text must be localized through l10n (`.arb` + `AppLocalizations`). Do not hardcode visible copy in widgets or pages.
- Do not manually edit generated files such as `*.g.dart`, `*.freezed.dart`, or `lib/l10n/app_localizations*.dart`.
- Do not use deprecated `Color.withOpacity()`. Use `withValues(alpha: ...)`.
- UI semantic colors must come from `Theme.of(context).colorScheme` or theme-derived text colors.
- Dart dot shorthand is required in this project when the surrounding type context is clear.
- After code changes, run `flutter analyze` by default. Run `flutter test` when feasible.
- On Windows, Codex must execute native commands directly such as `flutter analyze` or `gh run list`. Do not wrap them in `powershell -Command` or `cmd /c`.
- Pages and widgets must not import `package:melo_trip/repository/...` directly. Go through providers unless there is a strong reason not to.
- Git commit messages must be written in English and follow:
  - `<type>(<platform>): <summary> [agent:<free-text>]`
  - `agent` is required but must remain free-text (do not enforce a fixed allowlist).
  - Example: `fix(desktop): restore logout entry in settings [agent:codex]`

## Code Style

### Flutter Color API

- Do not use deprecated `withOpacity()`.
- Use `withValues(alpha: ...)` instead.

Wrong:
```dart
color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
```

Correct:
```dart
color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
```

### Theme Colors

- UI semantic colors must come from `Theme.of(context).colorScheme` or `textTheme` derived colors.
- Do not hardcode normal UI colors such as `Colors.white`, `Colors.black`, `Colors.white54`, `Colors.redAccent`, or `Color(0x...)`.
- Prefer theme-derived variants with alpha, for example `colorScheme.onSurfaceVariant.withValues(alpha: 0.7)`.
- Allowed exceptions:
  - Brand assets or brand colors explicitly required by product design. Document the exception inline.
  - Non-UI, debug-only, or demo-only code that is not visible to end users.

### Theming and Minimalism (Theme-First)

- **Prioritize Global Theme**: Always use predefined `textTheme` styles. Avoid `copyWith` with hardcoded `fontWeight` or `fontSize`. If a label looks "wrong," try another standard style (e.g., `labelLarge` vs `titleSmall`) before creating a custom one.
- **Hierarchy via Contrast**: Use font weight, scale, and color opacity (e.g., `onSurfaceVariant` with alpha) to distinguish primary/secondary info. Remove explicit dividers, lines, and complex backgrounds.
- **Desktop Focus**: Maintain tight and purposeful spacing (e.g., using `EdgeInsets.fromLTRB` for fine-tuning). Avoid excessive "web-like" whitespace.

### Dart Conventions

- When intentionally ignoring parameters, use `_` wildcard names.
- In the same parameter list, repeated `_` is valid and preferred.
  - Good: `(_, _) { ... }`
  - Avoid: `(_, __) { ... }`
- Dart dot shorthand is required when the surrounding type context is unambiguous.
- Prefer readable, context-appropriate forms for enums and static values, and use dot shorthand by default when the target type is already fixed by context, for example `.min`, `.loop`, or `Uri.parse(url)` as applicable.
- Keep full explicit forms for common cases like `Icons.*` and `Colors.*`.
- Keep full explicit forms only when dot shorthand would make the code less readable or the type context is not obvious.
- Validate with `flutter analyze` after bulk replacements.

### Imports

- Always use `package:melo_trip/...` imports for project-internal files.
- Do not use relative imports such as `import 'file.dart'` or `import '../dir/file.dart'`.
- Examples:
  - Good: `import 'package:melo_trip/pages/shared/initial/initial_page.dart';`
  - Good: `import 'package:melo_trip/provider/auth/auth.dart';`
  - Wrong: `import '../../shared/initial/initial_page.dart';`

### Localization

- User-facing text must be localized through l10n.
- Do not hardcode visible copy in titles, labels, hints, toasts, dialog content, or similar UI.
- Exception: technical or internal-only strings not shown to end users, such as logs, debug keys, and route IDs.

### File Size

- Avoid oversized source files. Split by feature, section, widget, or service.
- Preferred threshold: keep Dart files under 300 lines.
- Hard limit: files above 350 lines must be refactored before merge unless explicitly approved.
- For large UI pages, extract reusable sections into `parts/` with clear ownership.

## Release Rules

### App Update Versioning

- This project uses app update metadata from `pubspec.yaml` `version` in the form `versionName+versionCode`.
- For every releasable change, bump both parts together:
  - `versionName` must increase, for example `1.0.0` -> `1.0.1`
  - `versionCode` must increase monotonically, for example `+1` -> `+2`
- Never reuse or decrease `versionCode`.

### Release Semantics

- Only treat `部署更新` as a formal release request.
- `推送更新` means a normal push only. Do not automatically bump version or create a tag.
- Default formal release flow:
  1. Update app version in `pubspec.yaml`
  2. Commit changes
  3. Create a tag pointing to that release commit
  4. Push branch and tags, preferably with `git push origin --tags`
- If the user does not provide a target version or tag:
  - Bump patch and build by `+1`, for example `1.0.2+3` -> `1.0.3+4`
  - Use the next sequential tag, for example `v0.0.8` -> `v0.0.9`
- If push fails, do not rewrite history and do not delete the local tag or commit. Report the error and keep local state.

## Editing Safety

### Encoding and BOM

- For text files, always read and write as UTF-8 explicitly.
- Do not use `Set-Content -Encoding utf8` for these files because it may introduce BOM or encoding issues.
- If scripting is required in PowerShell, use .NET APIs:
  - Read: `[System.IO.File]::ReadAllText(path, [System.Text.Encoding]::UTF8)`
  - Write UTF-8 without BOM: `[System.IO.File]::WriteAllText(path, text, (New-Object System.Text.UTF8Encoding($false)))`
- If preserving the original BOM is required, detect it from bytes first and write back with the same BOM setting.

### Generated Files

- Never manually edit generated files.
- Examples:
  - `*.g.dart`
  - `*.freezed.dart`
  - `lib/l10n/app_localizations*.dart`
- Update source files and regenerate instead:
  - l10n: `flutter gen-l10n`
  - codegen: `dart run build_runner build --delete-conflicting-outputs`

## Execution Rules

### General Command Execution

- For routine project validation, prefer whole-project commands first:
  - `flutter analyze`
  - `flutter test`
  - `dart analyze`
- Do not prepend temporary environment variables to routine `flutter` or `dart` commands unless explicitly requested or strictly required by the environment.
- Avoid forms such as `$env:DART_SUPPRESS_ANALYTICS='true'; flutter analyze` for normal validation.
- Use file-specific forms only when necessary for focused debugging.
- After completing code changes, run `flutter analyze` by default. If it cannot be run, explicitly report why.

### Codex on Windows Command Form

- This section applies specifically to Codex running on Windows.
- When executing normal CLI tools, always put the native command directly in the command field.
- Do not wrap routine commands with explicit shell executable prefixes such as:
  - `C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -Command`
  - `powershell -Command`
  - `cmd /c`
- This rule applies to normal execution and escalation requests.
- Preferred examples:
  - `flutter analyze`
  - `flutter test`
  - `dart analyze`
  - `gh run list`
  - `gh run view <id> --log`
  - `git status --short`
- Avoid examples:
  - `C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -Command flutter analyze`
  - `powershell -Command flutter test`
  - `cmd /c gh run view 123 --log`
- Only use an explicit shell wrapper if:
  - the user explicitly requests that exact wrapper form, or
  - the native command form has already failed and the wrapper is strictly required by the environment.
- If escalation is needed, escalate the native command itself rather than rewriting it into a shell-wrapped form.
- Do not choose a shell-wrapped form merely to match an already approved prefix rule.

## Codex Workflow

### File Editing

- This section applies specifically to Codex or similar code-editing agents.
- Prefer `apply_patch` for normal text edits.
- Preserve UTF-8 encoding and avoid BOM changes during agent-driven edits.

## Testing Expectations

- After refactoring or modifying code, do regression validation. At minimum, run `flutter test` when feasible.
- For changed logic, add or update targeted tests whenever reasonably possible instead of relying only on existing tests.
- If a targeted test cannot be added due to environment limits, framework limits, or high setup cost, document why in the handoff.

## Architecture

### Repository Boundaries

- Treat `lib/repository/` as a data-access implementation detail.
- Pages and widgets must not import `package:melo_trip/repository/...` directly.
- Prefer reading a provider from `lib/provider/...` instead of depending on a concrete repository class in UI or service code.
- Repository implementation classes may remain public when needed for Dart library boundaries, but they should usually be consumed through provider boundaries.

### Provider and Repository Conventions

- For new stateful providers, prefer `@riverpod` generator-based providers over `StateNotifierProvider`.
- Use plain provider objects for repository injection. Repositories are infrastructure, not UI state.
- If a REST endpoint is used in multiple places, extract fetch and parse logic into `lib/repository/...` instead of duplicating it in pages or providers.
- Single-page or single-use endpoints may remain in provider scope until a second real consumer appears.
- For simple read and write state backed by one upstream source, prefer a single `@riverpod class` with `build()` for reads and explicit instance methods for writes.
- Do not split simple settings flows into multiple controller or reader providers unless the behavior is complex enough to justify the indirection.

### User Configuration Persistence

- User preference and settings data should default to the existing app configuration storage path, for example database-backed `user_config`, instead of ad-hoc JSON files.
- Only introduce a separate settings file when there is a clear product or technical requirement such as import or export, external tooling, or cross-process sharing.
- When a setting is stored as structured JSON inside the main configuration store, keep the runtime config model and the persistence mapping localized to the same owner file or class when feasible.

### Pagination and Error Models

- Shared pagination data structures should live under `lib/model/...`, not inside provider files.
- Prefer neutral model names such as `PaginatedListSnapshot<T>`. Avoid Flutter-confusing names ending with bare `State` for provider value models.
- Do not expose pagination errors as raw `Object?` on shared models.
- Use a typed failure model such as `PaginatedListFailure` that provides a stable user-facing message plus the original cause.

## Platform-Specific

### Windows C++ UI and DPI Awareness

- When implementing or modifying Windows native UI elements such as `MeloTripUpdater.exe` using Direct2D or Win32 API, always ensure correct DPI scaling.
- Watch for the double-scaling DPI bug. If the render target already applies DPI scaling automatically, do not manually apply `ScaleDip` or similar multipliers to text sizes or layout rects.
- In `WM_CREATE`, calculate the window's physical bounds using the real monitor DPI from the start.
- Use `GetDpiForWindow(window)` inside the `WM_CREATE` handler and immediately resize the window using `SetWindowPos` or equivalent instead of relying on a `96` DPI fallback.
- If the physical window shell is not resized while the inner render target scales up correctly, layout truncation can occur, including clipped text.
