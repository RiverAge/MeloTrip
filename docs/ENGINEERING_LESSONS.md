# Engineering Lessons: State, Contracts, and Tests

Status date: 2026-06-30

A collection of engineering lessons distilled from real bugs. Each entry starts
from a concrete incident, abstracts the underlying pattern, and gives detection
and defense guidance. The examples are drawn from a Flutter + Riverpod +
Subsonic-client codebase, but the patterns are framework-agnostic: they apply
to any reactive state system, any layered protocol, and any test suite that
fakes its dependencies.

These are general engineering notes, not project specs.

---

## Lesson 1 — The Read/Write Loop in Reactive State

### The incident

A "For You" recommendation feature was persisted across app restarts. Two
keep-alive state providers were changed from synchronous to asynchronous
`build()` so they could load their initial state from a persisted config on
startup:

```dart
@Riverpod(keepAlive: true)
class ForYouRecommendationRefresh extends _$ForYouRecommendationRefresh {
  @override
  Future<ForYouRecommendationRefreshState> build() async {
    final config = await ref.watch(sessionConfigProvider.future); // ← watch
    return ForYouRecommendationRefreshState(
      excludedSongIds: parseRecommendRefreshState(config?.recommendRefreshState).excludedSongIds,
    );
  }

  void requestRefresh(Iterable<SongEntity> currentSongs) {
    // ... compute excludedIds ...
    state = AsyncData(ForYouRecommendationRefreshState(...));
    unawaited(
      ref.read(userSessionProvider.notifier)
          .setRecommendRefreshState(excludedSongIds: excludedIds), // ← writes session
    );
  }
}
```

Symptom: the "For You" shelf hung in a loading state forever. No exception was
logged. The console was silent.

### The abstract pattern

**A reactive provider subscribes to a piece of state that its own methods
write back to.** This forms a closed loop:

```
build()  --watch-->  S
requestRefresh()  --write-->  S
S changes  --notifies-->  build() reruns  --(side effect)-->  write  --→  ∞
```

The loop is consumed silently by the framework's reconciliation: each rebuild
schedules the next, the framework keeps coalescing, and the UI never settles
into a stable frame with data. Because no rule is *individually* broken —
`watch` is legal, writing state is legal — static analysis and the type system
have nothing to flag.

The root misuse is a category error between two operations that look similar
but have opposite intent:

| Operation | Semantic | Establishes subscription? | Correct use |
|---|---|---|---|
| `watch(p)` | "I depend on p; rebuild me when p changes" | Yes | UI, or a provider that must *react* to p |
| `read(p)` | "Give me p's value right now" | No | One-shot reads, command-style calls |

`watch` was used where `read` was meant. The fix is one token per site
(`watch` → `read`), but the lesson is structural.

### Why it is a discipline violation, not just a typo

There is an implicit rule in any reactive/observer system:

> A unit (provider, component, observer) must not subscribe to a state that
> it — directly or through its downstream — mutates.

This is the observer-pattern equivalent of "don't add a listener to the event
you emit." Reactive frameworks give you `watch`/`read` (or `subscribe`/`get`)
precisely so you can express this distinction. Using `watch` for a one-shot
initial load collapses the distinction and reintroduces the loop the framework
was designed to prevent.

A common rationalization — "I only want the initial value" — is exactly the
case `read` exists for. `watch`'s subscription is a side effect you don't want
when the value is a seed, not a live dependency.

### Detection

- **Code review smell.** Whenever a provider `watch`es a globally-writable
  state (a session config, a settings store, a user object), ask: "Does this
  provider, or anything it calls, write back to that state?" If yes, the
  `watch` is wrong.
- **Grep audit.** List every `watch(<globalWritableState>)` call site. For
  each, trace whether the containing provider's methods (or its downstream
  callees) mutate that state. This is mechanical and worth doing once after
  any feature that persists state into a shared store.
- **Runtime symptom.** "Loading forever, no error" in a reactive UI is a
  strong signal of a rebuild loop. Add a print/log at the top of `build()`;
  if it fires repeatedly without user action, you have a loop.
- **Test gap (see Lesson 3).** Tests with no-op fakes won't catch this.

### Defense

1. **Prefer `read` for seeds.** When a provider loads an initial value it will
   not subsequently react to, use `read`, not `watch`. Reserve `watch` for
   values the provider must re-render on.
2. **Separate read and write surfaces.** The cleanest architecture keeps the
   persisted state in its own provider, separate from the session/settings
   store that many UI widgets watch. That way writing recommendation state
   does not invalidate theme/language/search widgets, and there is no shared
   writable state to accidentally subscribe to.
