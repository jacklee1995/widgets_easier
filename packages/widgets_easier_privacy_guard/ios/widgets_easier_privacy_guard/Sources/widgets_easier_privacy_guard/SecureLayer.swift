import UIKit

/// Blocks screenshots and recordings by moving the key window's layer into
/// the secure container of a password `UITextField`; UIKit blanks that
/// container in captures. This depends on private layer structure (the
/// container moved from the first to the last sublayer in iOS 17), so every
/// step checks what it finds and gives up instead of guessing.
///
/// Moving the window layer back is not reliable, so once set up the field
/// stays and turning the protection off only clears `isSecureTextEntry`.
final class SecureLayer {
  private var field: UITextField?

  static func keyWindow() -> UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }

  private static func container(of field: UITextField) -> CALayer? {
    guard let layers = field.layer.sublayers, !layers.isEmpty else { return nil }
    if #available(iOS 17.0, *) {
      return layers.last
    }
    return layers.first
  }

  private static func makeField() -> UITextField {
    let field = UITextField()
    field.isSecureTextEntry = true
    field.isUserInteractionEnabled = false
    return field
  }

  /// Whether the secure container exists on this iOS version.
  var isAvailable: Bool {
    if field != nil { return true }
    guard let window = Self.keyWindow() else { return false }
    let probe = Self.makeField()
    window.addSubview(probe)
    probe.layoutIfNeeded()
    defer { probe.removeFromSuperview() }
    return Self.container(of: probe) != nil
  }

  func setEnabled(_ enabled: Bool) {
    if let field {
      field.isSecureTextEntry = enabled
      return
    }
    guard enabled, let window = Self.keyWindow(), let root = window.layer.superlayer else {
      return
    }
    let field = Self.makeField()
    window.addSubview(field)
    field.layoutIfNeeded()
    guard let container = Self.container(of: field) else {
      field.removeFromSuperview()
      NSLog("PrivacyGuard: secure text layer not found, iosSecureLayerHack is a no-op")
      return
    }
    root.addSublayer(field.layer)
    container.addSublayer(window.layer)
    self.field = field
  }
}
