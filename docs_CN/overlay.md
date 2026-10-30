### 14. 浮层：WePopper、WeTooltip、WePopover、WePopconfirm

> 适用平台：通用 —— WePopper、WePopover、WePopconfirm 在触屏上悬停改点按；WeTooltip 属于网页 / 桌面，触屏上改为长按显示（[按平台选组件](platform.md)）

这一组组件对标 Element Plus 里所有"贴着触发器弹出来"的东西。它们共用一个底座 `WePopper`，`WeSelect` 和 `WeDropdown` 的下拉面板也是它。

#### WePopper

`WePopper` 负责把 `popupBuilder` 画出来的面板放到触发器旁边，并处理这些事情：

- **跟随**：触发器所在的列表滚动时，面板跟着走。
- **翻转**：首选方向放不下时（比如触发器贴着窗口底边），翻到对面。
- **平移**：沿交叉轴挪回视口里，贴着右边的触发器不会把面板顶出屏幕；开了箭头时，箭头仍然指着触发器。
- **关闭**：点面板外面、按 Esc 都会关闭。Esc 只关最上面一层：弹窗里的下拉框开着时按 Esc，先关下拉框，再按一次才关弹窗。

```dart
WePopper(
  placement: WePlacement.bottomStart,    // 12 个方向，同 Element 的 placement
  trigger: WePopperTrigger.click,        // hover / click / focus / manual
  showArrow: true,
  width: 240,
  popupBuilder: (context) => const Text('任意内容'),
  child: const Text('点我'),
)
```

触发器是按钮时用 `WePopper.builder`，让按钮自己的 `onPressed` 去开关面板：

```dart
WePopper.builder(
  popupBuilder: (context) => const FilterPanel(),
  builder: (context, toggle) => WeButton(text: '筛选', icon: Icons.filter_alt_outlined, onPressed: toggle),
)
```

需要从外部开关时传一个 `WePopperController`，调 `show()` / `hide()` / `toggle()`，`isOpen` 可以读当前状态。自己写的弹窗如果也用 Esc 关闭，先判断一下 `WePopper.escapeHandled`，为 `true` 说明这次 Esc 已经关掉了一个浮层。

| 参数 | 说明 |
| --- | --- |
| `placement` | 首选方向，放不下时自动翻转 |
| `trigger` | 触发方式；`builder` 形态固定为 `manual` |
| `gap` | 面板与触发器的距离 |
| `showArrow` | 是否显示小箭头 |
| `style` | `WePopperStyle`：背景、边框、内边距、圆角、阴影；`WePopperStyle.none` 表示完全自绘 |
| `width` / `minWidth` / `maxWidth` / `maxHeight` | 面板尺寸 |
| `matchTriggerWidth` | 面板与触发器等宽，下拉选择用 |
| `showAfter` / `hideAfter` | hover 触发时的延迟 |
| `closeOnTapOutside` / `closeOnEscape` | 关闭方式 |
| `onOpenChanged` | 打开、关闭时回调 |

#### WeTooltip

鼠标停在元素上时出现的一句提示，对标 `el-tooltip`。默认深色，放在上方。

```dart
WeTooltip(
  content: '编辑商品',
  child: WeButton.icon(Icons.edit_outlined, variant: WeButtonVariant.text, onPressed: edit),
)

// 浅色、放右边、带富文本
WeTooltip(
  effect: WeTooltipEffect.light,
  placement: WePlacement.right,
  contentBuilder: (context) => const Text.rich(TextSpan(text: '库存低于 ', children: [TextSpan(text: '10 件')])),
  child: const Icon(Icons.info_outline),
)
```

`WeButton` 的 `tooltip` 参数现在也是 `WeTooltip`，和主题一致。

#### WePopover

比 Tooltip 大的浮动卡片，可以放标题和任意组件，对标 `el-popover`。默认点击打开。

```dart
WePopover(
  title: '库存明细',
  width: 260,
  contentBuilder: (context) => const StockTable(),
  child: const WeLink('查看'),
)

// 按钮触发
WePopover.builder(
  title: '说明',
  content: '价格包含运费。',
  builder: (context, toggle) => WeButton(text: '?', onPressed: toggle),
)
```

#### WePopconfirm

贴在按钮上的确认气泡，对标 `el-popconfirm`，适合行内删除这种不值得弹一个大弹窗的操作。`onConfirm` 返回 `Future` 时，确定按钮会转圈，完成后气泡关闭；如果抛了异常，气泡保持打开，方便重试。

```dart
WePopconfirm.builder(
  title: '确定删除「夏季T恤」吗？',
  type: SemanticEnum.danger,
  confirmText: '删除',
  onConfirm: () => api.deleteProduct(id),
  builder: (context, open) => WeButton.icon(
    Icons.delete_outline,
    variant: WeButtonVariant.text,
    type: SemanticEnum.danger,
    onPressed: open,
  ),
)
```

| 参数 | 说明 |
| --- | --- |
| `title` | 提示文字 |
| `confirmText` / `cancelText` | 按钮文字，默认"确定""取消" |
| `type` | 确定按钮的语义色 |
| `icon` / `iconColor` / `hideIcon` | 左侧图标，默认黄色问号 |
| `onConfirm` / `onCancel` | 回调；`onConfirm` 可以是异步的 |
| `placement` / `width` | 位置与宽度 |
