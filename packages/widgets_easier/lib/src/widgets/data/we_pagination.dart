import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../form/we_input.dart';
import '../form/we_select.dart';

/// Page controls for a list, after `el-pagination`.
///
/// Pages are 1-based. Give [total] and [pageSize]; the widget derives the
/// page count, collapses long runs with ellipses and optionally shows the
/// total, a page-size picker and a "go to" jumper.
///
/// ```dart
/// WePagination(
///   total: 486,
///   page: page,
///   pageSize: size,
///   onPageChanged: (p) => setState(() => page = p),
///   pageSizes: const [10, 20, 50],
///   onPageSizeChanged: (s) => setState(() { size = s; page = 1; }),
///   showTotal: true,
///   showJumper: true,
/// )
/// ```
///
/// Platform: desktop and web (pointer + keyboard, wide screen). On phones prefer [PaginationView].
class WePagination extends StatelessWidget {
  const WePagination({
    super.key,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    this.pageSizes,
    this.onPageSizeChanged,
    this.showTotal = false,
    this.showJumper = false,
    this.pagerCount = 7,
    this.small = false,
    this.background = true,
    this.totalBuilder,
    this.alignment = MainAxisAlignment.end,
  }) : assert(pagerCount >= 5 && pagerCount % 2 == 1);

  final int total;
  final int page;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  /// Offer these sizes in a picker. Requires [onPageSizeChanged].
  final List<int>? pageSizes;
  final ValueChanged<int>? onPageSizeChanged;
  final bool showTotal;
  final bool showJumper;

  /// Maximum number of page buttons shown at once; odd, at least 5.
  final int pagerCount;
  final bool small;

  /// Fill page buttons instead of drawing them as plain text.
  final bool background;

  /// Custom total text, e.g. `(n) => '共 $n 条'`.
  final String Function(int total)? totalBuilder;
  final MainAxisAlignment alignment;

  int get pageCount => total <= 0 ? 1 : (total / pageSize).ceil();

  List<int?> _pages() {
    final int n = pageCount;
    if (n <= pagerCount) return [for (int i = 1; i <= n; i++) i];
    final int half = (pagerCount - 2) ~/ 2;
    if (page <= half + 2) {
      return [for (int i = 1; i <= pagerCount - 2; i++) i, null, n];
    }
    if (page >= n - half - 1) {
      return [1, null, for (int i = n - pagerCount + 3; i <= n; i++) i];
    }
    return [
      1,
      null,
      for (int i = page - half + 1; i <= page + half - 1; i++) i,
      null,
      n,
    ];
  }

  @override
  Widget build(BuildContext context) {
    WePlatform.debugCheckFit(
      context,
      'WePagination',
      WePlatformFit.desktop,
      alternative: 'PaginationView（上拉加载）',
    );
    final we = WeTheme.of(context);
    final colors = we.colors;
    final double h = small ? 26 : 32;
    final double fs = small ? 12 : 13.5;
    final int n = pageCount;

    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (showTotal) ...[
          Text(
            totalBuilder?.call(total) ?? 'Total $total',
            style: TextStyle(fontSize: fs, color: colors.regularText),
          ),
          const SizedBox(width: 12),
        ],
        if (pageSizes != null) ...[
          WeSelect<int>(
            width: small ? 96 : 110,
            size: small ? SizeEnum.small : SizeEnum.defaultSize,
            value: pageSize,
            options: [
              for (final s in pageSizes!) WeSelectOption(s, '$s / page'),
            ],
            onChanged: (v) {
              if (v != null) onPageSizeChanged?.call(v);
            },
          ),
          const SizedBox(width: 12),
        ],
        _PageButton(
          height: h,
          background: background,
          enabled: page > 1,
          onTap: () => onPageChanged(page - 1),
          child: Icon(Icons.chevron_left_rounded, size: fs + 5),
        ),
        for (final p in _pages())
          if (p == null)
            SizedBox(
              width: h,
              child: Center(
                child: Icon(
                  Icons.more_horiz,
                  size: fs + 3,
                  color: colors.placeholderText,
                ),
              ),
            )
          else
            _PageButton(
              height: h,
              background: background,
              active: p == page,
              enabled: true,
              onTap: () => onPageChanged(p),
              child: Text('$p', style: TextStyle(fontSize: fs)),
            ),
        _PageButton(
          height: h,
          background: background,
          enabled: page < n,
          onTap: () => onPageChanged(page + 1),
          child: Icon(Icons.chevron_right_rounded, size: fs + 5),
        ),
        if (showJumper) ...[
          const SizedBox(width: 12),
          Text(
            'Go to',
            style: TextStyle(fontSize: fs, color: colors.regularText),
          ),
          const SizedBox(width: 6),
          WeInput(
            width: 56,
            size: small ? SizeEnum.small : SizeEnum.defaultSize,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: (v) {
              final int? p = int.tryParse(v);
              if (p != null) onPageChanged(p.clamp(1, n));
            },
          ),
        ],
      ],
    );
  }
}

class _PageButton extends StatefulWidget {
  const _PageButton({
    required this.height,
    required this.background,
    required this.enabled,
    required this.onTap,
    required this.child,
    this.active = false,
  });

  final double height;
  final bool background;
  final bool enabled;
  final bool active;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_PageButton> createState() => _PageButtonState();
}

class _PageButtonState extends State<_PageButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final Color fg = !widget.enabled
        ? colors.disabledText
        : widget.active
        ? (widget.background ? colors.onSemantic : colors.primary)
        : _hover
        ? colors.primary
        : colors.primaryText;
    final Color? bg = !widget.background
        ? null
        : widget.active
        ? colors.primary
        : colors.lightFill;

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: widget.height,
          constraints: BoxConstraints(minWidth: widget.height),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(we.radius.base),
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: fg),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: fg,
                fontWeight: widget.active ? FontWeight.w600 : FontWeight.w500,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
