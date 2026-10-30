import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'we_alert.dart';

/// Corner a [WeNotification] slides in from.
enum WeNotificationPosition { topRight, topLeft, bottomRight, bottomLeft }

/// Closes one notification early or waits for it to go.
class WeNotificationHandle {
  WeNotificationHandle._(this._entry);

  final _Entry _entry;

  /// Completes once the card has left the screen.
  Future<void> get done => _entry.done.future;

  void close() => WeNotification._close(_entry);
}

/// A titled card in a screen corner that stacks with its neighbours, after
/// `ElNotification`. Use it for events the user did not just trigger, such
/// as a finished export or a failed sync; [WeMessage] is for direct feedback.
///
/// ```dart
/// WeNotification.success(context, title: '导出完成', message: '文件已保存到下载目录');
/// WeNotification.show(
///   context,
///   title: '库存告急',
///   message: '仅剩 46 件',
///   type: SemanticEnum.warning,
///   position: WeNotificationPosition.bottomRight,
///   onClick: () => openStock(),
/// );
/// ```
///
/// A [Duration.zero] keeps the card until it is closed by the user, through
/// the returned [WeNotificationHandle] or [closeAll].
abstract final class WeNotification {
  static final Map<WeNotificationPosition, List<_Entry>> _stacks = {
    for (final p in WeNotificationPosition.values) p: [],
  };

  static const double _gap = 12;

  static WeNotificationHandle show(
    BuildContext context, {
    String? title,
    String? message,
    Widget? content,
    SemanticEnum? type,
    WeNotificationPosition position = WeNotificationPosition.topRight,
    Duration duration = const Duration(milliseconds: 4500),
    bool closable = true,
    bool showIcon = true,
    IconData? icon,
    double width = 330,
    double offset = 16,
    VoidCallback? onClick,
  }) {
    assert(
      title != null || message != null || content != null,
      'A notification needs a title, a message or a content widget.',
    );
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    final entry = _Entry(
      title: title,
      message: message,
      content: content,
      type: type,
      position: position,
      closable: closable,
      showIcon: showIcon && type != null || icon != null,
      icon: icon,
      width: width,
      offset: offset,
      onClick: onClick,
    );
    _stacks[position]!.add(entry);
    _relayout(position);

    entry.overlay = OverlayEntry(
      builder: (_) => _NotificationView(
        entry: entry,
        onMeasured: () => _relayout(position),
      ),
    );
    overlay.insert(entry.overlay!);

    entry.duration = duration;
    _startTimer(entry);
    return WeNotificationHandle._(entry);
  }

  static void _startTimer(_Entry e) {
    e.timer?.cancel();
    if (e.duration > Duration.zero && !e.closing) {
      e.timer = Timer(e.duration, () => _close(e));
    }
  }

  /// Hovering holds the card; leaving starts the full countdown again, as
  /// Element Plus does, so a card never vanishes while it is being read.
  static void _hold(_Entry e, bool on) {
    if (on) {
      e.timer?.cancel();
    } else {
      _startTimer(e);
    }
  }

  static WeNotificationHandle success(
    BuildContext context, {
    String? title,
    String? message,
    WeNotificationPosition position = WeNotificationPosition.topRight,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onClick,
  }) => show(
    context,
    title: title,
    message: message,
    type: SemanticEnum.success,
    position: position,
    duration: duration,
    onClick: onClick,
  );

  static WeNotificationHandle warning(
    BuildContext context, {
    String? title,
    String? message,
    WeNotificationPosition position = WeNotificationPosition.topRight,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onClick,
  }) => show(
    context,
    title: title,
    message: message,
    type: SemanticEnum.warning,
    position: position,
    duration: duration,
    onClick: onClick,
  );

  static WeNotificationHandle info(
    BuildContext context, {
    String? title,
    String? message,
    WeNotificationPosition position = WeNotificationPosition.topRight,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onClick,
  }) => show(
    context,
    title: title,
    message: message,
    type: SemanticEnum.info,
    position: position,
    duration: duration,
    onClick: onClick,
  );

  static WeNotificationHandle error(
    BuildContext context, {
    String? title,
    String? message,
    WeNotificationPosition position = WeNotificationPosition.topRight,
    Duration duration = const Duration(milliseconds: 4500),
    VoidCallback? onClick,
  }) => show(
    context,
    title: title,
    message: message,
    type: SemanticEnum.danger,
    position: position,
    duration: duration,
    onClick: onClick,
  );

  /// Dismisses every visible notification, in every corner.
  static void closeAll() {
    for (final stack in _stacks.values) {
      for (final e in List.of(stack)) {
        _close(e);
      }
    }
  }

  static void _close(_Entry e) {
    if (e.closing) return;
    e.closing = true;
    e.timer?.cancel();
    e.visible.value = false;
    Future<void>.delayed(const Duration(milliseconds: 260), () {
      e.overlay?.remove();
      e.overlay = null;
      _stacks[e.position]!.remove(e);
      _relayout(e.position);
      if (!e.done.isCompleted) e.done.complete();
    });
  }

