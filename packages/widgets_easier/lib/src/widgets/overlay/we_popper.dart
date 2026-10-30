import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';

/// Where a floating panel sits relative to its trigger, after Element Plus's
/// `placement`.
///
/// `top` / `bottom` / `left` / `right` centre the panel on that side;
/// `…Start` and `…End` align it with the trigger's leading or trailing edge.
enum WePlacement {
  top,
  topStart,
  topEnd,
  bottom,
  bottomStart,
  bottomEnd,
  left,
  leftStart,
  leftEnd,
  right,
  rightStart,
  rightEnd;

  bool get isVertical => index <= bottomEnd.index;

  WePlacement get opposite => switch (this) {
    top => bottom,
    topStart => bottomStart,
    topEnd => bottomEnd,
    bottom => top,
    bottomStart => topStart,
    bottomEnd => topEnd,
    left => right,
    leftStart => rightStart,
    leftEnd => rightEnd,
    right => left,
    rightStart => leftStart,
    rightEnd => leftEnd,
  };

  AxisDirection get side => switch (this) {
    top || topStart || topEnd => AxisDirection.up,
    bottom || bottomStart || bottomEnd => AxisDirection.down,
    left || leftStart || leftEnd => AxisDirection.left,
    right || rightStart || rightEnd => AxisDirection.right,
  };

  /// The trigger point the panel hangs from.
  Alignment get targetAnchor => switch (this) {
    top => Alignment.topCenter,
    topStart => Alignment.topLeft,
    topEnd => Alignment.topRight,
    bottom => Alignment.bottomCenter,
    bottomStart => Alignment.bottomLeft,
    bottomEnd => Alignment.bottomRight,
    left => Alignment.centerLeft,
    leftStart => Alignment.topLeft,
    leftEnd => Alignment.bottomLeft,
    right => Alignment.centerRight,
    rightStart => Alignment.topRight,
    rightEnd => Alignment.bottomRight,
  };

  /// The panel point pinned to [targetAnchor].
  Alignment get followerAnchor => switch (this) {
    top => Alignment.bottomCenter,
    topStart => Alignment.bottomLeft,
    topEnd => Alignment.bottomRight,
    bottom => Alignment.topCenter,
    bottomStart => Alignment.topLeft,
    bottomEnd => Alignment.topRight,
    left => Alignment.centerRight,
    leftStart => Alignment.topRight,
    leftEnd => Alignment.bottomRight,
    right => Alignment.centerLeft,
    rightStart => Alignment.topLeft,
    rightEnd => Alignment.bottomLeft,
  };
}

/// What opens a [WePopper].
enum WePopperTrigger {
  /// Pointer enters the trigger; leaving both trigger and panel closes it.
  hover,

  /// Tap the trigger to toggle; tapping anywhere else closes it.
  click,

  /// Open while the trigger holds keyboard focus.
  focus,

  /// Only through a [WePopperController].
  manual,
}

/// Opens and closes a [WePopper] from outside.
class WePopperController extends ChangeNotifier {
  _WePopperState? _state;

  bool get isOpen => _state?._open ?? false;

  void show() => _state?._show();
  void hide() => _state?._hide();
  void toggle() => isOpen ? hide() : show();

  void _attach(_WePopperState state) {
    assert(
      _state == null || _state == state,
      'A WePopperController can drive one WePopper at a time.',
    );
    _state = state;
  }

  void _detach(_WePopperState state) {
    if (_state == state) _state = null;
  }

  void _notify() => notifyListeners();
}

/// The panel chrome of a [WePopper]; `null` fields fall back to `WeTheme`.
@immutable
class WePopperStyle {
  const WePopperStyle({
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(12),
    this.radius,
    this.shadow = true,
  });

  /// No chrome at all: the popup draws itself.
  static const WePopperStyle none = WePopperStyle(
    backgroundColor: Colors.transparent,
    borderColor: Colors.transparent,
    padding: EdgeInsets.zero,
    radius: 0,
    shadow: false,
  );

  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets padding;
  final double? radius;
  final bool shadow;
}

