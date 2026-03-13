import AppKit

protocol DesktopLyricsOverlayControlling: AnyObject {
  func show()
  func hide()
  func dispose()
  func updateLyricFrame(_ currentLine: String, lineProgress: Double)
  func updateConfig(_ config: DesktopLyricsOverlayConfig)
}

struct DesktopLyricsOverlayConfig: Equatable {
  var enabled = true
  var clickThrough = false
  var fontSize = 38.0
  var opacity = 0.96
  var textArgb: UInt32 = 0xFFF6F7FF
  var shadowArgb: UInt32 = 0x00000000
  var strokeArgb: UInt32 = 0x00000000
  var strokeWidth = 0.0
  var backgroundArgb: UInt32 = 0x7A220A35
  var backgroundRadius = 22.0
  var backgroundPadding = 12.0
  var textGradientEnabled = true
  var textGradientStartArgb: UInt32 = 0xFFFFD36E
  var textGradientEndArgb: UInt32 = 0xFFFF4D8D
  var textGradientAngle = 0.0
  var overlayWidth = 980.0
  var overlayHeight = -1.0
  var fontFamily = "Segoe UI"
  var textAlign = 1
  var fontWeightValue = 400

  init(arguments: [String: Any]? = nil) {
    guard let arguments else { return }
    enabled = Self.readBool(arguments["enabled"], fallback: enabled)
    clickThrough = Self.readBool(arguments["clickThrough"], fallback: clickThrough)
    fontSize = Self.clamp(Self.readDouble(arguments["fontSize"], fallback: fontSize), min: 20.0, max: 72.0)
    opacity = Self.clamp(Self.readDouble(arguments["opacity"], fallback: opacity), min: 0.0, max: 1.0)
    textArgb = Self.readUInt32(arguments["textColorArgb"], fallback: textArgb)
    shadowArgb = Self.readUInt32(arguments["shadowColorArgb"], fallback: shadowArgb)
    strokeArgb = Self.readUInt32(arguments["strokeColorArgb"], fallback: strokeArgb)
    strokeWidth = Self.clamp(Self.readDouble(arguments["strokeWidth"], fallback: strokeWidth), min: 0.0, max: 6.0)
    backgroundArgb = Self.readUInt32(arguments["backgroundColorArgb"], fallback: backgroundArgb)
    backgroundRadius = Self.clamp(Self.readDouble(arguments["backgroundRadius"], fallback: backgroundRadius), min: 0.0, max: 48.0)
    backgroundPadding = Self.clamp(Self.readDouble(arguments["backgroundPadding"], fallback: backgroundPadding), min: 0.0, max: 36.0)
    textGradientEnabled = Self.readBool(arguments["textGradientEnabled"], fallback: textGradientEnabled)
    textGradientStartArgb = Self.readUInt32(arguments["textGradientStartArgb"], fallback: textGradientStartArgb)
    textGradientEndArgb = Self.readUInt32(arguments["textGradientEndArgb"], fallback: textGradientEndArgb)
    textGradientAngle = Self.readDouble(arguments["textGradientAngle"], fallback: textGradientAngle)
    overlayWidth = Self.clamp(Self.readDouble(arguments["overlayWidth"], fallback: overlayWidth), min: 480.0, max: 2600.0)
    overlayHeight = Self.readDouble(arguments["overlayHeight"], fallback: overlayHeight)
    if overlayHeight > 0 {
      overlayHeight = Self.clamp(overlayHeight, min: 90.0, max: 800.0)
    }
    let family = (arguments["fontFamily"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    fontFamily = (family?.isEmpty == false) ? family! : fontFamily
    textAlign = Int(Self.clamp(Double(Self.readInt(arguments["textAlign"], fallback: textAlign)), min: 0.0, max: 2.0))
    fontWeightValue = Int(Self.clamp(Double(Self.readInt(arguments["fontWeightValue"], fallback: fontWeightValue)), min: 100.0, max: 900.0))
  }

  static func argbColor(_ argb: UInt32) -> NSColor {
    let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
    let red = CGFloat((argb >> 16) & 0xFF) / 255.0
    let green = CGFloat((argb >> 8) & 0xFF) / 255.0
    let blue = CGFloat(argb & 0xFF) / 255.0
    return NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
  }

  private static func clamp(_ value: Double, min: Double, max: Double) -> Double {
    Swift.max(min, Swift.min(max, value))
  }

  private static func readBool(_ value: Any?, fallback: Bool) -> Bool {
    switch value {
    case let value as Bool:
      return value
    case let value as NSNumber:
      return value.boolValue
    default:
      return fallback
    }
  }

  private static func readDouble(_ value: Any?, fallback: Double) -> Double {
    switch value {
    case let value as Double:
      return value
    case let value as NSNumber:
      return value.doubleValue
    default:
      return fallback
    }
  }

  private static func readInt(_ value: Any?, fallback: Int) -> Int {
    switch value {
    case let value as Int:
      return value
    case let value as NSNumber:
      return value.intValue
    default:
      return fallback
    }
  }

  private static func readUInt32(_ value: Any?, fallback: UInt32) -> UInt32 {
    switch value {
    case let value as UInt32:
      return value
    case let value as Int:
      return UInt32(bitPattern: Int32(truncatingIfNeeded: value))
    case let value as Int64:
      return UInt32(truncatingIfNeeded: value)
    case let value as NSNumber:
      return UInt32(truncatingIfNeeded: value.uint64Value)
    default:
      return fallback
    }
  }
}

struct DesktopLyricsFramePayload: Equatable {
  let currentLine: String
  let lineProgress: Double

  init(arguments: [String: Any]? = nil) {
    let currentLine = (arguments?["currentLine"] as? String) ?? ""
    let rawProgress: Double
    switch arguments?["lineProgress"] {
    case let value as Double:
      rawProgress = value
    case let value as NSNumber:
      rawProgress = value.doubleValue
    default:
      rawProgress = 1.0
    }
    self.currentLine = currentLine
    if rawProgress.isFinite {
      self.lineProgress = Swift.max(0.0, Swift.min(1.0, rawProgress))
    } else {
      self.lineProgress = 1.0
    }
  }
}
