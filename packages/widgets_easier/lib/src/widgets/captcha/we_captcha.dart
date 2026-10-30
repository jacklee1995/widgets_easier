import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';

/// What the captcha is currently doing.
enum WeCaptchaStatus {
  /// Waiting for the user to start dragging.
  idle,

  /// The handle is being dragged.
  dragging,

  /// [WeCaptcha.onVerify] is running.
  verifying,

  /// The piece landed in the gap.
  success,

  /// The last attempt missed; the puzzle resets itself.
  failure,

  /// Out of attempts. Only a refresh gets out of this state.
  locked,
}

/// Drives a [WeCaptcha] from the outside.
///
/// ```dart
/// final captcha = WeCaptchaController();
/// // ...
/// WeCaptcha(controller: captcha, onSuccess: submit),
/// WeButton(text: '换一张', onPressed: captcha.refresh),
/// ```
class WeCaptchaController extends ChangeNotifier {
  WeCaptchaStatus _status = WeCaptchaStatus.idle;
  WeCaptchaStatus get status => _status;

  bool get solved => _status == WeCaptchaStatus.success;

  VoidCallback? _refresh;
  VoidCallback? _reset;

  void _attach({required VoidCallback refresh, required VoidCallback reset}) {
    _refresh = refresh;
    _reset = reset;
  }

  void _detach() {
    _refresh = null;
    _reset = null;
  }

  void _setStatus(WeCaptchaStatus value) {
    if (_status == value) return;
    _status = value;
    notifyListeners();
  }

  /// New gap position and a fresh attempt counter.
  void refresh() => _refresh?.call();

  /// Sends the piece back to the start, keeping the gap where it is.
  void reset() => _reset?.call();

  @override
  void dispose() {
    _detach();
    super.dispose();
  }
}

/// A slide-to-fit puzzle captcha, the kind used to gate risky actions.
///
/// The user drags the handle until the cut-out piece lands back in its gap.
/// Without [image] the board paints a generated pattern, so the widget still
/// works offline — handy for tests and demos.
///
/// ```dart
/// WeCaptcha(
///   image: const NetworkImage('https://picsum.photos/600/200'),
///   onSuccess: () => Navigator.of(context).pop(true),
/// )
/// ```
///
/// Pass [onVerify] to have a server decide instead; the widget shows a spinner
/// while the future runs and treats `false` as a miss.
class WeCaptcha extends StatefulWidget {
  const WeCaptcha({
    super.key,
    this.image,
    this.controller,
    this.onSuccess,
    this.onFail,
    this.onVerify,
    this.height = 180,
    this.pieceSize,
    this.tolerance = 8,
    this.maxAttempts,
    this.hint = '按住滑块，拖动完成拼图',
    this.successText = '验证通过',
    this.failText = '没对上，再试一次',
    this.lockedText = '尝试次数过多，请刷新后重试',
    this.verifyingText = '校验中…',
    this.showRefresh = true,
    this.humanCheck = true,
    this.enabled = true,
    this.borderRadius,
  }) : assert(tolerance > 0);

  /// Background of the puzzle. `null` paints a generated pattern.
  final ImageProvider? image;
  final WeCaptchaController? controller;

  /// Called once per solve, after [onVerify] if that is given.
  final VoidCallback? onSuccess;

  /// Called on every miss, including a failed [onVerify].
  final VoidCallback? onFail;

  /// Server-side check. Receives the horizontal distance between the piece and
  /// the gap, in logical pixels. When omitted, [tolerance] decides locally.
  final Future<bool> Function(double distance)? onVerify;

  final double height;

  /// Side of the puzzle piece. Defaults to a third of [height], 44–64.
  final double? pieceSize;

  /// How far the piece may sit from the gap and still count, in pixels.
  final double tolerance;

  /// Misses allowed before the captcha locks. `null` allows unlimited retries.
  final int? maxAttempts;

  final String hint;
  final String successText;
  final String failText;
  final String lockedText;
  final String verifyingText;

  /// Shows the refresh button over the board.
  final bool showRefresh;

