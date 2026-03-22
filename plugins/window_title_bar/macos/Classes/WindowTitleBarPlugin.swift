import Cocoa
import FlutterMacOS

public class WindowTitleBarPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "melo_trip/window_title_bar",
      binaryMessenger: registrar.messenger
    )
    let instance = WindowTitleBarPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let window = NSApp.mainWindow ?? NSApp.keyWindow else {
      result(FlutterError(code: "window_unavailable", message: nil, details: nil))
      return
    }

    switch call.method {
    case "apply":
      let args = call.arguments as? [String: Any]
      let enabled = args?["enabled"] as? Bool ?? false
      configureCustomTitleBar(window: window, enabled: enabled)
      result(true)
    case "minimize":
      window.miniaturize(nil)
      result(nil)
    case "toggleMaximize":
      window.zoom(nil)
      result(nil)
    case "isMaximized":
      result(window.isZoomed)
    case "close":
      window.performClose(nil)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func configureCustomTitleBar(window: NSWindow, enabled: Bool) {
    if enabled {
      window.styleMask.insert(.fullSizeContentView)
      window.titlebarAppearsTransparent = true
      window.titleVisibility = .hidden
      window.isMovableByWindowBackground = false
    } else {
      window.styleMask.remove(.fullSizeContentView)
      window.titlebarAppearsTransparent = false
      window.titleVisibility = .visible
      window.isMovableByWindowBackground = false
    }
  }
}
