import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A placeholder for a region with nothing to show, after `el-empty`.
///
/// ```dart
/// WeEmpty(description: 'No orders yet', action: WeButton(text: 'Create', ...))
/// ```
class WeEmpty extends StatelessWidget {
  const WeEmpty({
    super.key,
    this.description = 'No data',
    this.icon = Icons.inbox_outlined,
    this.image,
    this.imageSize = 96,
    this.action,
    this.padding = const EdgeInsets.symmetric(vertical: 40),
  });

  final String description;

  /// Drawn on a soft disc when [image] is `null`.
  final IconData icon;

  /// Custom illustration replacing the icon.
  final Widget? image;
  final double imageSize;

  /// A widget under the description, usually a [WeButton].
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image ??
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [colors.lightFill, colors.baseBackground],
                    stops: const [0.6, 1],
                  ),
                ),
                child: Icon(
                  icon,
                  size: imageSize * 0.42,
                  color: colors.placeholderText,
                ),
              ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: colors.secondaryText),
          ),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