3. **Document the invariant at the type.** A comment on the global store:
   "Providers that `watch` this must not call `setX` on it." Make the rule a
   local convention, not a private discovery.

---

## Lesson 2 — String-Matched Cross-Layer Contracts

### The incident

A music client identifies "this song has not been analyzed by the
recommendation backend" by matching a substring of an error message:

```dart
if (message.contains('AudioMuse-AI returned status 404')) {
  throw SongNotAnalyzedError(songId, endpoint);
}
```

The string originates three layers away: a plugin wraps a backend's HTTP 404
into `error('AudioMuse-AI returned status 404')`, the server stuffs that
string into `subsonic-response.error.message`, and the client greps for the
literal. The plugin does not distinguish 404 from 500/502 — the only signal is
the digits `404` inside an English sentence.

### The abstract pattern

**A typed contract degrades into a string contract across layer boundaries,
and downstream code pattern-matches the prose.**

Layers: `Backend (HTTP status)` → `Adapter (error string)` → `Server
(envelope)` → `Client (substring match)`.

Each transition is an opportunity to lose structure:
- 404 (typed) → "returned status 404" (string) → lost distinction from 500
- structured error code → free-text message → lost i18n safety
- enum → string → lost exhaustiveness checking

The client's matcher is the symptom, not the disease. The disease is that no
layer along the way committed to a stable, machine-readable contract for this
case, so the client had no choice but to grep the message.

### Why it is fragile

- **Renaming breaks silently.** Change the message wording (e.g.
  "status code 404") and the matcher returns false; the error degrades to a
  generic `unknown` instead of the friendly "song not analyzed" UI. No compile
  error, no test failure (unless the test asserts the exact string).
- **Localization breaks silently.** If the server ever localizes error
  messages, the English substring stops matching.
- **No exhaustiveness.** A new error category cannot be added as a case; it
  falls through to `unknown`.
- **Negative space is invisible.** You cannot tell which error strings the
  client *intends* to handle, so you cannot tell when a refactor leaves an
  orphaned matcher.

### Detection

- **Grep for `.contains(` / `.startsWith(` / regex on error messages.** Each
  one is a candidate for "string contract." Ask whether a typed code exists
  upstream that could be used instead.
- **Review the boundary.** At each layer transition, check: does the inner
  layer expose a stable code/enum, and does the outer layer preserve it? If
  the outer layer only sees a message, the contract has already degraded.
- **Audit error messages that contain numbers.** "status 404", "code 123" —
  these usually mean a typed value was stringified and is being recovered by
  parsing.

### Defense

1. **Carry a code, not a sentence.** If you control any layer, give the error
   a stable numeric/string code (`error.code` field) and match on the code.
   Prose is for humans; codes are for machines.
2. **When you cannot change upstream.** If the upstream is a third party you
   cannot edit, centralize the string matching in *one* adapter near the
   boundary — not scattered in feature code. Document the exact literal being
   matched and where it comes from, so a rename upstream is caught during
   review.
3. **Test the contract, not the prose.** If you must match a string, write a
   test that asserts the full end-to-end path produces the expected typed
   outcome, so a wording change upstream turns the test red rather than the
   UI.

---

## Lesson 3 — The Fake That Swallowed the Side Effect

### The incident

The loop from Lesson 1 shipped green. The test suite for the recommendation
providers passed. Why? Because the test faked the session store with a no-op:

```dart
class _FakeUserSession extends UserSession {
  @override
  Future<void> setRecommendRefreshState({
    List<String>? recentIds,
    List<String>? excludedSongIds,
  }) async {}  // ← does nothing
}
```

In production, `setRecommendRefreshState` updates the session state, which
rebuilds `sessionConfigProvider`, which (with the buggy `watch`) rebuilds the
recommendation provider, which calls `record()`, which calls
`setRecommendRefreshState` again — the loop. In the test, the fake's body was
empty, so the loop's closing edge was cut. The test could not reproduce the
bug because the fake lied about the write semantics.

### The abstract pattern

**A test fake omits a side effect of the real dependency, and the omitted side
effect is exactly what the bug relies on.**

Fakes exist to simplify tests, but "simplify" must mean "irrelevant detail
removed," not "behavior that matters deleted." The dividing line is: does the
code under test *observe* the side effect? If yes, the fake must reproduce it.

Side effects that fakes commonly (and wrongly) drop:
- Writing to a shared store that other providers subscribe to
- Emitting a state change that triggers downstream rebuilds
- Throwing on invalid input
- Ordering guarantees (e.g., "write completes before next read sees it")

