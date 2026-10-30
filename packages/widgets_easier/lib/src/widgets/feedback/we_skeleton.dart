import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Grey placeholder blocks shown while content loads, after `el-skeleton`.
///
/// ```dart
/// WeSkeleton(rows: 3)                 // title + 3 text rows
/// WeSkeleton.avatarRow()              // circle + two lines, like a list item
/// WeSkeleton.block(height: 160)       // one rectangle, e.g. for a chart
/// ```
///
/// Wrap real content with [WeSkeleton.loading] to switch between the two:
///
/// ```dart
/// WeSkeleton.loading(loading: busy, skeleton: WeSkeleton(rows: 4), child: table)
/// ```
class WeSkeleton extends StatefulWidget {
  const WeSkeleton({
    super.key,
    this.rows = 3,
    this.title = true,
    this.animated = true,
    this.rowHeight = 14,
    this.gap = 12,
  }) : _shape = null,
       _child = null;

  /// A single rectangle of the given size.
  const WeSkeleton.block({
    super.key,
    double? width,
    double height = 16,
    double radius = 4,
    this.animated = true,
  }) : rows = 0,
       title = false,
       rowHeight = height,
       gap = 0,
       _shape = (width, height, radius),
       _child = null;

  /// A circle beside two text lines.
  const WeSkeleton.avatarRow({super.key, this.animated = true})
    : rows = 2,
      title = false,
      rowHeight = 12,
      gap = 8,
      _shape = null,
      _child = const _AvatarRow();

  final int rows;

  /// A wider, taller first line.
  final bool title;

  /// Shimmer across the blocks.
  final bool animated;
  final double rowHeight;
  final double gap;

  final (double?, double, double)? _shape;
  final Widget? _child;

  /// Shows [skeleton] while [loading], otherwise [child], with a cross-fade.
  static Widget loading({
    required bool loading,
    required Widget skeleton,
    required Widget child,
  }) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    child: loading
        ? KeyedSubtree(key: const ValueKey('skeleton'), child: skeleton)
        : KeyedSubtree(key: const ValueKey('content'), child: child),
  );

  @override
  State<WeSkeleton> createState() => _WeSkeletonState();
}

class _WeSkeletonState extends State<WeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animated) _c.repeat();
  }

  @override
  void didUpdateWidget(WeSkeleton old) {
    super.didUpdateWidget(old);
    if (widget.animated && !_c.isAnimating) _c.repeat();
    if (!widget.animated && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    Widget body;
    if (widget._shape != null) {
      final (w, h, r) = widget._shape!;
      body = _Bone(width: w, height: h, radius: r);
    } else if (widget._child != null) {
      body = widget._child!;
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title) ...[
            const _Bone(widthFactor: 0.4, height: 20, radius: 4),
            SizedBox(height: widget.gap + 4),
          ],
          for (int i = 0; i < widget.rows; i++) ...[
            _Bone(
              widthFactor: i == widget.rows - 1 ? 0.6 : 1,
              height: widget.rowHeight,
              radius: 4,
            ),
            if (i != widget.rows - 1) SizedBox(height: widget.gap),
          ],
        ],
      );
    }

    return _SkeletonScope(
      base: colors.lightFill,
      highlight: colors.baseFill,
      child: widget.animated
          ? AnimatedBuilder(
              animation: _c,
              builder: (_, child) => ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment(-1 + 3 * _c.value, 0),
                  end: Alignment(3 * _c.value, 0),
                  colors: [colors.lightFill, colors.baseFill, colors.lightFill],
                ).createShader(bounds),
                child: child,
              ),
              child: body,
            )
          : body,
    );
  }
}

class _SkeletonScope extends InheritedWidget {
  const _SkeletonScope({
    required this.base,
    required this.highlight,
    required super.child,
  });

  final Color base;
  final Color highlight;

  static _SkeletonScope? of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<_SkeletonScope>();

  @override
  bool updateShouldNotify(_SkeletonScope old) =>
      old.base != base || old.highlight != highlight;
}

class _Bone extends StatelessWidget {
  const _Bone({
    this.width,
    this.widthFactor,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double? widthFactor;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Color color =
        _SkeletonScope.of(context)?.base ?? context.weColors.lightFill;
    final Widget box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    final double? factor = widthFactor ?? (width == null ? 1.0 : null);
    if (factor != null) {
      return FractionallySizedBox(
        widthFactor: factor,
        alignment: Alignment.centerLeft,
        child: box,
      );
    }
    return box;
  }
}

class _AvatarRow extends StatelessWidget {
  const _AvatarRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Bone(width: 40, height: 40, radius: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Bone(widthFactor: 0.5, height: 14, radius: 4),
              SizedBox(height: 8),
              _Bone(widthFactor: 0.8, height: 12, radius: 4),
            ],
          ),
        ),
      ],
    );
  }
}
