import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';

class NotifyToasts {
  // 存储每个位置的OverlayEntry列表
  static final Map<NotifyToastPosition, List<OverlayEntry>> _overlayEntries = {
    NotifyToastPosition.topLeft: [],
    NotifyToastPosition.topRight: [],
    NotifyToastPosition.bottomLeft: [],
    NotifyToastPosition.bottomRight: [],
  };

  /// Display a toast notification at the top left corner.
  ///
  /// * [context] - The context used for locating the Overlay.
  /// * [title] - Optional title, default is an empty string.
  /// * [message] - Required message text.
  /// * [duration] - Duration for which the message is displayed, default is 3 seconds.
  /// * [animationDuration] Duration of message spinning in and out of animation.
  /// * [animationEffect] - Custom animation effect, defaults to slide in from the left if not provided.
  /// * [showClose] - Whether to show a close button, default is true.
  /// * [autoClose] - Whether the message should automatically close after the specified duration, default is true.
  /// * [type] - Type of the message, used to define the semantics and color of the message, optional.
  /// * [color] - Background color of the message box, optional.
  /// * [messageStyle] - Style of the message text, optional.
  /// * [width] - Width of the message box, optional.
  /// * [onTap] - Callback function when the message is tapped, optional.
  /// * [icon] - Icon on the left side of the message box, optional.
  /// * [borderRadius] -  Border radius of the message box, optional.
  /// * [titleStyle] -  Style of the title text, optional.
  static void showTopLeft(
    context, {
    String title = '',
    required String message,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    bool showClose = true,
    bool autoClose = true,
    SemanticEnum? type,
    Color? color,
    TextStyle? messageStyle,
    double? width,
    VoidCallback? onTap,
    Widget? icon,
    BorderRadiusGeometry? borderRadius,
    TextStyle? titleStyle,
  }) {
    _show(
      context,
      title: title,
      message: message,
      duration: duration,
      animationDuration: animationDuration,
      position: NotifyToastPosition.topLeft,
      animationEffect: animationEffect ?? AnimateStyles.slideInLeft,
      showClose: showClose,
      autoClose: autoClose,
      type: type,
      color: color,
      messageStyle: messageStyle,
      width: width,
      onTap: onTap,
      icon: icon,
      borderRadius: borderRadius,
      titleStyle: titleStyle,
    );
  }

  /// Display a toast notification at the top right corner.
  ///
  /// * [context] - The context used for locating the Overlay.
  /// * [title] - Optional title, default is an empty string.
  /// * [message] - Required message text.
  /// * [duration] - Duration for which the message is displayed, default is 3 seconds.
  /// * [animationDuration] Duration of message spinning in and out of animation.
  /// * [animationEffect] - Custom animation effect, defaults to slide in from the right if not provided.
  /// * [showClose] - Whether to show a close button, default is true.
  /// * [autoClose] - Whether the message should automatically close after the specified duration, default is true.
  /// * [type] - Type of the message, used to define the semantics and color of the message, optional.
  /// * [color] - Background color of the message box, optional.
  /// * [messageStyle] - Style of the message text, optional.
  /// * [width] - Width of the message box, optional.
  /// * [onTap] - Callback function when the message is tapped, optional.
  /// * [icon] - Icon on the left side of the message box, optional.
  /// * [borderRadius] - Border radius of the message box, optional.
  /// * [titleStyle] - Style of the title text, optional.
  static void showTopRight(
    context, {
    String title = '',
    required String message,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    bool showClose = true,
    bool autoClose = true,
    SemanticEnum? type,
    Color? color,
    TextStyle? messageStyle,
    double? width,
    VoidCallback? onTap,
    Widget? icon,
    BorderRadiusGeometry? borderRadius,
    TextStyle? titleStyle,
  }) {
    _show(
      context,
      title: title,
      message: message,
      duration: duration,
      animationDuration: animationDuration,
      position: NotifyToastPosition.topRight,
      animationEffect: animationEffect ?? AnimateStyles.slideInRight,
      showClose: showClose,
      autoClose: autoClose,
      type: type,
      color: color,
      messageStyle: messageStyle,
      width: width,
      onTap: onTap,
      icon: icon,
      borderRadius: borderRadius,
      titleStyle: titleStyle,
    );
  }

