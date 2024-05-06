import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class DynamicTagsExample extends StatefulWidget {
  const DynamicTagsExample({super.key});

  @override
  State<DynamicTagsExample> createState() => _DynamicTagsExampleState();
}

class _DynamicTagsExampleState extends State<DynamicTagsExample> {
  final List<String> _tags = ['Tag 1', 'Tag 2', 'Tag 3'];
  final String _newTagButtonText = '+ 添加 Tag';

  void _handleClose(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _tags.add(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int index = 0; index < _tags.length; index++)
          Tag(
            // key: UniqueKey(),
            _tags[index],
            type: SemanticEnum.primary,
            theme: TagThemeEnum.light,
            closable: true,
            onClose: (_) {
              _handleClose(index);
            },
          ),
        Tag(
          _newTagButtonText,
          type: SemanticEnum.danger,
          editable: true,
          restoreAfterSubmitted: true,
          onSubmitted: _handleSubmitted,
        ),
      ],
    );
  }
}
