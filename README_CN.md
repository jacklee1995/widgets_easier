# Widgets Easier

Widgets Easier是一个开源库的Flutter组件库，附带了多个预构建UI组件。它旨在使开发更快更加地简单和高效，让开发成为一件愉快地事情。

![widgets_easier.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/widgets_easier.png)

## Features

- **预构建的 UI 组件**：使用我们的预构建 UI 小部件集合，包括按钮、卡片、弹窗等，节省时间和精力。
- **定制选项**：轻松定制每个组件，以匹配您应用程序的独特设计和品牌需求。
- **响应式设计**：借助内置的响应式功能，确保您的应用在任何屏幕大小上都看起来很棒。
- **跨平台兼容性**：轻松构建一次，并在多个平台（包括 iOS、Android 和 Web）上部署，无需额外工作。
- **开源和社区驱动**：受益于积极的开发者社区，他们不断为库的增长和改进做出贡献。
- **简单集成**：通过简单的安装步骤，轻松将 WidgetsEasier 无缝集成到您现有的 Flutter 项目中。
- **定期更新**：我们会持续更新和增强 WidgetsEasier，让您紧跟最新的 Flutter 趋势和最佳实践。

## 开始

在你的Flutter项目中，运行下面的命令：

```bash
flutter pub add widgets_easier
flutter pub add flutter_easy_animations
```

即可安装最新版本的 Widgets Easier 库。其中动画部分封装为 flutter_easy_animations 库，使用到相关功能时，需要单独安装。

## 示例应用

