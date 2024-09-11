


### 6. 加减器

#### 6.1 加减器组件简介

**CounterInput** 是一个用于数值输入和调整的 **Flutter** 组件，它提供了一个直观的界面，允许用户通过点击加号和减号按钮或直接输入数值来改变当前值。改组件包含以下特性：

1. 支持点击加号和减号按钮来增加或减少当前值
2. 支持直接在文本框中输入数值；
3. 可自定义的最小值、最大值和步长；
4. 可自定义的样式，包括大小、颜色和边框样式；
5. 提供了多个回调事件，用于监听值的变化和边界情况；
6. 支持长按加号和减号按钮来连续改变值；
7. 支持禁用和启用组件的交互。



#### 6.2 使用语义

和其它组件一样，通过`type`属性可以指定语义枚举值，以得到不同的语义色彩。例如：

```dart
CounterInput(type: SemanticEnum.primary)
```

![example_uoLPuBTKzb](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uoLPuBTKzb.png)

#### 6.3 自定义色彩

如果你想更加灵活地指定各个部分的颜色，这也是可行的。具体来说，有以下几个颜色参数：

1. iconColor：加减图标的颜色
2. backgroundColor：输入框背景色；
3. buttonColor：按钮颜色；
4. textColor：输入框文本颜色。

下面是一个例子：

```dart
const CounterInput(
  size: SizeEnum.small,
  iconColor: Colors.amber,
  backgroundColor: Colors.black,
  buttonColor: Colors.blue,
  textColor: Colors.white,
)
```



![example_h0k4KWue9E](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_h0k4KWue9E.png)

#### 6.4 尺寸

##### 1 枚举尺寸

通过size组件可以指定尺寸枚举，包括SizeEnum.small、SizeEnum.defaultSize、SizeEnum.large，如果未指定，默认为SizeEnum.defaultSize。例如：

```dart
Row(
  children: [
    Column(
      children: [
        CounterInput(
          size: SizeEnum.small,
          controller: CounterInputController(),
        ),
        const Text('SizeEnum.small'),
      ],
    ),
    Column(
      children: [
        CounterInput(
          size: SizeEnum.defaultSize,
          controller: CounterInputController(),
        ),
        const Text('SizeEnum.defaultSize'),
      ],
    ),
    Column(
      children: [
        CounterInput(
          size: SizeEnum.large,
          controller: CounterInputController(),
        ),
        const Text('izeEnum.large'),
      ],
    ),
  ],
),
```

![example_1JTzG6Hlaf](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_1JTzG6Hlaf.png)

##### 2 数值尺寸

如果枚举尺寸不能满足要求还可以指定数值：

```dart
CounterInput(
  height: 50,
  controller: CounterInputController(),
),
```

![example_eDBmo5IVT9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_eDBmo5IVT9.png)

#### 6.5 轮廓型

通过指定`isOutlined`的值为true，可以设置加减器为轮廓型。例如：

```dart
Row(
  children: [
    CounterInput(
      type: SemanticEnum.primary,
      controller: CounterInputController(),
      isOutlined: true,
    ),
    CounterInput(
      type: SemanticEnum.secondary,
      controller: CounterInputController(),
      isOutlined: true,
    ),
    CounterInput(
      type: SemanticEnum.info,
      controller: CounterInputController(),
      isOutlined: true,
    ),
    CounterInput(
      type: SemanticEnum.success,
      controller: CounterInputController(),
      isOutlined: true,
    ),
  ],
),
```

![example_tjpQHhVKRl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_tjpQHhVKRl.png)

#### 6.6 圆角加减器

通过`radius`属性可以很方便地为加减器设置圆角.例如：

```dart
const CounterInput(
  type: SemanticEnum.info,
  radius: 20,
  step: 3,
)
```

![example_4AXqYeLDKp](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4AXqYeLDKp.gif)

#### 6.7 自动宽度和固定宽度

默认情况下宽度是自动的，加减器文本输入区的宽度随着位数的增加而增加。但是也可以指定一个固定的文本输入区宽度。例如：

```dart
CounterInput(
  textFieldWidth: 60,
  controller: CounterInputController(),
),
```



#### 6.8 回调事件



