import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'we_alert.dart';

/// A global, transient message that drops in from the top centre and stacks
/// below earlier ones, after `ElMessage`.
///
/// ```dart
/// WeMessage.success(context, 'Saved');
/// WeMessage.error(context, 'Network error', closable: true);
/// WeMessage.show(context, 'Custom', type: SemanticEnum.warning, duration: Duration.zero);
/// ```
///
/// A [Duration.zero] keeps the message until it is closed by the user or
/// through [closeAll].
abstract final class WeMessage {
  static final List<_Entry> _stack = [];

  static const double _top = 20;
  static const double _gap = 12;

  static Future<void> show(
    BuildContext context,
    String message, {
    SemanticEnum type = SemanticEnum.info,
    Duration duration = const Duration(seconds: 3),
    bool closable = false,
    bool plain = false,
    bool showIcon = true,
    IconData? icon,
  }) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    final entry = _Entry(
      message: message,
      type: type,
      closable: closable,
      plain: plain,
      showIcon: showIcon,
      icon: icon,
    );
    _stack.add(entry);
    _relayout();

    entry.overlay = OverlayEntry(
      builder: (_) => _MessageView(entry: entry, onMeasured: _relayout),
    );
    overlay.insert(entry.overlay!);

    if (duration > Duration.zero) {
      entry.timer = Timer(duration, () => _close(entry));
    }
    return entry.done.future;
  }

  static Future<void> success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool closable = false,
    bool plain = false,
  }) => show(
    context,
    message,
    type: SemanticEnum.success,
    duration: duration,
    closable: closable,
    plain: plain,
  );

  static Future<void> warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool closable = false,
    bool plain = false,
  }) => show(
    context,
    message,
    type: SemanticEnum.warning,
    duration: duration,
    closable: closable,
    plain: plain,
  );

  static Future<void> info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool closable = false,
    bool plain = false,
  }) => show(
    context,
    message,
    duration: duration,
    closable: closable,
    plain: plain,
  );

  static Future<void> error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool closable = false,
    bool plain = false,
  }) => show(
    context,
    message,
    type: SemanticEnum.danger,
    duration: duration,
    closable: closable,
    plain: plain,
  );

  /// Dismisses every visible message.
  static void closeAll() {
    for (final e in List.of(_stack)) {
      _close(e);
    }
  }

  static void _close(_Entry e) {
    if (e.closing) return;
    e.closing = true;
    e.timer?.cancel();
    e.visible.value = false;
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      e.overlay?.remove();
      e.overlay = null;
      _stack.remove(e);
      _relayout();
      if (!e.done.isCompleted) e.done.complete();
    });
  }

  static void _relayout() {
    double y = _top;
    for (final e in _stack) {
      if (e.closing) continue;
      e.top.value = y;
      y += e.height + _gap;
    }
  }
}

class _Entry {
  _Entry({
    required this.message,
    required this.type,
    required this.closable,
    required this.plain,
    required this.showIcon,
    required this.icon,
  });

  final String message;
  final SemanticEnum type;
  final bool closable;
  final bool plain;
  final bool showIcon;
  final IconData? icon;

  final ValueNotifier<double> top = ValueNotifier(WeMessage._top);
  final ValueNotifier<bool> visible = ValueNotifier(true);
  final Completer<void> done = Completer<void>();
  OverlayEntry? overlay;
  Timer? timer;
  double height = 40;
  bool closing = false;
}

class _MessageView extends StatefulWidget {
  const _MessageView({required this.entry, required this.onMeasured});

  final _Entry entry;
  final VoidCallback onMeasured;

  @override
  State<_MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<_MessageView> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null &&
          box.hasSize &&
          box.size.height != widget.entry.height) {
        widget.entry.height = box.size.height;
        widget.onMeasured();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final e = widget.entry;
    final Color accent = colors.semantic(e.type);
    final Color bg = e.plain
        ? colors.overlayBackground
        : colors.light(e.type, 9);
    final Color border = e.plain
        ? colors.lighterBorder
        : colors.light(e.type, 8);

    return ValueListenableBuilder<double>(
      valueListenable: e.top,
      builder: (_, top, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        top: top,
        left: 0,
        right: 0,
        child: child!,
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: e.visible,
        builder: (_, visible, child) => AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(0, -0.6),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: visible ? 1 : 0,
            child: child,
          ),
        ),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              key: _key,
              constraints: const BoxConstraints(maxWidth: 520, minHeight: 40),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(we.radius.base),
                border: Border.all(color: border),
                boxShadow: e.plain ? we.shadows.light : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.showIcon) ...[
                    Icon(
                      e.icon ?? WeAlert.iconFor(e.type),
                      size: 16,
                      color: accent,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      e.message,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: e.plain ? colors.regularText : accent,
                      ),
                    ),
                  ),
                  if (e.closable) ...[
                    const SizedBox(width: 12),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => WeMessage._close(e),
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: colors.placeholderText,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
