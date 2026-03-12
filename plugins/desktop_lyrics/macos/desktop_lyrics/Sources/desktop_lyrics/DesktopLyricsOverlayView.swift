import AppKit
import CoreText

final class DesktopLyricsOverlayView: NSView {
  var onBeginDrag: (() -> Void)?

  var currentLine = "" {
    didSet { needsDisplay = true }
  }

  var lineProgress = 1.0 {
    didSet { needsDisplay = true }
  }

  var config = DesktopLyricsOverlayConfig() {
    didSet { needsDisplay = true }
  }

  override var isOpaque: Bool { false }

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    guard !currentLine.isEmpty else { return }
    guard let context = NSGraphicsContext.current?.cgContext else { return }

    context.clear(bounds)
    drawBackground(in: context, rect: bounds)

    let textRect = bounds.insetBy(dx: 24.0, dy: 10.0)
    let textPath = buildTextPath(in: textRect)
    guard !textPath.isEmpty else { return }

    if DesktopLyricsOverlayConfig.argbColor(config.shadowArgb).alphaComponent > 0 {
      context.saveGState()
      context.translateBy(x: 2.5, y: -2.5)
      context.addPath(textPath)
      context.setFillColor(DesktopLyricsOverlayConfig.argbColor(config.shadowArgb).cgColor)
      context.fillPath()
      context.restoreGState()
    }

    if config.strokeWidth > 0, DesktopLyricsOverlayConfig.argbColor(config.strokeArgb).alphaComponent > 0 {
      context.saveGState()
      context.addPath(textPath)
      context.setStrokeColor(DesktopLyricsOverlayConfig.argbColor(config.strokeArgb).cgColor)
      context.setLineWidth(CGFloat(config.strokeWidth) * 2.0)
      context.setLineJoin(.round)
      context.strokePath()
      context.restoreGState()
    }

    context.saveGState()
    context.addPath(textPath)
    context.clip()
    if config.textGradientEnabled {
      drawGradientText(in: context, rect: textRect)
    } else {
      context.setFillColor(DesktopLyricsOverlayConfig.argbColor(config.textArgb).cgColor)
      context.fill(textRect)
    }
    context.restoreGState()

