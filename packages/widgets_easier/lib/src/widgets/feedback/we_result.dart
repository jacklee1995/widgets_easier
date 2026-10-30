import 'package:flutter/material.dart';

import '../../core/core.dart';
import 'we_alert.dart';

/// The outcome of an operation, centred with a big icon, after `el-result`.
///
/// ```dart
/// WeResult(
///   type: SemanticEnum.success,
///   title: 'Order shipped',
///   subtitle: 'Tracking number SF1234567890',
///   actions: [WeButton(text: 'Back', onPressed: pop)],
/// )
/// ```
class WeResult extends StatelessWidget {
  const WeResult({
    super.key,
    required this.title,
    this.subtitle,
    this.type = SemanticEnum.info,
    this.icon,
    this.actions = const [],
    this.extra,
    this.padding = const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
  });

  final String title;
  final String? subtitle;
  final SemanticEnum type;
  final IconData? icon;

  /// Buttons under the text.
  final List<Widget> actions;

  /// Any extra content below the actions.
  final Widget? extra;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Color accent = colors.semantic(type);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.light(type, 9),
              border: Border.all(color: colors.light(type, 7), width: 2),
            ),
            child: Icon(icon ?? WeAlert.iconFor(type), size: 40, color: accent),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.primaryText,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: colors.secondaryText,
              ),
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: actions,
            ),
          ],
          if (extra != null) ...[const SizedBox(height: 20), extra!],
        ],
      ),
    );
  }
}
