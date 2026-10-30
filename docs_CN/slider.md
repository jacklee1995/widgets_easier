### 22. 滑块：WeSlider

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

```dart
WeSlider(value: v, min: 1, max: 10, step: 0.5, showStops: true, showInput: true, onChanged: (n) => setState(() => v = n))
WeSlider.range(values: (20, 80), onRangeChanged: (r) => setState(() => range = r))
```

`marks` 在轨道下方标刻度。放进 `WeFormItem` 后跟随禁用和校验。