  /// Rejects drags that finish implausibly fast or in a single jump.
  final bool humanCheck;

  final bool enabled;
  final BorderRadius? borderRadius;

  /// Convenience for a network background.
  WeCaptcha.network(
    String url, {
    super.key,
    this.controller,
    this.onSuccess,
    this.onFail,
    this.onVerify,
    this.height = 180,
    this.pieceSize,
    this.tolerance = 8,
    this.maxAttempts,
    this.hint = '按住滑块，拖动完成拼图',
    this.successText = '验证通过',
    this.failText = '没对上，再试一次',
    this.lockedText = '尝试次数过多，请刷新后重试',
    this.verifyingText = '校验中…',
    this.showRefresh = true,
    this.humanCheck = true,
    this.enabled = true,
    this.borderRadius,
  }) : image = NetworkImage(url),
       assert(tolerance > 0);

  /// Convenience for an asset background.
  WeCaptcha.asset(
    String name, {
    super.key,
    this.controller,
    this.onSuccess,
    this.onFail,
    this.onVerify,
    this.height = 180,
    this.pieceSize,
    this.tolerance = 8,
    this.maxAttempts,
    this.hint = '按住滑块，拖动完成拼图',
    this.successText = '验证通过',
    this.failText = '没对上，再试一次',
    this.lockedText = '尝试次数过多，请刷新后重试',
    this.verifyingText = '校验中…',
    this.showRefresh = true,
    this.humanCheck = true,
    this.enabled = true,
    this.borderRadius,
  }) : image = AssetImage(name),
       assert(tolerance > 0);

  @override
  State<WeCaptcha> createState() => _WeCaptchaState();
}

