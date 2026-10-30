### 27. 树：WeTree / WeTreeSelect

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeTree` 对标 `el-tree`，用来展示有层级的数据（商品类目、部门、权限），可以点选、勾选、搜索、按需加载。`WeTreeSelect` 把同一棵树放进下拉框，用在表单和筛选区。

#### WeTree

```dart
const categories = [
  WeTreeNode('home', '家居生活', children: [
    WeTreeNode('daily', '家居日用'),
    WeTreeNode('kitchen', '厨房电器', disabled: true),
  ]),
  WeTreeNode('digital', '数码出行', children: [
    WeTreeNode('acc', '数码配件'),
  ]),
];

Set<String> _checked = {};

WeTree<String>(
  nodes: categories,
  showCheckbox: true,
  defaultExpandAll: true,
  checked: _checked,
  onCheck: (s) => setState(() => _checked = s),
  selected: _current,
  onSelect: (v) => setState(() => _current = v),
  filter: _query, // 搜索框里的字，空串表示不过滤
)
```

`WeTreeNode(value, label, children:, disabled:, icon:, isLeaf:)`：`value` 是节点的唯一标识，`isLeaf: true` 表示肯定没有下级（懒加载时用来隐藏箭头）。

**勾选规则**（与 Element Plus 一致）：

- 勾父节点会连带勾上它下面所有**没禁用**的子孙；子节点全勾上时父节点自动变成勾选，只勾了一部分时父节点显示半选。
- 禁用的子节点保持原样。例如"厨房电器"禁用且没勾，那么勾"家居生活"后它只能是半选；再点一次会把能取消的都取消。
- `onCheck` 回传所有**完全勾选**的节点（父节点只有在子孙全勾时才在里面）。
- `checkStrictly: true` 时父子互不影响，每个节点单独勾。
- 不渲染组件也能算：`WeTree.toggleChecked(nodes, checked, value, true)` 按同样规则返回新集合，`WeTree.find(nodes, value)` 按值找节点。

| 参数 | 说明 |
| --- | --- |
| `nodes` | 树形数据 |
| `selected` / `onSelect` | 当前选中（高亮）的节点 |
| `showCheckbox` / `checked` / `onCheck` | 显示勾选框及勾选结果 |
| `checkStrictly` | 父子不联动 |
| `defaultExpandAll` / `defaultExpanded` | 初始全部展开 / 初始展开哪些节点 |
| `onExpandedChanged` | 展开集合变化时回调 |
| `expandOnClickNode` | 点整行是否同时展开，默认 `true`；`false` 时只有点箭头才展开 |
| `accordion` | 同一级只能展开一个 |
| `filter` / `filterMethod(query, node)` | 过滤关键字 / 自定义匹配；默认按名字包含。命中的节点连同祖先一起保留并自动展开，命中的字会高亮 |
| `lazyLoad(node)` | 第一次展开时调用，返回 `Future<List<WeTreeNode>>`；加载中该行显示转圈，出错会打到 Flutter 日志 |
| `nodeBuilder(context, node)` | 自定义每行的文字部分 |
| `indent` / `itemHeight` / `showLine` | 每级缩进（默认 18）、行高（默认 32）、是否画层级引导线 |
| `highlightCurrent` | 选中行是否高亮 |
| `emptyText` | 没有数据或过滤无结果时的提示，默认"暂无数据" |
| `focusNode` / `autofocus` | 键盘焦点 |

键盘操作（桌面端）：↑ ↓ Home End 移动，→ 展开或进入第一个子节点，← 收起或回到父节点，Enter 选中，空格勾选。

#### WeTreeSelect

```dart
// 单选：默认只能选叶子，点父节点只会展开
WeTreeSelect<String>(
  nodes: categories,
  value: _category,
  onChanged: (v) => setState(() => _category = v),
  hint: '选择类目',
  clearable: true,
  filterable: true,
)

// 多选：勾选规则与 WeTree 相同
WeTreeSelect<String>.multiple(
  nodes: categories,
  values: _categories,
  onValuesChanged: (s) => setState(() => _categories = s),
  collapseTags: true,
  prefixIcon: Icons.category_outlined,
)
```

多选时输入框里的标签只显示**最上层的完全勾选节点**：整棵"家居生活"勾满就只显示一个"家居生活"标签，点它的 × 会连同子孙一起去掉。`collapseTags` 把超过 `maxCollapseTags`（默认 1）的标签折叠成 `+ N`。

| 参数 | 说明 |
| --- | --- |
| `nodes` | 树形数据 |
| `value` / `onChanged` | 单选的值 |
| `values` / `onValuesChanged` | 多选的值（`.multiple` 构造） |
| `checkStrictly` | 单选时允许选父节点；多选时父子不联动 |
| `filterable` / `filterMethod` | 在输入框里打字过滤树 |
| `defaultExpandAll` | 打开面板时全部展开；否则会自动展开到当前选中值 |
| `collapseTags` / `maxCollapseTags` | 多选标签折叠 |
| `clearable` / `disabled` / `size` / `width` / `status` / `hint` / `prefixIcon` | 与 `WeSelect` 相同 |
| `maxHeight` | 面板最大高度，默认 274 |
| `noMatchText` | 过滤无结果时的提示 |

键盘操作：焦点在输入框时 ↓ 进入树，之后按 `WeTree` 的键盘规则操作；多选时 Backspace 删掉最后一个标签；Esc 关闭面板。放在 `WeFormItem` 里时跟随表单的尺寸、禁用和校验出错状态。

输入框的外观来自 `WeFieldBox`，`WeSelect`、`WeCascader` 也用它。要自己做一个"看起来像下拉框"的控件，可以直接用 `WeFieldBox(child:, onTap:, open:, focused:, onClear:, prefixIcon:)`。
