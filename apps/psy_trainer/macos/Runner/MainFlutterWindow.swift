import Cocoa
import FlutterMacOS

/// Default window geometry for the desktop build (see docs/ARCHITECTURE.md, "Platforms").
/// Keyboard-native activities are laid out for a landscape desktop viewport, so the window
/// opens at a comfortable size and cannot be shrunk below the size the exam screens are
/// designed for.
private let defaultWindowSize = NSSize(width: 1280, height: 800)
private let minimumWindowSize = NSSize(width: 1024, height: 700)

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    self.minSize = minimumWindowSize
    self.setContentSize(defaultWindowSize)
    self.center()
    self.setFrameAutosaveName("MainFlutterWindow")

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
