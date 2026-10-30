import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// What the current platform can do for [PrivacyGuardPlatform].
@immutable
class PrivacyGuardCapabilities {
  /// Creates a capability set. Mostly useful in tests.
  const PrivacyGuardCapabilities({
    this.preventScreenshot = false,
    this.hideInRecents = false,
    this.screenshotDetection = false,
    this.recordingDetection = false,
    this.iosSecureLayer = false,
  });

  /// A platform that supports nothing beyond the Dart-only background blur.
  static const PrivacyGuardCapabilities none = PrivacyGuardCapabilities();

  /// Screenshots and screen recordings can be blocked
  /// (Android `FLAG_SECURE`, macOS `NSWindow.sharingType`, Windows
  /// `SetWindowDisplayAffinity`).
  final bool preventScreenshot;

  /// The task switcher thumbnail can be hidden without blocking screenshots
  /// (Android 13 and later).
  final bool hideInRecents;

  /// [PrivacyGuardPlatform.onScreenshot] reports screenshots
  /// (iOS, Android 14 and later).
  final bool screenshotDetection;

  /// [PrivacyGuardPlatform.onScreenRecordingChanged] reports screen recording
  /// (iOS, Android 15 and later).
  final bool recordingDetection;

  /// The opt-in iOS secure-layer workaround found the layer structure it
  /// relies on. See [PrivacyGuardPlatform.requestIosSecureLayer].
  final bool iosSecureLayer;

