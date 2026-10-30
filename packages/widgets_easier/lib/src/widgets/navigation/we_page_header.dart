import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'we_breadcrumb.dart';

/// A page title row after `el-page-header`.
///
/// ```dart
/// WePageHeader(
///   title: '经营概览',
///   description: '数据延迟约 5 分钟',
///   actions: [WeButton(text: '导出')],
/// )
/// ```
class WePageHeader extends StatelessWidget {
  const WePageHeader({
    super.key,
    required this.title,
    this.description,
    this.actions = const [],
    this.tag,
    this.onBack,
    this.icon,
    this.breadcrumb,
    this.extra,
    this.content,
  });

  final String title;
  final String? description;
  final List<Widget> actions;
  final Widget? tag;
  final VoidCallback? onBack;
  final IconData? icon;
  final List<WeBreadcrumbItem>? breadcrumb;
  final Widget? extra;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (breadcrumb != null && breadcrumb!.isNotEmpty) ...[
          WeBreadcrumb(items: breadcrumb!),
          const SizedBox(height: 10),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (onBack != null) ...[
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: '返回',
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
            ],
            if (icon != null) ...[
              Icon(icon, size: 22, color: colors.primary),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: colors.primaryText,
                          ),
                        ),
                      ),
                      if (tag != null) ...[const SizedBox(width: 10), tag!],
                    ],
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ?extra,
            if (actions.isNotEmpty)
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: actions,
              ),
          ],
        ),
        if (content != null) ...[const SizedBox(height: 12), content!],
      ],
    );
  }
}
