import 'package:example/widgets/docs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'animate_examples.dart';

class AnimationDocs extends StatefulWidget {
  const AnimationDocs({super.key});

  @override
  State<AnimationDocs> createState() => _AnimationDocsState();
}

class _AnimationDocsState extends State<AnimationDocs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header2('1. 安装'),
        Write.paragraph('Widgets Easy动画在独立的动画库中，它包含了多种常用动画。你可以通过运行下面的方法进行安装：'),
        HighlightView(
          'flutter pub add flutter_easy_animations',
          language: 'bash',
          theme: vs2015Theme,
          padding: const EdgeInsets.all(12),
        ),
        Write.header2('2. 用法'),
        Write.header3('2.1 导入'),
        Write.paragraph('在你的代码中先导入flutter_easy_animations库：'),
        HighlightView(
          'import \'package:flutter_easy_animations/flutter_easy_animations.dart\';',
          language: 'dart',
          theme: vs2015Theme,
          padding: const EdgeInsets.all(12),
        ),
        Write.header3('2.2 AnimateStyles类'),
        Write.paragraph(
            'AnimateStyles类以静态成员的方式提供了多个动画效果。考虑到 https://animate.style/ 中（即Animate.css）中的动画为前端开发者所熟知，这里对该前端动画效果完整给出了对应的Flutter端实现并进行了一定程度的拓展。下面的代码展示了如何为子元素添加动画效果：'),
        HighlightView(
          '''AnimateStyles.zoomIn(
  _controller,
  Container(
    decoration: const BoxDecoration(color: Colors.red),
    width: 100,
    height: 100,
  ),
)''',
          language: 'dart',
          theme: vs2015Theme,
          padding: const EdgeInsets.all(12),
        ),
        Write.paragraph(
            '上面的代码中，_controller表示一个Flutter动画控制器（AnimationController）实例，代码的预览效果如下：'),
        Align(
          alignment: Alignment.center,
          child: AnimateStyles.zoomIn(
            _controller,
            Container(
              decoration: const BoxDecoration(color: Colors.red),
              width: 100,
              height: 100,
            ),
          ),
        ),
        Write.paragraph('为了使用不同的动画效果，你只需要使用不同的动画名称，下面的各个动画文本展示了对应于自生的动画预览效果：'),
        const AnimateExamples(),
      ],
    );
  }
}