/// Floats [popupBuilder] next to its trigger, the shared base of tooltips,
/// popovers, popconfirms and select panels.
///
/// The panel follows the trigger when it scrolls, flips to the opposite side
/// when it does not fit, and slides along the cross axis to stay inside the
/// viewport. It closes on a tap outside and on Escape; an Escape that closes
/// a panel does not also close the dialog underneath.
///
/// ```dart
/// WePopper(
///   placement: WePlacement.bottomStart,
///   popupBuilder: (context) => const Text('Hello'),
///   child: const Text('Click me'),
/// )
/// ```
class WePopper extends StatefulWidget {
  const WePopper({
    super.key,
    required Widget this.child,
    required this.popupBuilder,
    this.controller,
    this.placement = WePlacement.bottom,
    this.trigger = WePopperTrigger.click,
    this.gap = 8,
    this.showArrow = false,
    this.style = const WePopperStyle(),
    this.width,
    this.minWidth,
    this.maxWidth = 420,
    this.maxHeight,
    this.matchTriggerWidth = false,
    this.showAfter = Duration.zero,
    this.hideAfter = const Duration(milliseconds: 120),
    this.disabled = false,
    this.closeOnTapOutside = true,
    this.closeOnEscape = true,
    this.onOpenChanged,
  }) : builder = null;

  /// Builds the trigger yourself, with a callback that toggles the panel.
  ///
  /// Use this when the trigger is a button: a plain [child] would get its tap
  /// swallowed, or would have to pretend to have an `onPressed`.
  ///
  /// ```dart
  /// WePopper.builder(
  ///   popupBuilder: (context) => const Text('More'),
  ///   builder: (context, toggle) => WeButton(text: 'Open', onPressed: toggle),
  /// )
  /// ```
  const WePopper.builder({
    super.key,
    required Widget Function(BuildContext context, VoidCallback toggle)
    this.builder,
    required this.popupBuilder,
    this.controller,
    this.placement = WePlacement.bottom,
    this.gap = 8,
    this.showArrow = false,
    this.style = const WePopperStyle(),
    this.width,
    this.minWidth,
    this.maxWidth = 420,
    this.maxHeight,
    this.matchTriggerWidth = false,
    this.disabled = false,
    this.closeOnTapOutside = true,
    this.closeOnEscape = true,
    this.onOpenChanged,
  }) : child = null,
       trigger = WePopperTrigger.manual,
       showAfter = Duration.zero,
       hideAfter = Duration.zero;

  final Widget? child;
  final Widget Function(BuildContext context, VoidCallback toggle)? builder;
  final WidgetBuilder popupBuilder;
  final WePopperController? controller;
  final WePlacement placement;
  final WePopperTrigger trigger;

  /// Distance between trigger and panel.
  final double gap;

  final bool showArrow;
  final WePopperStyle style;

  final double? width;
  final double? minWidth;
  final double maxWidth;
  final double? maxHeight;

  /// Make the panel exactly as wide as the trigger, for select-like panels.
  final bool matchTriggerWidth;

  /// Hover delay before opening, and before closing once the pointer leaves.
  final Duration showAfter;
  final Duration hideAfter;

  final bool disabled;
  final bool closeOnTapOutside;
  final bool closeOnEscape;
  final ValueChanged<bool>? onOpenChanged;

  static final List<_WePopperState> _openStack = [];
  static bool _escapeHandled = false;

  /// Whether the Escape press being dispatched right now already closed a
  /// panel. Dialogs check it so one Escape does not close two layers.
  static bool get escapeHandled => _escapeHandled;

  @override
  State<WePopper> createState() => _WePopperState();
}

