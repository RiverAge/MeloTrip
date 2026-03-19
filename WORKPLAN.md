# Network Governance Workplan

Last updated: 2026-03-19

## Now

- [ ] Unify album failure semantics end-to-end
  - Status: `albumListProvider` now returns `Result<List<AlbumEntity>, AppFailure>` and read surfaces are disambiguated; paginated album flow still maps Result errors into thrown exceptions for snapshot compatibility.
  - Target: decide whether paginated snapshots should carry `AppFailure` directly to remove remaining throw-based translation.

- [x] Eliminate duplicate error handling between global error bus and page-local handling
  - Status: API interceptor now emits global errors only for transport failures (timeout/connection), while business and HTTP response failures are handled in feature context.
  - Validation: `test/api_provider_test.dart` updated for policy and passing.

## Next

- [ ] Add typed transport baseline in API layer
  - Scope: default timeout, retry policy (bounded), and request correlation id.
  - Goal: improve online diagnosis and reduce silent network instability.

- [ ] Align album/playlist/folder provider boundaries to orchestration-only style
  - Scope: keep provider focused on state transitions; keep request assembly/response shaping in repository.

## Later

- [ ] CI guard for naming conventions
  - Enforce: repository `Future<Result<...>>` methods must be `try*`; forbid new `*ResultProvider` primary naming.

- [ ] Evaluate unified user-facing error mapping
  - Scope: centralize failure-to-message conversion strategy per `AppFailureType`.

## Completed

- [x] Repository Result API naming unified to `try*`.
- [x] Added repository guard and naming contract tests.
- [x] Moved lyrics merge flow into repository boundary.
- [x] Removed direct Dio usage from player scrobble runtime via scrobble repository.
- [x] Restricted global API error bus to transport failures only.