  /// Display a toast notification at the bottom right corner.
  ///
  /// * [context] - The context used for locating the Overlay.
  /// * [title] - Optional title, default is an empty string.
  /// * [message] - Required message text.
  /// * [duration] - Duration for which the message is displayed, default is 3 seconds.
  /// * [animationDuration] Duration of message spinning in and out of animation.
  /// * [animationEffect] - Custom animation effect, defaults to slide in from the right if not provided.
  /// * [showClose] - Whether to show a close button, default is true.
  /// * [autoClose] - Whether the message should automatically close after the specified duration, default is true.
  /// * [type] - Type of the message, used to define the semantics and color of the message, optional.
  /// * [color] - Background color of the message box, optional.
  /// * [messageStyle] - Style of the message text, optional.
  /// * [width] - Width of the message box, optional.
  /// * [onTap] - Callback function when the message is tapped, optional.
  /// * [icon] - Icon on the left side of the message box, optional.
  /// * [borderRadius] - Border radius of the message box, optional.
  /// * [titleStyle] - Style of the title text, optional.
  static void showBottomRight(
    context, {
    String title = '',
    required String message,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    bool showClose = true,
    bool autoClose = true,
    SemanticEnum? type,
    Color? color,
    TextStyle? messageStyle,
    double? width,
    VoidCallback? onTap,
    Widget? icon,
    BorderRadiusGeometry? borderRadius,
    TextStyle? titleStyle,
  }) {
    _show(
      context,
      title: title,
      message: message,
      duration: duration,
      animationDuration: animationDuration,
      position: NotifyToastPosition.bottomRight,
      animationEffect: animationEffect ?? AnimateStyles.slideInRight,
      showClose: showClose,
      autoClose: autoClose,
      type: type,
      color: color,
      messageStyle: messageStyle,
      width: width,
      onTap: onTap,
      icon: icon,
      borderRadius: borderRadius,
      titleStyle: titleStyle,
    );
  }

  /// Display a toast notification at the bottom left corner.
  ///
  /// * [context] - The context used for locating the Overlay.
  /// * [title] - Optional title, default is an empty string.
  /// * [message] - Required message text.
  /// * [duration] - Duration for which the message is displayed, default is 3 seconds.
  /// * [animationDuration] Duration of message spinning in and out of animation.
  /// * [animationEffect] - Custom animation effect, defaults to slide in from the left if not provided.
  /// * [showClose] - Whether to show a close button, default is true.
  /// * [autoClose] - Whether the message should automatically close after the specified duration, default is true.
  /// * [type] - Type of the message, used to define the semantics and color of the message, optional.
  /// * [color] - Background color of the message box, optional.
  /// * [messageStyle] - Style of the message text, optional.
  /// * [width] - Width of the message box, optional.
  /// * [onTap] - Callback function when the message is tapped, optional.
  /// * [icon] - Icon on the left side of the message box, optional.
  /// * [borderRadius] - Border radius of the message box, optional.
  /// * [titleStyle] - Style of the title text, optional.
  static void showBottomLeft(
    context, {
    String title = '',
    required String message,
    Duration duration = const Duration(seconds: 3),
    Duration animationDuration = const Duration(milliseconds: 300),
    AnimatedWidget Function(Animation<double>, Widget)? animationEffect,
    bool showClose = true,
    bool autoClose = true,
    SemanticEnum? type,
    Color? color,
    TextStyle? messageStyle,
    double? width,
    VoidCallback? onTap,
    Widget? icon,
    BorderRadiusGeometry? borderRadius,
    TextStyle? titleStyle,
  }) {
    _show(
      context,
      title: title,
      message: message,
      duration: duration,
      animationDuration: animationDuration,
      position: NotifyToastPosition.bottomLeft,
      animationEffect: animationEffect ?? AnimateStyles.slideInLeft,
      showClose: showClose,
      autoClose: autoClose,
      type: type,
      color: color,
      messageStyle: messageStyle,
      width: width,
      onTap: onTap,
      icon: icon,
      borderRadius: borderRadius,
      titleStyle: titleStyle,
    );
  }

