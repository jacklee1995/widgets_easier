### 18. 级联选择：WeCascader

> 适用平台：网页 / 桌面 —— 多列并排展开，需要宽屏；手机上建议改用 CascadeBottomSheet（[按平台选组件](platform.md)）

`WeCascader` 对标 `el-cascader`，用来从一棵树里选一条路径，比如"省 / 市 / 区"、"一级类目 / 二级类目"。面板一列一层，点一项就在右边展开它的下一级。

```dart
List<String>? _region;

WeCascader<String>(
  value: _region,
  onChanged: (path) => setState(() => _region = path),
  clearable: true,
  filterable: true,
  options: const [
    WeCascaderOption('zj', '浙江', children: [
      WeCascaderOption('hz', '杭州', children: [
        WeCascaderOption('xh', '西湖区'),
        WeCascaderOption('bj', '滨江区'),
      ]),
    ]),
    WeCascaderOption('xz', '西藏', disabled: true),
  ],
)
```

值是从根到选中节点的 `value` 列表，例如 `['zj', 'hz', 'bj']`；清空时回调 `null`。输入框默认显示完整路径"浙江 / 杭州 / 滨江区"。

默认只能选叶子：点有下级的项只会展开。要允许选任意一级，打开 `checkStrictly`，每行前面会出现一个单选框，点单选框就选中这一级，面板不关，方便接着往下看。

| 参数 | 说明 |
| --- | --- |
| `options` | 树形数据，`WeCascaderOption(value, label, children:, disabled:)` |
| `value` / `onChanged` | 选中路径；`onChanged` 为 `null` 时整个控件禁用 |
| `checkStrictly` | 可以选任意一级，而不只是叶子 |
| `expandTrigger` | `click`（默认）或 `hover`，悬停就展开下一级 |
| `filterable` | 打开后可直接输入，按任意一级的名字搜索，结果显示成完整路径 |
| `filterMethod(query, path)` | 自定义匹配规则，替换默认的"任意一级名字包含关键字" |
| `showAllLevels` | `false` 时输入框只显示最后一级 |
| `separator` | 路径分隔符，默认 `' / '` |
| `clearable` / `disabled` / `size` / `width` / `status` | 与 `WeSelect` 相同 |
| `columnWidth` / `columnHeight` | 每一列的宽和高，默认 180 × 204 |
| `noMatchText` / `noDataText` | 空状态文案 |

键盘操作（桌面端）：↑ ↓ 在当前列移动并展开，→ 进入下一级，← 回到上一级，Enter 选中叶子（`checkStrictly` 时选中当前级），Esc 关闭。放在 `WeFormItem` 里时，会跟随表单的尺寸、禁用和校验出错状态，选择后触发 `change` 校验。
