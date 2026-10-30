import 'package:flutter/material.dart';

/// Hands the drag callbacks of a [WeMovableDialog] down to its header.
///
/// Headers do not need to know how the dialog is positioned; they only wrap
/// themselves in a [WeDialogDragHandle].
class WeDialogDragScope extends InheritedWidget {
  const WeDialogDragScope({
    super.key,
    required this.enabled,
    required this.onDrag,
    required this.onReset,
    required super.child,
  });

  final bool enabled;

  /// Moves the dialog by [delta], clamped so part of it stays reachable.
  final ValueChanged<Offset> onDrag;

  /// Snaps the dialog back to where it opened.
  final VoidCallback onReset;

  static WeDialogDragScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WeDialogDragScope>();

  @override
  bool updateShouldNotify(WeDialogDragScope old) => old.enabled != enabled;
}

/// Makes [child] drag the dialog it belongs to.
///
/// Outside a [WeMovableDialog], or when dragging is off, it is a no-op — so a
/// header can always wrap itself in one.
///
/// It listens to raw pointer events rather than using a [GestureDetector]: a
/// pan recognizer would swallow the first 18 logical pixels before the dialog
/// budged, and a double-tap recognizer would hold the gesture arena open long
/// enough to delay every click on the close button sitting in the same bar.
class WeDialogDragHandle extends StatefulWidget {
  const WeDialogDragHandle({super.key, required this.child});

  final Widget child;

  @override
  State<WeDialogDragHandle> createState() => _WeDialogDragHandleState();
}

class _WeDialogDragHandleState extends State<WeDialogDragHandle> {
  static const Duration _doubleTapWindow = Duration(milliseconds: 300);
  static const double _doubleTapSlop = 12;

  Duration? _lastDown;
  Offset? _lastDownAt;

  void _onDown(PointerDownEvent event, WeDialogDragScope scope) {
    final Duration now = event.timeStamp;
    final Duration? last = _lastDown;
    final Offset? at = _lastDownAt;

    // 双击标题栏回到初始位置，和桌面窗口的习惯一致。
    if (last != null &&
        at != null &&
        now - last < _doubleTapWindow &&
        (event.position - at).distance < _doubleTapSlop) {
      _lastDown = null;
      _lastDownAt = null;
      scope.onReset();
      return;
    }

    _lastDown = now;
    _lastDownAt = event.position;
  }

  @override
  Widget build(BuildContext context) {
    final WeDialogDragScope? scope = WeDialogDragScope.maybeOf(context);
    if (scope == null || !scope.enabled) return widget.child;

    return MouseRegion(
      cursor: SystemMouseCursors.move,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (e) => _onDown(e, scope),
        onPointerMove: (e) {
          if (e.down) scope.onDrag(e.delta);
        },
        child: widget.child,
      ),
    );
  }
}

/// Positions a dialog and lets the user drag it around by its header.
///
/// The dialog may be dragged most of the way off screen, but [keepVisible]
/// pixels always stay inside so it can be dragged back. Resizing the window
/// pulls a stranded dialog back into view.
class WeMovableDialog extends StatefulWidget {
  const WeMovableDialog({
    super.key,
    required this.child,
    this.enabled = true,
    this.alignment = Alignment.center,
    this.insets = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.keepVisible = 72,
  });

  final Widget child;

  /// Whether the header can drag the dialog.
  final bool enabled;

  /// Where the dialog sits before it is dragged.
  final AlignmentGeometry alignment;

  /// Space kept between the resting dialog and the viewport edges.
  final EdgeInsets insets;

  /// How much of the dialog must remain on screen while dragging.
  final double keepVisible;

  @override
  State<WeMovableDialog> createState() => _WeMovableDialogState();
}

class _WeMovableDialogState extends State<WeMovableDialog> {
  final GlobalKey _boxKey = GlobalKey();

  Offset _offset = Offset.zero;
  Size _viewport = Size.zero;

  void _drag(Offset delta) => _moveTo(_offset + delta);

  void _reset() {
    if (_offset == Offset.zero) return;
    setState(() => _offset = Offset.zero);
  }

  void _moveTo(Offset next) {
    final RenderBox? box =
        _boxKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || _viewport.isEmpty) {
      setState(() => _offset = next);
      return;
    }

    // localToGlobal 已经包含当前位移，减掉它就是未拖动时的静止位置。
    final Offset rest = box.localToGlobal(Offset.zero) - _offset;
    final Size size = box.size;
    final double keep = widget.keepVisible.clamp(0.0, size.width);

    final double minDx = keep - size.width - rest.dx;
    final double maxDx = _viewport.width - keep - rest.dx;
    // 标题栏不能滑到视口上方，否则就再也抓不回来了。
    final double minDy = -rest.dy;
    final double maxDy = _viewport.height - keep - rest.dy;

    final Offset clamped = Offset(
      next.dx.clamp(minDx < maxDx ? minDx : maxDx, maxDx),
      next.dy.clamp(minDy < maxDy ? minDy : maxDy, maxDy),
    );
    if (clamped == _offset) return;
    setState(() => _offset = clamped);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final Size viewport = Size(box.maxWidth, box.maxHeight);
        if (viewport != _viewport) {
          _viewport = viewport;
          // 窗口尺寸变了，把跑到视口外的弹窗拉回来。
          if (_offset != Offset.zero) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _moveTo(_offset);
            });
          }
        }

        return WeDialogDragScope(
          enabled: widget.enabled,
          onDrag: _drag,
          onReset: _reset,
          child: Padding(
            padding: widget.insets,
            child: Align(
              alignment: widget.alignment,
              child: Transform.translate(
                offset: _offset,
                child: KeyedSubtree(key: _boxKey, child: widget.child),
              ),
            ),
          ),
        );
      },
    );
  }
}
