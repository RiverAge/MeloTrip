# Network Governance Workplan

Last updated: 2026-03-19

## Now

- [ ] Unify album failure semantics end-to-end
  - Status: repository has `tryFetchAlbumListResponse`, but provider boundary still returns raw `List<AlbumEntity>` and paginated flow still relies on thrown exceptions.
  - Target: expose Result-based read path for album list where needed and remove ambiguous "empty means failure" interpretation.

- [ ] Eliminate duplicate error handling between global error bus and page-local handling
  - Status: API interceptor still emits global errors while many pages also handle `Result.isErr` locally.
  - Target: define one display policy (global-only for transport errors, page-local for business context) and apply consistently.

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
