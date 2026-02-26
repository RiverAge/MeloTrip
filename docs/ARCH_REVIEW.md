# Architecture Review Notes

Status date: 2026-02-26

This document records architecture-level findings and improvement ideas for MeloTrip.

## Summary

The app works, but core responsibilities are blurred between UI, state, and data layers.
Networking, storage, and lifecycle concerns are handled in multiple places without a unified
abstraction, which increases maintenance cost and risk over time.

## Key Issues And Improvement Areas

1. Layer boundaries are unclear (UI, domain, data mixed).
2. Network access is not centralized (some pages create their own Dio).
3. Database schema has no migration strategy.
4. Cache proxy server lifecycle is tightly coupled to app startup.
5. Sensitive credentials are stored in SQLite rather than secure storage.
6. Providers contain both state and workflow logic, making testing harder.
7. Common behaviors (errors, loading, cancellation) are duplicated instead of shared.
8. Observability is weak (no unified error reporting/logging).
9. Test coverage is minimal.

## Suggested Directions

1. Introduce a clear layered architecture (Presentation / Domain / Data).
2. Create a shared ApiClient wrapper for Dio with timeouts, retries, and error mapping.
3. Implement DB migrations with versioned upgrades.
4. Extract cache proxy into a controllable service with lifecycle management.
5. Move secrets to secure storage; keep only non-sensitive config in DB.
6. Move workflow logic into use cases/services; keep providers focused on state.
7. Standardize error and loading handling across screens.
8. Add logging and error reporting hooks.
9. Add tests for auth, search, and play-queue at minimum.

## Updates

1. AI chat feature removed (code, pages, providers, and repositories deleted).
2. AI-related localization keys have been removed from ARB source files.
