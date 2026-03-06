## 0.0.5

* Refactored `DesktopLyrics` to default to a shared singleton instance.
* Prevented state split between `apply` and `render` when called from different app layers.
* Added singleton lifecycle tests (`same instance`, `dispose -> recreate`, `shared state across references`).

## 0.0.4

* Changed default visibility to disabled (`enabled: false`) to avoid showing overlay during app startup.
* Aligned Windows/Linux native default `enabled` behavior with Dart-side default.
* Updated README usage notes for explicit enable flow.
* Added tests for default disabled state and adjusted toggle tests.

## 0.0.3

* Added GitHub Actions tag-based publish workflow for pub.dev.
* Added public API dartdoc comments to improve pub.dev documentation score.
* Updated README with Trusted Publisher + tag release instructions.

## 0.0.1

* Initial desktop floating lyrics implementation (Windows/Linux).
* Added public Dart API:
  * `DesktopLyricsFrame`
  * `DesktopLyricsConfig`
  * `DesktopLyrics.apply`
  * `DesktopLyrics.state` (read-only, single state entry)
  * `DesktopLyrics.render`
  * `DesktopLyrics.dispose`
* Added desktop overlay behavior:
  * top-most transparent layered window
  * click-through toggle
  * drag and double-click reset position
  * text/shadow/stroke style controls
