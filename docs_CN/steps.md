### 17. 步骤条：WeSteps

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeSteps` 对标 `el-steps`，用来展示多步流程走到了哪一步，例如发布向导、订单履约。

```dart
WeSteps(
  active: 1,
  steps: const [
    WeStep(title: '下单支付'),
    WeStep(title: '拣货出库', description: '预计今天 18:00 前'),
    WeStep(title: '干线配送'),
    WeStep(title: '签收完成'),
  ],
)
```

`active` 之前的步骤是 `finishStatus`（默认 `finish`，蓝色打勾），`active` 本身是 `processStatus`（默认 `process`，深色加粗），之后的是 `wait`。`active` 等于步骤数时全部完成。

单个步骤可以用 `WeStep.status` 覆盖，比如把出问题的那一步标成 `error`（红色叉号）：

```dart
WeSteps(
  active: 2,
  finishStatus: WeStepStatus.success,
  steps: const [
    WeStep(title: '选择商品'),
    WeStep(title: '确认订单'),
    WeStep(title: '支付失败', status: WeStepStatus.error),
  ],
)
```

| 参数 | 说明 |
| --- | --- |
| `direction` | `Axis.horizontal`（默认）或 `Axis.vertical` |
| `alignCenter` | 横向时标题居中在图标下方 |
| `simple` | 一行紧凑样式，步骤之间用箭头分隔 |
| `space` | 每步固定宽度（横向）或最小高度（纵向），不传则平分 |
| `onTap(index)` | 点击某一步，适合向导里回到前面的步骤 |
| `WeStep.icon` | 用图标代替序号圆圈 |
| `WeStep.description` | 标题下方的说明 |

状态颜色：`wait` 占位灰，`process` 主文字色，`finish` primary，`success` success，`error` danger；已完成步骤后面的连接线也跟着着色。
