## 0.0.1

* Initial Windows desktop floating lyrics implementation.
* Added public Dart API:
  * `DesktopLyricsLine`
  * `DesktopLyricsConfig`
  * `DesktopLyrics.show/hide/dispose`
  * `DesktopLyrics.updateTrack/updateProgress/updateConfig`
* Added Windows overlay behavior:
  * top-most transparent layered window
  * click-through toggle
  * drag and double-click reset position
  * text/shadow/stroke style controls
