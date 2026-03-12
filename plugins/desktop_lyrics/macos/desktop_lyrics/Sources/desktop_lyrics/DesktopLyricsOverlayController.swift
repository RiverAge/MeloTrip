import AppKit

final class DesktopLyricsOverlayController: NSObject, DesktopLyricsOverlayControlling {
  private static let defaultHeight = 160.0
  private static let bottomMargin = 120.0

  private lazy var panel: NSPanel = {
    let panel = NSPanel(
      contentRect: NSRect(x: 0, y: 0, width: config.overlayWidth, height: Self.defaultHeight),
      styleMask: [.borderless, .nonactivatingPanel],
      backing: .buffered,
      defer: false
    )
    panel.level = .statusBar
    panel.isReleasedWhenClosed = false
    panel.backgroundColor = .clear
    panel.isOpaque = false
    panel.hasShadow = false
    panel.hidesOnDeactivate = false
    panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]
    panel.ignoresMouseEvents = config.clickThrough
    panel.contentView = overlayView
    return panel
  }()

  private let overlayView = DesktopLyricsOverlayView(frame: NSRect(x: 0, y: 0, width: 980, height: 160))
  private var config = DesktopLyricsOverlayConfig()
  private var currentLine = ""
  private var lineProgress = 1.0
  private var hasCustomPosition = false

  override init() {
    super.init()
    overlayView.onBeginDrag = { [weak self] in
      self?.hasCustomPosition = true
    }
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(recenterOverlay),
      name: .desktopLyricsRecentreOverlay,
      object: nil
    )
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func show() {
    guard config.enabled, !currentLine.isEmpty else { return }
    ensureSized()
    if !panel.isVisible {
      panel.orderFrontRegardless()
    }
    panel.alphaValue = 1.0
    positionNearBottomCenter(force: false)
    overlayView.needsDisplay = true
  }

  func hide() {
    panel.orderOut(nil)
  }

  func dispose() {
    hide()
    panel.close()
  }

  func updateLyricFrame(_ currentLine: String, lineProgress: Double) {
    self.currentLine = currentLine
    self.lineProgress = max(0.0, min(1.0, lineProgress))
    overlayView.currentLine = currentLine
    overlayView.lineProgress = self.lineProgress
    if currentLine.isEmpty {
      hide()
      return
    }
    if config.enabled {
      show()
    }
  }

  func updateConfig(_ config: DesktopLyricsOverlayConfig) {
    self.config = config
    overlayView.config = config
    panel.ignoresMouseEvents = config.clickThrough
    panel.alphaValue = 1.0
    ensureSized()
    if !config.enabled || currentLine.isEmpty {
      hide()
      return
    }
    show()
  }

  @objc
  private func recenterOverlay() {
    hasCustomPosition = false
    positionNearBottomCenter(force: true)
  }

  private func ensureSized() {
    let width = config.overlayWidth
    let height = config.overlayHeight > 0 ? config.overlayHeight : computeAutoOverlayHeight(width: width)
    overlayView.frame = NSRect(x: 0, y: 0, width: width, height: height)
    panel.setContentSize(NSSize(width: width, height: height))
    positionNearBottomCenter(force: false)
  }

  private func computeAutoOverlayHeight(width: Double) -> Double {
    let font = resolvedFont()
    let line = currentLine.isEmpty ? "Ag" : currentLine
    let textWidth = max(width - 48.0, 120.0)
    let rect = NSString(string: line).boundingRect(
      with: NSSize(width: textWidth, height: 2000),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      attributes: [.font: font]
    )
    let contentHeight = rect.height + 20.0 + config.backgroundPadding * 2.0 + max(0.0, config.strokeWidth) * 2.0 + 4.0
    return max(90.0, min(800.0, ceil(contentHeight)))
  }

  private func resolvedFont() -> NSFont {
    if let custom = NSFont(name: config.fontFamily, size: CGFloat(config.fontSize)) {
      return custom
    }
    return NSFont.systemFont(ofSize: CGFloat(config.fontSize))
  }

  private func positionNearBottomCenter(force: Bool) {
    guard force || !hasCustomPosition else { return }
    let targetScreen = panel.screen ?? NSScreen.main ?? NSScreen.screens.first
    guard let targetScreen else { return }
    let visibleFrame = targetScreen.visibleFrame
    let size = panel.frame.size
    let origin = NSPoint(
      x: visibleFrame.midX - size.width * 0.5,
      y: visibleFrame.minY + Self.bottomMargin
    )
    panel.setFrameOrigin(origin)
  }
}
