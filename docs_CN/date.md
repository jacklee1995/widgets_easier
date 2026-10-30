### 19. 日期：WeDatePicker、WeDatePanel 与 WeCalendar

> 适用平台：WeDatePicker〔通用〕—— 电脑上弹日历面板，手机上自动改成底部滚轮；WeDatePanel、WeCalendar〔网页 / 桌面〕；WeDateWheel、WeDateSheet〔手机〕（[按平台选组件](platform.md)）

这些组件共用同一套文案表 `WeDateLocale`（默认 `WeDateLocale.zh`，周一开头；`WeDateLocale.en` 周日开头）：

- `WeDatePicker`：输入框 + 下拉面板，放在表单和筛选栏里。
- `WeDatePanel`：不带输入框的面板，直接嵌在页面里。
- `WeCalendar`：整月日程看板，对标 `el-calendar`。
- `WeDateWheel`：年 / 月 / 日三列滚轮，手指上下拨（见文末"手机端"一节）。
- `WeDateSheet`：从屏幕底部弹出的滚轮选择框。

面板和日历为网页和桌面端设计：鼠标悬停有反馈，全部可以用键盘操作。手机上 `WeDatePicker` 会自动改用 `WeDateSheet`，不用改代码。

#### WeDatePicker

```dart
DateTime? _day;
DateTimeRange? _period;

WeDatePicker(
  value: _day,
  onChanged: (d) => setState(() => _day = d),
  disabledDate: (d) => d.isAfter(DateTime.now()),
)

WeDatePicker.range(
  range: _period,
  onChanged: (r) => setState(() => _period = r),
  shortcuts: [
    WeDateShortcut('最近一周', () {
      final now = DateTime.now();
      return DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now);
    }),
  ],
)
```

- 可以直接键入：`2026-9-5`、`2026/09/05`、`20260905` 都认，按 Enter 或离开输入框时生效，不合法的内容会恢复成原来的值。
- 按 ↓ 进入面板，方向键移动，Enter 选中。
- 点面板标题可以切到"选月"、"选年"。
- 范围模式显示两个月，先点开始、再点结束，鼠标移动时预览区间；`shortcuts` 会在左侧列出快捷项。

| 参数 | 说明 |
| --- | --- |
| `format` | 显示格式，默认 `yyyy-MM-dd` |
| `editable` | `false` 时只能在面板里选 |
| `firstDate` / `lastDate` / `disabledDate` | 限制可选范围 |
| `firstDayOfWeek` / `showWeekNumber` / `locale` | 周起始日、周数列、文案 |
| `clearable` / `disabled` / `size` / `width` / `status` / `placement` | 与其他表单控件相同 |
| `touchMode` | 触屏上怎么选：默认 `WeDatePickerTouchMode.sheet` 弹底部滚轮（此时输入框只读，避免弹出键盘）；`panel` 仍用日历面板，例如在平板上 |

#### WeDatePanel

```dart
WeDatePanel(
  value: _day,
  onChanged: (d) => setState(() => _day = d),
  showWeekNumber: true,
)
```

`WeDatePanel.range(range:, onRangeChanged:)` 是范围版本。键盘：方向键按天 / 周移动，PageUp / PageDown 翻月（加 Shift 翻年），Home / End 跳到周首 / 周末，T 回到今天。

#### WeCalendar

```dart
WeCalendar(
  value: _selected,
  onChanged: (d) => setState(() => _selected = d),
  showWeekNumber: true,
  events: (day) => _eventsOf(day),
  onEventTap: (event, day) => _open(event),
  headerTrailing: WeButton(text: '新建日程', icon: Icons.add, size: SizeEnum.small),
)
```

每个日程是 `WeCalendarEvent(title, type:, color:, time:, data:)`，在格子里显示成左侧带色条的横条；放不下时最后一行显示"还有 N 项"，格子太窄时改成小圆点。需要完全自定义格子时用 `cellBuilder`。

#### 工具函数

- `weFormatDate(date, [pattern])`：按 `yyyy`、`MM`、`dd` 等格式化。
- `weParseDate(text, [pattern])`：宽松解析，失败返回 `null`。

#### 手机端：WeDateSheet 与 WeDateWheel

> 适用平台：手机 —— 为手指设计，从底部弹出、上下拨动

手机屏幕窄、没有键盘，日历面板的小格子不好点。手机 App 常见的做法是三列滚轮：年、月、日各一列，手指上下拨。

```dart
// 选一天：用户点"确定"返回日期，点"取消"或下滑关掉返回 null
final DateTime? day = await WeDateSheet.show(
  context,
  initial: _day,
  title: '发货日期',
  lastDate: DateTime.now(),
);

// 选范围：上方切换"开始 / 结束"，分别拨
final DateTimeRange? stay = await WeDateSheet.showRange(
  context,
  initial: _stay,
  shortcuts: [WeDateShortcut('最近一周', () => lastWeek())],
);
```

- 底部弹窗顶部是"取消 · 标题 · 确定"，下面是滚轮；`shortcuts` 显示成一排小圆按钮，点了直接返回。
- 范围模式里，如果结束日拨到了开始日之前，确定时会自动对调。
- 弹窗最宽 640，在平板或电脑上不会撑满整个屏幕；底部会留出手机的安全区（Home 条）；横屏放不下时可以上下滚。

想把滚轮直接放在页面里，用 `WeDateWheel`：

```dart
WeDateWheel(
  value: _day,
  onChanged: (d) => setState(() => _day = d),
  disabledDate: (d) => d.weekday >= DateTime.saturday, // 周末不可选
)
```

| 参数 | 说明 |
| --- | --- |
| `type` | `WeDateWheelType.date` 年月日三列；`month` 只选年月两列 |
| `firstDate` / `lastDate` | 范围外的年、月、日直接不显示，默认 1900 到 2100 年 |
| `disabledDate` | 不可选的日子显示成灰色，停在上面会自动挪到最近的可选日 |
| `locale` | 中文按"年 月 日"排，英文按"月 日 年"排 |
| `itemExtent` / `visibleItems` | 每行高度（默认 44）、可见行数（默认 5，须为单数） |

- 1 月 31 日拨到 2 月，会自动变成 2 月 28 日（闰年 29 日），不会出现 2 月 31 日。
- 每拨过一格手机会轻微震动；接了键盘时，用 ↑ / ↓ 拨动当前列。
- 读屏软件能读出每一列的当前值，并可以上下调整。
