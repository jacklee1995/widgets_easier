// 搜索结果项组件
import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const ResultItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item['title']),
      subtitle: Text(item['snippet']),
    );
  }
}
