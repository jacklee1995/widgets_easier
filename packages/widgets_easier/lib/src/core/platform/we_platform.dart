import 'package:flutter/material.dart';

import '../theme/we_theme.dart';

/// How the user drives the app, which decides control sizes and whether
/// hover triggers work. Set it on [WeTheme.interaction].
enum WeInteraction {
  /// Touch on Android, iOS and Fuchsia, pointer everywhere else. On the web
  /// the platform is the visitor's system, so a phone browser counts as
  /// touch.
  auto,

  /// Mouse and keyboard: standard sizes, hover triggers.
  pointer,

  /// Fingers: larger controls, hover triggers act on tap.
  touch,
}

/// Which platform a component is designed for. The gallery and the docs
/// label every component with one of these.
enum WePlatformFit {
  /// Works the same with a finger or a mouse.
  universal('通用', Icons.devices_outlined),

  /// Relies on hover, the keyboard or a wide screen.
  desktop('网页 / 桌面', Icons.desktop_windows_outlined),

  /// Relies on touch gestures or a narrow screen.
  mobile('手机', Icons.smartphone_outlined);

  const WePlatformFit(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Platform checks shared by the components.
abstract final class WePlatform {
  /// Whether [platform] is a touch-first system.
  static bool isTouchPlatform(TargetPlatform platform) => switch (platform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => true,
    TargetPlatform.linux ||
    TargetPlatform.macOS ||
    TargetPlatform.windows => false,
  };

  /// Resolves [interaction] against [platform].
  static bool resolveTouch(
    WeInteraction interaction,
    TargetPlatform platform,
  ) => switch (interaction) {
    WeInteraction.pointer => false,
    WeInteraction.touch => true,
    WeInteraction.auto => isTouchPlatform(platform),
  };

  /// Whether the app around [context] is driven by touch.
  ///
  /// Reads [WeTheme.interaction]; for [WeInteraction.auto] it looks at
  /// `Theme.of(context).platform`, so a local [Theme] can simulate a phone.
  static bool isTouch(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return resolveTouch(
      theme.extension<WeTheme>()?.interaction ?? WeInteraction.auto,
      theme.platform,
    );
  }

  /// Prints a one-time hint in debug builds when a desktop component is used
  /// on touch. Set to false to silence it.
  static bool debugHints = true;

  static final Set<String> _hinted = {};

  /// In debug builds, prints once per [name] when a [WePlatformFit.desktop]
  /// component is built on touch, suggesting [alternative]. Does nothing in
  /// release builds.
  static void debugCheckFit(
    BuildContext context,
    String name,
    WePlatformFit fit, {
    String? alternative,
  }) {
    assert(() {
      if (!debugHints || fit != WePlatformFit.desktop) return true;
      if (_hinted.contains(name) || !isTouch(context)) return true;
      _hinted.add(name);
      debugPrint(
        '[widgets_easier] $name 为网页 / 桌面设计（依赖鼠标、键盘或宽屏），'
        '当前是触屏。'
        '${alternative == null ? '' : '在手机上建议改用 $alternative。'}'
        '关闭提示：WePlatform.debugHints = false',
      );
      return true;
    }());
  }

  /// Forgets which hints were printed, so tests can check them again.
  @visibleForTesting
  static void debugResetHints() => _hinted.clear();
}
