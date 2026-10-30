### 5. 标签

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

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

#### 5.7 可选中标签

有时候因为业务需求，我们可能会需要用到类似复选框的标签，但是按钮式的复选框的样式又不满足需求，此时我们就可以用到可选中标签 **CheckTag**（对应 Element Plus 的 `el-check-tag`）。

点击 CheckTag 会在选中与未选中之间切换：

- **选中**：正常标签外观，颜色由 `type`（或 `color`）与 `theme` 决定；
- **未选中**：浅灰色背景、无边框、灰色文字。

##### 基本用法

不传 `checked` 时组件自行维护状态，通过 `initialChecked` 指定初始值。共有三个回调：`onChanged` 在每次切换时收到新值；`onChecked` 与 `onUnchecked` 分别只在选中和取消选中时触发。

```dart
CheckTag('未选中'),
CheckTag('已选中', initialChecked: true),
CheckTag(
  '带回调',
  onChecked: () => print('checked'),
  onUnchecked: () => print('unchecked'),
  onChanged: (value) => print('changed: $value'),
),
CheckTag('带勾选图标', showCheckIcon: true, initialChecked: true),
```

##### 语义类型与主题

选中态的颜色默认为 `primary`，可通过 `type` 使用任意语义色，或用 `color` 指定自定义颜色；`theme` 同样支持 `plain`、`light`、`dark`，默认为 `light`。

```dart
CheckTag('success', initialChecked: true, type: SemanticEnum.success),
CheckTag('danger', initialChecked: true, type: SemanticEnum.danger),
CheckTag('plain', initialChecked: true, theme: TagThemeEnum.plain),
CheckTag('dark', initialChecked: true, theme: TagThemeEnum.dark),
```

##### 禁用

`disabled: true` 时不响应点击与键盘，并以淡化的颜色显示。

```dart
CheckTag('禁用未选中', disabled: true),
CheckTag('禁用已选中', disabled: true, initialChecked: true),
```

##### 受控用法

传入 `checked` 后组件进入受控模式：它只渲染你给的值，不会自行切换，在 `onChanged` 中更新状态并重建即可。下面用一组受控 CheckTag 实现多选筛选：

```dart
class CheckTagsExample extends StatefulWidget {
  const CheckTagsExample({super.key});

  @override
  State<CheckTagsExample> createState() => _CheckTagsExampleState();
}

class _CheckTagsExampleState extends State<CheckTagsExample> {
  static const List<String> _options = ['Flutter', 'Dart', 'Vue', 'Rust'];
  final Set<String> _selected = {'Flutter'};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in _options)
          CheckTag(
            option,
            checked: _selected.contains(option),
            showCheckIcon: true,
            onChanged: (checked) {
              setState(() {
                checked ? _selected.add(option) : _selected.remove(option);
              });
            },
          ),
      ],
    );
  }
}
```

##### 其它

- 尺寸相关参数 `size`、`height`、`width`、`radius`、`shrink` 与 Tag 一致；
- CheckTag 可获得焦点，按下空格或回车即可切换，并暴露正确的无障碍语义（`checked` 状态）；
- 选中与未选中之间的切换带有过渡动画。