  static void _show(
    context, {
    required String title,
    required String message,
    required Duration duration,
    required Duration animationDuration,
    required NotifyToastPosition position,
    required AnimatedWidget Function(Animation<double>, Widget) animationEffect,
    required bool showClose,
    required bool autoClose,
    SemanticEnum? type,
    Color? color,
    TextStyle? messageStyle,
    double? width,
    VoidCallback? onTap,
    Widget? icon,
    BorderRadiusGeometry? borderRadius,
    TextStyle? titleStyle,
  }) {
    final GlobalKey<_NotificationMessageState> key =
        GlobalKey<_NotificationMessageState>();
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => NotificationMessage(
        key: key,
        context: context,
        entry: overlayEntry,
        title: title,
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        position: position,
        animationEffect: animationEffect,
        showClose: showClose,
        autoClose: autoClose,
        onDismissed: () {
          _overlayEntries[position]!.remove(overlayEntry);
          overlayEntry.remove();
        },
        overlayEntry: overlayEntry,
        type: type,
        color: color,
        messageStyle: messageStyle,
        width: width,
        onTap: onTap,
        icon: icon,
        borderRadius: borderRadius,
        titleStyle: titleStyle,
      ),
    );
    _overlayEntries[position]!.add(overlayEntry);
    Overlay.of(context).insert(overlayEntry);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateOverlayEntries(context, position);
    });
  }

  // 更新Overlay条目，确保它们正确显示
  static void _updateOverlayEntries(
      BuildContext context, NotifyToastPosition position) {
    final entries = _overlayEntries[position]!;
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final notificationMessage = entry.builder(context) as NotificationMessage;
      notificationMessage.entry.markNeedsBuild();
    }
  }

  // 计算Toast的垂直偏移量
  static double _getOffset(
      BuildContext context, NotifyToastPosition position, int index) {
    const double offsetSpacing = 15;

    double offset = 20;
    for (int i = 0; i < index; i++) {
      final entry = _overlayEntries[position]![i];
      final notificationMessage = entry.builder(context) as NotificationMessage;
      final height =
          (notificationMessage.key as GlobalKey<_NotificationMessageState>)
              .currentState!
              .getHeight();
      offset += height + offsetSpacing;
    }

    return offset;
  }
}

/// 一个消息吐丝单元，用于显示具体的Toast消息
class NotificationMessage extends StatefulWidget {
  /// 上下文，用于定位Overlay。
  final BuildContext context;

  /// OverlayEntry对象，用于控制Toast的显示和隐藏。
  final OverlayEntry entry;

  /// 消息标题，如果没有特定标题则可以为空。
  final String title;

  /// 主要显示的消息内容。
  final String message;

  /// 消息显示持续时间。
  final Duration duration;

  /// 动画时间
  final Duration animationDuration;

  /// 消息显示的位置，如左上、右上等。
  final NotifyToastPosition position;

  /// 自定义动画效果，用于消息的显示和隐藏。
  final AnimatedWidget Function(Animation<double>, Widget) animationEffect;

  /// 是否显示关闭按钮。
  final bool showClose;

  /// 是否自动关闭消息。
  final bool autoClose;

  /// 当消息被关闭时的回调函数。
  final VoidCallback onDismissed;

  /// 同entry，用于内部处理。
  final OverlayEntry overlayEntry;

  /// 消息类型，用于定义消息的语义和颜色。
  final SemanticEnum? type;

  /// 消息框的背景颜色。
  final Color? color;

  /// 消息文本的样式。
  final TextStyle? messageStyle;

  /// 消息框的宽度。
  final double? width;

  /// 点击消息时的回调函数。
  final VoidCallback? onTap;

  /// 消息框左侧的图标。
  final Widget? icon;

  /// 消息框的边框圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 标题文本的样式。
  final TextStyle? titleStyle;

