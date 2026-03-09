import Cocoa
import FlutterMacOS
import XCTest
@testable import desktop_lyrics

class RunnerTests: XCTestCase {
  private final class MockOverlay: DesktopLyricsOverlayControlling {
    var didShow = false
    var didHide = false
    var didDispose = false
    var lastFrame: DesktopLyricsFramePayload?
    var lastConfig: DesktopLyricsOverlayConfig?

    func show() {
      didShow = true
    }

    func hide() {
      didHide = true
    }

    func dispose() {
      didDispose = true
    }

    func updateLyricFrame(_ currentLine: String, lineProgress: Double) {
      lastFrame = DesktopLyricsFramePayload(arguments: [
        "currentLine": currentLine,
        "lineProgress": lineProgress
      ])
    }

    func updateConfig(_ config: DesktopLyricsOverlayConfig) {
      lastConfig = config
    }
  }

  func testUpdateConfigParsesAndClampsPayload() {
    let overlay = MockOverlay()
    let handler = DesktopLyricsMethodHandler(overlay: overlay)

    let response = handler.handle(method: "updateConfig", arguments: [
      "enabled": false,
      "clickThrough": true,
      "fontSize": 120.0,
      "opacity": 0.1,
      "textColorArgb": UInt64(0xFF123456),
      "overlayWidth": 320.0,
      "overlayHeight": 1200.0,
      "textAlign": 9,
      "fontWeightValue": 950,
      "fontFamily": "PingFang SC"
    ])

    guard case .success = response else {
      XCTFail("Expected success response")
      return
    }
    XCTAssertEqual(overlay.lastConfig?.enabled, false)
    XCTAssertEqual(overlay.lastConfig?.clickThrough, true)
    XCTAssertEqual(overlay.lastConfig?.fontSize, 72.0)
    XCTAssertEqual(overlay.lastConfig?.opacity, 0.25)
    XCTAssertEqual(overlay.lastConfig?.textArgb, 0xFF123456)
    XCTAssertEqual(overlay.lastConfig?.overlayWidth, 480.0)
    XCTAssertEqual(overlay.lastConfig?.overlayHeight, 800.0)
    XCTAssertEqual(overlay.lastConfig?.textAlign, 2)
    XCTAssertEqual(overlay.lastConfig?.fontWeightValue, 900)
    XCTAssertEqual(overlay.lastConfig?.fontFamily, "PingFang SC")
  }

  func testUpdateLyricFrameClampsProgress() {
    let overlay = MockOverlay()
    let handler = DesktopLyricsMethodHandler(overlay: overlay)

    let response = handler.handle(method: "updateLyricFrame", arguments: [
      "currentLine": "hello",
      "lineProgress": 5.0
    ])

    guard case .success = response else {
      XCTFail("Expected success response")
      return
    }
    XCTAssertEqual(overlay.lastFrame?.currentLine, "hello")
    XCTAssertEqual(overlay.lastFrame?.lineProgress, 1.0)
  }

  func testShowHideAndDisposeDispatchToOverlay() {
    let overlay = MockOverlay()
    let handler = DesktopLyricsMethodHandler(overlay: overlay)

    _ = handler.handle(method: "show", arguments: nil)
    _ = handler.handle(method: "hide", arguments: nil)
    _ = handler.handle(method: "dispose", arguments: nil)

    XCTAssertTrue(overlay.didShow)
    XCTAssertTrue(overlay.didHide)
    XCTAssertTrue(overlay.didDispose)
  }

  func testGetPlatformVersionReturnsMacPrefix() {
    let overlay = MockOverlay()
    let handler = DesktopLyricsMethodHandler(overlay: overlay)

    let response = handler.handle(method: "getPlatformVersion", arguments: nil)
    guard case let .success(value) = response else {
      XCTFail("Expected success response")
      return
    }
    let version = value as? String
    XCTAssertTrue(version?.hasPrefix("macOS ") == true)
  }
}