除了包内 `example/` 中的最小示例，GitHub 上还提供了一个独立的桌面示例应用项目 [widgets_easier_app](https://github.com/jacklee1995/widgets_easier_app)，完整演示了各个组件的用法，建议参考。

## 按平台选组件

每个组件都有一个平台标签，下面各节标题后的〔 〕就是它：

| 标签 | 意思 | 例子 |
| --- | --- | --- |
| 〔通用〕 | 手机、网页、桌面都好用 | 按钮、标签、表单控件、WeDatePicker、WeDialog、WeMessage、WeDrawer |
| 〔网页 / 桌面〕 | 依赖鼠标悬停、键盘或宽屏 | WeMenu、WeTable、WePagination、WeCalendar、WeCascader、WeTooltip |
| 〔手机〕 | 为手指和窄屏设计 | 底部弹窗、WeDateSheet、WeTabbar、CounterInput、PaginationView |
| 〔已弃用〕 | 1.0.0 移除，请换成新组件 | SemanticButton、NotifyToasts、TipToasts |

在手机上（包括手机浏览器）组件会自动适应：按钮、输入框等从 32 高变成 44 高，悬停触发改成点按，`WeTooltip` 改成长按，通知和弹窗不会超出屏幕。不想要可以用 `WeTheme.light(interaction: WeInteraction.pointer)` 关掉。调试时在手机上用了〔网页 / 桌面〕组件，控制台会提醒一次并给出替代建议。

完整清单、手机上的替代组件和两套尺寸见：[按平台选组件](./docs_CN/platform.md)。示例 app 的「组件总览」页可以按平台筛选，还能打开「按手机预览」直接看效果。

## Usage

### 1. 边框〔通用〕

受到CSS边框和其它一些前端模块的启发，**Widgets Easier** 提供了多种边框类型和边框工具，如常见的实线边框、虚线边框、破折线式边框、点划线边框、双线边框，还包括一些略为复杂的具有立体效果边框类型如槽线式边框、脊线式边框、内嵌式边框、外凸式边框等。详细文档请参考：[border](./docs_CN/border.md)

### 2. 阴影盒子〔通用〕

受启发于 **[Element-Plus](https://element-plus.org/)** 在 **Widgets Easier** 组件库中，提供了特定阴影效果。这些阴影效果能够以组件的方式为其它的组件添加相对应的阴影效果。：[shadow_box](./docs_CN/shadow_box.md)

![example_kAfLS9VvwG](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_kAfLS9VvwG.png)

### 3. 按钮〔已弃用〕

**SemanticButton** 是一个高度可定制的按钮组件，支持多种视觉和交互效果。它允许开发者设置按钮的文本、图标、颜色、边框样式、阴影、以及交互时的视觉反馈。此外，按钮可以配置为带有前缀图标和后缀图标，增加按钮的表达力和功能性。详细文档请参考：

[SemanticButton文档](./docs_CN/semantic_button.md)

![example_udTNKdt6RP](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_udTNKdt6RP.gif)

![example_Ta3ohFfhRn](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Ta3ohFfhRn.gif)

![example_zQldNd5Agw](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_zQldNd5Agw.gif)

![example_0IooMDarZl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0IooMDarZl.gif)

![example_xIzQytfQ87](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_xIzQytfQ87.gif)

![example_3spR0CNRPN](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_3spR0CNRPN.gif)

![example_j7nmu9vC0M](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_j7nmu9vC0M.png)

![example_6WGxVLs5Dy](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_6WGxVLs5Dy.gif)

![example_ZPNFkyEpaC](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_ZPNFkyEpaC.gif)

### 4. 按钮组〔已弃用〕

按钮组是多个SemanticButton的集合，他们具有统一的语义，并且以紧密的方式进行排列。

详细请参考文档：[ButtonGroup](./docs_CN/button_group.md)

![example_M8MY32Z4QW](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_M8MY32Z4QW.gif)

![example_GFp71agb79](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_GFp71agb79.gif)

![example_KLiWhn18t5](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_KLiWhn18t5.gif)

![example_FWgfhJiS1W](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_FWgfhJiS1W.gif)

![example_f6xDuUhP6W](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_f6xDuUhP6W.gif)

![example_W6GYBdDlgJ](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_W6GYBdDlgJ.gif)

### 5. 标签〔通用〕

详细请参考文档：[Tag](./docs_CN/tag.md)

![example_RLfAZpHGRt](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_RLfAZpHGRt.png)

![example_uLVBhrUyBl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uLVBhrUyBl.png)

![example_4GWiRl3tzL](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4GWiRl3tzL.png)

![example_HJgxs2Vv3O](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_HJgxs2Vv3O.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/cea33e4f5e9f46d5a148d886959c6d32.gif)

### 6. 加减器〔手机〕

**CounterInput** 是一个用于数值输入和调整的 **Flutter** 组件，它提供了一个直观的界面，允许用户通过点击加号和减号按钮或直接输入数值来改变当前值。改组件包含以下特性：

1. 支持点击加号和减号按钮来增加或减少当前值
2. 支持直接在文本框中输入数值；
3. 可自定义的最小值、最大值和步长；
4. 可自定义的样式，包括大小、颜色和边框样式；
5. 提供了多个回调事件，用于监听值的变化和边界情况；
6. 支持长按加号和减号按钮来连续改变值；
7. 支持禁用和启用组件的交互。

详细请参考文档：[Counter](./docs_CN/counter.md)

![example_uoLPuBTKzb](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uoLPuBTKzb.png)

![example_h0k4KWue9E](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_h0k4KWue9E.png)

![example_1JTzG6Hlaf](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_1JTzG6Hlaf.png)

![example_eDBmo5IVT9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_eDBmo5IVT9.png)

![example_tjpQHhVKRl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_tjpQHhVKRl.png)

![example_4AXqYeLDKp](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4AXqYeLDKp.gif)

![example_wzi2mFQRMk](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_wzi2mFQRMk.gif)

![example_fMYLgu8hR9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_fMYLgu8hR9.gif)

![example_Jfs459a3CF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Jfs459a3CF.gif)

### 7. 动画〔通用〕

动画相关工具被单独封装在`flutter_easy_animations`库中，需要独立进行安装：

```bash
flutter pub add flutter_easy_animations
```

更多关于动画用法，请查阅写在`flutter_easy_animations`中的文档：[https://pub.dev/packages/flutter_easy_animations](https://pub.dev/packages/flutter_easy_animations)

### 8. 弹窗〔通用〕

**widgets Easier** 内部集成了多种弹窗类型，详细请参考文档：[Dialogs](./docs_CN/dialogs.md)

![example_QCpD0oPAWg](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_QCpD0oPAWg.gif)

![example_CYfwe0SU6B](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_CYfwe0SU6B.gif)

![example_UqL2qrRpiO](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_UqL2qrRpiO.gif)

![example_EGAUPCK3VF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_EGAUPCK3VF.gif)

![example_Z45EJiFtKU](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Z45EJiFtKU.gif)

![example_BTEipOt7f9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_BTEipOt7f9.gif)

![example_XXgNIBMhxU](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_XXgNIBMhxU.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/989b2405eaab4d629d9ce22c4a9a6a71.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/9fc16728e2c740e39d3bd1f729a6dd7d.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/296cf1829bb047448477db75ff560ed1.gif)

### 9. 消息吐丝〔已弃用〕

> **已弃用，1.0.0 移除**：新代码请用 [WeNotification](./docs_CN/notification.md)。`NotifyToasts.showTopRight(...)` 直接改成 `WeNotification.show(...)`，其余三个角加 `position:`。

消息吐丝（**NotifyToasts**）受到**Element-Plus**的**Notification**启发，并以一种适合于在**Flutter**上使用的方式进行封装。它提供了一种简单而灵活的方式来在你的应用中显示消息通知。通过自定义样式、动画效果和交互，你可以创建出符合应用设计风格的消息通知。详细请参考文档：[NotifyToasts](./docs_CN/notify_toasts.md)

![example_qCE7P4gOkP](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_qCE7P4gOkP.gif)

![example_5MJrSKGAUZ](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_5MJrSKGAUZ.gif)

![example_N97sCnevj3](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_N97sCnevj3.gif)

![example_0VkrqwD0V6](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0VkrqwD0V6.gif)

![example_v5UtPLQkCx](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_v5UtPLQkCx.gif)

![example_oRw9m9WFAl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_oRw9m9WFAl.gif)

![example_hLZFdhRnWm](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_hLZFdhRnWm.gif)

![example_11BEIJRAt5](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_11BEIJRAt5.gif)

![example_s2AsI6WQKD](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_s2AsI6WQKD.gif)

### 10. 提示吐丝〔已弃用〕

**TipToasts** 是一个用于在 **Flutter** 应用中显示提示消息的工具类，是一种最简单的吐丝。它提供了一种简单而灵活的方式来在屏幕的不同位置显示短暂的提示信息，并支持自定义动画效果和样式。详细请参考文档：[TipToasts](./docs_CN/tip_toasts.md)

![example_JskzbjcvBA](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_JskzbjcvBA.gif)

![example_NznGSg2hm0](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_NznGSg2hm0.gif)

![example_hbHZoFAO8O](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_hbHZoFAO8O.gif)

### 11. 底部弹窗〔手机〕

**widgets Easier** 内部集成了多种底部弹窗类型，详细请参考文档：[Bottom Sheets](./docs_CN/bottom_sheets.md)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/50c63288482441e696045cef7abddea9.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/6a74972d5f8048209ccb257206fba86d.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/cc84116e550b4a28a58660ad918cb24b.gif)

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/3d7c9de55d8642c8bc054514a68b5d76.gif)

### 12. 抽屉〔通用〕

`WeDrawer` 对标 `el-drawer`：四个方向滑出，尺寸可按屏幕比例或像素指定，可拖动调整大小，`beforeClose` 可以在关闭前询问。详细请参考文档：[Dialogs · WeDrawer](./docs_CN/dialogs.md#wedrawer)

### 13. 隐私保护组件〔通用〕

`PrivacyGuard` 已移到独立的包 [widgets_easier_privacy_guard](https://pub.dev/packages/widgets_easier_privacy_guard)，因为它是唯一带原生代码的组件。添加这个包，并改为导入 `package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart`。各平台的后台模糊、禁止截屏、截屏和录屏事件的支持情况见该包的 README。

### 14. 浮层〔通用〕

`WePopper` 是所有贴着触发器弹出的面板的底座，会跟随滚动、自动翻转、Esc 只关最上面一层；在它之上有 `WeTooltip`、`WePopover`、`WePopconfirm`。详细请参考文档：[Overlay](./docs_CN/overlay.md)

### 15. 表单〔通用〕

`WeForm` / `WeFormItem` / `WeRule` / `WeFormController` 提供标签排版和同步、异步校验；`WeSelect` 支持多选、搜索、远程搜索、分组和键盘操作。详细请参考文档：[Form](./docs_CN/form.md)

### 16. 上传〔通用〕

`WeUpload` 不带原生依赖：选文件和上传都由你传入回调，组件负责类型 / 大小 / 数量检查、进度、失败重试、删除确认，支持文件列表、缩略图列表和图片墙。详细请参考文档：[Upload](./docs_CN/upload.md)

### 17. 步骤条〔通用〕

`WeSteps` 支持横向、居中、纵向和 simple 样式，finish / process / error / success 状态，以及点击回跳。详细请参考文档：[Steps](./docs_CN/steps.md)

### 18. 级联选择〔网页 / 桌面〕

`WeCascader` 一列一层地选出一条路径（省 / 市 / 区），支持搜索完整路径、任选一级、悬停展开和键盘操作。详细请参考文档：[Cascader](./docs_CN/cascader.md)

### 19. 日期〔通用〕

`WeDatePicker`（单日 / 范围、可键入、快捷项）在电脑上弹日历面板，全部可用键盘操作；在手机上自动改成从底部弹出的年 / 月 / 日滚轮 `WeDateSheet`，不用改代码。滚轮本身 `WeDateWheel` 也能直接放进页面〔手机〕。日历面板 `WeDatePanel` 和日程看板 `WeCalendar` 仍为网页和桌面端设计〔网页 / 桌面〕。详细请参考文档：[Date](./docs_CN/date.md)

### 20. 通知与加载〔通用〕

`WeNotification` 是从屏幕四角滑入、自动排队的通知卡片，鼠标悬停时不会消失，适合"导出完成""库存告急"这类消息；刚做完一个操作的即时反馈继续用 `WeMessage`。`WeLoading` 可以盖住一块区域（空闲时不耗性能），也可以 `WeLoading.service` 盖住全屏；`WeTable(loading: true)` 在有数据时保留旧行并盖遮罩，没数据时显示骨架屏。详细请参考文档：[Notification](./docs_CN/notification.md)、[Loading](./docs_CN/loading.md)

### 21. 滑块〔通用〕

`WeSlider` / `WeSlider.range` 支持步进、刻度、旁路数字框，并接入 `WeFormItem`。详细请参考文档：[Slider](./docs_CN/slider.md)

### 22. 页头、折叠、图片、走马灯〔通用〕

`WePageHeader` 页头；`WeCollapse` 折叠面板（手风琴、右侧 extra、键盘可操作）；`WeImage` 图片与全屏预览器 `WeImageViewer`（鼠标点两侧箭头翻页、滚轮缩放、旋转，键盘 ← → + - 0 Esc，触屏滑动）；`WeCarousel` 走马灯。详细请参考文档：[PageHeader](./docs_CN/page_header.md)、[Collapse](./docs_CN/collapse.md)、[Image](./docs_CN/image.md)、[Carousel](./docs_CN/carousel.md)

### 23. 树〔通用〕

`WeTree` 展示有层级的数据：父子联动勾选（与 Element Plus 规则一致，禁用项不跟着勾）、搜索过滤并高亮、第一次展开时再加载、手风琴、全键盘操作。`WeTreeSelect` 把树放进下拉框，单选 / 多选都支持，示例后台的商品筛选和"发布新品"里的类目就是用它做的。三种下拉框（`WeSelect`、`WeCascader`、`WeTreeSelect`）共用同一个外框 `WeFieldBox`，外观和交互完全一致。详细请参考文档：[Tree](./docs_CN/tree.md)

### 24. 底部导航栏〔手机〕

`WeTabbar` 是手机 App 最下面那一排"首页 / 分类 / 消息 / 我的"：各项平分宽度，支持数字角标、小红点、选中时换实心图标，再点一次当前项会触发 `onReselect`（常用来回到顶部），并自动让出 iPhone 底部的 Home 条。电脑和网页上请继续用 `WeMenu` 或 `WeTabs`。详细请参考文档：[Tabbar](./docs_CN/tabbar.md)

## 已知限制与后续计划

- **选平台**：见上面的[按平台选组件](#按平台选组件)和 [platform.md](./docs_CN/platform.md)。
- **平台适配还没做**：按实际指针类型动态切换（例如带触屏的笔记本，目前只看系统平台，可用 `WeInteraction` 手动指定）；`WeTable` 在窄屏上自动变成卡片列表。
- **还没有替代品的老组件**：无。`NotifyToasts`、`TipToasts`、`SliderWidget`、`FutureDialogs`、`PercentIndicator`、`Picture` 均已标记弃用，1.0.0 移除。
- **还没做**：`WeTimePicker` / `WeDateTimePicker`（手机滚轮目前只能选到日，不能选时分）、`WeTabbar` 中间凸起的大按钮、农历显示、多选版 `WeCascader`、树节点拖拽、`WeTree` 的虚拟滚动（几千个节点全部展开时会慢，建议配合懒加载）、`WeConfigProvider` 全局文案表（组件里的"请选择""暂无数据"目前是中文默认值，要改得逐个传参数）。
- `WeImageViewer` 不带 SVG 支持；`WeImage` 取代 `Picture` 后，SVG 请直接用 `flutter_svg`。
- `WeUpload` 不带原生依赖，因此"从系统拖文件进来"需要应用自己接入拖放插件，再把文件交给 `WeUploadController`。

## 问题报告和代码贡献

### Issues Report

您可以在该项目的 **GitHub** 页面上提供反馈或报告[问题](https://github.com/jacklee1995/widgets_easier/issues)。如果您觉得这个库缺少某个功能，请创建一个功能请求。在提交前，请先检查是否已又类似问题。

### 代码贡献

请将此仓库Fock到您的账户中，修改后rebase再PR到dev分支。建议提交信息格式为：

```
type(scope): info about commit.
```