  /// Reads the map the platform side sends back for `getCapabilities`.
  factory PrivacyGuardCapabilities.fromMap(Map<Object?, Object?> map) {
    bool read(String key) => map[key] == true;
    return PrivacyGuardCapabilities(
      preventScreenshot: read('preventScreenshot'),
      hideInRecents: read('hideInRecents'),
      screenshotDetection: read('screenshotDetection'),
      recordingDetection: read('recordingDetection'),
      iosSecureLayer: read('iosSecureLayer'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PrivacyGuardCapabilities &&
      other.preventScreenshot == preventScreenshot &&
      other.hideInRecents == hideInRecents &&
      other.screenshotDetection == screenshotDetection &&
      other.recordingDetection == recordingDetection &&
      other.iosSecureLayer == iosSecureLayer;

  @override
  int get hashCode => Object.hash(
    preventScreenshot,
    hideInRecents,
    screenshotDetection,
    recordingDetection,
    iosSecureLayer,
  );

  @override
  String toString() =>
      'PrivacyGuardCapabilities(preventScreenshot: $preventScreenshot, '
      'hideInRecents: $hideInRecents, '
      'screenshotDetection: $screenshotDetection, '
      'recordingDetection: $recordingDetection, '
      'iosSecureLayer: $iosSecureLayer)';
}

/// A hold on one of the window-wide flags. Call [release] once you no longer
/// need it; releasing twice is harmless.
class PrivacyGuardHandle {
  PrivacyGuardHandle._(this._flag);

  _RefCountedFlag? _flag;

  /// Whether [release] has not been called yet.
  bool get isActive => _flag != null;

  /// Gives the hold back. The flag is cleared once every hold is released.
  void release() {
    _flag?._release();
    _flag = null;
  }
}

/// Window-wide flags are shared by every guard on screen, so they are only
/// switched on for the first hold and off after the last one.
class _RefCountedFlag {
  _RefCountedFlag(this._method, {this.onlyOn});

  final String _method;
  final TargetPlatform? onlyOn;
  int _holders = 0;

  PrivacyGuardHandle acquire() {
    if (_holders++ == 0) _send(true);
    return PrivacyGuardHandle._(this);
  }

  void _release() {
    if (_holders == 0) return;
    if (--_holders == 0) _send(false);
  }

  void _send(bool value) {
    if (onlyOn != null && (kIsWeb || defaultTargetPlatform != onlyOn)) return;
    PrivacyGuardPlatform._invoke<void>(_method, value);
  }
}

/// Direct access to the platform side of `PrivacyGuard`.
///
/// Most apps should use the `PrivacyGuard` widget. This class is for toggling
/// the flags outside a widget tree and for listening to capture events.
abstract final class PrivacyGuardPlatform {
  static const MethodChannel _channel = MethodChannel(
    'tech.thispage.widgets_easier_privacy_guard',
  );
  static const EventChannel _events = EventChannel(
    'tech.thispage.widgets_easier_privacy_guard/events',
  );

  static final _RefCountedFlag _secure = _RefCountedFlag('setSecure');
  static final _RefCountedFlag _hideInRecents = _RefCountedFlag(
    'setHideInRecents',
    onlyOn: TargetPlatform.android,
  );
  static final _RefCountedFlag _iosSecureLayer = _RefCountedFlag(
    'setIosSecureLayer',
    onlyOn: TargetPlatform.iOS,
  );
  static PrivacyGuardHandle? _manualSecure;
  static Stream<Map<Object?, Object?>>? _eventStream;

  static bool get _hasNativeSide =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        TargetPlatform.android ||
        TargetPlatform.iOS ||
        TargetPlatform.macOS ||
        TargetPlatform.windows => true,
        _ => false,
      };

  /// Whether [setSecure] can block screenshots on this platform without the
  /// iOS workaround: Android, macOS and Windows.
  static bool get isSecureSupported =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        TargetPlatform.android ||
        TargetPlatform.macOS ||
        TargetPlatform.windows => true,
        _ => false,
      };

  /// Asks the platform which features work on this device. Some depend on the
  /// OS version, so this has to go through the platform side.
  static Future<PrivacyGuardCapabilities> getCapabilities() async {
    if (!_hasNativeSide) return PrivacyGuardCapabilities.none;
    final Map<Object?, Object?>? map = await _invoke<Map<Object?, Object?>>(
      'getCapabilities',
    );
    return map == null
        ? PrivacyGuardCapabilities.none
        : PrivacyGuardCapabilities.fromMap(map);
  }

  /// Blocks screenshots and screen recording for the whole window.
  ///
  /// This shares a counter with every `PrivacyGuard(preventScreenshot: true)`
  /// on screen: the flag stays on while any of them, or this call, asks for
  /// it. `setSecure(false)` only gives back the hold taken by
  /// `setSecure(true)`.
  static void setSecure(bool secure) {
    if (secure) {
      _manualSecure ??= requestSecure();
    } else {
      _manualSecure?.release();
      _manualSecure = null;
    }
  }

  /// Takes a hold on the window-wide screenshot block.
  static PrivacyGuardHandle requestSecure() => _secure.acquire();

  /// Takes a hold on hiding the task switcher thumbnail (Android 13+).
  static PrivacyGuardHandle requestHideInRecents() => _hideInRecents.acquire();

  /// Takes a hold on the iOS secure-layer workaround. It relies on private
  /// UIKit layer structure; see the package README before turning it on.
  /// Does nothing on other platforms.
  static PrivacyGuardHandle requestIosSecureLayer() =>
      _iosSecureLayer.acquire();

  /// Fires after the user takes a screenshot. The screenshot itself is not
  /// prevented. Empty where `screenshotDetection` is not supported.
  static Stream<void> get onScreenshot =>
      _captureEvents.where((e) => e['type'] == 'screenshot').map((_) {});

  /// Emits `true` when screen recording or mirroring starts and `false` when
  /// it stops. The current state is sent as soon as you listen. Empty where
  /// `recordingDetection` is not supported.
  static Stream<bool> get onScreenRecordingChanged => _captureEvents
      .where((e) => e['type'] == 'recording')
      .map((e) => e['active'] == true);

  static Stream<Map<Object?, Object?>> get _captureEvents {
    final bool mobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (!mobile) return const Stream.empty();
    return _eventStream ??= _events
        .receiveBroadcastStream()
        .where((e) => e is Map)
        .cast<Map<Object?, Object?>>()
        .handleError(_report);
  }

  static Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    if (!_hasNativeSide) return null;
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      return null;
    } catch (error, stack) {
      _report(error, stack);
      return null;
    }
  }

  static void _report(Object error, [StackTrace? stack]) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'widgets_easier_privacy_guard',
        context: ErrorDescription('while talking to the platform side'),
      ),
    );
  }

  /// Drops every hold and cached stream without telling the platform.
  @visibleForTesting
  static void debugReset() {
    _secure._holders = 0;
    _hideInRecents._holders = 0;
    _iosSecureLayer._holders = 0;
    _manualSecure = null;
    _eventStream = null;
  }
}
