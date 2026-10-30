### 26. 走马灯：WeCarousel

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

```dart
WeCarousel(
  height: 180,
  autoplay: true,
  arrow: WeCarouselArrow.hover,
  indicator: WeCarouselIndicator.inside,
  children: slides,
)
```

`type: WeCarouselType.card` 两侧缩小。`loop` 到头后回到第一张。
