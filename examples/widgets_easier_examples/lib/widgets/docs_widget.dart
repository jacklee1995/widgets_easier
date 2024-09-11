import 'package:flutter/material.dart';

class DocsWidget extends StatefulWidget {
  final List<Widget> children;
  const DocsWidget({
    super.key,
    this.children = const [],
  });

  @override
  State<DocsWidget> createState() => _DocsWidgetState();
}

class _DocsWidgetState extends State<DocsWidget> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(isExpanded ? '关闭文档' : '展开文档'),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      initiallyExpanded: isExpanded,
      children: widget.children,
    );
  }
}
