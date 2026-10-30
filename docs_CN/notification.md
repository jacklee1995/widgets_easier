### 20. 通知：WeNotification

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeNotification` 对标 `el-notification`：带标题的卡片从屏幕某个角滑入，同一个角的多条自动往下排，关掉一条后后面的补位。

它适合"不是用户刚才那次点击直接产生的消息"，比如导出完成、库存告急、同步失败。用户刚做完一个操作、要立刻给个结果的，用更轻的 `WeMessage`。

```dart
// 四个快捷方法
WeNotification.success(context, title: '导出完成', message: '文件已保存到下载目录');
WeNotification.warning(context, title: '库存告急', message: '仅剩 46 件');
WeNotification.info(context, title: '有新的售后工单');
WeNotification.error(context, title: '同步失败', message: '抖音小店接口超时');

// 完整写法
final handle = WeNotification.show(
  context,
  title: '库存告急',
  message: '「冷萃咖啡液」仅剩 46 件',
  type: SemanticEnum.warning,
  position: WeNotificationPosition.bottomRight,
  duration: Duration.zero,           // 一直留着，直到用户或代码关掉
  onClick: () => openStockPage(),    // 点卡片
);

handle.close();                      // 代码里关掉这一条
await handle.done;                   // 等它完全离场
WeNotification.closeAll();           // 四个角全部清空
```

| 参数 | 说明 |
| --- | --- |
| `title` / `message` | 标题和正文，至少给一个（或给 `content`） |
| `content` | 自定义正文组件，放在 `message` 下面 |
| `type` | `SemanticEnum` 的任一值（`success` / `warning` / `info` / `danger` / `primary`），决定左侧图标和颜色；不给就没有图标 |
| `position` | `topRight`（默认）、`topLeft`、`bottomRight`、`bottomLeft` |
| `duration` | 停留时间，默认 4.5 秒；`Duration.zero` 表示不自动关 |
| `closable` | 是否显示右上角 ×，默认 `true` |
| `showIcon` / `icon` | 是否显示类型图标 / 换一个图标 |
| `width` / `offset` | 卡片宽度（默认 330）/ 离屏幕边缘的距离（默认 16） |
| `onClick` | 点卡片时回调，鼠标会变成手型 |

鼠标悬停在卡片上时倒计时暂停，移开后重新计时，不会读到一半就消失。

老的 `NotifyToasts` 已弃用：`NotifyToasts.showTopRight(...)` 改成 `WeNotification.show(...)`，其余三个角加 `position:`。
