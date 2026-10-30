import 'package:flutter/material.dart';

import '../../../core/core.dart';

/// The command bar of a [WinStyleDialog]: a tinted strip with right-aligned
/// buttons, the way desktop dialogs lay them out.
class WinStyleInfoDialogFooter extends StatelessWidget {
  const WinStyleInfoDialogFooter({
    super.key,
    required this.actions,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.spacing = 10,
  });

  final List<Widget> actions;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;
    if (actions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.lightFill,
        border: Border(top: BorderSide(color: colors.lighterBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            actions[i],
          ],
        ],
      ),
    );
  }
}