class _WeCaptchaState extends State<WeCaptcha>
    with SingleTickerProviderStateMixin {
  static const double _handleSize = 44;
  static const double _trackHeight = 44;
  static const Duration _minDragDuration = Duration(milliseconds: 240);

  final math.Random _random = math.Random();

  /// Seeds both the gap position and the generated background.
  int _seed = 0;

  /// Gap position as a fraction of the free space, so a resize keeps it valid.
  double _gapXFactor = 0.5;
  double _gapYFactor = 0.5;

  /// Handle travel in pixels, `0` at rest.
  double _handleX = 0;
  double _boardWidth = 0;

  int _attempts = 0;
  int _dragMoves = 0;
  DateTime? _dragStart;

  /// 失败后把滑块送回起点的延时。
  Timer? _recover;

  ImageInfo? _info;
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Object? _imageError;

  ui.Image? get _frame => _info?.image;

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  WeCaptchaController? _ownController;
  WeCaptchaController get _controller =>
      widget.controller ?? (_ownController ??= WeCaptchaController());

  WeCaptchaStatus get _status => _controller.status;

  @override
  void initState() {
    super.initState();
    _shuffle();
    _controller._attach(refresh: _refresh, reset: _reset);
  }

  @override
  void didUpdateWidget(WeCaptcha old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?._detach();
      _controller._attach(refresh: _refresh, reset: _reset);
    }
    if (old.image != widget.image) {
      _resolveImage();
      _refresh();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void dispose() {
    _recover?.cancel();
    _stopListening();
    _info?.dispose();
    _shake.dispose();
    widget.controller?._detach();
    _ownController?.dispose();
    super.dispose();
  }

  // ── 图片 ──────────────────────────────────────────────────────────────

  void _resolveImage() {
    final ImageProvider? provider = widget.image;
    if (provider == null) {
      _stopListening();
      if (_info != null || _imageError != null) {
        setState(() {
          _info?.dispose();
          _info = null;
          _imageError = null;
        });
      }
      return;
    }

    final ImageStream stream = provider.resolve(
      createLocalImageConfiguration(context),
    );
    if (stream.key == _stream?.key) return;

    _stopListening();
    _stream = stream;
    _listener = ImageStreamListener(
      (info, _) {
        if (!mounted) {
          info.dispose();
          return;
        }
        setState(() {
          // ImageInfo 的所有权交给了监听者，换帧时要自己释放上一张。
          _info?.dispose();
          _info = info;
          _imageError = null;
        });
      },
      onError: (error, _) {
        if (!mounted) return;
        setState(() => _imageError = error);
      },
    );
    stream.addListener(_listener!);
  }

  void _stopListening() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _stream = null;
    _listener = null;
  }

  // ── 状态 ──────────────────────────────────────────────────────────────

  void _shuffle() {
    _seed = _random.nextInt(1 << 30);
    // 缺口留在右侧 40%–90%，太靠左滑一下就中了。
    _gapXFactor = 0.4 + _random.nextDouble() * 0.5;
    _gapYFactor = _random.nextDouble();
    _handleX = 0;
    _attempts = 0;
  }

  void _refresh() {
    if (!mounted) return;
    _recover?.cancel();
    setState(_shuffle);
    _controller._setStatus(WeCaptchaStatus.idle);
  }

  void _reset() {
    if (!mounted) return;
    _recover?.cancel();
    setState(() => _handleX = 0);
    _controller._setStatus(WeCaptchaStatus.idle);
  }

  bool get _interactive =>
      widget.enabled &&
      _status != WeCaptchaStatus.success &&
      _status != WeCaptchaStatus.locked &&
      _status != WeCaptchaStatus.verifying;

  double _pieceSize(double height) =>
      widget.pieceSize ?? (height / 3).clamp(44.0, 64.0);

  double _gapX(double boardWidth, double piece) =>
      _gapXFactor * math.max(0, boardWidth - piece - 12) + 6;

  double _gapY(double piece) =>
      _gapYFactor * math.max(0, widget.height - piece - 12) + 6;

  /// 滑块能走的距离；板子比滑块还窄时退化成 0，免得 clamp 的上下界反过来。
  double get _travel => math.max(0, _boardWidth - _handleSize);

  double _pieceX(double boardWidth, double piece) {
    if (_travel == 0) return 0;
    return _handleX / _travel * math.max(0, boardWidth - piece);
  }

  void _onDragStart() {
    if (!_interactive) return;
    _dragStart = DateTime.now();
    _dragMoves = 0;
    _controller._setStatus(WeCaptchaStatus.dragging);
  }

  void _onDragUpdate(double delta) {
    if (!_interactive) return;
    _dragMoves++;
    setState(() {
      _handleX = (_handleX + delta).clamp(0.0, _travel);
    });
  }

  Future<void> _onDragEnd() async {
    if (_status != WeCaptchaStatus.dragging) return;

    final double piece = _pieceSize(widget.height);
    final double distance =
        (_pieceX(_boardWidth, piece) - _gapX(_boardWidth, piece)).abs();

    final Duration elapsed = DateTime.now().difference(
      _dragStart ?? DateTime.now(),
    );
    final bool robotic =
        widget.humanCheck && (elapsed < _minDragDuration || _dragMoves < 3);

    bool ok = !robotic && distance <= widget.tolerance;
    if (ok && widget.onVerify != null) {
      _controller._setStatus(WeCaptchaStatus.verifying);
      try {
        ok = await widget.onVerify!(distance);
      } catch (_) {
        ok = false;
      }
      if (!mounted) return;
    }

    if (ok) {
      _controller._setStatus(WeCaptchaStatus.success);
      widget.onSuccess?.call();
      return;
    }

    _attempts++;
    _controller._setStatus(WeCaptchaStatus.failure);
    widget.onFail?.call();
    unawaited(_shake.forward(from: 0));

    // 晃完再归位，让用户看清是哪一次没对上。定时器要能取消，否则组件销毁后
    // 它还挂在 event loop 上，使用方的 widget test 会报「timer still pending」。
    _recover?.cancel();
    _recover = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _handleX = 0);
      final bool out =
          widget.maxAttempts != null && _attempts >= widget.maxAttempts!;
      _controller._setStatus(
        out ? WeCaptchaStatus.locked : WeCaptchaStatus.idle,
      );
    });
  }

  /// 键盘微调不参与「像不像人」的判断，否则无障碍用户永远过不了。
  void _nudge(double delta) {
    if (!_interactive) return;
    _dragStart ??= DateTime.now().subtract(const Duration(seconds: 1));
    _dragMoves = 3;
    _controller._setStatus(WeCaptchaStatus.dragging);
    setState(() {
      _handleX = (_handleX + delta).clamp(0.0, _travel);
    });
  }

  // ── 构建 ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;
    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(10);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => LayoutBuilder(
        builder: (context, box) {
          _boardWidth = box.maxWidth.isFinite ? box.maxWidth : 320;
          final double piece = _pieceSize(widget.height);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _board(colors, radius, piece),
              const SizedBox(height: 12),
              _track(colors, radius),
              const SizedBox(height: 8),
              _caption(colors),
            ],
          );
        },
      ),
    );
  }

  Widget _board(WeColorScheme colors, BorderRadius radius, double piece) {
    final double gapX = _gapX(_boardWidth, piece);
    final double gapY = _gapY(piece);
    final bool loading =
        widget.image != null && _frame == null && _imageError == null;

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _BoardPainter(
                  frame: _frame,
                  seed: _seed,
                  gap: Rect.fromLTWH(gapX, gapY, piece, piece),
                  shadow: colors.mask,
                  fallbackBase: colors.primary,
                  fallbackTint: colors.success,
                ),
              ),
            ),
            if (loading)
              Positioned.fill(
                child: ColoredBox(
                  color: colors.lightFill,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.placeholderText,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: _pieceX(_boardWidth, piece),
              top: gapY,
              width: piece,
              height: piece,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PiecePainter(
                    frame: _frame,
                    seed: _seed,
                    board: Size(_boardWidth, widget.height),
                    source: Offset(gapX, gapY),
                    edge: colors.baseBackground,
                    fallbackBase: colors.primary,
                    fallbackTint: colors.success,
                  ),
                ),
              ),
            ),
            if (_status == WeCaptchaStatus.success)
              Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(
                    color: colors.success.withValues(alpha: 0.16),
                    child: Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 40,
                        color: colors.success,
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.showRefresh)
              Positioned(
                right: 8,
                top: 8,
                child: _GlassButton(
                  icon: Icons.refresh_rounded,
                  tooltip: '换一张',
                  onTap: widget.enabled ? _refresh : null,
                ),
              ),
            if (_imageError != null)
              const Positioned(
                left: 8,
                bottom: 8,
                child: _GlassButton(
                  icon: Icons.broken_image_outlined,
                  tooltip: '底图加载失败，已改用生成图案',
                  onTap: null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _track(WeColorScheme colors, BorderRadius radius) {
    final Color accent = switch (_status) {
      WeCaptchaStatus.success => colors.success,
      WeCaptchaStatus.failure || WeCaptchaStatus.locked => colors.danger,
      _ => colors.primary,
    };
    final bool done = _status == WeCaptchaStatus.success;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        // 衰减的正弦抖动，失败时晃两下就停。
        final double t = _shake.value;
        final double dx = t == 0 ? 0 : math.sin(t * math.pi * 4) * 8 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Semantics(
        label: '滑块验证',
        value: _travel == 0 ? '0%' : '${(_handleX / _travel * 100).round()}%',
        slider: true,
        child: FocusableActionDetector(
          enabled: _interactive,
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.arrowLeft): _NudgeIntent(-2),
            SingleActivator(LogicalKeyboardKey.arrowRight): _NudgeIntent(2),
            SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true):
                _NudgeIntent(-12),
            SingleActivator(LogicalKeyboardKey.arrowRight, shift: true):
                _NudgeIntent(12),
            SingleActivator(LogicalKeyboardKey.enter): _SubmitIntent(),
            SingleActivator(LogicalKeyboardKey.space): _SubmitIntent(),
          },
          actions: {
            _NudgeIntent: CallbackAction<_NudgeIntent>(
              onInvoke: (intent) {
                _nudge(intent.delta);
                return null;
              },
            ),
            _SubmitIntent: CallbackAction<_SubmitIntent>(
              onInvoke: (_) {
                unawaited(_onDragEnd());
                return null;
              },
            ),
          },
          child: SizedBox(
            height: _trackHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.lightFill,
                      borderRadius: radius,
                      border: Border.all(color: colors.lighterBorder),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: _handleSize),
                        child: Text(
                          switch (_status) {
                            WeCaptchaStatus.success => widget.successText,
                            WeCaptchaStatus.locked => widget.lockedText,
                            WeCaptchaStatus.verifying => widget.verifyingText,
                            _ => widget.hint,
                          },
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: done
                                ? colors.success
                                : colors.placeholderText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: _handleX + _handleSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.16),
                      borderRadius: radius,
                      border: Border.all(color: accent.withValues(alpha: 0.45)),
                    ),
                  ),
                ),
                Positioned(
                  left: _handleX,
                  top: 0,
                  bottom: 0,
                  width: _handleSize,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (_) => _onDragStart(),
                    onHorizontalDragUpdate: (d) => _onDragUpdate(d.delta.dx),
                    onHorizontalDragEnd: (_) => unawaited(_onDragEnd()),
                    child: MouseRegion(
                      cursor: _interactive
                          ? SystemMouseCursors.grab
                          : SystemMouseCursors.basic,
                      child: _Handle(
                        status: _status,
                        accent: accent,
                        colors: colors,
                        radius: radius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _caption(WeColorScheme colors) {
    final (String text, Color color) = switch (_status) {
      WeCaptchaStatus.success => (widget.successText, colors.success),
      WeCaptchaStatus.failure => (widget.failText, colors.danger),
      WeCaptchaStatus.locked => (widget.lockedText, colors.danger),
      WeCaptchaStatus.verifying => (widget.verifyingText, colors.secondaryText),
      _ => (widget.hint, colors.secondaryText),
    };

    final int? left = widget.maxAttempts == null
        ? null
        : widget.maxAttempts! - _attempts;

    return Row(
      children: [
        Icon(
          switch (_status) {
            WeCaptchaStatus.success => Icons.verified_rounded,
            WeCaptchaStatus.failure ||
            WeCaptchaStatus.locked => Icons.error_outline_rounded,
            _ => Icons.touch_app_outlined,
          },
          size: 14,
          color: color,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 12, color: color)),
        ),
        if (left != null && _status != WeCaptchaStatus.success)
          Text(
            '剩余 $left 次',
            style: TextStyle(fontSize: 11.5, color: colors.placeholderText),
          ),
      ],
    );
  }
}