  /// Stacks the cards of one corner from its edge inwards; closing ones
  /// keep their slot until they are gone, then the rest slide up.
  static void _relayout(WeNotificationPosition position) {
    double y = 0;
    for (final e in _stacks[position]!) {
      if (e.closing) continue;
      e.along.value = e.offset + y;
      y += e.height + _gap;
    }
  }
}

class _Entry {
  _Entry({
    required this.title,
    required this.message,
    required this.content,
    required this.type,
    required this.position,
    required this.closable,
    required this.showIcon,
    required this.icon,
    required this.width,
    required this.offset,
    required this.onClick,
  });

  final String? title;
  final String? message;
  final Widget? content;
  final SemanticEnum? type;
  final WeNotificationPosition position;
  final bool closable;
  final bool showIcon;
  final IconData? icon;
  final double width;
  final double offset;
  final VoidCallback? onClick;

  /// Distance from the top or bottom edge, whichever the corner sits on.
  late final ValueNotifier<double> along = ValueNotifier(offset);
  final ValueNotifier<bool> visible = ValueNotifier(true);
  final Completer<void> done = Completer<void>();
  OverlayEntry? overlay;
  Timer? timer;
  Duration duration = Duration.zero;
  double height = 72;
  bool closing = false;

  bool get top =>
      position == WeNotificationPosition.topLeft ||
      position == WeNotificationPosition.topRight;
  bool get left =>
      position == WeNotificationPosition.topLeft ||
      position == WeNotificationPosition.bottomLeft;
}

class _NotificationView extends StatefulWidget {
  const _NotificationView({required this.entry, required this.onMeasured});

  final _Entry entry;
  final VoidCallback onMeasured;

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView> {
  final GlobalKey _key = GlobalKey();
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize && box.size.height != widget.entry.height) {
      widget.entry.height = box.size.height;
      widget.onMeasured();
    }
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final e = widget.entry;
    final EdgeInsets safe = MediaQuery.paddingOf(context);

    final Widget card = Material(
      color: Colors.transparent,
      child: Container(
        key: _key,
        width: math.max(
          0.0,
          math.min(
            e.width,
            MediaQuery.sizeOf(context).width -
                2 * e.offset -
                safe.left -
                safe.right,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: colors.overlayBackground,
          borderRadius: BorderRadius.circular(we.radius.base),
          border: Border.all(color: colors.lighterBorder),
          boxShadow: we.shadows.light,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (e.showIcon) ...[
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Icon(
                  e.icon ?? WeAlert.iconFor(e.type ?? SemanticEnum.info),
                  size: 22,
                  color: colors.semantic(e.type ?? SemanticEnum.info),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.title != null)
                    Text(
                      e.title!,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryText,
                      ),
                    ),
                  if (e.message != null)
                    Padding(
                      padding: EdgeInsets.only(top: e.title != null ? 6 : 0),
                      child: Text(
                        e.message!,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: colors.regularText,
                        ),
                      ),
                    ),
                  if (e.content != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: e.title != null || e.message != null ? 8 : 0,
                      ),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: colors.regularText,
                        ),
                        child: e.content!,
                      ),
                    ),
                ],
              ),
            ),
            if (e.closable) ...[
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => WeNotification._close(e),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: _hover
                          ? colors.regularText
                          : colors.placeholderText,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    final Widget body = MouseRegion(
      cursor: e.onClick != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _hover = true);
        WeNotification._hold(e, true);
      },
      onExit: (_) {
        setState(() => _hover = false);
        WeNotification._hold(e, false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: e.onClick == null
            ? null
            : () {
                e.onClick!();
                WeNotification._close(e);
              },
        child: card,
      ),
    );

    return ValueListenableBuilder<double>(
      valueListenable: e.along,
      builder: (_, along, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        top: e.top ? along + safe.top : null,
        bottom: e.top ? null : along + safe.bottom,
        left: e.left ? e.offset + safe.left : null,
        right: e.left ? null : e.offset + safe.right,
        child: child!,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: e.visible,
        builder: (_, visible, child) => AnimatedSlide(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : Offset(e.left ? -1.1 : 1.1, 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: visible ? 1 : 0,
            child: child,
          ),
        ),
        child: _SlideIn(fromLeft: e.left, child: body),
      ),
    );
  }
}

/// Slides the card in from its edge once, on first build.
class _SlideIn extends StatefulWidget {
  const _SlideIn({required this.fromLeft, required this.child});

  final bool fromLeft;
  final Widget child;

  @override
  State<_SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<_SlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> slide = Tween<Offset>(
      begin: Offset(widget.fromLeft ? -1.1 : 1.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    return SlideTransition(position: slide, child: widget.child);
  }
}