  const NotificationMessage({
    super.key,
    required this.context,
    required this.entry,
    required this.title,
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.position,
    required this.animationEffect,
    required this.showClose,
    required this.autoClose,
    required this.onDismissed,
    required this.overlayEntry,
    this.type,
    this.color,
    this.messageStyle,
    this.width,
    this.onTap,
    this.icon,
    this.borderRadius,
    this.titleStyle,
  });

  @override
  State<NotificationMessage> createState() => _NotificationMessageState();
}

class _NotificationMessageState extends State<NotificationMessage>
    with SingleTickerProviderStateMixin {
  /// 控制动画的动画控制器
  late AnimationController _animationController;

  /// 自动关闭消息的定时器
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器，设置动画持续时间
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    // 启动动画
    _animationController.forward();

    // 如果设置了自动关闭，初始化一个定时器来关闭消息，否则初始化为null
    _timer = widget.autoClose ? Timer(widget.duration, _dismiss) : null;
  }

  // 关闭消息并触发onDismissed回调。
  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // 获取消息框的高度。
  double getHeight() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  @override
  Widget build(BuildContext context) {
    // 计算消息框的位置
    final index = NotifyToasts._overlayEntries[widget.position]!
        .indexOf(widget.overlayEntry);
    final offset = NotifyToasts._getOffset(context, widget.position, index);

    // 使用动画定位消息框
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: widget.position == NotifyToastPosition.topRight ||
              widget.position == NotifyToastPosition.topLeft
          ? offset
          : null,
      bottom: widget.position == NotifyToastPosition.bottomRight ||
              widget.position == NotifyToastPosition.bottomLeft
          ? offset
          : null,
      left: widget.position == NotifyToastPosition.topLeft ||
              widget.position == NotifyToastPosition.bottomLeft
          ? 20
          : null,
      right: widget.position == NotifyToastPosition.topRight ||
              widget.position == NotifyToastPosition.bottomRight
          ? 20
          : null,
      child: widget.animationEffect(_animationController, _buildContent()),
    );
  }

  // 构建吐丝消息中具体内容
  Widget _buildContent() {
    // 根据消息类型确定边框颜色
    final Color borderColor = widget.color ??
        (widget.type != null
            ? findStatusColor(widget.type!)
            : Theme.of(context).primaryColor);

    return Material(
      elevation: 4,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
      child: Container(
        width: widget.width ?? 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: borderColor,
              width: 4,
            ),
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (widget.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: FittedBox(
                              child: widget.icon,
                            ),
                          ),
                        )
                      else if (widget.type != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: FittedBox(
                              child: Icon(
                                _getIconFromType(widget.type!),
                                color: borderColor,
                              ),
                            ),
                          ),
                        ),
                      Text(
                        widget.title.isNotEmpty
                            ? widget.title
                            : _getTitleFromType(widget.type),
                        style: widget.titleStyle ??
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: borderColor,
                            ),
                      ),
                    ],
                  ),
                  // 关闭图标
                  if (widget.showClose || !widget.autoClose)
                    InkWell(
                      onTap: _dismiss,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // 消息文本
              Text(
                widget.message,
                style: widget.messageStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData? _getIconFromType(SemanticEnum type) {
    switch (type) {
      case SemanticEnum.primary:
        return Icons.info;
      case SemanticEnum.secondary:
        return Icons.help;
      case SemanticEnum.success:
        return Icons.check_circle;
      case SemanticEnum.danger:
        return Icons.error;
      case SemanticEnum.warning:
        return Icons.warning;
      case SemanticEnum.info:
        return Icons.info;
      case SemanticEnum.fatal:
        return Icons.dangerous;
      default:
        return null;
    }
  }

  String _getTitleFromType(SemanticEnum? type) {
    switch (type) {
      case SemanticEnum.primary:
        return 'Primary';
      case SemanticEnum.secondary:
        return 'Secondary';
      case SemanticEnum.success:
        return 'Success';
      case SemanticEnum.danger:
        return 'Danger';
      case SemanticEnum.warning:
        return 'Warning';
      case SemanticEnum.info:
        return 'Info';
      case SemanticEnum.fatal:
        return 'Fatal';
      default:
        return '';
    }
  }
}

enum NotifyToastPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
