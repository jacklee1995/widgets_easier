### 25. 图片：WeImage / WeImageViewer

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeImage` 对标 `el-image`：加载中显示占位，加载失败显示兜底图标，可以点击放大预览。`WeImageViewer` 是全屏预览器，对标 `el-image-viewer`。

```dart
// 网络图
WeImage(src: url, width: 96, height: 96, radius: BorderRadius.circular(6))

// 内存里的图（上传前、截图等）
WeImage(bytes: pngBytes, width: 96, height: 96)

// assets 图或任何 ImageProvider
WeImage(provider: const AssetImage('assets/banner.png'), height: 140, preview: true)

// 一组图：点第几张就从第几张开始看
for (int i = 0; i < gallery.length; i++)
  WeImage(
    src: urls[i],
    width: 72,
    height: 72,
    preview: true,
    previewList: gallery,  // List<WeImageSource>
    initialIndex: i,
  )
```

| 参数 | 说明 |
| --- | --- |
| `src` / `bytes` / `provider` | 图片来源，三选一；都没有时显示兜底图标 |
| `width` / `height` / `fit` | 尺寸和填充方式，默认 `BoxFit.cover` |
| `radius` | 圆角 |
| `placeholder` / `error` | 自定义加载中 / 加载失败的样子 |
| `preview` | 点击打开预览器 |
| `previewList` / `initialIndex` | 预览器翻看的一组图，以及这张图在其中的位置 |
| `semanticLabel` | 读屏文字 |

#### 预览器

```dart
WeImageViewer.show(
  context,
  images: [WeImageSource.network(url), WeImageSource.bytes(bytes)],
  initialIndex: 1,
);
```

`WeImageSource` 有 `.network(url)`、`.bytes(bytes)`、`.provider(provider)` 三种。

预览器同时照顾鼠标、键盘和触屏：

| 操作 | 鼠标 | 键盘 | 触屏 |
| --- | --- | --- | --- |
| 上一张 / 下一张 | 两侧圆形箭头 | ← / → | 左右滑（放大后改为拖动图片） |
| 放大 / 缩小 | 滚轮，或底部工具栏 | + / - | 双指缩放 |
| 原始大小 | 工具栏"1:1" | 0 | — |
| 旋转 | 工具栏向左 / 向右旋转 | — | — |
| 关闭 | 右上角 × | Esc | — |

缩放范围 0.2 ~ 8 倍，换图时缩放和旋转会复位。`WeUpload` 的图片预览也用它，会从点击的那张开始翻看列表里的所有图片。

老的 `Picture` 已弃用，改用 `WeImage`；如果要显示 SVG，请直接用 `flutter_svg` 的 `SvgPicture`。