### Why it is a testing discipline violation

A fake's contract is "behave like the real thing for the behaviors the code
under test depends on." A no-op `set*` method silently redefines the contract
to "writes have no consequences." Any bug whose mechanism is "a write triggers
a re-entrant read" becomes invisible — the test environment has unilaterally
disarmed it.

This is especially dangerous because the fake *looks* correct: it compiles,
it satisfies the interface, it makes the test fast. The gap only shows under
the exact production wiring the fake replaced.

### Detection

- **Review every fake `set*` / `write*` / `update*` method.** Ask: "In the
  real implementation, does this change state that any subscriber reads?" If
  yes, the fake must update its own state to reflect the write.
- **Compare fake behavior to real behavior.** For each fake, write one test
  that performs a write then a read and asserts the read sees the write. If
  the fake is a no-op, this test fails immediately.
- **Suspect "loading forever" bugs that tests don't reproduce.** When
  production hangs but tests pass, the first hypothesis should be "the test
  fake cut a side effect." Inspect what the real dependency does on write that
  the fake doesn't.

### Defense

1. **Fakes should be behaviorally faithful, not just signature-faithful.** A
   fake store that supports `set` must remember what was set, and a read after
   a write must return the written value. This is the minimum contract.
2. **For shared mutable state, fake the propagation too.** If the real store
   notifies subscribers on write, the fake should update its own state so any
   `watch`/`subscribe` in the code under test fires. Otherwise you are testing
   against a world where writes are invisible — which is not the world that
   ships.
3. **Prefer the real dependency when cheap.** If the real store is an
   in-memory map with no I/O, use it instead of a fake. Fakes earn their cost
   only when the real thing is slow, networked, or persistent. An in-memory
   real store reproduces side effects for free.
4. **Write the failing test first when fixing a loop bug.** Before changing
   `watch` to `read`, write a test with a faithful fake that hangs/fails. Then
   make the fix. This pins the regression so it cannot return.

---

## Lesson 4 — The Overflow That the Test Suite Could Not See

### The incident

A desktop album card's hover overlay had a `Row` of three action buttons
separated by fixed `SizedBox(width: 12)` gaps. At a critical card width of
~146px the row overflowed by **0.269 pixels**. In production this printed one
line to the debug console — `A RenderFlex overflowed by 0.269 pixels on the
right` — and nothing else. The app did not crash, the layout did not visibly
break (a sub-pixel overflow is invisible to the eye), and no test failed.

The bug was found only because someone happened to read the console log. It
had been shipping undetected. When a regression test was finally written for
it, the same test immediately surfaced **three more** overflow bugs on the
mobile home page, the desktop hero, and the desktop artist detail grid — all
of which the existing suite had been silently rendering without complaint.

### The abstract pattern

**`RenderFlex` overflow is reported as a `FlutterError` to the console, not as
a test failure.** The Flutter test framework routes rendering errors through
`FlutterError.onError`, which by default prints them. Unless a test
explicitly captures that channel, the overflow is invisible to the test
result — `tester.takeException()` does not see it, and `pumpAndSettle()` does
not throw.

```
RenderFlex lays out children
  → children exceed constraints
    → FlutterError.reportError(details)   // prints to console
      → test framework: "noted, continuing"   // NOT a failure
```

This means a page can overflow on every frame and every test that renders it
still reports green. The existing suite had ~20 page-level tests; not one of
them asserted against rendering errors, so not one of them could catch a
layout regression. The defense was absent at the framework default, and
absent by convention in the codebase.

The deeper pattern matches Lessons 1–3: a failure mode that the tooling
cannot see. Static analysis does not model layout. The type system does not
know a `Row` will overflow. And the test runner, by default, treats a
`FlutterError` as a log line, not a verdict.

### Why it is a discipline violation, not just a missing test

There is an implicit rule the framework invites you to assume:

> If a widget renders, it rendered correctly.

This is false. A widget can render *and* overflow. The render succeeds; the
layout contract does not. Conflating "rendered without throwing" with
"rendered correctly" is the same category error as Lessons 1–3: the
observable signal (no exception) is taken as proof of a property (correct
layout) that was never actually checked.

Sub-pixel overflows make this worse because they are invisible in manual QA
too. A 0.269px overflow cannot be seen on a screen; it can only be caught by
a test that asserts the absence of the error. So the *only* layer that can
reliably detect this class of bug is the test suite — and only if it opts in.

### Detection

- **Grep the test suite for the guard.** If there is no `FlutterError.onError`
  capture and no `expectNoFlutterErrors()` (or equivalent) in a test that
  renders a page, that test cannot detect overflow. It is a smoke test, not a
  layout test.
