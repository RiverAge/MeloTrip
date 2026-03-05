## 0.0.2

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
