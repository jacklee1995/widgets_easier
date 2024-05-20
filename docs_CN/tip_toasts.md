

### 10. 提示吐丝

#### 10.1 TipToasts工具简介

**TipToasts** 是一个用于在 **Flutter** 应用中显示提示消息的工具类，是一种最简单的吐丝。它提供了一种简单而灵活的方式来在屏幕的不同位置显示短暂的提示信息，并支持自定义动画效果和样式。**TipToast** 适用各种需要简单提示性的场景：

1. 显示操作成功或失败的提示信息；
2. 向用户提供通知或警告；
3. 在用户执行特定操作后给予反馈；
4. 显示临时的状态信息。

TipToasts 提供了几个静态方法来显示提示消息，分别是`toCenter`、`toTop`和`toBottom`。

#### 10.2 toCenter方法

```dart
static void toCenter(
  BuildContext context,
  String message, {
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})
```

toCenter方法是一个静态方法，该方法用于在屏幕中央显示提示消息，包含以下参数：

- context: 构建上下文；
- message: 要显示的文本消息；
- opacity：背景透明度，默认为 0.7；
- backgroundColor：背景颜色，默认为黑色；
- textStyle：文本样式，默认为白色字体，字号为 16；
- messageStyle: 消息文本的样式；
- maxWidth: 提示消息的最大宽度，默认为 200。


例如：

```dart
SemanticButton(
  shrink: true,
  text: 'toCenter',
  onTap: () => TipToasts.toCenter(context, 'toCenter'),
)
```

![example_JskzbjcvBA](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_JskzbjcvBA.gif)



#### 10.3 toTop方法

该方法用于在屏幕顶部显示提示消息，并可以指定垂直偏移量。

```dart
static void toTop(
  BuildContext context,
  String message, {
  double offset = 100,
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})
```

其中参数offset表示从屏幕顶部的垂直偏移量，默认为 100，其他参数与 toCenter 方法相同。

例如：

```dart
SemanticButton(
  shrink: true,
  text: 'toTop',
  onTap: () => TipToasts.toTop(context, 'toTop'),
)
```

![example_NznGSg2hm0](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_NznGSg2hm0.gif)



#### 10.4 toBottom 方法

该方法用于在屏幕底部显示提示消息，并可以指定垂直偏移量。

```dart
static void toBottom(
  BuildContext context,
  String message, {
  double offset = 100,
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})
```

其中参数offset表示从屏幕底部的垂直偏移量，默认为 100。

例如：

```dart
SemanticButton(
  shrink: true,
  text: 'toBottom',
  onTap: () => TipToasts.toBottom(context, 'toBottom'),
)
```

![example_hbHZoFAO8O](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_hbHZoFAO8O.gif)