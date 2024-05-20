### 11. 底部弹窗

#### 11.1 底部消息弹窗

底部消息弹窗是消息弹窗的底部版本。你可以使用或禁用图片，指定相关文本，以及按钮的回调等。


例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'Primary',
      type: SemanticEnum.primary,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Primary Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.primary,
      ),
    ),
    SemanticButton(
      text: 'Secondary',
      type: SemanticEnum.secondary,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Secondary Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.secondary,
      ),
    ),
    SemanticButton(
      text: 'Info',
      type: SemanticEnum.info,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Info Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.info,
      ),
    ),
    SemanticButton(
      text: 'Success',
      type: SemanticEnum.success,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Success Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.success,
      ),
    ),
    SemanticButton(
      text: 'Warning',
      type: SemanticEnum.warning,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Warning Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.warning,
      ),
    ),
    SemanticButton(
      text: 'Danger',
      type: SemanticEnum.danger,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Danger Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.danger,
      ),
    ),
    SemanticButton(
      text: 'Fatal',
      type: SemanticEnum.fatal,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Fatal Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.fatal,
      ),
    ),
  ],
),
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/50c63288482441e696045cef7abddea9.gif)

### 11.2 底部确认弹窗

底部确认弹窗是确认弹窗的底部版本。你可以使用或禁用图片，指定相关文本，以及按钮的回调等。

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'Primary',
      type: SemanticEnum.primary,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Primary Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.primary,
      ),
    ),
    SemanticButton(
      text: 'Secondary',
      type: SemanticEnum.secondary,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Secondary Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.secondary,
      ),
    ),
    SemanticButton(
      text: 'Info',
      type: SemanticEnum.info,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Info Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.info,
      ),
    ),
    SemanticButton(
      text: 'Success',
      type: SemanticEnum.success,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Success Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.success,
      ),
    ),
    SemanticButton(
      text: 'Warning',
      type: SemanticEnum.warning,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Warning Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.warning,
      ),
    ),
    SemanticButton(
      text: 'Danger',
      type: SemanticEnum.danger,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Danger Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.danger,
      ),
    ),
    SemanticButton(
      text: 'Fatal',
      type: SemanticEnum.fatal,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Fatal Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
),
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/6a74972d5f8048209ccb257206fba86d.gif)

### 11.3 底部级联选择器

### 11.3.1 底部级联选择器简介

底部级联选择器是一种在移动应用中常用的UI组件，主要用于在一个底部弹出的模态框中进行多级选择。用户可以通过滚动选择不同的选项，这些选项通常是分层次的，例如选择地址时的省、市、区。底部级联选择器适用于需要多级选择的场景，常见的应用包括：

- 地址选择：用户可以依次选择省、市、区。

- 分类选择：在电商平台中选择商品的类别。

- 设置选项：例如设置日期和时间，先选择年份，再选择月份，最后选择日期。



底部级联选择器的主要特点包括：

- **多级选择**：支持多级数据的动态加载和显示。

- **自定义样式**：可以自定义按钮文本、样式等。

- **灵活配置**：支持配置是否可以点击背景关闭选择器，以及其他行为的自定义。

- **响应式交互**：选中项会即时反馈到UI上，提高用户体验。

### 11.3.2 示例：单级选择


```dart
SemanticButton(
  text: '一级选择表单',
  shrink: true,
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () => BottomSheets.showCascadeSheet(
    context,
    items: [
      {'label': ''},
      {'label': '中国'},
      {'label': '俄罗斯'},
      {'label': '美国'},
      {'label': '法国'},
      {'label': '德国'},
      {'label': '意大利'},
    ],
  ).then((value) {
    debugPrint('value = $value');
  }),
)
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/cc84116e550b4a28a58660ad918cb24b.gif)

### 11.3.3 示例：多级联动选择


```dart
SemanticButton(
  text: '多级联动选择表单',
  shrink: true,
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () => BottomSheets.showCascadeSheet(
    context,
    items: [
      {
        'label': '中国',
        'children': [
          {
            'label': '北京市',
            'children': [
              {
                'label': '东城区',
                'children': [
                  {'label': '安定门街道'},
                  {'label': '建国门街道'},
                  {'label': '朝阳门街道'},
                ],
              },
              {
                'label': '西城区',
                'children': [
                  {'label': '德胜门街道'},
                  {'label': '新街口街道'},
                  {'label': '月坛街道'},
                ],
              },
            ],
          },
          {
            'label': '上海市',
            'children': [
              {
                'label': '黄浦区',
                'children': [
                  {'label': '南京东路街道'},
                  {'label': '外滩街道'},
                  {'label': '半淞园路街道'},
                ],
              },
              {
                'label': '徐汇区',
                'children': [
                  {'label': '湖南路街道'},
                  {'label': '斜土路街道'},
                  {'label': '枫林路街道'},
                ],
              },
            ],
          },
        ],
      },
      {
        'label': '美国',
        'children': [
          {
            'label': '加利福尼亚州',
            'children': [
              {
                'label': '旧金山市',
                'children': [
                  {'label': '唐人街'},
                  {'label': '金融区'},
                  {'label': '渔人码头'},
                ],
              },
              {
                'label': '洛杉矶市',
                'children': [
                  {'label': '好莱坞'},
                  {'label': '比佛利山'},
                  {'label': '圣莫尼卡'},
                ],
              },
            ],
          },
          {
            'label': '纽约州',
            'children': [
              {
                'label': '纽约市',
                'children': [
                  {'label': '曼哈顿'},
                  {'label': '布鲁克林'},
                  {'label': '皇后区'},
                ],
              },
              {
                'label': '布法罗市',
                'children': [
                  {'label': '尼亚加拉广场'},
                  {'label': '艾伦敦'},
                  {'label': '拉萨尔公园'},
                ],
              },
            ],
          },
        ],
      },
    ],
  ).then((value) {
    debugPrint('value = $value');
  }),
)
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/3d7c9de55d8642c8bc054514a68b5d76.gif)

