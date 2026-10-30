import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../feedback/we_empty.dart';
import '../feedback/we_loading.dart';
import '../feedback/we_skeleton.dart';
import '../form/we_checkbox.dart';

/// One column of a [WeTable].
///
/// Give either a fixed [width] or a [flex] share of the remaining width.
class WeColumn<T> {
  const WeColumn({
    required this.title,
    required this.cell,
    this.width,
    this.flex = 1,
    this.align = Alignment.centerLeft,
    this.sortBy,
    this.headerTooltip,
  });

  final String title;

  /// Builds the cell for a row.
  final Widget Function(BuildContext context, T row) cell;
  final double? width;
  final int flex;
  final AlignmentGeometry align;

  /// Makes the column sortable by the returned key.
  final Comparable<Object?> Function(T row)? sortBy;
  final String? headerTooltip;

  /// A text column; the common case.
  static WeColumn<T> text<T>(
    String title,
    String Function(T row) value, {
    double? width,
    int flex = 1,
    AlignmentGeometry align = Alignment.centerLeft,
    Comparable<Object?> Function(T row)? sortBy,
    TextStyle? style,
  }) => WeColumn<T>(
    title: title,
    width: width,
    flex: flex,
    align: align,
    sortBy: sortBy,
    cell: (ctx, row) => Text(
      value(row),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    ),
  );
}

/// A data table with typed columns, row selection, striping, hover, sorting
/// and an empty state, after `el-table`.
///
/// ```dart
/// WeTable<Order>(
///   rows: orders,
///   selectable: true,
///   selected: picked,
///   onSelectionChanged: (s) => setState(() => picked = s),
///   columns: [
///     WeColumn.text('No.', (o) => o.id, width: 120),
///     WeColumn(title: 'Status', width: 100, cell: (_, o) => Tag(text: o.status)),
///     WeColumn.text('Amount', (o) => '¥${o.amount}', align: Alignment.centerRight, sortBy: (o) => o.amount),
///   ],
/// )
/// ```
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones prefer [WeDescriptions] or a list of cards.
class WeTable<T> extends StatefulWidget {
  const WeTable({
    super.key,
    required this.columns,
    required this.rows,
    this.selectable = false,
    this.selected,
    this.onSelectionChanged,
    this.onRowTap,
    this.striped = false,
    this.bordered = false,
    this.hover = true,
    this.showHeader = true,
    this.size = SizeEnum.defaultSize,
    this.rowHeight,
    this.maxHeight,
    this.empty,
    this.emptyText = 'No data',
    this.loading = false,
    this.loadingText,
    this.footer,
    this.rowKey,
    this.rowColor,
  });

  final List<WeColumn<T>> columns;
  final List<T> rows;

  /// Adds a checkbox column. Requires [selected] and [onSelectionChanged].
  final bool selectable;
  final Set<T>? selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final void Function(T row)? onRowTap;

  /// Alternate row backgrounds.
  final bool striped;

  /// Vertical rules between columns and an outer frame.
  final bool bordered;

  /// Highlight rows under the pointer.
  final bool hover;
  final bool showHeader;
  final SizeEnum size;

  /// Overrides the size-derived row height.
  final double? rowHeight;

  /// Scroll the body when it exceeds this height; the header stays put.
  final double? maxHeight;

  /// Custom empty state; defaults to a [WeEmpty] with [emptyText].
  final Widget? empty;
  final String emptyText;

  /// With no rows yet, shows skeleton rows; with rows, keeps them and lays a
  /// [WeLoading] mask over them so a refresh does not make the table jump.
  final bool loading;

  /// Text under the spinner of the refresh mask.
  final String? loadingText;

  /// A widget below the body, e.g. a [WePagination].
  final Widget? footer;

  /// Stable identity for rows; defaults to the row itself.
  final Object Function(T row)? rowKey;

  /// Tints a row, e.g. to flag an error.
  final Color? Function(T row)? rowColor;

  @override
  State<WeTable<T>> createState() => _WeTableState<T>();
}

class _WeTableState<T> extends State<WeTable<T>> {
  int? _sortIndex;
  bool _ascending = true;
  int? _hoverRow;

  List<T> get _sortedRows {
    if (_sortIndex == null) return widget.rows;
    final key = widget.columns[_sortIndex!].sortBy;
    if (key == null) return widget.rows;
    final list = [...widget.rows];
    list.sort((a, b) {
      final int c = key(a).compareTo(key(b));
      return _ascending ? c : -c;
    });
    return list;
  }

  void _toggleSort(int index) {
    setState(() {
      if (_sortIndex == index) {
        if (_ascending) {
          _ascending = false;
        } else {
          _sortIndex = null;
          _ascending = true;
        }
      } else {
        _sortIndex = index;
        _ascending = true;
      }
    });
  }

  bool _isSelected(T row) => widget.selected?.contains(row) ?? false;

  void _setSelected(T row, bool on) {
    final next = {...?widget.selected};
    on ? next.add(row) : next.remove(row);
    widget.onSelectionChanged?.call(next);
  }

