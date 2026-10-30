import 'dart:async';
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'privacy_guard_platform.dart';

/// Hides [child] while the app is in the background, and optionally blocks
/// screenshots and screen recording.
///
/// The overlay appears when the app is paused, hidden or detached, and by
/// default also when it becomes inactive. It covers the task switcher
/// thumbnail as well. While it is shown, [child] is excluded from semantics
/// and does not receive pointer events.
class PrivacyGuard extends StatefulWidget {
  /// Creates a privacy guard around [child].
  const PrivacyGuard({
    super.key,
    required this.child,
    this.enabled = true,
    this.blurRadius = 10.0,
    this.blurColor = const Color.fromARGB(136, 225, 225, 225),
    this.overlayBuilder,
    this.blurWhenInactive = true,
    this.blurWhileRecording = false,
    this.preventScreenshot = false,
    this.hideInRecents = false,
    this.iosSecureLayerHack = false,
    this.onEnterPrivacyMode,
    this.onExitPrivacyMode,
    this.onScreenshot,
    this.onScreenRecordingChanged,
  });

  /// The content to protect.
  final Widget child;

  /// Turns every feature of this guard off when `false`, as if it were not in
  /// the tree.
  final bool enabled;

  /// The blur sigma, used for both axes of the default overlay.
  final double blurRadius;

  /// The tint painted over the blur in the default overlay.
  final Color blurColor;

  /// Builds a custom overlay, for example a logo and a lock icon, instead of
  /// the default blur. It is sized to [child].
  final WidgetBuilder? overlayBuilder;

  /// Whether [AppLifecycleState.inactive] also shows the overlay.
  ///
  /// iOS takes the task switcher snapshot while the app is inactive, so turning
  /// this off can leak content there. The upside is that pulling down Control
  /// Center, a permission prompt or Face ID no longer flashes the overlay.
  final bool blurWhenInactive;

  /// Shows the overlay while the screen is being recorded or mirrored, where
  /// the platform can report it (iOS, Android 15 and later).
  final bool blurWhileRecording;

  /// Blocks screenshots and screen recording for the whole window while this
  /// guard is mounted. Works on Android, macOS and Windows; on iOS see
  /// [iosSecureLayerHack]. The flag is shared by every guard on screen and
  /// stays on while at least one of them asks for it.
  final bool preventScreenshot;

  /// Hides the task switcher thumbnail while still allowing screenshots.
  /// Android 13 and later; ignored elsewhere.
  final bool hideInRecents;

  /// On iOS, blocks screenshots by moving the app's layers into the secure
  /// layer of a password text field. Only applies together with
  /// [preventScreenshot]. This relies on private UIKit structure that has
  /// changed before; if it is not found, nothing happens. Off by default.
  final bool iosSecureLayerHack;

  /// Called when the overlay appears.
  final VoidCallback? onEnterPrivacyMode;

  /// Called when the overlay goes away.
  final VoidCallback? onExitPrivacyMode;

  /// Called after the user takes a screenshot (iOS, Android 14 and later).
  final VoidCallback? onScreenshot;

  /// Called when screen recording starts (`true`) or stops (`false`), where
  /// the platform can report it.
  final ValueChanged<bool>? onScreenRecordingChanged;