- **Treat any `RenderFlex overflowed` line in CI logs as a failure.** If your
  CI captures console output, a single overflow line is a bug report, not
  noise. Most teams filter it away — that filtering is the gap.
- **Audit pages with `Row`/`Column` + fixed `SizedBox` widths + text.** These
  are the overflow high-risk zone: a `Text` with no `maxLines`/`Expanded`, a
  `Row` with fixed gaps, a `SliverGrid` with a `childAspectRatio` tuned only
  for wide windows. The bug lives where a fixed-size child meets an
  unbounded-text child in a constrained parent.

### Defense

1. **Install an overflow guard in widget tests.** A small helper that, in
   `setUp`, replaces `FlutterError.onError` to record every
   `FlutterErrorDetails`, and an `expectNoFlutterErrors()` assertion called at
   the end of each `testWidgets`. This converts the invisible failure into a
   red test. One-time investment, permanent protection.

   ```dart
   void setUpOverflowGuard() {
     setUp(() {
       _recordedErrors = <FlutterErrorDetails>[];
       final previous = FlutterError.onError;
       FlutterError.onError = (details) {
         _recordedErrors.add(details);
         FlutterError.presentError(details); // keep console output
       };
       addTearDown(() => FlutterError.onError = previous);
     });
   }

   void expectNoFlutterErrors() {
     if (_recordedErrors.isEmpty) return;
     final count = _recordedErrors.length;
     final summary = _recordedErrors.map((e) => e.exception).join('\n');
     _recordedErrors = const [];
     fail('Expected no FlutterError during rendering, but got $count:\n$summary');
   }
   ```

2. **Make a page-level overflow test part of the page's definition of done.**
   When you build or modify a page, add a test that pumps it at the smallest
   supported surface size with long-text mock data, and asserts
   `expectNoFlutterErrors()`. This is the page's layout contract: "I do not
   overflow at 320×568 with long content." A future change that breaks it
   turns the test red.

   ```dart
   void main() {
     setUpOverflowGuard();
     testWidgets('renders without overflow on small screen', (tester) async {
       await tester.binding.setSurfaceSize(const Size(320, 568));
       await tester.pumpWidget(... /* long-text mock data */);
       await tester.pumpAndSettle(); // or tester.pump() for infinite animations
       expectNoFlutterErrors();
     });
   }
   ```

   Cover at least two surface sizes (smallest supported + a wide one) and use
   realistically long strings — the bug is in the long-text path, not the
   short-text path. For pages with infinite animations (progress bars,
   shimmer), use `tester.pump()` rather than `pumpAndSettle()`, which times
   out on a never-settling animation.

3. **Prefer flex over fixed sizes in the layout itself.** The guard catches
   the bug; the fix is usually structural: wrap an unbounded `Text` in
   `Expanded` with `maxLines` + `overflow: .ellipsis`; replace fixed
   `SizedBox(width:)` gaps with `Spacer` when the row's total fixed width can
   exceed its parent; tune `SliverGrid` `childAspectRatio` for the narrow
   case, not just the wide one. A layout that cannot overflow by construction
   is better than one that is guarded against overflowing.

The meta-lesson: **a test that renders a page but does not assert against
`FlutterError` is not testing the page's layout — it is testing that the page
can be instantiated.** The layout contract has to be asserted explicitly, or
it does not exist.

---

## Cross-Cutting Theme — Invisible Failures

All four lessons share a shape: **a failure that the tooling cannot see.**

- Lesson 1: a rebuild loop that produces no exception, only a stuck UI.
- Lesson 2: a string rename that produces no compile error, only a degraded
  UX path.
- Lesson 3: a fake that produces no test failure, only a false sense of
  coverage.
- Lesson 4: a layout overflow that produces no test failure, only a console
  line.

In each case, the type system, the linter, and the test suite all reported
green. The bug lived in the *dynamic* contract between components — who writes
what, who subscribes to whom, what prose crosses which boundary, what a
`Row` does when its children don't fit — which static tools do not model.

The defense, therefore, is not "add more types" (though typed codes help
Lesson 2). It is to make the dynamic contract explicit and tested:

- State who may subscribe to whom (Lesson 1).
- State which literal is matched across a boundary (Lesson 2).
- State which side effect a fake must reproduce (Lesson 3).
- State that a page does not overflow, and assert it (Lesson 4).

Write these invariants down as local conventions and as tests that would fail
if the invariant were violated. The goal is to convert an invisible failure
into a visible one — before it ships.