// ── 滑块 ────────────────────────────────────────────────────────────────

class _Handle extends StatelessWidget {
  const _Handle({
    required this.status,
    required this.accent,
    required this.colors,
    required this.radius,
  });

  final WeCaptchaStatus status;
  final Color accent;
  final WeColorScheme colors;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    final bool active =
        status == WeCaptchaStatus.dragging ||
        status == WeCaptchaStatus.success ||
        status == WeCaptchaStatus.failure ||
        status == WeCaptchaStatus.locked;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: active ? accent : colors.baseBackground,
        borderRadius: radius,
        border: Border.all(color: active ? accent : colors.baseBorder),
        boxShadow: [
          BoxShadow(
            color: colors.mask.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: switch (status) {
          WeCaptchaStatus.verifying => SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.onSemantic,
            ),
          ),
          WeCaptchaStatus.success => Icon(
            Icons.check_rounded,
            size: 20,
            color: colors.onSemantic,
          ),
          WeCaptchaStatus.failure || WeCaptchaStatus.locked => Icon(
            Icons.close_rounded,
            size: 20,
            color: colors.onSemantic,
          ),
          _ => Icon(
            Icons.keyboard_double_arrow_right_rounded,
            size: 20,
            color: active ? colors.onSemantic : colors.regularText,
          ),
        },
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 28,
            height: 28,
            child: Icon(icon, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── 绘制 ────────────────────────────────────────────────────────────────

/// 拼图块的轮廓：圆角方块 + 右侧凸起 + 顶部凹口，画布与裁剪共用同一条路径。
Path _jigsaw(double size) {
  final double bump = size * 0.2;
  final Rect body = Rect.fromLTWH(0, bump, size - bump, size - bump);

  Path path = Path()
    ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(size * 0.1)));
  path = Path.combine(
    PathOperation.difference,
    path,
    Path()..addOval(
      Rect.fromCircle(center: Offset(body.center.dx, body.top), radius: bump),
    ),
  );
  return Path.combine(
    PathOperation.union,
    path,
    Path()..addOval(
      Rect.fromCircle(center: Offset(body.right, body.center.dy), radius: bump),
    ),
  );
}