  @override
  State<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends State<PrivacyGuard> {
  late final AppLifecycleListener _lifecycle;
  bool _backgrounded = false;
  bool _recording = false;
  bool _shown = false;

  PrivacyGuardHandle? _secure;
  PrivacyGuardHandle? _hideInRecents;
  PrivacyGuardHandle? _iosSecureLayer;
  StreamSubscription<void>? _screenshotSub;
  StreamSubscription<bool>? _recordingSub;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: _onLifecycleChanged);
    _backgrounded = _isBackground(WidgetsBinding.instance.lifecycleState);
    _shown = _computeShown();
    _syncPlatform();
  }

  @override
  void didUpdateWidget(PrivacyGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _backgrounded = _isBackground(WidgetsBinding.instance.lifecycleState);
    _syncPlatform();
    _refresh(deferCallbacks: true);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _secure?.release();
    _hideInRecents?.release();
    _iosSecureLayer?.release();
    _screenshotSub?.cancel();
    _recordingSub?.cancel();
    super.dispose();
  }

  bool _isBackground(AppLifecycleState? state) => switch (state) {
    AppLifecycleState.paused ||
    AppLifecycleState.hidden ||
    AppLifecycleState.detached => true,
    AppLifecycleState.inactive => widget.blurWhenInactive,
    AppLifecycleState.resumed || null => false,
  };

  bool _computeShown() =>
      widget.enabled &&
      (_backgrounded || (widget.blurWhileRecording && _recording));

  void _onLifecycleChanged(AppLifecycleState state) {
    _backgrounded = _isBackground(state);
    _refresh();
  }

  void _refresh({bool deferCallbacks = false}) {
    final bool shown = _computeShown();
    if (shown == _shown) return;
    setState(() => _shown = shown);
    // Frames are disabled once the app is hidden or paused, which would leave
    // the overlay unpainted in exactly the state it exists for.
    SchedulerBinding.instance.scheduleForcedFrame();
    final VoidCallback? callback = shown
        ? widget.onEnterPrivacyMode
        : widget.onExitPrivacyMode;
    if (callback == null) return;
    if (deferCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => callback());
    } else {
      callback();
    }
  }

  static PrivacyGuardHandle? _hold(
    PrivacyGuardHandle? current,
    bool wanted,
    PrivacyGuardHandle Function() request,
  ) {
    if (wanted) return current ?? request();
    current?.release();
    return null;
  }

  void _syncPlatform() {
    final bool on = widget.enabled;
    _secure = _hold(
      _secure,
      on && widget.preventScreenshot,
      PrivacyGuardPlatform.requestSecure,
    );
    _hideInRecents = _hold(
      _hideInRecents,
      on && widget.hideInRecents,
      PrivacyGuardPlatform.requestHideInRecents,
    );
    _iosSecureLayer = _hold(
      _iosSecureLayer,
      on && widget.preventScreenshot && widget.iosSecureLayerHack,
      PrivacyGuardPlatform.requestIosSecureLayer,
    );
    _syncSubscriptions();
  }

  void _syncSubscriptions() {
    final bool on = widget.enabled;
    if (on && widget.onScreenshot != null) {
      _screenshotSub ??= PrivacyGuardPlatform.onScreenshot.listen(
        (_) => widget.onScreenshot?.call(),
      );
    } else {
      _screenshotSub?.cancel();
      _screenshotSub = null;
    }

    final bool wantsRecording =
        on &&
        (widget.blurWhileRecording || widget.onScreenRecordingChanged != null);
    if (wantsRecording) {
      _recordingSub ??= PrivacyGuardPlatform.onScreenRecordingChanged.listen(
        _onRecordingChanged,
      );
    } else {
      _recordingSub?.cancel();
      _recordingSub = null;
      _recording = false;
    }
  }

  void _onRecordingChanged(bool recording) {
    if (!mounted || recording == _recording) return;
    _recording = recording;
    widget.onScreenRecordingChanged?.call(recording);
    _refresh();
  }

  Widget _buildOverlay(BuildContext context) {
    final WidgetBuilder? builder = widget.overlayBuilder;
    if (builder != null) return builder(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurRadius,
          sigmaY: widget.blurRadius,
        ),
        child: ColoredBox(color: widget.blurColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.passthrough,
      children: [
        ExcludeSemantics(
          excluding: _shown,
          child: AbsorbPointer(absorbing: _shown, child: widget.child),
        ),
        if (_shown) Positioned.fill(child: _buildOverlay(context)),
      ],
    );
  }
}
