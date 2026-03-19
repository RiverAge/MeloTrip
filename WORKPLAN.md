# Network Governance Workplan

Last updated: 2026-03-19

## Now

- [x] Unify album failure semantics end-to-end
  - Status: `albumListProvider` returns `Result<List<AlbumEntity>, AppFailure>` and paginated album flow now consumes repository `Result` directly without throw-based translation.
  - Validation: `albums_test` includes a Result.err pagination case and full test suite is green.

- [x] Eliminate duplicate error handling between global error bus and page-local handling
  - Status: API interceptor now emits global errors only for transport failures (timeout/connection), while business and HTTP response failures are handled in feature context.
  - Validation: `test/api_provider_test.dart` updated for policy and passing.

## Next

- [x] Add typed transport baseline in API layer
  - Status: API now has default timeout, one-shot bounded retry for transport failures on GET, and request correlation id header injection.
  - Validation: `api_provider_test` covers timeout setup, correlation-id injection, and retry behavior.

- [x] Align album/playlist/folder provider boundaries to orchestration-only style
  - Scope: keep provider focused on state transitions; keep request assembly/response shaping in repository.
  - Status: playlist list and playlist detail boundaries now return typed entities from repository, with provider focused on orchestration and refresh behavior.

## Later

- [x] CI guard for naming conventions
  - Status: contract tests now enforce repository `Future<Result<...>>` methods use `try*`, and non-generated provider sources forbid `*ResultProvider` naming.

- [x] Evaluate unified user-facing error mapping
  - Scope: centralize failure-to-message conversion strategy per `AppFailureType`.
  - Progress: global snackbar now maps `AppFailureType` to localized user-facing messages, and a contract test prevents rendering raw error payload text directly in app-level listener.
  - Progress: `AsyncValueBuilder` now maps `Result.err(AppFailure)` and `AsyncError(AppFailure)` to unified localized copy, reducing page-level ad-hoc `NoData` fallback on failures.
  - Progress: removed redundant `result.isErr` branches in pages already using `AsyncValueBuilder`, so error rendering path stays centralized.
  - Validation: app-global and widget-level mapping now share `resolveAppFailureMessage(...)`, guarded by `test/error_mapping_unified_contract_test.dart`.

## Completed

- [x] Repository Result API naming unified to `try*`.
- [x] Added repository guard and naming contract tests.
- [x] Added repository parsing contract test to block hand-written Subsonic map path parsing in repositories.
- [x] Added provider boundary contract test to prevent direct Subsonic endpoint literals (`/rest/`) in provider layer.
- [x] Added page contract test to prevent duplicate `result.isErr` branches inside `AsyncValueBuilder` scopes.
- [x] Moved lyrics merge flow into repository boundary.
- [x] Removed direct Dio usage from player scrobble runtime via scrobble repository.
- [x] Restricted global API error bus to transport failures only.
- [x] Added API timeout/retry/correlation-id transport baseline.
