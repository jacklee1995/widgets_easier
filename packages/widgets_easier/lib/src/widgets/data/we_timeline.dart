import 'package:flutter/material.dart';

import '../../core/core.dart';

/// One event of a [WeTimeline].
class WeTimelineItem {
  const WeTimelineItem({
    required this.title,
    this.timestamp,
    this.description,
    this.child,
    this.type,
    this.color,
    this.icon,
    this.hollow = false,
    this.size = 12,
  });

  final String title;
  final String? timestamp;
  final String? description;

  /// Rich content under the title, instead of or after [description].
  final Widget? child;

  /// Colours the node. `null` uses the neutral border colour.
  final SemanticEnum? type;
  final Color? color;

  /// Icon inside the node; the node grows to fit it.
  final IconData? icon;

  /// Ring instead of a filled dot.
  final bool hollow;
  final double size;
}

/// A vertical list of dated events, after `el-timeline`.
///
/// ```dart
/// WeTimeline(items: [
///   WeTimelineItem(title: 'Order placed', timestamp: '09:12', type: SemanticEnum.primary),
///   WeTimelineItem(title: 'Paid', timestamp: '09:13', type: SemanticEnum.success),
///   WeTimelineItem(title: 'Shipped', timestamp: '14:40', hollow: true),
/// ])
/// ```
class WeTimeline extends StatelessWidget {
  const WeTimeline({
    super.key,
    required this.items,
    this.timestampOnTop = false,
    this.reverse = false,
  });

  final List<WeTimelineItem> items;

  /// Timestamp above the title instead of below.
  final bool timestampOnTop;

  /// Newest first.
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final list = reverse ? items.reversed.toList() : items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < list.length; i++)
          _Row(
            item: list[i],
            last: i == list.length - 1,
            timestampOnTop: timestampOnTop,
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.item,
    required this.last,
    required this.timestampOnTop,
  });

  final WeTimelineItem item;
  final bool last;
  final bool timestampOnTop;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color node =
        item.color ??
        (item.type != null ? colors.semantic(item.type!) : colors.lightBorder);
    final double d = item.icon != null ? item.size + 8 : item.size;
    const double gutter = 28;

    final Widget stamp = item.timestamp == null
        ? const SizedBox.shrink()
        : Text(
            item.timestamp!,
            style: TextStyle(fontSize: 12, color: colors.secondaryText),
          );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: gutter,
            child: Column(
              children: [
                const SizedBox(height: 3),
                Container(
                  width: d,
                  height: d,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.hollow ? colors.baseBackground : node,
                    border: item.hollow
                        ? Border.all(color: node, width: 2)
                        : null,
                  ),
                  child: item.icon != null
                      ? Icon(
                          item.icon,
                          size: item.size,
                          color: item.hollow ? node : colors.onSemantic,
                        )
                      : null,
                ),
                if (!last)
                  Expanded(
                    child: Container(width: 2, color: colors.lighterBorder),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (timestampOnTop && item.timestamp != null) ...[
                    stamp,
                    const SizedBox(height: 4),
                  ],
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.primaryText,
                    ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: colors.regularText,
                      ),
                    ),
                  ],
                  if (item.child != null) ...[
                    const SizedBox(height: 8),
                    item.child!,
                  ],
                  if (!timestampOnTop && item.timestamp != null) ...[
                    const SizedBox(height: 6),
                    stamp,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
