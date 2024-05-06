import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class DynamicTagsExample extends StatefulWidget {
  const DynamicTagsExample({super.key});

  @override
  State<DynamicTagsExample> createState() => _DynamicTagsExampleState();
}

class _DynamicTagsExampleState extends State<DynamicTagsExample> {
  final List<String> _tags = ['Tag 1', 'Tag 2', 'Tag 3'];

  void _handleTagClose(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _handleTagTextChanged(String oldText, String newText) {
    setState(() {
      final index = _tags.indexOf(oldText);
      if (index != -1) {
        _tags[index] = newText;
      }
    });
  }

  void _handleAddTag() {
    setState(() {
      _tags.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._tags.asMap().entries.map((entry) {
          final index = entry.key;
          final tag = entry.value;
          final isLastTag = index == _tags.length - 1;

          return Tag(
            tag.isEmpty && isLastTag ? 'New Tag' : tag,
            closable: tag.isNotEmpty,
            onClose: () => _handleTagClose(tag),
            editable: isLastTag,
            onTextChanged: _handleTagTextChanged,
            onTap: isLastTag && tag.isEmpty ? null : () {},
          );
        }),
        Tag(
          '+',
          onTap: _handleAddTag,
          theme: TagThemeEnum.plain,
        ),
      ],
    );
  }
}
