# Quality Milestones

Status date: 2026-02-26

This document tracks product-quality risks, defects, and improvement work in MeloTrip.

## M0 - Critical Security And Reliability

Scope: Must-fix before broad distribution.

1. Remove hard-coded default credentials and host from login.
2. Move sensitive credentials out of SQLite (token, salt, AI API key).
3. Add startup error handling to avoid splash lock and blank screens.
4. Restrict local cache proxy exposure to localhost or require auth.

## M1 - Network And Data Safety

Scope: Reduce outage impact and improve data integrity.

1. Add global network timeouts and retry strategy for Dio.
2. Standardize API usage so all network calls go through the shared Dio client.
3. Harden error handling when response data is not JSON.
4. Add DB migration strategy with versioned upgrades.

## M2 - Storage And Cache Hygiene

Scope: Control growth and enable recovery.

1. Add cache size cap and eviction policy.
2. Ensure HttpClient instances are closed after proxying.
3. Add user-facing cache cleanup action or schedule.

## M3 - UX And Quality Baseline

Scope: Reduce paper cuts and increase confidence.

1. Fix login page hint text for username.
2. Store search history as structured data instead of comma-joined string.
3. Stop hand-editing l10n generated files; only edit `.arb`.
4. Add tests for auth, search, and play-queue flows.

## M4 - Desktop Platform Enhancements

Scope: Improve desktop-native experience and parity.

1. Add Windows desktop lyrics overlay (always-on-top, transparent window, optional click-through).
2. Sync desktop lyrics with current playback progress and structured lyrics timing.
3. Add settings toggles for desktop lyrics visibility, lock position, and font/opacity.

## Notes

1. The `smart_suggestion` feature was removed but the placeholder UI remains.
2. Existing user databases may still contain the old `smart_suggestion` table.
3. AI chat feature has been removed (code and UI).
4. AI-related localization keys have been removed from ARB source files.
5. `media_kit` upstream issue tracking:
   - Symptom: after `play -> pause -> jump(n)`, playback may auto-resume and briefly blip previous track.
   - Decision (2026-03-02): do not add local workaround for now.
   - Follow-up trigger: re-test immediately when a new `media_kit` version lands and update status.
