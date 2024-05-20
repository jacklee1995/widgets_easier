import 'package:flutter/material.dart';

import '../../color/utils.dart';
import '../../enums/semantic_enum.dart';
import '/src/enums/size_enum.dart';

class SemanticToggle extends StatefulWidget {
  final double slideSize;
  final double borderWidth;
  final Color borderColor;
  final Duration duration;
  final dynamic modelValue;
  final dynamic activeValue;
  final dynamic inactiveValue;
  final VoidCallback onToggle;
  final Widget activeActionIcon;
  final Widget inactiveActionIcon;
  final SemanticEnum type;
  final SizeEnum size;
  final String activeText;
  final String inactiveText;
  final bool inlinePrompt;
  final bool disabled;

  const SemanticToggle({
    super.key,
    this.slideSize = 21.0,
    this.borderWidth = 1.0,
    this.borderColor = Colors.grey,
    this.duration = const Duration(milliseconds: 300),
    required this.modelValue,
    this.activeValue = true,
    this.inactiveValue = false,
    required this.onToggle,
    required this.activeActionIcon,
    required this.inactiveActionIcon,
    required this.type,
    this.size = SizeEnum.defaultSize,
    this.activeText = '',
    this.inactiveText = '',
    this.inlinePrompt = false,
    this.disabled = false,
  });

  @override
  State<SemanticToggle> createState() => _SemanticToggleState();
}

class _SemanticToggleState extends State<SemanticToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _rotateAnimation =
        Tween<double>(begin: 0.0, end: 2 * 3.1416).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = findStatusColor(widget.type);
    final double height = _getHeightForSize(widget.size);
    final double width = height * 2.3;
    final bool isActive = widget.modelValue == widget.activeValue;

    if (isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    Widget textWidget = Text(
      isActive ? widget.activeText : widget.inactiveText,
      style: const TextStyle(color: Colors.white),
    );

    Widget iconWidget =
        isActive ? widget.activeActionIcon : widget.inactiveActionIcon;

    return GestureDetector(
      onTap: !widget.disabled ? widget.onToggle : null,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: widget.duration,
                curve: Curves.easeInOut,
                left: isActive ? width - widget.slideSize - 4 : 2,
                right: isActive ? 2 : width - widget.slideSize - 4,
                child: AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: child,
                    );
                  },
                  child: AnimatedContainer(
                    duration: widget.duration,
                    width: widget.slideSize,
                    height: widget.slideSize,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.black : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: widget.inlinePrompt ? iconWidget : Container(),
                  ),
                ),
              ),
              if (widget.inlinePrompt) ...[
                Positioned(
                  left: isActive ? 4 : width - widget.slideSize - 4,
                  child: textWidget,
                ),
              ] else ...[
                Center(child: textWidget),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double _getHeightForSize(SizeEnum size) {
    switch (size) {
      case SizeEnum.small:
        return 16;
      case SizeEnum.large:
        return 24;
      default:
        return 20;
    }
  }
}