    if lineProgress < 0.999 {
      let dimmed = DesktopLyricsOverlayConfig.argbColor(config.textGradientEnabled ? config.textGradientStartArgb : config.textArgb).withAlphaComponent(0.52)
      context.saveGState()
      context.addPath(textPath)
      context.clip()
      let dimRect = CGRect(
        x: textRect.minX + textRect.width * CGFloat(lineProgress),
        y: textRect.minY,
        width: textRect.width * CGFloat(1.0 - lineProgress),
        height: textRect.height
      )
      context.setFillColor(dimmed.cgColor)
      context.fill(dimRect)
      context.restoreGState()
    }
  }

  override func mouseDown(with event: NSEvent) {
    guard !config.clickThrough else { return }
    if event.clickCount >= 2 {
      NotificationCenter.default.post(name: .desktopLyricsRecentreOverlay, object: nil)
      return
    }
    onBeginDrag?()
    window?.performDrag(with: event)
  }

  private func drawBackground(in context: CGContext, rect: CGRect) {
    let baseColor = DesktopLyricsOverlayConfig.argbColor(config.backgroundArgb)
    let color = baseColor.withAlphaComponent(baseColor.alphaComponent * CGFloat(config.opacity))
    guard color.alphaComponent > 0.001 else { return }
    let inset = CGFloat(config.backgroundPadding)
    let backgroundRect = rect.insetBy(dx: inset, dy: inset)
    let path = NSBezierPath(roundedRect: backgroundRect, xRadius: CGFloat(config.backgroundRadius), yRadius: CGFloat(config.backgroundRadius))
    context.addPath(path.cgPath)
    context.setFillColor(color.cgColor)
    context.fillPath()
  }

  private func drawGradientText(in context: CGContext, rect: CGRect) {
    let startColor = DesktopLyricsOverlayConfig.argbColor(config.textGradientStartArgb).cgColor
    let endColor = DesktopLyricsOverlayConfig.argbColor(config.textGradientEndArgb).cgColor
    guard let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB), colors: [startColor, endColor] as CFArray, locations: [0.0, 1.0]) else {
      context.setFillColor(startColor)
      context.fill(rect)
      return
    }
    let radians = CGFloat(config.textGradientAngle) * .pi / 180.0
    let radius = max(rect.width, rect.height)
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let start = CGPoint(x: center.x - cos(radians) * radius, y: center.y - sin(radians) * radius)
    let end = CGPoint(x: center.x + cos(radians) * radius, y: center.y + sin(radians) * radius)
    context.drawLinearGradient(gradient, start: start, end: end, options: [])
  }

  private func buildTextPath(in rect: CGRect) -> CGPath {
    let font = resolvedFont()
    let attributes: [NSAttributedString.Key: Any] = [
      .font: font
    ]
    let attributed = NSAttributedString(string: currentLine, attributes: attributes)
    let line = CTLineCreateWithAttributedString(attributed)

    var ascent: CGFloat = 0
    var descent: CGFloat = 0
    var leading: CGFloat = 0
    let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading))
    let flush: CGFloat
    switch config.textAlign {
    case 1:
      flush = 0.5
    case 2:
      flush = 1.0
    default:
      flush = 0.0
    }
    let penOffset = CGFloat(CTLineGetPenOffsetForFlush(line, Double(flush), Double(rect.width)))
    let baselineX = rect.minX + penOffset
    let baselineY = rect.midY - ((ascent - descent) * 0.5)

    let path = CGMutablePath()
    let runs = CTLineGetGlyphRuns(line) as NSArray
    for case let run as CTRun in runs {
      let runAttributes = CTRunGetAttributes(run) as NSDictionary
      let ctFont = runAttributes[kCTFontAttributeName] as! CTFont

      let glyphCount = CTRunGetGlyphCount(run)
      var glyphs = Array(repeating: CGGlyph(), count: glyphCount)
      var positions = Array(repeating: CGPoint.zero, count: glyphCount)
      CTRunGetGlyphs(run, CFRange(location: 0, length: glyphCount), &glyphs)
      CTRunGetPositions(run, CFRange(location: 0, length: glyphCount), &positions)

      for index in 0..<glyphCount {
        guard let glyphPath = CTFontCreatePathForGlyph(ctFont, glyphs[index], nil) else {
          continue
        }
        var transform = CGAffineTransform(
          translationX: baselineX + positions[index].x,
          y: baselineY + positions[index].y
        )
        path.addPath(glyphPath, transform: transform)
      }
    }

    if width <= 0 {
      return CGMutablePath()
    }
    return path
  }

  private func resolvedFont() -> NSFont {
    let fontWeight = normalizedWeight(config.fontWeightValue)
    if let custom = NSFont(name: config.fontFamily, size: CGFloat(config.fontSize)) {
      let traits = NSFontTraitMask(fontWeightValue: config.fontWeightValue)
      return NSFontManager.shared.convert(custom, toHaveTrait: traits) ?? custom
    }
    return NSFont.systemFont(ofSize: CGFloat(config.fontSize), weight: fontWeight)
  }

  private func normalizedWeight(_ value: Int) -> NSFont.Weight {
    switch value {
    case ..<250:
      return .ultraLight
    case ..<350:
      return .light
    case ..<450:
      return .regular
    case ..<550:
      return .medium
    case ..<650:
      return .semibold
    case ..<750:
      return .bold
    case ..<850:
      return .heavy
    default:
      return .black
    }
  }
}

private extension NSFontTraitMask {
  init(fontWeightValue: Int) {
    switch fontWeightValue {
    case 600...:
      self = .boldFontMask
    default:
      self = []
    }
  }
}

private extension NSBezierPath {
  var cgPath: CGPath {
    let path = CGMutablePath()
    var points = [NSPoint](repeating: .zero, count: 3)
    for index in 0..<elementCount {
      switch element(at: index, associatedPoints: &points) {
      case .moveTo:
        path.move(to: points[0])
      case .lineTo:
        path.addLine(to: points[0])
      case .curveTo:
        path.addCurve(to: points[2], control1: points[0], control2: points[1])
      case .closePath:
        path.closeSubpath()
      @unknown default:
        break
      }
    }
    return path
  }
}

extension Notification.Name {
  static let desktopLyricsRecentreOverlay = Notification.Name("desktopLyricsRecentreOverlay")
}
