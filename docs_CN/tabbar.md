### 24. 底部导航栏：WeTabbar

> 适用平台：手机 —— 为手指和窄屏设计；电脑和网页上请用 WeMenu 或 WeTabs（[按平台选组件](platform.md)）

`WeTabbar` 对标 Vant 的 `van-tabbar`，就是手机 App 最下面那一排"首页 / 分类 / 消息 / 我的"。一般放在 `Scaffold.bottomNavigationBar` 里：

```dart
int _tab = 0;

Scaffold(
  body: _pages[_tab],
  bottomNavigationBar: WeTabbar(
    index: _tab,
    onChanged: (i) => setState(() => _tab = i),
    onReselect: (i) => _scrollToTop(i),
    items: const [
      WeTabbarItem('首页', Icons.home_outlined, activeIcon: Icons.home),
      WeTabbarItem('分类', Icons.grid_view_outlined),
      WeTabbarItem('消息', Icons.chat_bubble_outline, badge: 3),
      WeTabbarItem('我的', Icons.person_outline, dot: true),
    ],
  ),
)
```

#### WeTabbarItem

| 参数 | 说明 |
| --- | --- |
| `label` / `icon` | 文字和图标（必填） |
| `activeIcon` | 选中时换成的图标，通常是同一个图标的实心版 |
| `badge` | 图标右上角的数字或短文字，超过 99 显示 `99+` |
| `dot` | 图标右上角的小红点，表示"有新内容"；和 `badge` 同时给时只显示 `badge` |

#### WeTabbar

| 参数 | 说明 |
| --- | --- |
| `items` | 至少 2 项，平分宽度 |
| `index` / `onChanged` | 当前选中项、点了别的项时回调 |
| `onReselect` | 再点一次当前项时回调，常用来让列表回到顶部 |
| `activeColor` / `inactiveColor` / `backgroundColor` | 默认是主题色、次要文字色、浮层背景色 |
| `safeArea` | 默认 `true`：在底部加上手机的安全区（iPhone 的 Home 条），不会被挡住 |
| `border` | 默认 `true`：顶部一条细分隔线 |
| `height` | 每项的高度，默认 56，不会小于 48，保证手指好点 |

- 切换时图标和文字的颜色有 150 毫秒的渐变。
- 读屏软件会把每一项读成"按钮，已选中，首页，1 / 4"，双击就能切换。
- 文字太长时显示省略号，不会挤乱排版。
