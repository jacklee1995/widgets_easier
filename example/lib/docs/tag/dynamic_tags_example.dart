import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class DynamicTagsExample extends StatefulWidget {
  const DynamicTagsExample({super.key});

  @override
  State<DynamicTagsExample> createState() => _DynamicTagsExampleState();
}

class _DynamicTagsExampleState extends State<DynamicTagsExample> {
  final List<String> _tags = ['Tag 1', 'Tag 2', 'Tag 3']; // 初始标签列表
  final TextEditingController _textController = TextEditingController();
  bool _isInputVisible = false; // 控制文本输入框的显示与隐藏

  // 处理移除标签的函数
  void _handleClose(String tag) {
    setState(() {
      _tags.remove(tag); // 从列表中移除标签
    });
  }

  // 显示文本输入框的函数
  void _showInput() {
    setState(() {
      _isInputVisible = true; // 设置输入框为可见
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode()); // 输入框可见后自动聚焦
    });
  }

  // 处理输入确认的函数
  void _handleInputConfirm() {
    if (_textController.text.isNotEmpty) {
      // 检查文本输入是否非空
      setState(() {
        _tags.add(_textController.text); // 将新标签添加到列表中
        _textController.clear(); // 清空文本输入框
        _isInputVisible = false; // 隐藏文本输入框
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // 子元素之间的水平间距
      runSpacing: 8, // 行之间的垂直间距
      children: [
        ..._tags.map((tag) => Tag(
              tag,
              closable: true, // 标签可关闭
              onClose: () => _handleClose(tag), // 关闭标签时调用的函数
              size: SizeEnum.small, // 标签的大小
            )),
        // 显示输入框
        if (_isInputVisible)
          SizedBox(
            width: 100, // 文本输入框的宽度
            child: TextField(
              controller: _textController,
              onSubmitted: (_) => _handleInputConfirm(), // 提交输入时调用的函数
              decoration: const InputDecoration(
                hintText: 'New Tag', // 输入框的占位文字
                contentPadding: EdgeInsets.symmetric(horizontal: 8), // 输入框内的填充
              ),
            ),
          )
        else
          Tag(
            '+ New Tag',
            onTap: _showInput,
          ),
      ],
    );
  }
}
