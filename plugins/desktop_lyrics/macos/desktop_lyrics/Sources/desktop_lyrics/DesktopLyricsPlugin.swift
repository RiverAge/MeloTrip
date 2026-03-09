import Cocoa
import FlutterMacOS

public final class DesktopLyricsPlugin: NSObject, FlutterPlugin {
  private let handler: DesktopLyricsMethodHandler

  public override init() {
    handler = DesktopLyricsMethodHandler(overlay: DesktopLyricsOverlayController())
    super.init()
  }

  init(handler: DesktopLyricsMethodHandler) {
    self.handler = handler
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "desktop_lyrics", binaryMessenger: registrar.messenger)
    let instance = DesktopLyricsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch handler.handle(method: call.method, arguments: call.arguments) {
    case let .success(value):
      result(value)
    case .notImplemented:
      result(FlutterMethodNotImplemented)
    }
  }
}
