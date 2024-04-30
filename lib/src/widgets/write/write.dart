import 'package:flutter/material.dart';

import '../images/picture.dart';

enum ListType {
  unordered,
  ordered,
}

abstract class ListContent {
  Widget build(BuildContext context);
}

class ListItem extends StatelessWidget {
  final String text;
  final List<Widget> children;

  const ListItem({
    super.key,
    required this.text,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        ...children,
      ],
    );
  }
}

class ListComponent extends StatelessWidget {
  final List<Widget> items;
  final ListType type;
  final int level;

  const ListComponent({
    super.key,
    required this.items,
    this.type = ListType.ordered,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++)
          _buildListItem(context, items[i], i),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Widget item, int index) {
    Widget prefix;
    if (item is ListItem) {
      if (type == ListType.ordered) {
        prefix = Text('${index + 1}. ',
            style: const TextStyle(fontWeight: FontWeight.bold));
      } else {
        prefix =
            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold));
      }

      return Padding(
        padding: EdgeInsets.only(left: level * 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                prefix,
                Expanded(child: Text(item.text)),
              ],
            ),
            if (item.children.isNotEmpty)
              ListComponent(
                items: item.children,
                type: type == ListType.ordered
                    ? ListType.ordered
                    : ListType.unordered,
                level: level + 1,
              ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: level * 20),
        child: item,
      );
    }
  }
}

class Write {
  static header1(title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        fontFamily: 'Arial',
      ),
    );
  }

  static header2(title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        fontFamily: 'Georgia',
      ),
    );
  }

  static header3(title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
        fontSize: 20,
        fontFamily: 'Verdana',
      ),
    );
  }

  static header4(title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        fontFamily: 'Courier New',
      ),
    );
  }

  static header5(title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.w300,
        fontSize: 16,
        fontFamily: 'Times New Roman',
      ),
    );
  }

  static header6(title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w200,
        fontSize: 14,
        fontFamily: 'Helvetica',
      ),
    );
  }

  static paragraph(text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      child: Text(
        '    $text',
        style: const TextStyle(
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  static Widget image({
    required String source,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.centerLeft,
    bool fillWidth = false,
    double borderRadius = 9.0, // 新增圆角大小参数，默认为0（无圆角）
  }) {
    Widget errorWidget = Image.asset(
      'assets/images/image_loading_failed.png',
      package: 'widgets_easier',
      width: 256,
      height: 256,
      fit: BoxFit.cover,
    );

    return Container(
      width: fillWidth ? double.infinity : null,
      alignment: alignment,
      child: ClipRRect(
        // 使用ClipRRect来应用圆角
        borderRadius: BorderRadius.circular(borderRadius), // 应用圆角大小
        child: Picture(
          source: source,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => errorWidget,
        ),
      ),
    );
  }

  static Widget orderedList(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: ListComponent(items: items, type: ListType.ordered),
    );
  }

  static Widget unorderedList(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: ListComponent(items: items, type: ListType.unordered),
    );
  }

  static ListItem listItem(String text, [List<Widget> children = const []]) {
    return ListItem(text: text, children: children);
  }
}
