import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../overlay/we_popper.dart';

/// One image that [WeImageViewer] can show.
@immutable
class WeImageSource {
  const WeImageSource.network(this.url) : bytes = null, provider = null;
  const WeImageSource.bytes(this.bytes) : url = null, provider = null;
  const WeImageSource.provider(this.provider) : url = null, bytes = null;

  final String? url;
  final Uint8List? bytes;
  final ImageProvider? provider;

  /// Null when there is nothing to load, e.g. an empty url.
  ImageProvider? get imageProvider {
    if (provider != null) return provider;
    if (bytes != null) return MemoryImage(bytes!);
    if (url != null && url!.isNotEmpty) return NetworkImage(url!);
    return null;
  }
}

/// A framed image after `el-image`: a placeholder while loading, a fallback
/// on error, and an optional click-to-preview.
///
/// ```dart
/// WeImage(src: url, width: 96, height: 96, radius: BorderRadius.circular(6),
///     preview: true, previewList: gallery, initialIndex: 2)
/// ```
class WeImage extends StatelessWidget {
  const WeImage({
    super.key,
    this.src,
    this.bytes,
    this.provider,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.radius,
    this.placeholder,
    this.error,
    this.preview = false,
    this.previewList,
    this.initialIndex = 0,
    this.semanticLabel,
  });

  /// Network url; [bytes] or [provider] win when set.
  final String? src;
  final Uint8List? bytes;
  final ImageProvider? provider;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? radius;

  /// Shown until the first frame arrives.
  final Widget? placeholder;

  /// Shown when there is no source or loading fails.
  final Widget? error;

  /// Tap opens [WeImageViewer].
  final bool preview;

  /// The gallery the viewer pages through; defaults to this image alone.
  final List<WeImageSource>? previewList;

  /// Where this image sits in [previewList], so the viewer opens on it.
  final int initialIndex;
  final String? semanticLabel;

  WeImageSource get source {
    if (provider != null) return WeImageSource.provider(provider!);
    if (bytes != null) return WeImageSource.bytes(bytes!);
    return WeImageSource.network(src ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final ImageProvider? p = source.imageProvider;
    final Widget fallback =
        error ?? _Fallback(icon: Icons.broken_image_outlined, colors: colors);
    Widget child;
    if (p == null) {
      child = fallback;
    } else {
      child = Image(
        image: p,
        fit: fit,
        width: width,
        height: height,
        semanticLabel: semanticLabel,
        frameBuilder: (context, img, frame, sync) {
          if (sync || frame != null) return img;
          return placeholder ??
              _Fallback(icon: Icons.image_outlined, colors: colors);
        },
        errorBuilder: (_, _, _) => fallback,
      );
    }

    child = SizedBox(width: width, height: height, child: child);
    if (radius != null) {
      child = ClipRRect(borderRadius: radius!, child: child);
    }
    if (!preview) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.zoomIn,
      child: GestureDetector(
        onTap: () => WeImageViewer.show(
          context,
          images: previewList ?? [source],
          initialIndex: previewList == null ? 0 : initialIndex,
        ),
        child: child,
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.icon, required this.colors});

  final IconData icon;
  final WeColorScheme colors;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: colors.lightFill,
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: colors.placeholderText),
        ),
      ),
    ),
  );
}

/// Full-screen image preview after `el-image-viewer`.
///
/// Mouse and keyboard work as well as touch: side arrows or ← / → page,
/// the wheel or + / - zoom, 0 resets, Esc closes. The bottom toolbar zooms,
/// resets and rotates.
abstract final class WeImageViewer {
  static const double minScale = 0.2;
  static const double maxScale = 8;

  static Future<void> show(
    BuildContext context, {
    required List<WeImageSource> images,
    int initialIndex = 0,
  }) {
    if (images.isEmpty) return Future.value();
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.86),
      barrierLabel: '关闭预览',
      builder: (context) => _Viewer(
        images: images,
        initialIndex: initialIndex.clamp(0, images.length - 1),
      ),
    );
  }
}

class _Viewer extends StatefulWidget {
  const _Viewer({required this.images, required this.initialIndex});

  final List<WeImageSource> images;
  final int initialIndex;

