import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A labelled number with optional prefix, suffix and trend, after
/// `el-statistic`.
///
/// ```dart
/// WeStatistic(title: 'GMV', value: 128400, prefix: '¥', trend: 0.12)
/// WeStatistic(title: 'Orders', value: 1432, suffix: '笔', trend: -0.04)
/// ```
class WeStatistic extends StatelessWidget {
  const WeStatistic({
    super.key,
    required this.title,
    required this.value,
    this.prefix,
    this.suffix,
    this.precision,
    this.groupSeparator = ',',
    this.trend,
    this.trendLabel,
    this.valueColor,
    this.valueSize = 26,
    this.compact = false,
  });

  final String title;

  /// A number is formatted with [groupSeparator] and [precision]; any other
  /// object is shown with `toString`.
  final Object value;
  final String? prefix;
  final String? suffix;

  /// Decimal places for numeric values. Defaults to 0 for integers and 2 for
  /// doubles.
  final int? precision;
  final String groupSeparator;

  /// A fraction such as `0.12` for +12 %. Positive is green with an up arrow,
  /// negative red with a down arrow.
  final double? trend;

  /// Text after the trend, e.g. "vs last week".
  final String? trendLabel;
  final Color? valueColor;
  final double valueSize;

  /// Puts the title after the value in a single line, for dense tables.
  final bool compact;

  String _format() {
    final v = value;
    if (v is! num) return v.toString();
    final int digits = precision ?? (v is int ? 0 : 2);
    final String fixed = v.toStringAsFixed(digits);
    final parts = fixed.split('.');
    final buf = StringBuffer();
    final String whole = parts[0];
    for (int i = 0; i < whole.length; i++) {
      final int remaining = whole.length - i;
      buf.write(whole[i]);
      if (remaining > 1 && remaining % 3 == 1 && whole[i] != '-') {
        buf.write(groupSeparator);
      }
    }
    return parts.length > 1 ? '$buf.${parts[1]}' : buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color vc = valueColor ?? colors.primaryText;

    final Widget number = Text.rich(
      TextSpan(
        children: [
          if (prefix != null)
            TextSpan(
              text: prefix,
              style: TextStyle(
                fontSize: valueSize * 0.6,
                fontWeight: FontWeight.w500,
                color: vc.withValues(alpha: 0.8),
              ),
            ),
          TextSpan(
            text: _format(),
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.5,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: vc,
            ),
          ),
          if (suffix != null)
            TextSpan(
              text: ' $suffix',
              style: TextStyle(
                fontSize: valueSize * 0.5,
                fontWeight: FontWeight.w500,
                color: colors.secondaryText,
              ),
            ),
        ],
      ),
    );

    final Widget label = Text(
      title,
      style: TextStyle(fontSize: 13, color: colors.secondaryText),
    );

    Widget? trendRow;
    if (trend != null) {
      final bool up = trend! >= 0;
      final Color tc = up ? colors.success : colors.danger;
      trendRow = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(4, 2, 6, 2),
            decoration: BoxDecoration(
              color: tc.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  up
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12,
                  color: tc,
                ),
                Text(
                  '${(trend!.abs() * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tc,
                  ),
                ),
              ],
            ),
          ),
          if (trendLabel != null) ...[
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                trendLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: colors.placeholderText),
              ),
            ),
          ],
        ],
      );
    }

    final bool hasTitle = title.isNotEmpty;

    if (compact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 放进窄表格列时缩小数字，而不是溢出。
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: number,
            ),
          ),
          if (hasTitle) ...[
            const SizedBox(width: 6),
            Padding(padding: const EdgeInsets.only(bottom: 3), child: label),
          ],
          if (trendRow != null) ...[const SizedBox(width: 8), trendRow],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTitle) ...[label, const SizedBox(height: 6)],
        number,
        if (trendRow != null) ...[const SizedBox(height: 8), trendRow],
      ],
    );
  }
}