  void _selectAll(bool on) {
    widget.onSelectionChanged?.call(on ? {...widget.rows} : <T>{});
  }

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WeTable',
      WePlatformFit.desktop,
      alternative: 'WeDescriptions 或列表卡片',
    );
    final we = WeTheme.of(context);
    final colors = we.colors;
    final metrics = we.sizes.control(widget.size);
    final double rowH = widget.rowHeight ?? metrics.height + 16;
    final double hPad = metrics.horizontalPadding * 0.75;
    final rows = _sortedRows;

    final BorderSide rule = BorderSide(color: colors.lighterBorder);

    final Widget header = Container(
      height: rowH - 4,
      decoration: BoxDecoration(
        color: colors.lightFill.withValues(alpha: 0.6),
        border: Border(bottom: rule),
      ),
      child: Row(
        children: [
          if (widget.selectable)
            _cellBox(
              width: 48,
              hPad: hPad,
              bordered: widget.bordered,
              rule: rule,
              child: WeCheckbox(
                size: widget.size,
                value: widget.rows.isEmpty
                    ? false
                    : (widget.selected?.length ?? 0) == widget.rows.length
                    ? true
                    : (widget.selected?.isEmpty ?? true)
                    ? false
                    : null,
                onChanged: _selectAll,
              ),
            ),
          for (int i = 0; i < widget.columns.length; i++)
            _cellBox(
              width: widget.columns[i].width,
              flex: widget.columns[i].flex,
              hPad: hPad,
              bordered: widget.bordered && i != widget.columns.length - 1,
              rule: rule,
              align: widget.columns[i].align,
              child: _HeaderCell(
                column: widget.columns[i],
                fontSize: metrics.fontSize - 1,
                sorted: _sortIndex == i,
                ascending: _ascending,
                onSort: widget.columns[i].sortBy == null
                    ? null
                    : () => _toggleSort(i),
              ),
            ),
        ],
      ),
    );

    Widget body;
    if (widget.loading && rows.isEmpty) {
      body = Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
        child: Column(
          children: [
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: WeSkeleton.block(height: rowH * 0.45),
              ),
          ],
        ),
      );
    } else if (rows.isEmpty) {
      body = widget.empty ?? WeEmpty(description: widget.emptyText);
    } else {
      body = Column(
        children: [
          for (int r = 0; r < rows.length; r++)
            _row(
              context,
              rows[r],
              r,
              rowH,
              hPad,
              rule,
              last: r == rows.length - 1,
            ),
        ],
      );
      if (widget.maxHeight != null) {
        body = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: widget.maxHeight!),
          child: SingleChildScrollView(child: body),
        );
      }
      body = WeLoading(
        loading: widget.loading,
        text: widget.loadingText,
        child: body,
      );
    }

    Widget table = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showHeader) header,
        body,
        if (widget.footer != null) ...[
          Container(height: 1, color: colors.lighterBorder),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
            child: widget.footer!,
          ),
        ],
      ],
    );

    if (widget.bordered) {
      table = Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: colors.lighterBorder),
          borderRadius: BorderRadius.circular(we.radius.base * 2),
        ),
        child: table,
      );
    }
    return table;
  }

  Widget _row(
    BuildContext context,
    T row,
    int index,
    double height,
    double hPad,
    BorderSide rule, {
    required bool last,
  }) {
    final colors = context.weColors;
    final bool selected = _isSelected(row);
    final bool hovered = widget.hover && _hoverRow == index;
    final Color? custom = widget.rowColor?.call(row);
    final Color bg = selected
        ? colors.light(SemanticEnum.primary, 9)
        : hovered
        ? colors.lightFill.withValues(alpha: 0.7)
        : custom ??
              (widget.striped && index.isOdd
                  ? colors.lighterFill
                  : Colors.transparent);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverRow = index),
      onExit: (_) => setState(() => _hoverRow = null),
      cursor: widget.onRowTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onRowTap == null ? null : () => widget.onRowTap!(row),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: height,
          decoration: BoxDecoration(
            color: bg,
            border: last && !widget.bordered ? null : Border(bottom: rule),
          ),
          child: Row(
            children: [
              if (widget.selectable)
                _cellBox(
                  width: 48,
                  hPad: hPad,
                  bordered: widget.bordered,
                  rule: rule,
                  child: WeCheckbox(
                    size: widget.size,
                    value: selected,
                    onChanged: (v) => _setSelected(row, v),
                  ),
                ),
              for (int i = 0; i < widget.columns.length; i++)
                _cellBox(
                  width: widget.columns[i].width,
                  flex: widget.columns[i].flex,
                  hPad: hPad,
                  bordered: widget.bordered && i != widget.columns.length - 1,
                  rule: rule,
                  align: widget.columns[i].align,
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: context.weTheme.sizes
                          .control(widget.size)
                          .fontSize,
                      color: colors.regularText,
                    ),
                    child: widget.columns[i].cell(context, row),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cellBox({
    double? width,
    int flex = 1,
    required double hPad,
    required bool bordered,
    required BorderSide rule,
    AlignmentGeometry align = Alignment.centerLeft,
    required Widget child,
  }) {
    final Widget cell = Container(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      alignment: align,
      decoration: bordered ? BoxDecoration(border: Border(right: rule)) : null,
      child: child,
    );
    if (width != null) return SizedBox(width: width, child: cell);
    return Expanded(flex: flex, child: cell);
  }
}

class _HeaderCell<T> extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.fontSize,
    required this.sorted,
    required this.ascending,
    required this.onSort,
  });

  final WeColumn<T> column;
  final double fontSize;
  final bool sorted;
  final bool ascending;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    Widget label = Text(
      column.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: sorted ? colors.primary : colors.secondaryText,
      ),
    );
    if (column.headerTooltip != null) {
      label = Tooltip(message: column.headerTooltip!, child: label);
    }
    if (onSort == null) return label;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onSort,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: label),
            const SizedBox(width: 2),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_drop_up,
                  size: 14,
                  color: sorted && ascending
                      ? colors.primary
                      : colors.placeholderText,
                ),
                Transform.translate(
                  offset: const Offset(0, -7),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 14,
                    color: sorted && !ascending
                        ? colors.primary
                        : colors.placeholderText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