##### 1 加、减回调

加回调用于监听值增加事件，当数值增加时触发；类似地，减回调用于监听减少事件，当数值减少时触发。

- 通过`onIncrement`回调，用于监值增加事件；
- 通过`Decremented`回调，用于监值减少事件。

下面这个例子中，初始值为7，步进值为2，当增加或者减少时在控制台打印新值和旧值：

```dart
CounterInput(
  controller: CounterInputController(initialValue: 7),
  step: 2,
  onIncrement: (oldValue, value) {
    debugPrint("+增加前为$oldValue；增加后为：$value");
  },
  onDecrement: (oldValue, value) {
    debugPrint("-减少前为$oldValue；减少后为：$value");
  },
),
```

> 注：指定初始值需要使用CounterInputController控制器，就像这个例子中所示的一样。



##### 2 最值到达回调

加减器有一个最大值和一个最小值，默认情况下最小值为0，最大值为100。当变化到最小值时，将触发最小值回调。下面的例子展示了到达最大/最小值时，执行相关回调。其中设置最大值为10，最小值为1，初始值为6，步进值为2。每当到达最小或最大值的时候弹窗提示。

```dart
CounterInput(
  type: SemanticEnum.primary,
  minValue: 1,
  maxValue: 10,
  controller: CounterInputController(),
  step: 1,
  onIncrement: (oldValue, value) {
    debugPrint("+Increasing from $oldValue to $value");
  },
  onDecrement: (oldValue, value) {
    debugPrint("-Decreasing from $oldValue to $value");
  },
  onMax: () => InfoDialogs.show(
    context,
    message: 'Reached maximum value',
    type: SemanticEnum.primary,
    onTapDismiss: () => Navigator.of(context).pop(),
  ),
  onMin: () => InfoDialogs.show(
    context,
    message: 'Reached minimum value',
    type: SemanticEnum.fatal,
    onTapDismiss: () => Navigator.of(context).pop(),
  ),
)
```

![example_wzi2mFQRMk](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_wzi2mFQRMk.gif)

通过这个例子可以看出，`onMax`、`onMin`仅仅是到达最值得时候被调用，但是从如果尝试往超出方向继续点击按钮时不会被调用。以上面得GIF图片为例，当增加到10单词会调用onMax方法，但是在10上继续增加是不会处理的。

##### 3 溢出回调

溢出回调是为了响应增道最大值继续操作增加、减到最小值继续操作减少的场景。例如：

```dart
CounterInput(
  type: SemanticEnum.primary,
  minValue: 1,
  maxValue: 13,
  controller: CounterInputController(initialValue: 7),
  step: 4,
  onMinOverflow: () => InfoDialogs.zoomIn(
    context,
    message: '当前已经时最小值，无法继续减少',
    buttonText: '确定',
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
  onMaxOverflow: () => InfoDialogs.zoomIn(
    context,
    message: '当前已经时最大值，无法继续增加',
    buttonText: '确定',
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
)
```



![example_fMYLgu8hR9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_fMYLgu8hR9.gif)


##### 4 值变化事件



```dart
CounterInput(
  onValueChanged: (oldValue, newValue) {
    print('oldValue is $oldValue, newValue is $newValue');
  },
)
```

![example_Jfs459a3CF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Jfs459a3CF.gif)

对应图中的点击，控制台打印的结果为：

```dart
flutter: oldValue is 0.0, newValue is 1.0
flutter: oldValue is 1.0, newValue is 2.0
flutter: oldValue is 2.0, newValue is 3.0
flutter: oldValue is 3.0, newValue is 4.0
flutter: oldValue is 4.0, newValue is 5.0
flutter: oldValue is 5.0, newValue is 6.0
flutter: oldValue is 6.0, newValue is 7.0
flutter: oldValue is 7.0, newValue is 6.0
flutter: oldValue is 6.0, newValue is 5.0
flutter: oldValue is 5.0, newValue is 4.0
flutter: oldValue is 4.0, newValue is 3.0
flutter: oldValue is 3.0, newValue is 2.0
flutter: oldValue is 2.0, newValue is 1.0
flutter: oldValue is 1.0, newValue is 0.0
```



