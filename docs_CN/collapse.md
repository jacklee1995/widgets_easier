### 24. 折叠面板：WeCollapse

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeCollapse` 对标 `el-collapse`，把一组内容收成可以点开的标题，常用于常见问题、分组设置、长表单分段。

```dart
Set<String> _open = {'basic'};

WeCollapse(
  expanded: _open,
  accordion: true,
  onChanged: (s) => setState(() => _open = s),
  items: [
    WeCollapseItem(name: 'basic', title: '基础信息', icon: Icons.info_outline, child: BasicForm()),
    WeCollapseItem(
      name: 'notice',
      title: '消息通知',
      extra: WeBadge(value: 3),
      child: NoticeSettings(),
    ),
    WeCollapseItem(name: 'archive', title: '已归档', disabled: true, child: SizedBox()),
  ],
)
```

`expanded` 是当前展开的面板 `name` 集合，由你保存；点标题时 `onChanged` 回传新的集合。`accordion: true` 时打开一个会自动收起其它的。

| 参数 | 说明 |
| --- | --- |
| `items` | 面板列表 |
| `expanded` / `onChanged` | 展开的面板 |
| `accordion` | 手风琴模式，同时只开一个 |
| `border` | 是否画外框，默认 `true`；`false` 时只保留上下和分隔线，适合放进卡片 |

`WeCollapseItem`：

| 参数 | 说明 |
| --- | --- |
| `name` | 面板标识 |
| `title` / `icon` | 标题文字和前置图标 |
| `extra` | 标题右侧、箭头左边的附加内容，比如徽标、状态文字；点它也会切换面板 |
| `child` | 面板内容，默认文字为 13 号常规色 |
| `disabled` | 禁用，不能展开 |
| `titleBuilder(context, expanded)` | 完全自定义标题行（箭头仍保留） |

键盘操作（桌面端）：Tab 聚焦到标题，Enter 或空格展开 / 收起。收起的面板里的输入框不会被 Tab 跳进去。
