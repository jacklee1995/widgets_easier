### 21. 加载：WeLoading

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeLoading` 对标 Element Plus 的 `v-loading`，有两种用法：盖住一块区域，或者盖住整个屏幕。

#### 区域加载

```dart
WeLoading(
  loading: _saving,
  text: '保存中',
  child: MyForm(),
)
```

`loading` 为 `true` 时，`child` 上面淡入一层半透明遮罩（浅色主题是 90% 白，暗色主题是 90% 深灰），中间是转圈和文字；变回 `false` 淡出。默认 `lock: true`，遮罩会挡住点击，防止用户在保存过程中重复提交；`lock: false` 时只是看起来在加载，下面仍可点击。

空闲时不会创建转圈动画，所以页面里放多少个 `WeLoading(loading: false)` 都没有性能开销，测试里的 `pumpAndSettle` 也能正常结束。

#### 全屏加载

```dart
final handle = WeLoading.service(context, text: '同步渠道');
try {
  await api.sync();
} finally {
  handle.close();
}
```

全屏版放在 `Overlay` 上而不是弹出一个路由，所以不会和对话框抢位置，也不会被返回键关掉。一定要在 `finally` 里 `close()`，否则请求出错时遮罩会一直留着；重复 `close()` 不会报错，`handle.isClosed` 可以查询状态。

#### 表格加载

`WeTable` 自带 `loading`：

```dart
WeTable<Order>(
  rows: _orders,
  loading: _refreshing,
  loadingText: '正在筛选订单',
  columns: [...],
)
```

- 表格**还没有数据**时显示骨架屏；
- 表格**已经有数据**时保留旧数据，在上面盖 `WeLoading` 遮罩，刷新时表格不会闪一下变空。

| 参数 | 说明 |
| --- | --- |
| `loading` | 是否显示遮罩（区域版） |
| `text` | 转圈下面的文字 |
| `spinner` | 换掉默认的转圈 |
| `background` | 遮罩颜色，默认主题浮层色的 90% |
| `lock` | 遮罩是否挡住点击，默认 `true` |

老的 `FutureDialogs` / `LoadingDialogs` 已弃用，改用 `WeLoading.service` 或区域版。
