import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/core.dart';

enum WeCarouselArrow { always, hover, never }

enum WeCarouselIndicator { inside, outside, none }

enum WeCarouselType { standard, card }

/// A looping gallery after `el-carousel`.
class WeCarousel extends StatefulWidget {
  const WeCarousel({
    super.key,
    required this.children,
    this.height = 180,
    this.autoplay = true,
    this.interval = const Duration(seconds: 3),
    this.loop = true,
    this.indicator = WeCarouselIndicator.inside,
    this.arrow = WeCarouselArrow.hover,
    this.direction = Axis.horizontal,
    this.type = WeCarouselType.standard,
    this.initialIndex = 0,
    this.onChanged,
  });

  final List<Widget> children;
  final double height;
  final bool autoplay;
  final Duration interval;
  final bool loop;
  final WeCarouselIndicator indicator;
  final WeCarouselArrow arrow;
  final Axis direction;
  final WeCarouselType type;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  @override
  State<WeCarousel> createState() => _WeCarouselState();
}

class _WeCarouselState extends State<WeCarousel> {
  late final PageController _pages = PageController(
    initialPage: widget.initialIndex,
    viewportFraction: widget.type == WeCarouselType.card ? 0.82 : 1,
  );
  late int _index = widget.initialIndex;
  Timer? _timer;
  bool _hover = false;

  int get _len => widget.children.length;

  @override
  void initState() {
    super.initState();
    _arm();
  }

  @override
  void didUpdateWidget(WeCarousel old) {
    super.didUpdateWidget(old);
    if (old.autoplay != widget.autoplay || old.interval != widget.interval) {
      _arm();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  void _arm() {
    _timer?.cancel();
    if (!widget.autoplay || _len <= 1) return;
    _timer = Timer.periodic(widget.interval, (_) {
      if (_hover || !mounted) return;
      _go(_index + 1);
    });
  }

  void _go(int i) {
    if (_len == 0) return;
    int next = i;
    if (widget.loop) {
      next = i % _len;
      if (next < 0) next += _len;
    } else {
      next = i.clamp(0, _len - 1);
    }
    _pages.animateToPage(
      next,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final bool showArrow =
        widget.arrow == WeCarouselArrow.always ||
        (widget.arrow == WeCarouselArrow.hover && _hover);

    final page = SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pages,
        scrollDirection: widget.direction,
        itemCount: _len,
        onPageChanged: (i) {
          setState(() => _index = i);
          widget.onChanged?.call(i);
        },
        itemBuilder: (context, i) {
          Widget slide = widget.children[i];
          if (widget.type == WeCarouselType.card) {
            final bool active = i == _index;
            slide = AnimatedScale(
              scale: active ? 1 : 0.88,
              duration: const Duration(milliseconds: 240),
              child: slide,
            );
          }
          return slide;
        },
      ),
    );

    final dots = widget.indicator == WeCarouselIndicator.none
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _len; i++)
                GestureDetector(
                  onTap: () => _go(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: i == _index ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i == _index
                          ? colors.primary
                          : colors.placeholderText,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          );

    Widget stage = MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          page,
          if (showArrow && _len > 1) ...[
            Positioned(
              left: 8,
              child: _Arrow(
                icon: Icons.chevron_left,
                onTap: () => _go(_index - 1),
              ),
            ),
            Positioned(
              right: 8,
              child: _Arrow(
                icon: Icons.chevron_right,
                onTap: () => _go(_index + 1),
              ),
            ),
          ],
          if (widget.indicator == WeCarouselIndicator.inside)
            Positioned(bottom: 10, child: dots),
        ],
      ),
    );

    if (widget.indicator == WeCarouselIndicator.outside) {
      stage = Column(
        mainAxisSize: MainAxisSize.min,
        children: [stage, const SizedBox(height: 8), dots],
      );
    }
    return stage;
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
