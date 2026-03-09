import Foundation

enum DesktopLyricsMethodResponse {
  case success(Any?)
  case notImplemented
}

final class DesktopLyricsMethodHandler {
  private let overlay: DesktopLyricsOverlayControlling

  init(overlay: DesktopLyricsOverlayControlling) {
    self.overlay = overlay
  }

  func handle(method: String, arguments: Any?) -> DesktopLyricsMethodResponse {
    let map = arguments as? [String: Any]
    switch method {
    case "show":
      overlay.show()
      return .success(nil)
    case "hide":
      overlay.hide()
      return .success(nil)
    case "dispose":
      overlay.dispose()
      return .success(nil)
    case "updateLyricFrame":
      let payload = DesktopLyricsFramePayload(arguments: map)
      overlay.updateLyricFrame(payload.currentLine, lineProgress: payload.lineProgress)
      return .success(nil)
    case "updateConfig":
      overlay.updateConfig(DesktopLyricsOverlayConfig(arguments: map))
      return .success(nil)
    case "getPlatformVersion":
      return .success("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      return .notImplemented
    }
  }
}
