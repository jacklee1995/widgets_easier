import 'package:flutter/material.dart';

import '../../core/core.dart';

/// One label/value pair of a [WeDescriptions].
class WeDescriptionItem {
  const WeDescriptionItem(this.label, this.value, {this.span = 1, this.child});

  final String label;
  final String value;

  /// How many columns the item occupies.
  final int span;

  /// A widget instead of [value].
  final Widget? child;
}

/// A grid of labelled values for showing one record, after `el-descriptions`.
///
/// ```dart
/// WeDescriptions(
///   title: 'Order',
///   columns: 3,
///   bordered: true,
///   items: const [
///     WeDescriptionItem('No.', 'SO20240918001'),
///     WeDescriptionItem('Buyer', 'Alice'),
///     WeDescriptionItem('Address', '…', span: 3),
///   ],
/// )
/// ```
class WeDescriptions extends StatelessWidget {
  const WeDescriptions({
    super.key,
    required this.items,
    this.title,
    this.extra,
    this.columns = 3,
    this.bordered = false,
    this.size = SizeEnum.defaultSize,
    this.labelWidth,
    this.vertical = false,
  });

  final List<WeDescriptionItem> items;
  final String? title;
  final Widget? extra;
  final int columns;

  /// Cell grid lines with a tinted label column.
  final bool bordered;
  final SizeEnum size;

  /// Fixed label width in bordered mode; otherwise labels size to content.
  final double? labelWidth;

  /// Label above value instead of beside it.
  final bool vertical;

  List<List<WeDescriptionItem>> _rows() {
    final rows = <List<WeDescriptionItem>>[];
    var row = <WeDescriptionItem>[];
    int used = 0;
    for (final it in items) {
      final int span = it.span.clamp(1, columns);
      if (used + span > columns) {
        rows.add(row);
        row = [];
        used = 0;
      }
      row.add(it);
      used += span;
      if (used == columns) {
        rows.add(row);
        row = [];
        used = 0;
      }
    }
    if (row.isNotEmpty) rows.add(row);
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final double fs = we.sizes.control(size).fontSize;
    final double pad = switch (size) {
      SizeEnum.large => 14,
      SizeEnum.defaultSize => 11,
      SizeEnum.small => 8,
    };
    final rows = _rows();

    Widget cellLabel(WeDescriptionItem it) => Text(
      it.label,
      style: TextStyle(
        fontSize: fs,
        fontWeight: bordered ? FontWeight.w600 : FontWeight.w400,
        color: bordered ? colors.regularText : colors.secondaryText,
      ),
    );
    Widget cellValue(WeDescriptionItem it) =>
        it.child ??
        Text(
          it.value,
          style: TextStyle(fontSize: fs, color: colors.primaryText),
        );

    Widget body;
    if (bordered) {
      final BorderSide side = BorderSide(color: colors.lighterBorder);
      final double lw = labelWidth ?? 120;
      body = Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: colors.lighterBorder),
          borderRadius: BorderRadius.circular(we.radius.base),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int r = 0; r < rows.length; r++)
              Container(
                decoration: BoxDecoration(
                  border: r == rows.length - 1 ? null : Border(bottom: side),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int c = 0; c < rows[r].length; c++)
                        Expanded(
                          flex: rows[r][c].span.clamp(1, columns),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: lw,
                                padding: EdgeInsets.symmetric(
                                  horizontal: pad,
                                  vertical: pad,
                                ),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: colors.lightFill.withValues(
                                    alpha: 0.6,
                                  ),
                                  border: Border(right: side),
                                ),
                                child: cellLabel(rows[r][c]),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: pad,
                                    vertical: pad,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: c == rows[r].length - 1
                                        ? null
                                        : Border(right: side),
                                  ),
                                  child: cellValue(rows[r][c]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      for (
                        int k = rows[r].fold<int>(
                          0,
                          (a, b) => a + b.span.clamp(1, columns),
                        );
                        k < columns;
                        k++
                      )
                        const Spacer(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final row in rows)
            Padding(
              padding: EdgeInsets.only(bottom: pad),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final it in row)
                    Expanded(
                      flex: it.span.clamp(1, columns),
                      child: vertical
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cellLabel(it),
                                const SizedBox(height: 4),
                                cellValue(it),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cellLabel(it),
                                Text(
                                  ': ',
                                  style: TextStyle(
                                    fontSize: fs,
                                    color: colors.secondaryText,
                                  ),
                                ),
                                Expanded(child: cellValue(it)),
                              ],
                            ),
                    ),
                  for (
                    int k = row.fold<int>(
                      0,
                      (a, b) => a + b.span.clamp(1, columns),
                    );
                    k < columns;
                    k++
                  )
                    const Spacer(),
                ],
              ),
            ),
        ],
      );
    }

    if (title == null && extra == null) return body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: fs + 2,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryText,
                    ),
                  ),
                )
              else
                const Spacer(),
              ?extra,
            ],
          ),
        ),
        body,
      ],
    );
  }
}
