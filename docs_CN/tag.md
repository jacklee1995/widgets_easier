### 5. 标签

#### 5.1 语义类型

通过Tag组件的`type`参数可以使用一个语义性色彩。例如：

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', type: SemanticEnum.primary),
    Tag('tag', type: SemanticEnum.secondary),
    Tag('tag', type: SemanticEnum.info),
    Tag('tag', type: SemanticEnum.success),
    Tag('tag', type: SemanticEnum.warning),
    Tag('tag', type: SemanticEnum.danger),
    Tag('tag', type: SemanticEnum.fatal),
  ],
),
```

![example_RLfAZpHGRt](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_RLfAZpHGRt.png)

#### 5.2 样式主题

受启发与Element-plus，**Tag**有3个样式主题，`plain`、`light`和`dark`，默认情况下为`palin`，正如上一节所展示的那样。下面展示`light`和`dark`两个主题：



##### light

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.primary),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.secondary),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.info),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.success),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.warning),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.danger),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.fatal),
  ],
),
```

![example_uLVBhrUyBl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uLVBhrUyBl.png)



##### dark

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.primary),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.secondary),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.info),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.success),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.warning),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.danger),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.fatal),
  ],
),
```

![example_4GWiRl3tzL](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4GWiRl3tzL.png)



#### 5.3 圆角

默认有一个大小为4的圆角，若要手动修改可以通过指定radius参数。radius参数接受一个double值。例如，设置radius为0则没有圆角：

```dart
Tag('radius: 0', radius: 0),
```

![example_WCSxzzhhjE](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_WCSxzzhhjE.png)



#### 5.4 尺寸



##### 枚举尺寸

例如：

```dart
Tag('SizeEnum.small', size: SizeEnum.small),
Tag('SizeEnum.defaultSize', size: SizeEnum.defaultSize),
Tag('SizeEnum.large', size: SizeEnum.large),
```



##### 数值尺寸

通过height参数可以指定数值作为尺寸。height一经指定，则size失效。例如，指定高度为50：

```dart
Tag('hignt=50', height: 50),
```

![example_0yBhql2v2F](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0yBhql2v2F.png)

##### 收缩属性

通过指定shrink属性为flase，可以使一个标签尽可能占满一行，例如：

```dart
Tag('shrink: false', shrink: false)
```

![example_sonRhtEJqj](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_sonRhtEJqj.png)

#### 5.5 可关闭标签

通过指定 closable: true，将展示一个关闭图标。例如：

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', closable: true, type: SemanticEnum.primary),
    Tag('tag', closable: true, type: SemanticEnum.secondary),
    Tag('tag', closable: true, type: SemanticEnum.info),
    Tag('tag', closable: true, type: SemanticEnum.success),
    Tag('tag', closable: true, type: SemanticEnum.warning),
    Tag('tag', closable: true, type: SemanticEnum.danger),
    Tag('tag', closable: true, type: SemanticEnum.fatal),
  ],
),
```

![example_HJgxs2Vv3O](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_HJgxs2Vv3O.gif)



#### 5.6 动态编辑标签示例



可以通过点击标签关闭按钮后触发的 onClose 事件来实现动态编辑标签。例如：

```dart
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
        Text('$_tags'),
        for (int index = 0; index < _tags.length; index++)
          Tag(
            key: UniqueKey(), // 重要
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
```

效果如下：
![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/cea33e4f5e9f46d5a148d886959c6d32.gif)