class _WePopperState extends State<WePopper>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  final OverlayPortalController _portal = OverlayPortalController();
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
    reverseDuration: const Duration(milliseconds: 100),
  );

  bool _open = false;
  late WePlacement _resolved = widget.placement;
  Offset _shift = Offset.zero;
  double? _arrowAt;
  bool _measured = false;
  Size? _popupSize;
  Timer? _hoverTimer;
  Offset? _downAt;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(WePopper old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?._detach(this);
      widget.controller?._attach(this);
    }
    if (old.placement != widget.placement) {
      _resolved = widget.placement;
      _measured = false;
      if (_open) _scheduleReposition();
    }
    if (widget.disabled && _open) _hide();
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    _unregister();
    widget.controller?._detach(this);
    _anim.dispose();
    super.dispose();
  }

  void _show() {
    _hoverTimer?.cancel();
    if (_open || widget.disabled || !mounted) return;
    setState(() {
      _open = true;
      _resolved = widget.placement;
      _shift = Offset.zero;
      _measured = false;
    });
    _portal.show();
    _anim.forward();
    WePopper._openStack.add(this);
    if (WePopper._openStack.length == 1) {
      HardwareKeyboard.instance.addHandler(_onKey);
    }
    widget.onOpenChanged?.call(true);
    widget.controller?._notify();
  }

  void _hide() {
    _hoverTimer?.cancel();
    if (!_open || !mounted) return;
    setState(() => _open = false);
    _unregister();
    _anim.reverse().whenComplete(() {
      if (mounted && !_open) _portal.hide();
    });
    widget.onOpenChanged?.call(false);
    widget.controller?._notify();
  }

  void _toggle() => _open ? _hide() : _show();

  void _unregister() {
    final bool removed = WePopper._openStack.remove(this);
    if (removed && WePopper._openStack.isEmpty) {
      HardwareKeyboard.instance.removeHandler(_onKey);
    }
  }

  // 只由栈底的实例注册一次；Esc 只关最上面那层。
  static bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }
    for (final state in WePopper._openStack.reversed) {
      if (!state.widget.closeOnEscape) continue;
      state._hide();
      WePopper._escapeHandled = true;
      scheduleMicrotask(() => WePopper._escapeHandled = false);
      return true;
    }
    return false;
  }

  /// Touch has no hover, so a hover trigger opens on tap there.
  WePopperTrigger get _trigger =>
      widget.trigger == WePopperTrigger.hover && WePlatform.isTouch(context)
      ? WePopperTrigger.click
      : widget.trigger;

  void _hoverIn() {
    if (_trigger != WePopperTrigger.hover) return;
    _hoverTimer?.cancel();
    if (_open) return;
    if (widget.showAfter == Duration.zero) {
      _show();
    } else {
      _hoverTimer = Timer(widget.showAfter, _show);
    }
  }

  void _hoverOut() {
    if (_trigger != WePopperTrigger.hover) return;
    _hoverTimer?.cancel();
    if (!_open) return;
    if (widget.hideAfter == Duration.zero) {
      _hide();
    } else {
      _hoverTimer = Timer(widget.hideAfter, _hide);
    }
  }

  void _onPopupSize(Size size) {
    if (size == _popupSize && _measured) return;
    _popupSize = size;
    _scheduleReposition();
  }

  void _scheduleReposition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _open) _reposition();
    });
  }

  void _reposition() {
    final RenderBox? target = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Overlay.maybeOf(context)?.context.findRenderObject() as RenderBox?;
    final Size? size = _popupSize;
    if (target == null || overlay == null || size == null || !target.hasSize) {
      return;
    }

    final Rect anchor =
        target.localToGlobal(Offset.zero, ancestor: overlay) & target.size;
    final Rect viewport = (Offset.zero & overlay.size).deflate(8);

    WePlacement placement = widget.placement;
    Rect rect = _rectFor(placement, anchor, size);
    if (!_fitsMainAxis(placement, rect, viewport)) {
      final WePlacement flipped = placement.opposite;
      final Rect other = _rectFor(flipped, anchor, size);
      if (_fitsMainAxis(flipped, other, viewport)) {
        placement = flipped;
        rect = other;
      }
    }

    // 沿交叉轴平移，贴边时不出视口。
    double dx = 0;
    double dy = 0;
    if (placement.isVertical) {
      if (rect.right > viewport.right) dx = viewport.right - rect.right;
      if (rect.left + dx < viewport.left) dx = viewport.left - rect.left;
    } else {
      if (rect.bottom > viewport.bottom) dy = viewport.bottom - rect.bottom;
      if (rect.top + dy < viewport.top) dy = viewport.top - rect.top;
    }

    final Offset shift = Offset(dx, dy);
    final Rect placed = rect.shift(shift);
    final double extent = placement.isVertical ? size.width : size.height;
    final double along =
        (placement.isVertical
                ? anchor.center.dx - placed.left
                : anchor.center.dy - placed.top)
            .clamp(
              math.min(14.0, extent / 2),
              math.max(extent - 14, extent / 2),
            );

    if (placement == _resolved &&
        shift == _shift &&
        along == _arrowAt &&
        _measured) {
      return;
    }
    setState(() {
      _resolved = placement;
      _shift = shift;
      _arrowAt = along;
      _measured = true;
    });
  }

  Offset _gapOffset(WePlacement p) => switch (p.side) {
    AxisDirection.up => Offset(0, -widget.gap),
    AxisDirection.down => Offset(0, widget.gap),
    AxisDirection.left => Offset(-widget.gap, 0),
    AxisDirection.right => Offset(widget.gap, 0),
  };

  Rect _rectFor(WePlacement p, Rect anchor, Size size) {
    final Offset pin = p.targetAnchor.withinRect(anchor) + _gapOffset(p);
    final Offset origin = pin - p.followerAnchor.alongSize(size);
    return origin & size;
  }

  bool _fitsMainAxis(WePlacement p, Rect rect, Rect viewport) =>
      switch (p.side) {
        AxisDirection.up => rect.top >= viewport.top,
        AxisDirection.down => rect.bottom <= viewport.bottom,
        AxisDirection.left => rect.left >= viewport.left,
        AxisDirection.right => rect.right <= viewport.right,
      };

  double? get _triggerWidth {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    return box != null && box.hasSize ? box.size.width : null;
  }

  Widget _buildPopup(BuildContext context) {
    final WeTheme theme = WeTheme.of(context);
    final WeColorScheme colors = theme.colors;
    final WePopperStyle style = widget.style;
    final Color bg = style.backgroundColor ?? colors.overlayBackground;
    final Color border = style.borderColor ?? colors.lighterBorder;
    final double radius = style.radius ?? theme.radius.base;
    // The panel never exceeds the screen minus the 8 px viewport margin on
    // each side, whatever width was asked for.
    final double screenMax = math.max(0, MediaQuery.sizeOf(context).width - 16);
    final double? asked = widget.matchTriggerWidth
        ? _triggerWidth
        : widget.width;
    final double? fixedWidth = asked == null
        ? null
        : math.min(asked, screenMax);

    Widget panel = Container(
      width: fixedWidth,
      constraints: BoxConstraints(
        minWidth: math.min(widget.minWidth ?? 0, screenMax),
        maxWidth: fixedWidth ?? math.min(widget.maxWidth, screenMax),
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      padding: style.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
        boxShadow: style.shadow ? theme.shadows.light : null,
      ),
      child: widget.popupBuilder(context),
    );

    if (widget.showArrow) {
      panel = Stack(
        clipBehavior: Clip.none,
        children: [
          panel,
          _Arrow(
            side: _resolved.side,
            along: _arrowAt,
            color: bg,
            border: border,
          ),
        ],
      );
    }

    if (_trigger == WePopperTrigger.hover) {
      panel = MouseRegion(
        onEnter: (_) => _hoverTimer?.cancel(),
        onExit: (_) => _hoverOut(),
        child: panel,
      );
    }

    final Alignment origin = _resolved.followerAnchor;
    return Align(
      alignment: Alignment.topLeft,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: _resolved.targetAnchor,
        followerAnchor: _resolved.followerAnchor,
        offset: _gapOffset(_resolved) + _shift,
        child: TapRegion(
          groupId: this,
          onTapOutside: widget.closeOnTapOutside ? (_) => _hide() : null,
          child: _SizeReporter(
            onSize: _onPopupSize,
            child: Opacity(
              opacity: _measured ? 1 : 0,
              child: FadeTransition(
                opacity: CurvedAnimation(parent: _anim, curve: Curves.easeOut),
                child: ScaleTransition(
                  alignment: origin,
                  scale: Tween<double>(begin: 0.94, end: 1).animate(
                    CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: colors.regularText,
                      ),
                      child: panel,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrigger(BuildContext context) {
    if (widget.builder != null) return widget.builder!(context, _toggle);

    Widget trigger = widget.child!;
    switch (_trigger) {
      case WePopperTrigger.click:
        // 用原始指针事件判断点击，不进手势竞技场，里面的按钮照样能点。
        trigger = Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (e) => _downAt = e.position,
          onPointerUp: (e) {
            final Offset? down = _downAt;
            _downAt = null;
            if (down != null && (e.position - down).distance < kTouchSlop) {
              _toggle();
            }
          },
          child: MouseRegion(
            cursor: widget.disabled
                ? MouseCursor.defer
                : SystemMouseCursors.click,
            child: trigger,
          ),
        );
      case WePopperTrigger.hover:
        trigger = MouseRegion(
          onEnter: (_) => _hoverIn(),
          onExit: (_) => _hoverOut(),
          child: trigger,
        );
      case WePopperTrigger.focus:
        trigger = Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: (focused) => focused ? _show() : _hide(),
          child: trigger,
        );
      case WePopperTrigger.manual:
        break;
    }
    return trigger;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: TapRegion(
        groupId: this,
        child: OverlayPortal(
          controller: _portal,
          overlayChildBuilder: _buildPopup,
          child: _buildTrigger(context),
        ),
      ),
    );
  }
}

/// A small rotated square on the panel edge facing the trigger. Only its two
/// outward sides carry a border, so it merges into the panel's outline.
class _Arrow extends StatelessWidget {
  const _Arrow({
    required this.side,
    required this.along,
    required this.color,
    required this.border,
  });

  final AxisDirection side;

  /// Centre of the arrow along the panel edge; `null` centres it.
  final double? along;
  final Color color;
  final Color border;

  static const double _size = 10;

  @override
  Widget build(BuildContext context) {
    final BorderSide line = BorderSide(color: border);
    // 旋转 45° 之后：top+left 朝上、bottom+right 朝下、left+bottom 朝左、top+right 朝右。
    final Border edges = switch (side) {
      AxisDirection.down => Border(top: line, left: line),
      AxisDirection.up => Border(bottom: line, right: line),
      AxisDirection.right => Border(left: line, bottom: line),
      AxisDirection.left => Border(top: line, right: line),
    };
    const double half = _size / 2;
    final Widget square = Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(color: color, border: edges),
      ),
    );

    final double? at = along == null ? null : along! - half;
    return switch (side) {
      AxisDirection.down =>
        at == null
            ? Positioned(
                top: -half,
                left: 0,
                right: 0,
                child: Center(child: square),
              )
            : Positioned(top: -half, left: at, child: square),
      AxisDirection.up =>
        at == null
            ? Positioned(
                bottom: -half,
                left: 0,
                right: 0,
                child: Center(child: square),
              )
            : Positioned(bottom: -half, left: at, child: square),
      AxisDirection.right =>
        at == null
            ? Positioned(
                left: -half,
                top: 0,
                bottom: 0,
                child: Center(child: square),
              )
            : Positioned(left: -half, top: at, child: square),
      AxisDirection.left =>
        at == null
            ? Positioned(
                right: -half,
                top: 0,
                bottom: 0,
                child: Center(child: square),
              )
            : Positioned(right: -half, top: at, child: square),
    };
  }
}

/// Reports its child's size after every layout that changes it.
class _SizeReporter extends SingleChildRenderObjectWidget {
  const _SizeReporter({required this.onSize, required super.child});

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSizeReporter(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSizeReporter renderObject,
  ) {
    renderObject.onSize = onSize;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _last) {
      _last = size;
      final Size reported = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onSize(reported));
    }
  }
}
