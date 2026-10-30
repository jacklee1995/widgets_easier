import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Closes one fullscreen [WeLoading.service] overlay. Closing twice is a
/// no-op.
class WeLoadingHandle {
  WeLoadingHandle._(this._close);

  final VoidCallback _close;
  bool _closed = false;

  bool get isClosed => _closed;

  void close() {
    if (_closed) return;
    _closed = true;
    _close();
  }
}

/// A loading mask over a region or the whole screen, after Element Plus's
/// `v-loading`.
///
/// ```dart
/// WeLoading(
///   loading: busy,
///   text: '保存中',
///   child: WeTable(...),
/// )
///
/// final h = WeLoading.service(context, text: '同步渠道');
/// try {
///   await api.sync();
/// } finally {
///   h.close();
/// }
/// ```
class WeLoading extends StatelessWidget {
  const WeLoading({
    super.key,
    required this.child,
    this.loading = false,
    this.text,
    this.spinner,
    this.background,
    this.lock = true,
  });

  final Widget child;
  final bool loading;
  final String? text;

  /// Replaces the default spinner.
  final Widget? spinner;

  /// Defaults to the overlay colour at 90% opacity, like `el-loading-mask`.
  final Color? background;

  /// When true the mask swallows pointer events, so the covered region
  /// cannot be clicked while loading.
  final bool lock;

  static const Duration _fade = Duration(milliseconds: 180);

  /// A fullscreen overlay. Call [WeLoadingHandle.close] when the work is
  /// done. Uses [Overlay], not a route, so it does not collide with dialogs
  /// or swallow the back button.
  static WeLoadingHandle service(
    BuildContext context, {
    String? text,
    Widget? spinner,
    Color? background,
    bool lock = true,
  }) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    final OverlayEntry entry = OverlayEntry(
      builder: (_) => _FadeIn(
        child: _Mask(
          text: text,
          spinner: spinner,
          background: background,
          lock: lock,
        ),
      ),
    );
    overlay.insert(entry);
    return WeLoadingHandle._(() {
      if (entry.mounted) entry.remove();
      entry.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          // The spinner only exists while shown, so an idle WeLoading keeps
          // no ticker running.
          child: AnimatedSwitcher(
            duration: _fade,
            child: loading
                ? _Mask(
                    key: const ValueKey('we-loading-mask'),
                    text: text,
                    spinner: spinner,
                    background: background,
                    lock: lock,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child});

  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: WeLoading._fade,
    opacity: _shown ? 1 : 0,
    child: widget.child,
  );
}

class _Mask extends StatelessWidget {
  const _Mask({
    super.key,
    required this.text,
    required this.spinner,
    required this.background,
    required this.lock,
  });

  final String? text;
  final Widget? spinner;
  final Color? background;
  final bool lock;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Widget body = ColoredBox(
      color: background ?? colors.overlayBackground.withValues(alpha: 0.9),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              spinner ??
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      strokeCap: StrokeCap.round,
                      color: colors.primary,
                    ),
                  ),
              if (text != null) ...[
                const SizedBox(height: 10),
                Text(
                  text!,
                  style: TextStyle(fontSize: 13.5, color: colors.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    return Semantics(
      liveRegion: true,
      label: text ?? '加载中',
      child: lock ? AbsorbPointer(child: body) : IgnorePointer(child: body),
    );
  }
}