/// 没有底图时按种子生成的图案，保证离线也能用。
void _paintFallback(
  Canvas canvas,
  Size size,
  int seed,
  Color base,
  Color tint,
) {
  final math.Random r = math.Random(seed);
  canvas.drawRect(
    Offset.zero & size,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [base, Color.lerp(base, tint, 0.75)!],
      ).createShader(Offset.zero & size),
  );
  for (int i = 0; i < 14; i++) {
    canvas.drawCircle(
      Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
      6 + r.nextDouble() * 34,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05 + r.nextDouble() * 0.08),
    );
  }
}

void _paintCover(Canvas canvas, Size size, ui.Image frame) {
  final Size raw = Size(frame.width.toDouble(), frame.height.toDouble());
  final FittedSizes fitted = applyBoxFit(BoxFit.cover, raw, size);
  final Rect src = Alignment.center.inscribe(fitted.source, Offset.zero & raw);
  canvas.drawImageRect(
    frame,
    src,
    Offset.zero & size,
    Paint()..filterQuality = FilterQuality.medium,
  );
}

class _BoardPainter extends CustomPainter {
  _BoardPainter({
    required this.frame,
    required this.seed,
    required this.gap,
    required this.shadow,
    required this.fallbackBase,
    required this.fallbackTint,
  });

