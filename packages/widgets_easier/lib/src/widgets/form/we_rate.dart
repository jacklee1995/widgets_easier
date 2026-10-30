import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A row of stars for scoring, after `el-rate`.
///
/// ```dart
/// WeRate(value: 4.5, readOnly: true, showScore: true)
/// WeRate(value: score, onChanged: (v) => setState(() => score = v), allowHalf: true)
/// ```
class WeRate extends StatefulWidget {
  const WeRate({
    super.key,
    required this.value,
    this.onChanged,
    this.max = 5,
    this.allowHalf = false,
    this.readOnly = false,
    this.disabled = false,
    this.size = 20,
    this.color,
    this.voidColor,
    this.icon = Icons.star_rounded,
    this.showScore = false,
    this.texts,
    this.clearable = true,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final int max;
  final bool allowHalf;

  /// Display only; half stars are always rendered in this mode.
  final bool readOnly;
  final bool disabled;
  final double size;

  /// Filled colour. Defaults to the theme's warning colour.
  final Color? color;
  final Color? voidColor;
  final IconData icon;

  /// Show the numeric value after the stars.
  final bool showScore;

  /// One label per star, shown instead of the score.
  final List<String>? texts;

  /// Tapping the current value resets it to zero.
  final bool clearable;

  @override
  State<WeRate> createState() => _WeRateState();
}

class _WeRateState extends State<WeRate> {
  double? _hover;

  bool get _interactive =>
      !widget.readOnly && !widget.disabled && widget.onChanged != null;

  double _valueAt(Offset local) {
    final double slot = widget.size + 4;
    final int i = (local.dx / slot).floor().clamp(0, widget.max - 1);
    final double inSlot = (local.dx - i * slot) / widget.size;
    if (widget.allowHalf && inSlot < 0.5) return i + 0.5;
    return i + 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color on = widget.color ?? colors.warning;
    final Color off = widget.voidColor ?? colors.lightBorder;
    final double shown = _hover ?? widget.value;

    final Widget stars = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < widget.max; i++)
          Padding(
            padding: EdgeInsets.only(right: i == widget.max - 1 ? 0 : 4),
            child: _Star(
              fill: (shown - i).clamp(0, 1),
              size: widget.size,
              on: widget.disabled ? colors.lighten(on, 5) : on,
              off: off,
              icon: widget.icon,
              scaled: _interactive && _hover != null && _hover! > i,
            ),
          ),
      ],
    );

    Widget body = stars;
    if (_interactive) {
      body = MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (e) => setState(() => _hover = _valueAt(e.localPosition)),
        onExit: (_) => setState(() => _hover = null),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) {
            final double v = _valueAt(d.localPosition);
            widget.onChanged!(widget.clearable && v == widget.value ? 0 : v);
          },
          child: stars,
        ),
      );
    }

    String? caption;
    if (widget.texts != null && shown > 0) {
      final int idx = (shown.ceil() - 1).clamp(0, widget.texts!.length - 1);
      caption = widget.texts![idx];
    } else if (widget.showScore) {
      caption = shown == shown.roundToDouble()
          ? shown.toInt().toString()
          : shown.toStringAsFixed(1);
    }

    if (caption == null) return body;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        body,
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            caption,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: widget.size * 0.7,
              fontWeight: FontWeight.w500,
              color: widget.disabled ? colors.disabledText : on,
            ),
          ),
        ),
      ],
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({
    required this.fill,
    required this.size,
    required this.on,
    required this.off,
    required this.icon,
    required this.scaled,
  });

  final double fill;
  final double size;
  final Color on;
  final Color off;
  final IconData icon;
  final bool scaled;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scaled ? 1.15 : 1,
      duration: const Duration(milliseconds: 100),
      child: Stack(
        children: [
          Icon(icon, size: size, color: off),
          ClipRect(
            clipper: _FractionClipper(fill),
            child: Icon(icon, size: size, color: on),
          ),
        ],
      ),
    );
  }
}

class _FractionClipper extends CustomClipper<Rect> {
  const _FractionClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_FractionClipper old) => old.fraction != fraction;
}
