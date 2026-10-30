### 15. 表单：WeForm 与 WeSelect

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

#### WeForm

`WeForm` 对标 `el-form`，负责两件事：标签对齐的排版，和校验。

Flutter 里字段的值保存在页面自己的 `State` 里，所以 `WeFormItem` 需要你把当前值交给它（`value`），它才能按 `rules` 检查。`WeInput`、`WeSelect` 放进 `WeFormItem` 后会自动读取它的状态：出错时边框变红，并继承表单的 `disabled` 和 `size`。

```dart
final form = WeFormController();
String title = '';
String? category;

WeForm(
  controller: form,
  labelWidth: 88,
  children: [
    WeFormItem(
      name: 'title',
      label: '商品名称',
      value: title,
      rules: const [
        WeRule(required: true),
        WeRule(min: 2, max: 30, trigger: WeRuleTrigger.blur),
      ],
      onReset: () => setState(() => title = ''),
      child: WeInput(onChanged: (v) => setState(() => title = v)),
    ),
    WeFormItem(
      name: 'category',
      label: '分类',
      value: category,
      rules: const [WeRule(required: true, message: '请选择分类')],
      onReset: () => setState(() => category = null),
      child: WeSelect<String>(
        value: category,
        options: categories,
        onChanged: (v) => setState(() => category = v),
      ),
    ),
  ],
);

// 提交
if (await form.validate()) {
  await save();
}
```

字段自己管理状态（例如用 `TextEditingController`）、页面不会随输入重建时，用 `valueGetter: () => controller.text` 代替 `value`。

##### 规则 WeRule

| 参数 | 说明 |
| --- | --- |
| `required` | 必填；空字符串、空集合、`null` 都算空 |
| `min` / `max` | 字符串比长度，数字比大小，集合比个数 |
| `pattern` | 正则 |
| `validator` | 自定义检查，返回错误文字或 `null`，可以是异步的（比如查重名） |
| `message` | 覆盖内置提示 |
| `trigger` | `change`（值变化时，默认）、`blur`（失焦时）、`submit`（只在 `validate()` 时） |

一个字段的规则按顺序执行，遇到第一个不通过的就停下。非必填且值为空时，除 `validator` 外的规则都跳过。

##### WeFormController

| 方法 | 说明 |
| --- | --- |
| `validate()` | 校验所有字段，返回 `Future<bool>`；失败时滚动到屏幕上最靠上的错误（`WeForm.scrollToError`） |
| `validateField(name)` | 只校验一个字段 |
| `resetFields([names])` | 清除错误并调用各项的 `onReset` 还原值；还原本身不会触发校验 |
| `clearValidate([names])` | 只清除错误 |
| `scrollToField(name)` | 滚动到某个字段 |
| `errorOf(name)` | 读取某个字段当前的错误 |

##### 排版

| 参数 | 说明 |
| --- | --- |
| `labelWidth` | 标签列宽度，默认 100 |
| `labelPosition` | `right`（默认）、`left`、`top` |
| `inline` | 行内表单，适合列表页上方的搜索条 |
| `size` | 字段没有自己指定尺寸时使用的尺寸 |
| `disabled` | 禁用整张表单 |
| `hideRequiredAsterisk` | 不显示必填星号 |
| `itemGap` | 每项下方的间距，错误文字就显示在这里，出错时不会把下面的内容顶下去 |

`WeFormItem` 上的 `labelWidth`、`labelPosition`、`size`、`disabled` 可以单独覆盖表单的设置；`error` 用来显示服务端返回的错误。

#### WeSelect

`WeSelect` 对标 `el-select`，下拉面板是 `WePopper`，会跟着滚动、放不下时向上翻。

```dart
// 单选
WeSelect<String>(
  value: status,
  hint: '订单状态',
  clearable: true,
  options: const [WeSelectOption('paid', '已付款'), WeSelectOption('shipped', '已发货')],
  onChanged: (v) => setState(() => status = v),
)

// 多选：标签展示，超过 1 个折叠为 +N，最多选 3 个，可搜索
WeSelect<String>.multiple(
  values: tags,
  options: allTags,
  filterable: true,
  collapseTags: true,
  collapseTagsTooltip: true,
  multipleLimit: 3,
  onChanged: (v) => setState(() => tags = v),
)

// 分组
WeSelect<String>(
  value: city,
  groups: const [
    WeSelectGroup('华东', [WeSelectOption('sh', '上海'), WeSelectOption('hz', '杭州')]),
    WeSelectGroup('华南', [WeSelectOption('gz', '广州'), WeSelectOption('sz', '深圳')]),
  ],
  onChanged: (v) => setState(() => city = v),
)

// 远程搜索：边输入边查，自带防抖和"加载中"
WeSelect<int>(
  value: userId,
  hint: '搜索用户',
  remoteMethod: (query) async => [
    for (final u in await api.searchUsers(query)) WeSelectOption(u.id, u.name),
  ],
  onChanged: (v) => setState(() => userId = v),
)
```

键盘操作：↓ / ↑ 打开面板并移动高亮（跳过禁用项），Enter 选中，Esc 关闭；多选且搜索框为空时，Backspace 删除最后一个标签。

| 参数 | 说明 |
| --- | --- |
| `options` / `groups` | 选项，或带标题的分组 |
| `clearable` | 悬停时显示清空按钮 |
| `filterable` / `filterMethod` | 可输入筛选，默认按标签包含、不区分大小写 |
| `remoteMethod` / `remoteDebounce` | 远程搜索与防抖时长，传了就自动可输入 |
| `noDataText` / `noMatchText` / `loadingText` | 三种空状态文字 |
| `collapseTags` / `maxCollapseTags` / `collapseTagsTooltip` | 多选时折叠标签 |
| `multipleLimit` | 多选上限，0 表示不限 |
| `status` | 边框语义色；放在 `WeFormItem` 里时出错会自动变红 |
| `maxHeight` | 选项列表最大高度 |