  final ui.Image? frame;
  final int seed;
  final Rect gap;
  final Color shadow;
  final Color fallbackBase;
  final Color fallbackTint;

  @override
  void paint(Canvas canvas, Size size) {
    if (frame != null) {
      _paintCover(canvas, size, frame!);
    } else {
      _paintFallback(canvas, size, seed, fallbackBase, fallbackTint);
    }

    final Path hole = _jigsaw(gap.width).shift(gap.topLeft);
    canvas.drawPath(hole, Paint()..color = shadow.withValues(alpha: 0.55));
    canvas.drawPath(
      hole,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(_BoardPainter old) =>
      old.frame != frame ||
      old.seed != seed ||
      old.gap != gap ||
      old.shadow != shadow;
}

class _PiecePainter extends CustomPainter {
  _PiecePainter({
    required this.frame,
    required this.seed,
    required this.board,
    required this.source,
    required this.edge,
    required this.fallbackBase,
    required this.fallbackTint,
  });

  final ui.Image? frame;
  final int seed;

  /// 整块底图的尺寸，画的时候要按它还原坐标。
  final Size board;

  /// 拼图块在底图上的取样位置。
  final Offset source;
  final Color edge;
  final Color fallbackBase;
  final Color fallbackTint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _jigsaw(size.width);

    canvas.save();
    canvas.clipPath(path);
    canvas.translate(-source.dx, -source.dy);
    if (frame != null) {
      _paintCover(canvas, board, frame!);
    } else {
      _paintFallback(canvas, board, seed, fallbackBase, fallbackTint);
    }
    canvas.restore();

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = edge.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(_PiecePainter old) =>
      old.frame != frame ||
      old.seed != seed ||
      old.board != board ||
      old.source != source ||
      old.edge != edge;
}

// ── 键盘意图 ────────────────────────────────────────────────────────────

class _NudgeIntent extends Intent {
  const _NudgeIntent(this.delta);

  final double delta;
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}
