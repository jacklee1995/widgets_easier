import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class CodeWidget extends StatefulWidget {
  final String codeStr;
  const CodeWidget(
    this.codeStr, {
    super.key,
  });

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('点击查看代码'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HighlightView(
            widget.codeStr,
            language: 'dart',
            theme: githubTheme,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
    );
  }
}
