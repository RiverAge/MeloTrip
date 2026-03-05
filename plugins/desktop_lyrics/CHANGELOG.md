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
