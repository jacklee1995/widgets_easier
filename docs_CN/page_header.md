### 23. 页头：WePageHeader

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

```dart
WePageHeader(
  title: '经营概览',
  description: '数据延迟约 5 分钟',
  onBack: Navigator.of(context).maybePop,
  tag: Tag('实时'),
  actions: [WeButton(text: '导出')],
)
```

还可传入 `breadcrumb`、`icon`、`extra`、`content`。