  @override
  State<_Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<_Viewer> {
  static const Duration _slide = Duration(milliseconds: 220);

  late int _index = widget.initialIndex;
  late final PageController _pages = PageController(initialPage: _index);
  final TransformationController _zoom = TransformationController();
  int _quarterTurns = 0;
  Size _viewport = Size.zero;

  double get _scale => _zoom.value.getMaxScaleOnAxis();
  bool get _zoomed => (_scale - 1).abs() > 0.01;
  bool get _hasPrev => _index > 0;
  bool get _hasNext => _index < widget.images.length - 1;

  @override
  void initState() {
    super.initState();
    _zoom.addListener(_onZoom);
  }

  @override
  void dispose() {
    _zoom.removeListener(_onZoom);
    _zoom.dispose();
    _pages.dispose();
    super.dispose();
  }

  bool _wasZoomed = false;

  void _onZoom() {
    // Rebuild only when crossing 1:1, which toggles swipe paging.
    if (_zoomed != _wasZoomed) setState(() => _wasZoomed = _zoomed);
  }

  void _close() {
    if (!WePopper.escapeHandled) Navigator.of(context).maybePop();
  }

  void _go(int delta) {
    final int next = _index + delta;
    if (next < 0 || next >= widget.images.length) return;
    _pages.animateToPage(next, duration: _slide, curve: Curves.easeOutCubic);
  }

  /// Scales around the viewport centre, clamped to the viewer limits.
  void _zoomBy(double factor) {
    final double target = (_scale * factor).clamp(
      WeImageViewer.minScale,
      WeImageViewer.maxScale,
    );
    final double f = target / _scale;
    final Offset c = _viewport.center(Offset.zero);
    final Matrix4 around = Matrix4.translationValues(c.dx, c.dy, 0)
      ..multiply(Matrix4.diagonal3Values(f, f, f))
      ..multiply(Matrix4.translationValues(-c.dx, -c.dy, 0));
    _zoom.value = around..multiply(_zoom.value);
  }

  void _reset() => _zoom.value = Matrix4.identity();

  void _rotate(int quarters) => setState(() => _quarterTurns += quarters);

  @override
  Widget build(BuildContext context) {
    final int count = widget.images.length;
    return Material(
      type: MaterialType.transparency,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): _close,
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _go(-1),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () => _go(1),
          const SingleActivator(LogicalKeyboardKey.equal): () => _zoomBy(1.25),
          const SingleActivator(LogicalKeyboardKey.equal, shift: true): () =>
              _zoomBy(1.25),
          const SingleActivator(LogicalKeyboardKey.numpadAdd): () =>
              _zoomBy(1.25),
          const SingleActivator(LogicalKeyboardKey.minus): () => _zoomBy(0.8),
          const SingleActivator(LogicalKeyboardKey.numpadSubtract): () =>
              _zoomBy(0.8),
          const SingleActivator(LogicalKeyboardKey.digit0): _reset,
          const SingleActivator(LogicalKeyboardKey.numpad0): _reset,
        },
        child: Focus(
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, box) {
              _viewport = box.biggest;
              return Stack(
                children: [
                  PageView.builder(
                    controller: _pages,
                    itemCount: count,
                    // While zoomed, drags pan the image instead of paging.
                    physics: _zoomed
                        ? const NeverScrollableScrollPhysics()
                        : const PageScrollPhysics(),
                    onPageChanged: (i) {
                      _reset();
                      setState(() {
                        _index = i;
                        _quarterTurns = 0;
                      });
                    },
                    itemBuilder: (context, i) => _page(i),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _RoundButton(
                      icon: Icons.close_rounded,
                      tooltip: _hint('关闭', 'Esc'),
                      onPressed: _close,
                    ),
                  ),
                  if (count > 1) ...[
                    Positioned(
                      left: 24,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _RoundButton(
                          icon: Icons.chevron_left_rounded,
                          tooltip: _hint('上一张', '←'),
                          onPressed: _hasPrev ? () => _go(-1) : null,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 24,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _RoundButton(
                          icon: Icons.chevron_right_rounded,
                          tooltip: _hint('下一张', '→'),
                          onPressed: _hasNext ? () => _go(1) : null,
                        ),
                      ),
                    ),
                  ],
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 28,
                    child: Center(child: _toolbar(count)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _page(int i) {
    final ImageProvider? p = widget.images[i].imageProvider;
    final Widget image = p == null
        ? const Icon(
            Icons.broken_image_outlined,
            color: Colors.white54,
            size: 56,
          )
        : Image(
            image: p,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 56,
            ),
          );
    final bool current = i == _index;
    return InteractiveViewer(
      transformationController: current ? _zoom : null,
      minScale: WeImageViewer.minScale,
      maxScale: WeImageViewer.maxScale,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 64, 80, 96),
          child: AnimatedRotation(
            turns: current ? _quarterTurns / 4 : 0,
            duration: const Duration(milliseconds: 200),
            child: image,
          ),
        ),
      ),
    );
  }

  /// Key hints only mean something with a keyboard, so touch drops them.
  String _hint(String label, String key) =>
      WePlatform.isTouch(context) ? label : '$label（$key）';

  Widget _toolbar(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF606266).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${_index + 1} / $count',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          _ToolButton(
            Icons.zoom_out_rounded,
            _hint('缩小', '-'),
            () => _zoomBy(0.8),
          ),
          _ToolButton(
            Icons.zoom_in_rounded,
            _hint('放大', '+'),
            () => _zoomBy(1.25),
          ),
          _ToolButton(Icons.crop_free_rounded, _hint('原始大小', '0'), _reset),
          _ToolButton(Icons.rotate_left_rounded, '向左旋转', () => _rotate(-1)),
          _ToolButton(Icons.rotate_right_rounded, '向右旋转', () => _rotate(1)),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    iconSize: 24,
    style: IconButton.styleFrom(
      fixedSize: const Size(44, 44),
      backgroundColor: const Color(0xFF606266).withValues(alpha: 0.9),
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFF606266).withValues(alpha: 0.4),
      disabledForegroundColor: Colors.white38,
    ),
    icon: Icon(icon),
  );
}

class _ToolButton extends StatelessWidget {
  const _ToolButton(this.icon, this.tooltip, this.onPressed);

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    color: Colors.white,
    iconSize: 20,
    visualDensity: VisualDensity.compact,
    icon: Icon(icon),
  );
}
