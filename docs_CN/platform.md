# 按平台选组件

widgets_easier 同时服务手机、网页和桌面。有的组件哪里都好用，有的离不开鼠标和宽屏，有的专门为手指设计。每个组件都贴了一个平台标签，组件总览页、文档标题下方和 README 里的标签保持一致。

## 三档标签

| 标签 | 意思 |
| --- | --- |
| 〔通用〕 | 手机、网页、桌面都好用；在触屏上会自动变大、改用点按 |
| 〔网页 / 桌面〕 | 依赖鼠标悬停、键盘或宽屏；放到手机上能用但不顺手，调试时会在控制台提醒 |
| 〔手机〕 | 为手指和窄屏设计，例如从底部弹出、大按钮、上拉加载 |
| 〔已弃用〕 | 老组件，1.0.0 移除；不再贴平台标签，按提示换成新组件 |

在代码里也能拿到这三档：`WePlatformFit.universal / desktop / mobile`，各自带 `label` 和 `icon`。

## 怎么判断

一个组件满足下面任意一条，就算〔网页 / 桌面〕：

- 核心功能靠鼠标悬停才能发现（手机上没有悬停）；
- 需要键盘操作才顺手（方向键、快捷键）；
- 内容需要 600 以上的宽度才放得下（多列表格、双月日历）；
- 手指可点区域达不到 44 × 44。

## 分类清单

- 〔通用〕
  - 基础：WeButton、WeButtonGroup、WeText、WeLink、Tag / CheckTag、WeBadge、WeAvatar、WeDivider、WeImage / WeImageViewer、WeCard、WeStatistic、边框与阴影
  - 表单：WeForm、WeInput、WeDatePicker（手机上自动弹底部滚轮）、WeSelect、WeTreeSelect、WeCheckbox、WeRadioGroup、WeSwitch、WeRate、WeSlider、WeUpload、WeCaptcha
  - 数据：WeDescriptions、WeTimeline、WeCollapse、WeCarousel、WeTree、WeProgress
  - 导航：WeTabs、WeSegmented、WeBreadcrumb、WeDropdown、WeSteps、WePageHeader
  - 反馈：WePopover / WePopconfirm、WePopper、WeDrawer、WeAlert、WeMessage、WeLoading、WeNotification、WeDialog、WeMessageBox、WeEmpty、WeResult、WeSkeleton
- 〔网页 / 桌面〕：WeMenu、WeTable、WePagination、WeCalendar、WeDatePanel、WeCascader、WeTooltip（触屏上改为长按显示）、WinStyleDialog / WinDialogs
- 〔手机〕：BottomSheets / CascadeBottomSheet、WeDateSheet / WeDateWheel、WeTabbar、CounterInput、PaginationView（加载框架）
- 〔已弃用〕：SemanticButton、ButtonGroup、NotifyToasts、TipToasts、InfoDialogs、ConfirmDialogs、FutureDialogs、LoadingDialogs、SliderWidget、SliderInputWidget、PercentIndicator、Picture、SlidingCaptcha

## 手机上换什么

| 网页 / 桌面 | 手机上建议 |
| --- | --- |
| WeMessageBox、WinStyleDialog | 底部弹窗 BottomSheets |
| WePagination | PaginationView（上拉加载） |
| WeCascader | CascadeBottomSheet |
| WeInput 数字输入 | CounterInput |
| WeMenu | 底部导航栏 WeTabbar，或 WeTabs |
| WeTable | WeDescriptions 或列表卡片 |
| WeDatePanel、WeCalendar | 底部滚轮 WeDateSheet，或直接放 WeDateWheel；WeDatePicker 在手机上会自己换成 WeDateSheet |

## 触屏上自动做了什么

不用改代码，组件在触屏上会自己调整：

- **控件变大**：按钮、输入框、选择器等从 32 高变成 44 高，字号和内边距一起加大，手指更好点。
- **悬停改点按**：`WePopper` / `WePopover` / `WeDropdown` 设成悬停触发时，在触屏上点一下打开。
- **提示改长按**：`WeTooltip` 在触屏上长按显示，约 1.5 秒后自己收起；单击仍然交给里面的按钮。
- **宽度不超屏**：`WeNotification`（330）、`WeDialog`（480）、`WinStyleDialog`（460）、浮层（420）都不会超过屏幕宽度。
- **日期改滚轮**：`WeDatePicker` 在触屏上点开是底部滚轮 `WeDateSheet`，输入框只读、不弹键盘；想保留日历面板就传 `touchMode: WeDatePickerTouchMode.panel`。
- **去掉键盘说明**：图片预览器的按钮提示不再显示"（Esc）""（←）"这类快捷键。
- **调试提醒**：在触屏上用了〔网页 / 桌面〕组件，调试模式下控制台打印一次提醒和替代建议；正式包里不会有。

## 怎么判断"是不是触屏"

`WePlatform.isTouch(context)` 看 `Theme.of(context).platform`：Android、iOS、Fuchsia 算触屏，Windows、macOS、Linux 不算。网页上这个值就是访问者的系统，所以手机浏览器会自动按触屏处理。

示例 app 的"按手机预览"开关就是用局部 `Theme` 把平台换成 Android 来模拟手机。

## 强制指定

```dart
// 平板或触屏一体机上也想用紧凑的桌面尺寸
ThemeData(extensions: const [WeTheme.light(interaction: WeInteraction.pointer)]);

// 桌面上也按触屏显示（例如做触摸屏收银机）
ThemeData(extensions: const [WeTheme.light(interaction: WeInteraction.touch)]);

// 关掉调试提醒
WePlatform.debugHints = false;
```

自己传了 `sizes`（不是默认的 `WeSizeScheme.standard()`）时，组件不会再替你换尺寸。

## 两套尺寸

| 档位 | 标准（鼠标） | 触屏 |
| --- | --- | --- |
| 常规控件 large / medium / small | 40 / 32 / 24 | 48 / 44 / 36 |
| 紧凑件 large / medium / small | 32 / 24 / 20 | 32 / 28 / 24 |
| 常规控件字号 medium | 14 | 16 |

也可以直接用：`WeSizeScheme.standard()`、`WeSizeScheme.touch()`。
