# Widgets Easier

Widgets Easier是一个开源库的Flutter组件库，附带了多个预构建UI组件。它旨在使开发更快更加地简单和高效，让开发成为一件愉快地事情。

![widgets_easier.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/assets/widgets_easier.png)

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

## Usage



### 1. 边框

#### 1.1 实线边框


实线边框（Solid Border）是最普通、最常见地边框类型。其主要特点包括：

1. 均匀的边缘：实线边框的特点是其边缘是均匀的、连续的实线，与周围的内容形成分隔。与脊线边框和槽线边框相比，实线边框的边缘没有凸起或凹陷的效果，而是平整地围绕着目标区域；
2. 清晰的界限：边框的边缘通常很清晰，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界；
3. 简洁的外观：实线边框呈现出简洁、直接的外观，没有额外的装饰或深度效果。这种简洁的外观有时候更适合需要注重内容本身而不是外观装饰的界面设计。

实线边框通常用于需要简洁、清晰的界面布局中，例如表格的边框、按钮、输入框等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用实线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。

 

```dart
Container(
  width: 100,
  height: 50,
  decoration: ShapeDecoration(
    shape: SolidBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Center(child: Text("Hello, World!")),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_rMLTHxf325.png)

```dart
Container(
  width: 100,
  height: 50,
  decoration: ShapeDecoration(
    shape: SolidBorder(
      width: 8,
      borderRadius: BorderRadius.circular(12),
      // 或使用渐变色
      gradient: const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  child: const Center(child: Text("Hello, World!")),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_tGc7sGaRB6.png)

#### 1.2 虚线边框


虚线边框（Dotted Border）是一种在界面设计中另外一种边框类型。

1. 点线组成：虚线边框的特点是其边缘由一系列间隔的点线组成，而不是连续的实线。这种点线的组合在视觉上形成了一种虚化的边界，使得目标区域的边缘变得更加柔和；
2. 轻盈的外观：虚线边框呈现出轻盈、细腻的外观，与实线边框相比更加柔和。这种轻盈的外观使得虚线边框在需要突出显示目标区域但又不希望过于强调边缘的场景中非常适用；
3. 视觉分隔：虽然虚线边框没有实线边框那么明确的界限，但它仍然能够提供视觉上的分隔效果，使得用户能够清晰地识别出目标区域的边界。虚线边框也常用于突出显示特定内容或者作为装饰性边框使用。

虚线边框通常用于需要柔和、轻盈的界面布局中，例如卡片、面板、图像边框等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用虚线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。

一个例子如下：


```dart
Container(
  height: 150,
  width: 300,
  decoration: ShapeDecoration(
    shape: DottedBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Center(
    child: Text('Dotted Border Example'),
  ),
)
```

![example_4Cfj04zZEp.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4Cfj04zZEp.png)

```dart
Container(
  height: 150,
  width: 300,
  decoration: ShapeDecoration(
    shape: DottedBorder(
      dotSize: 6,
      dotSpacing: 10,
      borderRadius: BorderRadius.circular(10),
      color: Colors.amber,
    ),
  ),
  child: const Center(
    child: Text('Dotted Border Example'),
  ),
)
```

![example_UYLv3I04IM.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_UYLv3I04IM.png)

```dart
Container(
  height: 50,
  width: 300,
  decoration: ShapeDecoration(
    shape: DottedBorder(
      dotSize: 6,
      dotSpacing: 10,
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [
          Colors.blue,
          Colors.purple,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  child: const Center(
    child: Text('Dotted Border Gradient Example'),
  ),
)
```

![example_ftVtVT1h3h.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_ftVtVT1h3h.png)

#### 1.3 破折线（划线）式边框


破折线式边框（Dashed Border）是界面设计中常见的边框样式之一，与实线边框和虚线边框相比，其外观和特点略有不同。其主要特点包括：

1. 破折线组成：破折线式边框的特点是其边缘由一系列间隔的短线段组成，这些短线段以一定的间隔排列，形成了一种破折的边缘效果。这种破折的外观在视觉上给人一种活泼、有趣的感觉；
2. 动态的外观：与实线边框和虚线边框相比，破折线式边框呈现出更具有动态感和活力感的外观。这种外观特点使得破折线边框常被用于需要突出显示目标区域并且希望引起用户注意的场景中；
3. 视觉分隔：尽管破折线式边框的边缘不像实线边框那样连续、明确，但它仍然能够提供一定程度的视觉分隔效果，帮助用户识别出目标区域的边界。

破折线式边框通常用于需要活泼、有趣的界面布局中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用破折线式边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。

一个例子如下：

```dart
Container(
  height: 150,
  width: 300,
  decoration: ShapeDecoration(
    shape: DashedBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Center(
    child: Text(
      'Dashed Border Example',
    ),
  ),
)
```

![example_YmfrrDWpjQ.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_YmfrrDWpjQ.png)

```dart
Container(
  height: 150,
  width: 300,
  decoration: ShapeDecoration(
    shape: DashedBorder(
      width: 4,
      dashSize: 9,
      dashSpacing: 2,
      gradient: const LinearGradient(colors: [
        Colors.blue,
        Colors.purple,
      ]),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Center(
    child: Text(
      'Dashed Border Example',
    ),
  ),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_kAfLS9VvwG.png)

#### 1.4 点划线边框

点划线边框（Dotted Dash Border）是一种在界面设计中另外一种边框类型，，与实线边框、虚线边框、破折线边框等相比，其外观和特点略有不同。其主要特点有：

1. 点划线组成：点划线边框的特点是其边缘由一系列交替排列的点和短线段组成。这些点和短线段的组合形成了一种交替变化的边缘效果，使得边框的外观既有点线的连续性，又有短线段的间隔感；
2. 间隔分隔：点划线边框的点和短线段之间通常有一定的间隔，使得边框看起来更加轻盈和柔和。这种间隔分隔的外观特点使得点划线边框常被用于需要突出显示目标区域但又不希望过于强调边缘的场景中；
3. 视觉分隔：尽管点划线边框的边缘没有实线边框那样连续、明确，但它仍然能够提供一定程度的视觉分隔效果，帮助用户识别出目标区域的边界。

点划线边框通常用于需要轻盈、柔和的界面布局中，例如卡片、面板、图像边框等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用点划线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。

```dart
Container(
  width: 200,
  height: 200,
  decoration: const ShapeDecoration(
    shape: DottedDashBorder(),
  ),
  child: const Center(child: Text("Circle Dots and Red Dashes")),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_trId7p4DfI.png)

```dart
Container(
  width: 200,
  height: 200,
  decoration: const ShapeDecoration(
    shape: DottedDashBorder(
      dotSize: 2.0,
      dashSize: 18.0,
      spacing: 6.0,
      dotShape: BorderDotShape.circle,
      dotColor: Colors.blue,
      dashColor: Colors.red,
    ),
  ),
  child: const Center(child: Text("Circle Dots and Red Dashes")),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_CKPX3uxFDT.png)

#### 1.5 双线边框


双线边框（Double Border）是一种常见的边框样式，在界面设计中用于突出显示或分隔不同区域。与单线边框相比，双线边框具有更加突出和立体的外观。其主要特点包括：

1. 双线结构：双线边框的特点是其边缘由两条平行的线条组成，这两条线条之间通常有一定的间隔，形成了一种双重的边界效果。这种双线结构在视觉上增强了边框的立体感和厚度感；
2. 突出的外观：由于双线边框具有两条线条，其边缘呈现出更加突出和立体的外观，与单线边框相比更加引人注目。这种突出的外观使得双线边框在需要强调目标区域或者提供视觉分隔的场景中非常适用；
3. 清晰的界限：双线边框的两条线条通常是清晰、连续的，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界。

双线边框常用于需要突出显示目标区域或者为元素增加立体感的界面布局中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用双线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。


```dart
Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: DoubleBorder(
      outerWidth: 4,
      innerWidth: 2,
      spacing: 3,
    ),
    color: Colors.white,
  ),
  child: const Center(child: Text("DoubleBorder")),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_yUydL93aSN.png)

```dart
Container(
  height: 150,
  width: 300,
  decoration: ShapeDecoration(
    shape: DoubleBorder(
      outerWidth: 5,
      borderRadius: BorderRadius.circular(20),
      innerWidth: 5,
      spacing: 4,
      outerGradient: const LinearGradient(
        colors: [Colors.purple, Colors.blue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      innerGradient: const LinearGradient(
        colors: [Colors.yellow, Colors.pink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    color: Colors.white,
  ),
  child: const Center(child: Text("DoubleBorder")),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Kb2mo2m5y3.png)

#### 1.6 槽线边框


槽线式边框（Groove Border）是一种3D效果的边框，用于突出显示或分隔不同区域。与其它边框相比，槽线边框呈现出相反的外观特点。其主要特点包括：

1. 凹陷的外观：槽线式边框的特点是其边缘呈现出一种凹陷的外观，与周围的内容形成明显的分隔。与脊线边框相比，槽线边框的边缘向内凹陷，这种外观给人一种深度感和压缩感；
2. 边缘明显：边框的边缘通常也比较明显，尽管是向内凹陷的，但同样可以吸引用户的注意力，同时提供视觉上的分隔。这使得界面元素之间的边界更加清晰;
3. 视觉层次感：槽线式边框同样可以带来视觉上的层次感，使得界面元素之间的关系更加清晰。通过外观的深度变化，用户可以更轻松地理解界面中不同部分之间的关系。

槽线边框通常用于与脊线边框相对应的场景，例如突出显示对话框、表格的单元格或者突出显示重要内容等。在设计中，选择使用槽线边框还是脊线边框取决于设计师对界面元素的整体风格和布局的需求。

你可以在 MDN 网站上尝试CSS版本，与这里的实现效果是一样的：https://developer.mozilla.org/zh-CN/docs/Web/CSS/border-style。


```dart
Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: GrooveBorder(width: 6),
  ),
  child: const Center(
    child: Text('Groove Border Example'),
  ),
),
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_pdxVBlA7pW.png)

#### 1.7 脊线式边框


脊线式边框（Ridge Border）通常用于突出显示或分隔不同区域。其特点包括：

1. 凸起的外观： 脊线式边框的特点是其边缘呈现出一种凸起的外观，与周围的内容形成明显的分隔;
2. 边缘明显： 边框的边缘通常比较明显，可以吸引用户的注意力，同时提供视觉上的分隔；
3. 视觉层次感： 脊线式边框可以带来视觉上的层次感，使得界面元素之间的关系更加清晰。
   这种边框常见于用户界面设计中，例如突出显示对话框、表格的单元格或者突出显示重要内容等场景。

你可以在 MDN 网站上尝试CSS版本，与这里的实现效果是一样的：https://developer.mozilla.org/zh-CN/docs/Web/CSS/border-style。

实际上脊线式边框和槽线式边框是完全对应的，相当于做了一个镜像。它也有两个颜色。亮色表示阴影，暗色表示实线。


```dart
Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: RidgeBorder(width: 6),
  ),
  child: const Center(child: Text("Ridge Border Example")),
),
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_ust5G0YwTs.png)

#### 1.8 内嵌式边框

内嵌式边框（Inset Border）也是一种3D效果的边框，它类似于Gooove边框。只不过没有内测阴影效果。

1. 向内凹陷的外观：内嵌式边框的特点是其边缘呈现出向内凹陷的外观，与周围的内容形成一种凹陷的边界。这种外观让用户感觉目标区域被边框所包裹，形成了一种立体感；
2. 清晰的界限：边框的边缘通常是清晰的，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界；
3. 视觉深度感：内嵌式边框带来了一种视觉深度感，使得目标区域看起来更加突出。这种效果有时候可以增强界面元素之间的层次感，提高用户对界面布局的理解；
4. 内嵌式边框（Inset Border）常用于突出显示或分隔不同区域。与外凸式边框（Outset Border）相对应，内嵌式边框的特点是其边缘呈现出向内凹陷的外观。

内嵌式边框常见于用户界面设计中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用内嵌式边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。


```dart
Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: InsetBorder(width: 8),
  ),
  child: const Center(child: Text("Inset Border Example")),
),
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_hhq0iDwXtx.png)

#### 1.9 外凸式边框

外凸式边框（Outset Border）也是一种3D效果的边框，它类似于Ridge边框。只不过没有内测阴影效果。与内嵌式边框相对应，其特点是边缘呈现出向外凸起的外观。

1. 向外凸起的外观：外凸式边框的特点是其边缘呈现出向外凸起的外观，与周围的内容形成一种凸起的边界。这种外观让用户感觉目标区域的边缘被突出，形成了一种立体感；
2. 清晰的界限：边框的边缘通常是清晰的，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界；
3. 视觉突出感：外凸式边框带来了一种视觉突出感，使得目标区域看起来更加突出。这种效果有时候可以增强界面元素之间的层次感，提高用户对界面布局的理解。

外凸式边框同样常见于用户界面设计中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用外凸式边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。


```dart
Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: OutsetBorder(width: 8),
  ),
  child: const Center(
    child: Text('Outset Border Example'),
  ),
),
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_bCS34n32wd.png)

#### 1.10 边框包装器（BorderWrapper）

通过使用BorderWrapper组件，可以在其它的组件上使用边框，边框外部的内容将被按照边框轮廓裁剪掉。例如：

```dart
BorderWrapper(
  shape: const SolidStarBorder(
    borderWidth: 19,
    borderGradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Card(
    child: SizedBox(
      width: 200,
      height: 200,
      child: Write.image(
        source: 'assets/example-img.png',
        fit: BoxFit.cover,
      ),
    ),
  ),
)
```

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_LY0KXoxpxN.png)

这个例子中，所使用的 SolidStarBorder 是基于Flutter原生的StarBorder实现的，在StarBorder上实现了Solid Border的效果。这使得你可以在SolidStarBorder上指定线宽、颜色，渐变色。边框包装器可以用于实现带有边框的裁剪，这使得改变原部件形状的同时在外围添加指定的线形效果。因此，为了实现更多边框形状，你可以实现类似于SolidStarBorder的，带有绘制线形的形状裁剪器。不过不用担心，此库后续将不断实现新的边框形状。



### 2. 阴影盒子

#### 2.1 阴影盒子介绍

受启发于 **[Element-Plus](https://element-plus.org/)** 在 **Widgets Easier** 组件库中，提供了特定阴影效果。这些阴影效果能够以组件的方式为其它的组件添加相对应的影音效果。

于 **[Element-Plus](https://element-plus.org/)** 类似， 在 **Widgets Easier** 库中，典型的阴影效果被封装为以下四个组件：**BasicShadow**、**LightShadow**、**LighterShadow**、**DarkShadow**，每个组件都使用 DecoratedBox 来实现特定的阴影效果。

![example_kAfLS9VvwG](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_kAfLS9VvwG.png)



#### 2.2 BasicShadow

`BasicShadow` 是一个提供基本阴影效果的组件。它使用 `DecoratedBox` 来实现阴影，适用于需要轻微突出显示的元素。这种阴影效果不太强烈，但足以给元素添加一些深度和立体感。

```dart
BasicShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('BasicShadow'),
    ),
  ),
)
```

#### 2.3 LightShadow

`LightShadow` 提供的是比 `BasicShadow` 更轻的阴影效果。它同样使用 `DecoratedBox`，阴影更加细微，适合不需要太多突出但又想有细微区分的界面元素。

```dart
LightShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('LightShadow'),
    ),
  ),
)
```

#### 2.4 LighterShadow

`LighterShadow` 是四种阴影中最轻的一种。它几乎不可见，只在必要时提供最轻微的阴影效果，适用于极为细腻的用户界面设计，其中每一个细节都需要精心处理。

```dart
LighterShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('LighterShadow'),
    ),
  ),
)
```

#### 2.5 DarkShadow

`DarkShadow` 提供的是最强烈的阴影效果，使用 `DecoratedBox` 实现。这种阴影适用于需要明显区分的元素，可以显著提升元素的视觉层次感和吸引用户的注意力。

```dart
DarkShadow(
  child: Container(
    height: 100,
    width: 100,
    color: Colors.white,
    child: const Center(
      child: Text('DarkShadow'),
    ),
  ),
)
```

### 3. 按钮

#### 3.1 SemanticButton基本用法

SemanticButton 是一个高度可定制的按钮组件，支持多种视觉和交互效果。它允许开发者设置按钮的文本、图标、颜色、边框样式、阴影、以及交互时的视觉反馈。此外，按钮可以配置为带有前缀图标和后缀图标，增加按钮的表达力和功能性。

将SemanticButton 的语义枚举应用于按钮，可以获得色彩主题差异化的不同按钮。

例如：
```dart
SemanticButton(
  text: 'primary',
  type: SemanticEnum.primary,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'secondary',
  type: SemanticEnum.secondary,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'info',
  type: SemanticEnum.info,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'success',
  type: SemanticEnum.success,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'warning',
  type: SemanticEnum.warning,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'danger',
  type: SemanticEnum.danger,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'fatal',
  type: SemanticEnum.fatal,
  onTap: () {},
```

![example_udTNKdt6RP](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_udTNKdt6RP.gif)

#### 3.2 轮廓按钮

##### 3.2.1 基本用法
SemanticButton默认为普通按钮（非轮廓按钮）。通过设置SemanticButton类的isOutlined属性参数值为true，则按钮将一轮廓形式显示，例如：

```dart
SemanticButton(
  text: 'primary',
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'secondary',
  type: SemanticEnum.secondary,
  isOutlined: true,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'info',
  type: SemanticEnum.info,
  isOutlined: true,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'success',
  type: SemanticEnum.success,
  isOutlined: true,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'warning',
  type: SemanticEnum.warning,
  isOutlined: true,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'danger',
  type: SemanticEnum.danger,
  isOutlined: true,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'fatal',
  type: SemanticEnum.fatal,
  isOutlined: true,
  onTap: () {},
),
```

![example_Ta3ohFfhRn](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_Ta3ohFfhRn.gif)

##### 3.2.2 轮廓类型

除了默认的实线轮廓外，还可以手动指定outlineStyle参数值设置伦托类型以及去轮廓。实线轮廓（OutlineStyle.solide）是默认的，因此这里不再重复给出例子。


###### Dotted轮廓
Dotted 轮廓由一系列间隔相等的点组成，这些点连接在一起形成物体的边缘。通过指定outlineStyle: OutlineStyle.dotted，可以设置Dotted轮廓。例如：

```dart
SemanticButton(
  text: 'primary',
  type: SemanticEnum.primary,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'secondary',
  type: SemanticEnum.secondary,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'info',
  type: SemanticEnum.info,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'success',
  type: SemanticEnum.success,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'warning',
  type: SemanticEnum.warning,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'danger',
  type: SemanticEnum.danger,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'fatal',
  type: SemanticEnum.fatal,
  isOutlined: true,
  outlineStyle: OutlineStyle.dotted,
  onTap: () {},
),
```

![example_zQldNd5Agw](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_zQldNd5Agw.gif)

###### Dashed轮廓

Dashed 轮廓由一系列间隔的虚线组成，这些虚线连接在一起形成物体的边缘。通过指定outlineStyle: OutlineStyle.dashed，可以设置Dashed轮廓。例如：
```dart
SemanticButton(
  text: 'primary',
  type: SemanticEnum.primary,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'secondary',
  type: SemanticEnum.secondary,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'info',
  type: SemanticEnum.info,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'success',
  type: SemanticEnum.success,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'warning',
  type: SemanticEnum.warning,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'danger',
  type: SemanticEnum.danger,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'fatal',
  type: SemanticEnum.fatal,
  isOutlined: true,
  outlineStyle: OutlineStyle.dashed,
  onTap: () {},
),
```

![example_0IooMDarZl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_0IooMDarZl.gif)

###### 禁用轮廓

通过指定outlineStyle: OutlineStyle.none，可以禁用轮廓。例如：

```dart
SemanticButton(
  text: 'primary',
  type: SemanticEnum.primary,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'secondary',
  type: SemanticEnum.secondary,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'info',
  type: SemanticEnum.info,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'success',
  type: SemanticEnum.success,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'warning',
  type: SemanticEnum.warning,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'danger',
  type: SemanticEnum.danger,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'fatal',
  type: SemanticEnum.fatal,
  isOutlined: true,
  outlineStyle: OutlineStyle.none,
  onTap: () {},
),
```

![example_xIzQytfQ87](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_xIzQytfQ87.gif)

#### 3.3 回调函数与禁用状态


通过设置按钮ontap属性值可以指定一个函数作为按钮点击时间的回调函数。如果没有指定回调函数，或者指定onTap属性的值为null，则按钮状态成为禁用状态。例如：

![example_3spR0CNRPN](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_3spR0CNRPN.gif)


对于桌面端或者Web平台，一个被禁用的按钮不仅无法被点击，而且在hover时，不会像正常按钮那样拥有海拔变化。图标上也从寿星图标转换为禁用图标。

#### 3.4 文本样式

通过设置fontSize属性，可以指定文本的大小。例如：

```dart
SemanticButton(
  text: 'fontSize: 22',
  fontSize: 22,
  onTap: () {},
  shrink: true,
),
```

![example_CKynxsm8dc](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_CKynxsm8dc.png)

通过fontWeight属性，可以指定字体粗细程度，例如


```dart
SemanticButton(
  text: 'normal',
  fontWeight: FontWeight.normal,
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'default',
  onTap: () {},
),
const Gap(10),
SemanticButton(
  text: 'FontWeight.w900',
  onTap: () {},
  fontWeight: FontWeight.w900,
),
```

![example_RBluUQsnWo](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_RBluUQsnWo.png)

#### 3.5 圆角大小

##### 3.5.1 通过radius参数指定圆角

SemanticButton的radius参数用于统一指定按钮的四个角的弧度数值。是一个double类型的参数。默认情况下，radius参数值为4。再某些场景中，依据你的需求，可以手动调整按钮的圆角大小。例如：

```dart
SemanticButton(
  text: 'radius: 20',
  shrink: true,
  type: SemanticEnum.info,
  isOutlined: true,
  onTap: () {},
  radius: 20,
),
const Gap(20),
SemanticButton(
  text: 'radius: 0',
  shrink: true,
  type: SemanticEnum.warning,
  isOutlined: true,
  onTap: () {},
  radius: 0,
),
```

![example_j7nmu9vC0M](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_j7nmu9vC0M.png)

##### 3.5.2 使用borderRadius属性

**SemanticButton** 的 `borderRadius`更为灵活，也可以用它来指定圆形的边框半径。比如下面的例子展示了两个按钮，分别为他们指定左上角和右下角的圆角形状：

```dart
SemanticButton(
  text: 'topLeft: Radius.circular(20)',
  borderRadius:
      const BorderRadius.only(topLeft: Radius.circular(20)),
  type: SemanticEnum.info,
  isOutlined: true,
  onTap: () {},
  radius: 20,
),
const Gap(20),
SemanticButton(
  text: 'bottomRight: Radius.circular(20)',
  borderRadius:
      const BorderRadius.only(bottomRight: Radius.circular(20)),
  type: SemanticEnum.warning,
  isOutlined: true,
  onTap: () {},
  radius: 20,
),
```

![example_6WGxVLs5Dy](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_6WGxVLs5Dy.gif)

#### 3.6 按钮尺寸

##### 3.6.1 尺寸枚举


通过尺寸枚举，可以使用预设大小。例如：

```dart
SemanticButton(
  text: 'small',
  size: SizeEnum.small,
  type: SemanticEnum.info,
  onTap: () {},
),
const Gap(20),
SemanticButton(
  text: 'defaultSize',
  type: SemanticEnum.info,
  size: SizeEnum.defaultSize,
  onTap: () {},
),
const Gap(20),
SemanticButton(
  text: 'large',
  size: SizeEnum.large,
  type: SemanticEnum.info,
  onTap: () {},
),
```

##### 3.6.2 数值尺寸

除了尺寸枚举，你还可以通过具体的数值来指定按钮的尺寸，一旦指定数值则枚举尺寸自动失效。一个通过数值指定尺寸的例子如：

```dart
SemanticButton(
  text: 'Size By Button Height: 60',
  type: SemanticEnum.info,
  height: 60,
  shrink: true,
  onTap: () {},
),
```

#### 3.7 收缩行为

在 SemanticButton 组件中，shrink 参数用于控制按钮的收缩行为。当 shrink 设置为 true 时，按钮会根据其内容自适应宽度，而不是占据所有可用空间。这在某些情况下很有用，例如当你想要将多个按钮并排放置，并且希望每个按钮的宽度与其内容相匹配时。下面通过例子具体看一下 shrink 参数的作用。

##### 3.7.1 默认行为（shrink = false）

1. 当 shrink 设置为 false（默认值）时，按钮将占据其父容器提供的所有可用宽度；
2. 在这种情况下，按钮的宽度由其父容器的约束决定，而不是由按钮的内容决定；
3. 按钮内容（文本和图标）将在按钮的可用空间内居中对齐。

假设下面这个按钮在一个Column中，这一行没有其它部件：

```dart
SemanticButton(
  text: 'shrink = false',
  type: SemanticEnum.primary,
  onTap: () {},
),
```
下一节的截图展示效果对比。

##### 3.7.2 收缩行为（shrink = true）

1. 当 shrink 设置为 true 时，按钮将根据其内容自适应宽度；
2. 按钮的宽度将由其内容（文本和图标）的实际宽度决定，而不是占据所有可用空间；
3. 这意味着按钮将收缩到恰好容纳其内容所需的宽度。

下面是一个shrink = true的例子，假设下面这个按钮在一个Column中，这一行没有其它部件：

```dart
SemanticButton(
  text: 'shrink = true',
  shrink: true,
  type: SemanticEnum.primary,
  onTap: () {},
),
```
两者的对比如下：

1. 当 shrink 设置为 true 时，按钮将根据其内容自适应宽度；
2. 按钮的宽度将由其内容（文本和图标）的实际宽度决定，而不是占据所有可用空间；
3. 这意味着按钮将收缩到恰好容纳其内容所需的宽度。




#### 3.8 按钮图标

##### 3.8.1 前缀图标的使用

在 `SemanticButton` 中，可以通过 `prefixIcon` 属性添加一个前缀图标。这个图标显示在按钮文本的左侧，通常用于增强按钮的语义或者提供视觉提示。例如，一个电话图标可以用在“呼叫”按钮上，以直观地表明按钮的功能。

```dart
SemanticButton(
  text: "Call",
  onTap: () {},
  shrink: true,
  prefixIcon: Icon(Icons.phone),
  type: SemanticEnum.primary,
)
```
![example_UaKvmEvzEC](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_UaKvmEvzEC.png)

在上述代码中，`Icon(Icons.phone)` 作为 `prefixIcon` 被传递给 `SemanticButton`，使得用户可以直观地识别这是一个用于拨打电话的按钮。

##### 3.8.2 后缀图标的使用

与前缀图标类似，`SemanticButton` 也支持后缀图标，通过 `suffixIcon` 属性设置。后缀图标显示在按钮文本的右侧，适用于指示按钮的次要操作或额外的功能，如展开箭头或信息图标。

```dart
SemanticButton(
  text: "Options",
  onTap: () {},
  shrink: true,
  suffixIcon: Icon(Icons.arrow_drop_down),
  type: SemanticEnum.primary,
)
```

在这个例子中，`Icon(Icons.arrow_drop_down)` 被设置为 `suffixIcon`，表明这个按钮可能会展开更多的选项或菜单。

![example_9RPs3ZX2Ti](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_9RPs3ZX2Ti.png)



不论前缀图标还是后缀图标，类型都是**Widget?**，这意味着你可以灵活使用组件作为图标。通过这种方式，`SemanticButton` 的 `prefixIcon` 和 `suffixIcon` 属性为Flutter开发者提供了一种灵活的方法来设计更具表达性和功能性的用户界面。



#### 3.9 自定义颜色

##### 3.9.1 一般色彩
通过按钮的 color 参数可以自定义颜色。color参数具有更高的优先级。如果自定义颜色，则 type 参数带来的颜色效果将消失。下面的例子展示了如何实现 color参数。

```dart
SemanticButton(
  text: 'Colors.amber',
  shrink: true,
  color: Colors.amber,
  onTap: () {},
),
const Gap(40),
SemanticButton(
  text: 'Colors.amber',
  shrink: true,
  color: Colors.amber,
  isOutlined: true,
  onTap: () {},
```
![example_9l6lQQ1ixn](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_9l6lQQ1ixn.gif)

##### 3.9.2 渐变色按钮

为了实现更加好看的外观，你还可以通过gradient参数指定按钮渐变色。例如，下面的例子展示了两个渐变色按钮：

```dart
SemanticButton(
  text: 'Gradient',
  shrink: true,
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  ),
  gradient: const LinearGradient(
    colors: [
      Colors.red,
      Colors.orange,
    ],
  ),
  onTap: () => print('Gradient1'),
),
const Gap(1),
SemanticButton(
  text: 'Gradient',
  shrink: true,
  borderRadius: const BorderRadius.only(
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
  ),
  gradient: const LinearGradient(
    colors: [
      Colors.orange,
      Colors.red,
    ],
  ),
  onTap: () => print('Gradient2'),
),
```

![example_ZPNFkyEpaC](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_ZPNFkyEpaC.gif)

### 4. 按钮组

Widgets Easier组件库中的按钮组是多个SemanticButton的集合，他们具有统一的语义，并且以紧密的方式进行排列。

#### 4.1 在ButtonGroup中组合SemanticButton

```dart
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'Button 1', onTap: () => print('Button 1 pressed')),
    SemanticButton(
        text: 'Button 2', onTap: () => print('Button 2 pressed')),
    SemanticButton(
        text: 'Button 3', onTap: () => print('Button 3 pressed')),
    SemanticButton(
        text: 'Button 4', onTap: () => print('Button 4 pressed')),
  ],
  type: SemanticEnum.primary,
  size: SizeEnum.defaultSize,
)
```
其中，ButtonGroup的每一个按钮的事件回调函数是在 SemanticButton 的onTap属性上直接指定的。与之类似的是单个按钮的文本，是通过每一个SemanticButton的text参数直接指定。

#### 4.2 使用语义类型
类似于SemanticButton，你也可以为ButtonGroup指定不同的type属性获得具有不同含义颜色象征的按钮组。例如：
```dart
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'primary But1',
        onTap: () => print('primary But1 pressed')),
    SemanticButton(
        text: 'primary But2',
        onTap: () => print('primary But2 pressed')),
  ],
  type: SemanticEnum.primary,
),
const Gap(20),
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'secondary But1',
        onTap: () => print('secondary But1 pressed')),
    SemanticButton(
        text: 'secondary But2',
        onTap: () => print('secondary But2 pressed')),
  ],
  type: SemanticEnum.secondary,
),
const Gap(20),
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'info But1', onTap: () => print('info But1 pressed')),
    SemanticButton(
        text: 'info But2', onTap: () => print('info But2 pressed')),
  ],
  type: SemanticEnum.info,
),
const Gap(20),
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'warning But1',
        onTap: () => print('warning But1 pressed')),
    SemanticButton(
        text: 'warning But2',
        onTap: () => print('warning But2 pressed')),
  ],
  type: SemanticEnum.success,
),
const Gap(20),
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'warning But1',
        onTap: () => print('warning But1 pressed')),
    SemanticButton(
        text: 'warning But2',
        onTap: () => print('warning But2 pressed')),
  ],
  type: SemanticEnum.warning,
),
const Gap(20),
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'danger But1', onTap: () => print('danger But1 pressed')),
    SemanticButton(
        text: 'danger But2', onTap: () => print('danger But2 pressed')),
  ],
  type: SemanticEnum.danger,
),
const Gap(20),
ButtonGroup(
  buttons: [
    SemanticButton(
        text: 'fatal But1', onTap: () => print('fatal But1 pressed')),
    SemanticButton(
        text: 'fatal But2', onTap: () => print('fatal But2 pressed')),
  ],
  type: SemanticEnum.fatal,
),
```

![example_M8MY32Z4QW](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_M8MY32Z4QW.gif)

#### 4.3 按钮组圆角

通过为按钮组指定 radius 属性可以手动修改按钮组圆角。若不指定，默认圆角大小为4。一个手动指定按钮组圆角的示例如下：
```dart
ButtonGroup(
  radius: 20,
  buttons: [
    SemanticButton(text: 'Group But1', onTap: () {}),
    SemanticButton(text: 'Group But2', onTap: () => {}),
    SemanticButton(text: 'Group But3', onTap: () => {}),
  ],
)
```

![example_GFp71agb79](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_GFp71agb79.gif)

#### 4.4 按钮组尺寸

类似于**SemanticButton**，**ButtonGroup**也可以使用枚举尺寸和数值尺寸两种方式来指定尺寸。

##### 4.4.1 枚举尺寸
可以使用尺寸枚举值为按钮组指定尺寸。例如：

![example_KLiWhn18t5](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_KLiWhn18t5.gif)

##### 4.4.2 数值尺寸
数值尺寸是更加灵活的大小指定方式。一旦使用数值尺寸，则指定的枚举尺寸将自动失效。你可以通过height属性来指定数值尺寸，例如：
```dart
ButtonGroup(
  radius: 20,
  type: SemanticEnum.info,
  height: 60,
  buttons: [
    SemanticButton(text: 'But1', onTap: () {}),
    SemanticButton(text: 'But2', onTap: () => {}),
    SemanticButton(text: 'But3', onTap: () => {}),
  ],
)
```

![example_FWgfhJiS1W](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_FWgfhJiS1W.gif)

#### 4.5 使用前后缀图标

虽然**ButtonGroup**中可以有多个**SemanticButton**，但是在**ButtonGroup**上只能为第一个按钮添加前缀图标以及最后一个按钮添加后缀图标。这用起来十分简单，只需要为**ButtonGroup**指定prefixIcon参数或者suffixIcon参数。例如：
```dart
ButtonGroup(
  radius: 10,
  prefixIcon: const Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  ),
  suffixIcon: const Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  ),
  buttons: [
    SemanticButton(
      text: 'Button 1',
      onTap: () {},
    ),
    SemanticButton(
      text: 'Button 2',
      onTap: () {},
    ),
    SemanticButton(
      text: 'Button 4',
      onTap: () {},
    ),
  ],
  type: SemanticEnum.primary,
  size: SizeEnum.defaultSize,
)
```

#### ![example_f6xDuUhP6W](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_f6xDuUhP6W.gif)

#### 4.6 收缩行为

类似于**SemanticButton**，你可以为**ButtonGroup**指定收缩行为。这在类似于需要单个按钮组占满容器宽度的时候特别有用。例如，指定shrink参数值为false使按钮组占满整行：
```dart
ButtonGroup(
  shrink: false,
  radius: 10,
  prefixIcon: const Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  ),
  suffixIcon: const Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  ),
  buttons: [
    SemanticButton(
      text: 'Button 1',
      onTap: () {},
    ),
    SemanticButton(
      text: 'Button 2',
      onTap: () {},
    ),
    SemanticButton(
      text: 'Button 4',
      onTap: () {},
    ),
  ],
  type: SemanticEnum.primary,
  size: SizeEnum.defaultSize,
),
```

![example_W6GYBdDlgJ](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_W6GYBdDlgJ.gif)

#### 4.7 有用的提示

按钮组**ButtonGroup**是由多个**SemanticButton**按照一定方式组织的整体。你可以为在**ButtonGroup**中的**SemanticButton**指定更多参数——语法这上没有错误。但是并不是每一个**SemanticButton**的参数在**ButtonGroup**中都会生效，因为在按钮组中需要按照自己的方式去进行管理。可以指定的主要是每一个按钮的文本、回调事件等，因为这些参数不属于整体，是单元特有的。




### 5. 标签

#### 5.1 语义类型

通过Tag组件的`type`参数可以使用一个语义性色彩。例如：

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', type: SemanticEnum.primary),
    Tag('tag', type: SemanticEnum.secondary),
    Tag('tag', type: SemanticEnum.info),
    Tag('tag', type: SemanticEnum.success),
    Tag('tag', type: SemanticEnum.warning),
    Tag('tag', type: SemanticEnum.danger),
    Tag('tag', type: SemanticEnum.fatal),
  ],
),
```

![example_RLfAZpHGRt](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_RLfAZpHGRt.png)

#### 5.2 样式主题

受启发与Element-plus，**Tag**有3个样式主题，`plain`、`light`和`dark`，默认情况下为`palin`，正如上一节所展示的那样。下面展示`light`和`dark`两个主题：



##### light

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.primary),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.secondary),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.info),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.success),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.warning),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.danger),
    Tag('tag', theme: TagThemeEnum.light, type: SemanticEnum.fatal),
  ],
),
```

![example_uLVBhrUyBl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uLVBhrUyBl.png)



##### dark

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.primary),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.secondary),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.info),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.success),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.warning),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.danger),
    Tag('tag', theme: TagThemeEnum.dark, type: SemanticEnum.fatal),
  ],
),
```

![example_4GWiRl3tzL](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4GWiRl3tzL.png)



#### 5.3 圆角

默认有一个大小为4的圆角，若要手动修改可以通过指定radius参数。radius参数接受一个double值。例如，设置radius为0则没有圆角：

```dart
Tag('radius: 0', radius: 0),
```

![example_WCSxzzhhjE](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_WCSxzzhhjE.png)



#### 5.4 尺寸



##### 枚举尺寸

例如：

```dart
Tag('SizeEnum.small', size: SizeEnum.small),
Tag('SizeEnum.defaultSize', size: SizeEnum.defaultSize),
Tag('SizeEnum.large', size: SizeEnum.large),
```



##### 数值尺寸

通过height参数可以指定数值作为尺寸。height一经指定，则size失效。例如，指定高度为50：

```dart
Tag('hignt=50', height: 50),
```

![example_0yBhql2v2F](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0yBhql2v2F.png)

##### 收缩属性

通过指定shrink属性为flase，可以使一个标签尽可能占满一行，例如：

```dart
Tag('shrink: false', shrink: false)
```

![example_sonRhtEJqj](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_sonRhtEJqj.png)

#### 5.5 可关闭标签

通过指定 closable: true，将展示一个关闭图标。例如：

```dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    Tag('tag', closable: true, type: SemanticEnum.primary),
    Tag('tag', closable: true, type: SemanticEnum.secondary),
    Tag('tag', closable: true, type: SemanticEnum.info),
    Tag('tag', closable: true, type: SemanticEnum.success),
    Tag('tag', closable: true, type: SemanticEnum.warning),
    Tag('tag', closable: true, type: SemanticEnum.danger),
    Tag('tag', closable: true, type: SemanticEnum.fatal),
  ],
),
```

![example_HJgxs2Vv3O](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_HJgxs2Vv3O.gif)



#### 5.6 动态编辑标签示例



可以通过点击标签关闭按钮后触发的 onClose 事件来实现动态编辑标签。例如：

```dart
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class DynamicTagsExample extends StatefulWidget {
  const DynamicTagsExample({super.key});

  @override
  State<DynamicTagsExample> createState() => _DynamicTagsExampleState();
}

class _DynamicTagsExampleState extends State<DynamicTagsExample> {
  final List<String> _tags = ['Tag 1', 'Tag 2', 'Tag 3'];
  final String _newTagButtonText = '+ 添加 Tag';

  void _handleClose(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _tags.add(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Text('$_tags'),
        for (int index = 0; index < _tags.length; index++)
          Tag(
            key: UniqueKey(), // 重要
            _tags[index],
            type: SemanticEnum.primary,
            theme: TagThemeEnum.light,
            closable: true,
            onClose: (_) {
              _handleClose(index);
            },
          ),
        Tag(
          _newTagButtonText,
          type: SemanticEnum.danger,
          editable: true,
          restoreAfterSubmitted: true,
          onSubmitted: _handleSubmitted,
        ),
      ],
    );
  }
}
```
效果如下：
![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/cea33e4f5e9f46d5a148d886959c6d32.gif)






### 6. 加减器

#### 5.1 加减器组件简介

**CounterInput** 是一个用于数值输入和调整的 **Flutter** 组件，它提供了一个直观的界面，允许用户通过点击加号和减号按钮或直接输入数值来改变当前值。改组件包含以下特性：

1. 支持点击加号和减号按钮来增加或减少当前值
2. 支持直接在文本框中输入数值；
3. 可自定义的最小值、最大值和步长；
4. 可自定义的样式，包括大小、颜色和边框样式；
5. 提供了多个回调事件，用于监听值的变化和边界情况；
6. 支持长按加号和减号按钮来连续改变值；
7. 支持禁用和启用组件的交互。



#### 5.2 使用语义

和其它组件一样，通过`type`属性可以指定语义枚举值，以得到不同的语义色彩。例如：

```dart
CounterInput(type: SemanticEnum.primary)
```

![example_uoLPuBTKzb](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uoLPuBTKzb.png)

#### 5.3 自定义色彩

如果你想更加灵活地指定各个部分的颜色，这也是可行的。具体来说，有以下几个颜色参数：

1. iconColor：加减图标的颜色
2. backgroundColor：输入框背景色；
3. buttonColor：按钮颜色；
4. textColor：输入框文本颜色。

下面是一个例子：

```dart
const CounterInput(
  size: SizeEnum.small,
  iconColor: Colors.amber,
  backgroundColor: Colors.black,
  buttonColor: Colors.blue,
  textColor: Colors.white,
)
```



![example_h0k4KWue9E](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_h0k4KWue9E.png)

#### 5.4 尺寸

##### 1 枚举尺寸

通过size组件可以指定尺寸枚举，包括SizeEnum.small、SizeEnum.defaultSize、SizeEnum.large，如果未指定，默认为SizeEnum.defaultSize。例如：

```dart
Row(
  children: [
    Column(
      children: [
        CounterInput(
          size: SizeEnum.small,
          controller: CounterInputController(),
        ),
        const Text('SizeEnum.small'),
      ],
    ),
    Column(
      children: [
        CounterInput(
          size: SizeEnum.defaultSize,
          controller: CounterInputController(),
        ),
        const Text('SizeEnum.defaultSize'),
      ],
    ),
    Column(
      children: [
        CounterInput(
          size: SizeEnum.large,
          controller: CounterInputController(),
        ),
        const Text('izeEnum.large'),
      ],
    ),
  ],
),
```

![example_1JTzG6Hlaf](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_1JTzG6Hlaf.png)

##### 2 数值尺寸

如果枚举尺寸不能满足要求还可以指定数值：

```dart
CounterInput(
  height: 50,
  controller: CounterInputController(),
),
```

![example_eDBmo5IVT9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_eDBmo5IVT9.png)

#### 5.5 轮廓型

通过指定`isOutlined`的值为true，可以设置加减器为轮廓型。例如：

```dart
Row(
  children: [
    CounterInput(
      type: SemanticEnum.primary,
      controller: CounterInputController(),
      isOutlined: true,
    ),
    CounterInput(
      type: SemanticEnum.secondary,
      controller: CounterInputController(),
      isOutlined: true,
    ),
    CounterInput(
      type: SemanticEnum.info,
      controller: CounterInputController(),
      isOutlined: true,
    ),
    CounterInput(
      type: SemanticEnum.success,
      controller: CounterInputController(),
      isOutlined: true,
    ),
  ],
),
```

![example_tjpQHhVKRl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_tjpQHhVKRl.png)

#### 5.6 圆角加减器

通过`radius`属性可以很方便地为加减器设置圆角.例如：

```dart
const CounterInput(
  type: SemanticEnum.info,
  radius: 20,
  step: 3,
)
```

![example_4AXqYeLDKp](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4AXqYeLDKp.gif)

#### 5.7 自动宽度和固定宽度

默认情况下宽度是自动的，加减器文本输入区的宽度随着位数的增加而增加。但是也可以指定一个固定的文本输入区宽度。例如：

```dart
CounterInput(
  textFieldWidth: 60,
  controller: CounterInputController(),
),
```



#### 5.8 回调事件



##### 1 加、减回调

加回调用于监听值增加事件，当数值增加时触发；类似地，减回调用于监听减少事件，当数值减少时触发。

- 通过`onIncrement`回调，用于监值增加事件；
- 通过`Decremented`回调，用于监值减少事件。

下面这个例子中，初始值为7，步进值为2，当增加或者减少时在控制台打印新值和旧值：

```dart
CounterInput(
  controller: CounterInputController(initialValue: 7),
  step: 2,
  onIncrement: (oldValue, value) {
    debugPrint("+增加前为$oldValue；增加后为：$value");
  },
  onDecrement: (oldValue, value) {
    debugPrint("-减少前为$oldValue；减少后为：$value");
  },
),
```

> 注：指定初始值需要使用CounterInputController控制器，就像这个例子中所示的一样。



##### 2 最值到达回调

加减器有一个最大值和一个最小值，默认情况下最小值为0，最大值为100。当变化到最小值时，将触发最小值回调。下面的例子展示了到达最大/最小值时，执行相关回调。其中设置最大值为10，最小值为1，初始值为6，步进值为2。每当到达最小或最大值的时候弹窗提示。

```dart
CounterInput(
  type: SemanticEnum.primary,
  minValue: 1,
  maxValue: 10,
  controller: CounterInputController(),
  step: 1,
  onIncrement: (oldValue, value) {
    debugPrint("+Increasing from $oldValue to $value");
  },
  onDecrement: (oldValue, value) {
    debugPrint("-Decreasing from $oldValue to $value");
  },
  onMax: () => InfoDialogs.show(
    context,
    message: 'Reached maximum value',
    type: SemanticEnum.primary,
    onTapDismiss: () => Navigator.of(context).pop(),
  ),
  onMin: () => InfoDialogs.show(
    context,
    message: 'Reached minimum value',
    type: SemanticEnum.fatal,
    onTapDismiss: () => Navigator.of(context).pop(),
  ),
)
```

![example_wzi2mFQRMk](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_wzi2mFQRMk.gif)

通过这个例子可以看出，`onMax`、`onMin`仅仅是到达最值得时候被调用，但是从如果尝试往超出方向继续点击按钮时不会被调用。以上面得GIF图片为例，当增加到10单词会调用onMax方法，但是在10上继续增加是不会处理的。

##### 3 溢出回调

溢出回调是为了响应增道最大值继续操作增加、减到最小值继续操作减少的场景。例如：

```dart
CounterInput(
  type: SemanticEnum.primary,
  minValue: 1,
  maxValue: 13,
  controller: CounterInputController(initialValue: 7),
  step: 4,
  onMinOverflow: () => InfoDialogs.zoomIn(
    context,
    message: '当前已经时最小值，无法继续减少',
    buttonText: '确定',
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
  onMaxOverflow: () => InfoDialogs.zoomIn(
    context,
    message: '当前已经时最大值，无法继续增加',
    buttonText: '确定',
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
)
```



![example_fMYLgu8hR9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_fMYLgu8hR9.gif)


##### 4 值变化事件



```dart
CounterInput(
  onValueChanged: (oldValue, newValue) {
    print('oldValue is $oldValue, newValue is $newValue');
  },
)
```

![example_Jfs459a3CF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Jfs459a3CF.gif)

对应图中的点击，控制台打印的结果为：

```dart

flutter: oldValue is 0.0, newValue is 1.0
flutter: oldValue is 1.0, newValue is 2.0
flutter: oldValue is 2.0, newValue is 3.0
flutter: oldValue is 3.0, newValue is 4.0
flutter: oldValue is 4.0, newValue is 5.0
flutter: oldValue is 5.0, newValue is 6.0
flutter: oldValue is 6.0, newValue is 7.0
flutter: oldValue is 7.0, newValue is 6.0
flutter: oldValue is 6.0, newValue is 5.0
flutter: oldValue is 5.0, newValue is 4.0
flutter: oldValue is 4.0, newValue is 3.0
flutter: oldValue is 3.0, newValue is 2.0
flutter: oldValue is 2.0, newValue is 1.0
flutter: oldValue is 1.0, newValue is 0.0
```


### 7. 动画

动画相关工具被单独封装在`flutter_easy_animations`库中，需要独立进行安装：

```bash
flutter pub add flutter_easy_animations
```

更多关于动画用法，请查阅写在`flutter_easy_animations`中的文档：[https://pub.dev/packages/flutter_easy_animations](https://pub.dev/packages/flutter_easy_animations)



### 8. 弹窗

#### InfoDialogs

##### 弹窗构成

消息弹窗（InfoDialog）通常用于在移动应用中显示重要信息，需要用户明确地关闭弹窗以确保信息被看到。以下是InfoDialog的主要构成元素：

- 图标（可选）

- 标题（Title）
- 内容（Content）
- 关闭按钮（Close Button）

##### 使用语义

**InfoDialogs**是一种消息式的弹窗，这种弹窗只有一个按钮。你可以为**InfoDialogs**指定一个`type`属性，这将拥有语义性色彩。它的弹窗体看起来是这样的：

![example_nc62R6kkem](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_nc62R6kkem.png)

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'primary弹窗',
      type: SemanticEnum.primary,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个primary消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.primary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'secondary弹窗',
      type: SemanticEnum.secondary,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个secondary消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.secondary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'info弹窗',
      type: SemanticEnum.info,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个info消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.info,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'success弹窗',
      type: SemanticEnum.success,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个success消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.success,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'warning弹窗',
      type: SemanticEnum.warning,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个warning消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.warning,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'danger弹窗',
      type: SemanticEnum.danger,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个danger消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.danger,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'fatal弹窗',
      type: SemanticEnum.fatal,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个fatal消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
)
```



![example_0YDNxnPzok](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0YDNxnPzok.gif)



##### zoomIn动画

`InfoDialogs.show`是没有动画效果的。你可以直接使用`InfoDialogs.zoomIn`方法，这将有一个缩放效果的弹窗动画。`InfoDialogs.zoomIn`方法和`InfoDialogs.show`具体完全一样的参数。例如：



```dart
SemanticButton(
  text: 'zoomIn动画',
  shrink: true,
  onTap: () => InfoDialogs.zoomIn(
    context,
    title: "你好啊！",
    message: "这是一个fatal消息弹窗",
    buttonText: "我知道了",
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
)
```

其效果如下：

![example_QCpD0oPAWg](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_QCpD0oPAWg.gif)



##### 自定义动画

你还可以通过在**InfoDialogs.showInfoDialog**方法中指定`transitionBuilder`参数来自定义弹窗动画效果，例如：

```dart
SemanticButton(
  text: '自定义动画',
  shrink: true,
  onTap: () => InfoDialogs.showInfoDialog(
    context,
    title: "你好啊！",
    message: "这是一个消息弹窗",
    buttonText: "我知道了",
    transitionBuilder:
        (context, animation, secondaryAnimation, child) {
      return AnimateStyles.backInDown(animation, child);
    },
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
)
```

> 注：这里使用的`AnimateStyles.backInDown`动画需要单独安装：
>
> ```bash
> flutter pub add flutter_easy_animations
> ```

其效果如下：

![example_CYfwe0SU6B](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_CYfwe0SU6B.gif)



#### ConfirmDialogs

##### 弹窗构成

确认型弹窗（Confirmation Dialog）用于在执行某些可能具有重大影响的操作前，要求用户确认其决定。这种弹窗通常包含以下元素：

- 图标（可选）；

- 标题：简洁明了地描述所需确认的操作;
- 内容：提供操作的详细信息，帮助用户做出决策;
- 操作按钮：通常是“确认”和“取消”，有时可能包括其他选项，如“保存”，“不保存”等;

其消息窗体看起来是这样的：

![example_AR1n3S0R9d](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_AR1n3S0R9d.png)

##### 使用语义

你可以为**ConfirmDialogs**指定一个`type`属性，这将拥有语义性色彩。它的弹窗体看起来是这样的：

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'primary弹窗',
      type: SemanticEnum.primary,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是primary确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.primary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'secondary弹窗',
      type: SemanticEnum.secondary,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是secondary确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.secondary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'info弹窗',
      type: SemanticEnum.info,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是info确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.info,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'success弹窗',
      type: SemanticEnum.success,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是success确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.success,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'warning弹窗',
      type: SemanticEnum.warning,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是warning确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.warning,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'danger弹窗',
      type: SemanticEnum.danger,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是danger确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.danger,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'fatal弹窗',
      type: SemanticEnum.fatal,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是fatal确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
)
```



##### zoomIn动画

`ConfirmDialogs.show`是没有动画效果的。你可以直接使用`ConfirmDialogs.zoomIn`方法，这将有一个缩放效果的弹窗动画。`ConfirmDialogs.zoomIn`方法和`ConfirmDialogs.show`具体完全一样的参数。例如：



```dart
SemanticButton(
  text: 'zoomIn动画',
  shrink: true,
  onTap: () => ConfirmDialogs.zoomIn(
    context,
    title: "你确定吗",
    message: "这个是确认弹窗",
    confirmButtonText: "确定",
    cancelButtonText: "真的确定",
    onTapCancel: () {
      Navigator.of(context).pop();
    },
    onTapConfirm: () {
      Navigator.of(context).pop();
    },
  ),
)
```

其效果如下：

![example_UqL2qrRpiO](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_UqL2qrRpiO.gif)

##### 自定义动画

你还可以通过在**ConfirmDialogs.showInfoDialog**方法中指定`transitionBuilder`参数来自定义弹窗动画效果，例如：

```dart
SemanticButton(
  text: 'flipInX动画',
  shrink: true,
  onTap: () => ConfirmDialogs.showConfirmDialog(
    context,
    transitionBuilder:
        (context, animation, secondaryAnimation, child) {
      return AnimateStyles.flipInX(animation, child);
    },
    title: "你确定吗",
    message: "这个是确认弹窗",
    confirmButtonText: "确定",
    cancelButtonText: "真的确定",
    onTapCancel: () {
      Navigator.of(context).pop();
    },
    onTapConfirm: () {
      Navigator.of(context).pop();
    },
  ),
)
```

> 注：这里使用的`AnimateStyles.flipInX`动画需要单独安装：
>
> ```bash
> flutter pub add flutter_easy_animations
> ```

其效果如下：

![example_EGAUPCK3VF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_EGAUPCK3VF.gif)


#### WinDialogs

WinDialogs是一种模仿Windows风格的弹窗。下面的示例展示了调用一个Windoiws风格的弹窗:

```dart
SemanticButton(
  text: '显示Windows风格弹窗',
  isOutlined: true,
  shrink: true,
  radius: 2,
  color: Colors.black,
  onTap: () => WinDialogs.show(
    context,
    title: 'title',
    icon: const Icon(Icons.run_circle_outlined),
    text: '在这个世界上，我们每个人都应该深刻理解，生活中，若能够不断地反思和自省，那么我们就能更好地理解生活的真谛。',
    contents: Row(
      children: [
        const Text('打开(O):'),
        const Gap(10),
        Expanded(
          child: Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    ),
    actions: [
      SemanticButton(
        text: '确定',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '取消',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '浏览',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
    ],
  ),
),
```

效果如图所示：

![example_Z45EJiFtKU](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Z45EJiFtKU.gif)



与之前的弹窗一样，你可以使用`zoomIn`方法来设置一个从小到大的弹窗动画效果，该方法用于与`show`方法一样的参数：



![example_BTEipOt7f9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_BTEipOt7f9.gif)



如果你打算自定义弹窗动画，这也是和之前的弹窗一样的。你可以使用`showWinDialog`，并通过`transitionBuilder`参数指定一个动画。例如：

```dart
SemanticButton(
  text: '使用bounceIn动画',
  isOutlined: true,
  shrink: true,
  radius: 2,
  color: Colors.black,
  onTap: () => WinDialogs.showWinDialog(
    context,
    transitionBuilder:
        (context, animation, secondaryAnimation, child) {
      return AnimateStyles.bounceIn(animation, child);
    },
    title: 'title',
    icon: const Icon(Icons.run_circle_outlined),
    text: '在这个世界上，我们每个人都应该深刻理解，生活中，若能够不断地反思和自省，那么我们就能更好地理解生活的真谛。',
    contents: Row(
      children: [
        const Text('打开(O):'),
        const Gap(10),
        Expanded(
          child: Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    ),
    actions: [
      SemanticButton(
        text: '确定',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '取消',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '浏览',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
    ],
  
```

其效果如下：

![example_XXgNIBMhxU](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_XXgNIBMhxU.gif)

> 注：这里使用的`AnimateStyles.bounceIn`动画需要单独安装：
> ```bash
> flutter pub add flutter_easy_animations
> ```





#### FutureDialogs

FutureDialogs 用于处理Future型弹窗。

一个 Future 对象在其生命周期中有两种状态：


1. **未完成（Uncompleted）**:

当 Future 被创建时，它处于未完成状态。这意味着异步操作尚未完成，结果还不可用。

2. **完成（Completed）**:

异步操作完成后，Future 进入完成状态。这个状态有两种可能的结果：

- **成功（Fulfilled）**: 异步操作成功完成，Future 获得了一个值。

- **失败（Rejected）**: 异步操作因错误而未能成功完成，Future 获得了一个错误。

FutureDialog弹窗中的静态方法需要对应构建加载中、成功、失败时候弹窗显示的内容。

以一个登录页面为例，登录请求需要请求后端服务器，有两种结果：成功、失败。于是我们分别构建下面两个弹窗的内容：

用于认证成功显示的内容：
```dart
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class SuccessDialog extends StatelessWidget {
  final String data;
  const SuccessDialog(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.all(26),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check,
                color: Colors.green,
                size: 60,
              ),
              const Gap(20),
              Text(data, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
```

用于认证失败显示的内容：


```dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FailureDialog extends StatelessWidget {
  final String data;
  const FailureDialog(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 230,
          height: 200,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.close,
                color: Colors.red,
                size: 60,
              ),
              const Gap(20),
              Text(data,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
```

然后我们在登录页面中调用弹窗：


```dart
import 'package:example/login/dialogs/failure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'dialogs/success_dialog.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginManager = LoginController();

  void handleLogin(BuildContext context) {
    // 从文本控制器获取用户名和密码
    final String username = usernameController.text;
    final String password = passwordController.text;

    // 显示一个异步操作的对话框，这个对话框将在 simulateLogin 方法的 Future 完成后关闭
    FutureDialogs.show<String>(
      context: context,
      futureCallback: () => loginManager.simulateLogin(username, password),
      buildSuccessDialog: (data) {
        return SuccessDialog(data);
      },
      buildFailureDialog: (data) {
        return FailureDialog(data);
      },
    ).then((result) {
      // 检查从 simulateLogin 返回的结果
      if (result != null && result['status'] == true) {
        // 如果登录成功，导航到主页
        Navigator.pushReplacementNamed(context, '/login-success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutureDialogs 示例')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: '输入你的账号',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: '输入你的密码',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SemanticButton(
              text: '登录',
              type: SemanticEnum.primary,
              onTap: () => handleLogin(context),
              radius: 40,
              isOutlined: true,
            )
          ],
        ),
      ),
    );
  }
}
```
其中：

```dart
FutureDialogs.show<String>(
      context: context,
      futureCallback: () => loginManager.simulateLogin(username, password),
      buildSuccessDialog: (data) {
        return SuccessDialog(data);
      },
      buildFailureDialog: (data) {
        return FailureDialog(data);
      },
    ).then((result) {
      // 检查从 simulateLogin 返回的结果
      if (result != null && result['status'] == true) {
        // 如果登录成功，导航到主页
        Navigator.pushReplacementNamed(context, '/login-success');
      }
    });
```

可以我们在完成完成之后还可以链式执行一些操作。这种设计非常有必要，以此例子为例，在登录成功之后我们跳转到了登录成功页面。其中这里then的参数result也是futureCallback返回的值。另一方面，如果有需要也可以在这里继续下一个弹窗。

其中异步函数：


```dart
import 'dart:async';

class LoginController {
  Future<Map<String, dynamic>> simulateLogin(
    String username,
    String password,
  ) async {
    // 一般对于空密码等情况可以在客户端验证，以减少API请求
    if (username.isEmpty || password.isEmpty) {
      return {
        'status': false,
        'data': '账户名或密码不能为空',
      };
    }
    // 模拟请求API返回结果，有可能成功也有可能失败
    else if (username == 'jclee95' && password == '123456') {
      await Future.delayed(const Duration(seconds: 1));
      return {'status': true, 'data': '登录成功'};
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return {'status': false, 'data': '账户名或密码错误'};
    }
  }
}

```
在这段代码中，simulateLogin是一个模拟异步登录的函数。
如果登录成功，则返回：

```dart
{'status': true, 'data': '登录成功'}
```
如果登录失败则返回：

```dart
{'status': false, 'data': '账户名或密码错误'}
```


然后构建一个登录成功页面



```dart
import 'package:flutter/material.dart';

class LoginSuccessView extends StatelessWidget {
  const LoginSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录成功'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '您已成功登录！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('回到主页'),
            ),
          ],
        ),
      ),
    );
  }
}
```

看起来效果是这样的：



1.用户名密码为空：
![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/989b2405eaab4d629d9ce22c4a9a6a71.gif)



2. 输入错误的密码：

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/9fc16728e2c740e39d3bd1f729a6dd7d.gif)

3. 密码认证成功

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/296cf1829bb047448477db75ff560ed1.gif)

### 9. 消息吐丝

消息吐丝组件受到Element-Plus的Notification启发，并以一种适合于在Flutter上使用的方式进行封装。它提供了一种简单而灵活的方式来在你的应用中显示消息通知。通过自定义样式、动画效果和交互，你可以创建出符合应用设计风格的消息通知。

#### 8.1 基本用法

消息吐丝相关组件是通过 NotifyToasts 类提供的静态方法来掉用显示的。 NotifyToasts 类中有四个静态方法，对应于显示消息通知的四个方位：

1. showTopLeft：在屏幕左上角显示消息通知；
2. showTopRight：在屏幕右上角显示消息通知；
3. showBottomLeft：在屏幕左下角显示消息通知；
4. showBottomRight：在屏幕右下角显示消息通知。

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      onTap: () => NotifyToasts.showTopRight(
        context,
        title: 'TopRight',
        message: 'Top Right Notification!',
      ),
      isOutlined: true,
      text: 'Top Right',
    ),
    SemanticButton(
      onTap: () => NotifyToasts.showTopLeft(
        context,
        title: 'TopLeft',
        message: 'Top Left Notification!',
      ),
      isOutlined: true,
      text: 'Top Left',
    ),
    SemanticButton(
      onTap: () => NotifyToasts.showBottomRight(
        context,
        title: 'BottomRight',
        message: 'Bottom Right Notification!',
      ),
      isOutlined: true,
      text: 'Bottom Right',
    ),
    SemanticButton(
      onTap: () => NotifyToasts.showBottomLeft(
        context,
        duration: const Duration(seconds: 1),
        title: 'BottomLeft',
        message: 'Bottom Left Notification!',
      ),
      isOutlined: true,
      text: 'Bottom Left',
    ),
  ],
),
```

代码的运行效果如下：

![example_qCE7P4gOkP](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_qCE7P4gOkP.gif)

一条消息吐丝的默认时间为3s，你可以通过`duration`参数指定其时间。上面的示例中，**Bottom Left** 的被手动设置为1秒。



#### 8.2 语义类型

NotifyToasts的四个静态方法中都有一个type属性，它是一个SemanticEnum枚举。你可以通过指定SemanticEnum的值来设置不同的语义类型。例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      type: SemanticEnum.primary,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.primary,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Primary',
    ),
    SemanticButton(
      type: SemanticEnum.secondary,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.secondary,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Secondary',
    ),
    SemanticButton(
      type: SemanticEnum.info,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.info,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Info',
    ),
    SemanticButton(
      type: SemanticEnum.success,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.success,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Success',
    ),
    SemanticButton(
      type: SemanticEnum.warning,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.warning,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Warning',
    ),
    SemanticButton(
      type: SemanticEnum.danger,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.danger,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Danger',
    ),
    SemanticButton(
      type: SemanticEnum.fatal,
      onTap: () => NotifyToasts.showTopRight(
        context,
        type: SemanticEnum.fatal,
        message: 'Here are some messages.',
      ),
      isOutlined: true,
      text: 'Fatal',
    ),
  ],
)
```

代码的运行效果如下：

![example_5MJrSKGAUZ](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_5MJrSKGAUZ.gif)

需要指出的是，消息吐丝中的type不会默认为SemanticEnum.primary，如果没有指定，则不使用语义色彩。

#### 8.3 自定义图片和标题

如果指定了非空的type值，你可以不必指定图标和标题，因为有默认的图标和标题。当然如果你需要自己指定也是可以的，例如：

```dart
SemanticButton(
  shrink: true,
  prefixIcon: const Icon(
    Icons.access_alarms,
    color: Color.fromARGB(255, 125, 8, 0),
  ),
  type: SemanticEnum.danger,
  onTap: () => NotifyToasts.showTopRight(
    context,
    title: 'Alarm',
    icon: const Icon(
      Icons.access_alarms,
      color: Color.fromARGB(255, 125, 8, 0),
    ),
    type: SemanticEnum.danger,
    message: 'Here are some messages.',
  ),
  isOutlined: true,
  text: 'Alarm',
)
```

代码的运行效果如下：

![example_N97sCnevj3](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_N97sCnevj3.gif)

这个例子中，自定义了一个“Alarm”消息通知。通过title属性指定标题文本为Alarm；通过icon属性指定了一个Alarm图标。可以看到，即使我们指定了type，自定义的标题也会覆盖掉对应于type的默认标题。

另外需要指出的是，这里的图标未必是一个Icon类型，可以是任意的Widget。这使得开发者又更大的使用灵活性，比如使用一张图片：

```dart
SemanticButton(
  shrink: true,
  onTap: () => NotifyToasts.showTopRight(
    context,
    title: 'Jack Lee',
    icon: Picture(source: 'assets/jclee95.png'),
    message: 'JackLee, the author of this library, is a good boy.',
  ),
  isOutlined: true,
  text: 'Jack Lee',
)
```

代码的运行效果如下：

![example_0VkrqwD0V6](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0VkrqwD0V6.gif)

#### 8.4 自定义颜色

你可以自己定义通知消息的颜色。例如：

```dart
SemanticButton(
  shrink: true,
  color: Colors.amber,
  onTap: () => NotifyToasts.showTopRight(
    context,
    color: Colors.amber,
    title: 'Custom color',
    message: 'The currently defined color is Colors.amber.',
  ),
  isOutlined: true,
  text: 'Custom color',
)
```

代码的运行效果如下：

![example_v5UtPLQkCx](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_v5UtPLQkCx.gif)

#### 8.5 自定义动画

你可以自定义动画，不过这里还是和以前一样推荐使用**Widgets Easier** 组件库配套的`flutter_easy_animations`库中现成的动画效果。默认情况下，**NotifyToasts**中的`showTopRight`方法和`showBottomRight`方法使用了 **AnimateStyles.slideInRight** 动画效果；`showTopLeft`方法和`showBottomLeft`方法使用了**AnimateStyles.slideInLeft**动画效果。

你可以通过 **NotifyToasts** 中任意一个静态方法的 `animationEffect` 参数指定动画效果。例如：

```dart
SemanticButton(
  shrink: true,
  onTap: () => NotifyToasts.showTopRight(
    context,
    animationEffect: AnimateStyles.zoomInRight,
    title: 'Custom Animation',
    message: 'Use AnimateStyles.zoomInRight animation effect.',
  ),
  isOutlined: true,
  text: 'AnimateStyles.zoomInRight',
)
```

代码的运行效果如下：

![example_oRw9m9WFAl](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_oRw9m9WFAl.gif)

需要注意的是，选择符合逻辑的动画能够让消息吐丝的进入和退出看起来更加自然。就比如这个例子中，`showTopRight`使用了`zoomInRight`动画，而不是`zoomInLeft`动画。

另外，如果有需要，你可以通过`animationDuration`参数来指定。如未指定，则采用默认的`300`毫秒。



#### 8.6 关闭按钮

默认情况下，每一条消息吐丝都带有一个关闭按钮。如果不显示关闭按钮，则可以指定showClose属性的值为flase。例如：

```dart
SemanticButton(
  shrink: true,
  onTap: () => NotifyToasts.showTopRight(
    context,
    title: 'close icon button',
    showClose: false,
    message:
        'You can disable the close icon button by specifying the value of the showClose property as flase.',
  ),
  isOutlined: true,
  text: 'close icon button',
)
```

代码的运行效果如下：

![example_hLZFdhRnWm](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_hLZFdhRnWm.gif)

#### 8.7 禁用自动移除

默认情况下，一旦到达指定时间则消息吐丝将被自动移除。不过如果指定了autoClose为false，则需要手动点击关闭按钮。例如：

```dart
SemanticButton(
  shrink: true,
  onTap: () => NotifyToasts.showTopRight(
    context,
    title: 'Jack Lee',
    autoClose: false,
    icon: Picture(source: 'assets/jclee95.png'),
    message: 'JackLee, the author of this library, is a good boy.',
  ),
  isOutlined: true,
  text: 'Jack Lee',
)
```

代码的运行效果如下：

![example_11BEIJRAt5](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_11BEIJRAt5.gif)

如果禁用自动移除，不管showClose是否为false，都将启用关闭按钮图标。

#### 8.8 点击事件

```dart
SemanticButton(
  shrink: true,
  onTap: () => NotifyToasts.showTopRight(
    context,
    autoClose: false,
    title: 'Click Login',
    message: 'Click the message toast to jump to the login page.',
    onTap: () => Navigator.of(context).pushNamed('/login'),
  ),
  text: 'OnTap Callback',
)
```

代码的运行效果如下：

![example_s2AsI6WQKD](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_s2AsI6WQKD.gif)

### 10. 提示吐丝

#### 10.1 TipToasts工具简介

TipToasts 是一个用于在 Flutter 应用中显示提示消息的工具类，是一种最简单的吐丝。它提供了一种简单而灵活的方式来在屏幕的不同位置显示短暂的提示信息，并支持自定义动画效果和样式。TipToast 适用各种需要简单提示性的场景：

1. 显示操作成功或失败的提示信息；
2. 向用户提供通知或警告；
3. 在用户执行特定操作后给予反馈；
4. 显示临时的状态信息。

TipToasts 提供了几个静态方法来显示提示消息，分别是toCenter、toTop和toBottom。

#### 10.2 toCenter方法

```dart
static void toCenter(
  BuildContext context,
  String message, {
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})
```
toCenter方法是一个静态方法，该方法用于在屏幕中央显示提示消息，包含以下参数：
- context: 构建上下文；
- message: 要显示的文本消息；
- opacity：背景透明度，默认为 0.7；
- backgroundColor：背景颜色，默认为黑色；
- textStyle：文本样式，默认为白色字体，字号为 16；
- messageStyle: 消息文本的样式；
- maxWidth: 提示消息的最大宽度，默认为 200。


例如：

```dart
SemanticButton(
  shrink: true,
  text: 'toCenter',
  onTap: () => TipToasts.toCenter(context, 'toCenter'),
)
```

![example_JskzbjcvBA](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_JskzbjcvBA.gif)



#### 10.3 toTop方法

该方法用于在屏幕顶部显示提示消息，并可以指定垂直偏移量。

```dart
static void toTop(
  BuildContext context,
  String message, {
  double offset = 100,
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})
```

其中参数offset表示从屏幕顶部的垂直偏移量，默认为 100，其他参数与 toCenter 方法相同。

例如：
```dart
SemanticButton(
  shrink: true,
  text: 'toTop',
  onTap: () => TipToasts.toTop(context, 'toTop'),
)
```

![example_NznGSg2hm0](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_NznGSg2hm0.gif)



#### 10.4 toBottom 方法

该方法用于在屏幕底部显示提示消息，并可以指定垂直偏移量。

```dart
static void toBottom(
  BuildContext context,
  String message, {
  double offset = 100,
  double opacity = 0.7,
  Color backgroundColor = Colors.black,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double maxWidth = double.infinity,
})
```

其中参数offset表示从屏幕底部的垂直偏移量，默认为 100。

例如：

```dart
SemanticButton(
  shrink: true,
  text: 'toBottom',
  onTap: () => TipToasts.toBottom(context, 'toBottom'),
)
```

![example_hbHZoFAO8O](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_hbHZoFAO8O.gif)


### 11. 底部弹窗

#### 11.1 底部消息弹窗

底部消息弹窗是消息弹窗的底部版本。你可以使用或禁用图片，指定相关文本，以及按钮的回调等。


例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'Primary',
      type: SemanticEnum.primary,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Primary Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.primary,
      ),
    ),
    SemanticButton(
      text: 'Secondary',
      type: SemanticEnum.secondary,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Secondary Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.secondary,
      ),
    ),
    SemanticButton(
      text: 'Info',
      type: SemanticEnum.info,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Info Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.info,
      ),
    ),
    SemanticButton(
      text: 'Success',
      type: SemanticEnum.success,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Success Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.success,
      ),
    ),
    SemanticButton(
      text: 'Warning',
      type: SemanticEnum.warning,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Warning Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.warning,
      ),
    ),
    SemanticButton(
      text: 'Danger',
      type: SemanticEnum.danger,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Danger Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.danger,
      ),
    ),
    SemanticButton(
      text: 'Fatal',
      type: SemanticEnum.fatal,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Fatal Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.fatal,
      ),
    ),
  ],
),
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/50c63288482441e696045cef7abddea9.gif)

### 11.2 底部确认弹窗

底部确认弹窗是确认弹窗的底部版本。你可以使用或禁用图片，指定相关文本，以及按钮的回调等。

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'Primary',
      type: SemanticEnum.primary,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Primary Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.primary,
      ),
    ),
    SemanticButton(
      text: 'Secondary',
      type: SemanticEnum.secondary,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Secondary Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.secondary,
      ),
    ),
    SemanticButton(
      text: 'Info',
      type: SemanticEnum.info,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Info Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.info,
      ),
    ),
    SemanticButton(
      text: 'Success',
      type: SemanticEnum.success,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Success Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.success,
      ),
    ),
    SemanticButton(
      text: 'Warning',
      type: SemanticEnum.warning,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Warning Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.warning,
      ),
    ),
    SemanticButton(
      text: 'Danger',
      type: SemanticEnum.danger,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Danger Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.danger,
      ),
    ),
    SemanticButton(
      text: 'Fatal',
      type: SemanticEnum.fatal,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Fatal Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
),
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/6a74972d5f8048209ccb257206fba86d.gif)

### 11.3 底部级联选择器

### 11.3.1 底部级联选择器简介

底部级联选择器是一种在移动应用中常用的UI组件，主要用于在一个底部弹出的模态框中进行多级选择。用户可以通过滚动选择不同的选项，这些选项通常是分层次的，例如选择地址时的省、市、区。底部级联选择器适用于需要多级选择的场景，常见的应用包括：

- 地址选择：用户可以依次选择省、市、区。

- 分类选择：在电商平台中选择商品的类别。

- 设置选项：例如设置日期和时间，先选择年份，再选择月份，最后选择日期。



底部级联选择器的主要特点包括：

- **多级选择**：支持多级数据的动态加载和显示。

- **自定义样式**：可以自定义按钮文本、样式等。

- **灵活配置**：支持配置是否可以点击背景关闭选择器，以及其他行为的自定义。

- **响应式交互**：选中项会即时反馈到UI上，提高用户体验。

### 11.3.2 示例：单级选择


```dart
SemanticButton(
  text: '一级选择表单',
  shrink: true,
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () => BottomSheets.showCascadeSheet(
    context,
    items: [
      {'label': ''},
      {'label': '中国'},
      {'label': '俄罗斯'},
      {'label': '美国'},
      {'label': '法国'},
      {'label': '德国'},
      {'label': '意大利'},
    ],
  ).then((value) {
    debugPrint('value = $value');
  }),
)
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/cc84116e550b4a28a58660ad918cb24b.gif)

### 11.3.3 示例：多级联动选择


```dart
SemanticButton(
  text: '多级联动选择表单',
  shrink: true,
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () => BottomSheets.showCascadeSheet(
    context,
    items: [
      {
        'label': '中国',
        'children': [
          {
            'label': '北京市',
            'children': [
              {
                'label': '东城区',
                'children': [
                  {'label': '安定门街道'},
                  {'label': '建国门街道'},
                  {'label': '朝阳门街道'},
                ],
              },
              {
                'label': '西城区',
                'children': [
                  {'label': '德胜门街道'},
                  {'label': '新街口街道'},
                  {'label': '月坛街道'},
                ],
              },
            ],
          },
          {
            'label': '上海市',
            'children': [
              {
                'label': '黄浦区',
                'children': [
                  {'label': '南京东路街道'},
                  {'label': '外滩街道'},
                  {'label': '半淞园路街道'},
                ],
              },
              {
                'label': '徐汇区',
                'children': [
                  {'label': '湖南路街道'},
                  {'label': '斜土路街道'},
                  {'label': '枫林路街道'},
                ],
              },
            ],
          },
        ],
      },
      {
        'label': '美国',
        'children': [
          {
            'label': '加利福尼亚州',
            'children': [
              {
                'label': '旧金山市',
                'children': [
                  {'label': '唐人街'},
                  {'label': '金融区'},
                  {'label': '渔人码头'},
                ],
              },
              {
                'label': '洛杉矶市',
                'children': [
                  {'label': '好莱坞'},
                  {'label': '比佛利山'},
                  {'label': '圣莫尼卡'},
                ],
              },
            ],
          },
          {
            'label': '纽约州',
            'children': [
              {
                'label': '纽约市',
                'children': [
                  {'label': '曼哈顿'},
                  {'label': '布鲁克林'},
                  {'label': '皇后区'},
                ],
              },
              {
                'label': '布法罗市',
                'children': [
                  {'label': '尼亚加拉广场'},
                  {'label': '艾伦敦'},
                  {'label': '拉萨尔公园'},
                ],
              },
            ],
          },
        ],
      },
    ],
  ).then((value) {
    debugPrint('value = $value');
  }),
)
```

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/3d7c9de55d8642c8bc054514a68b5d76.gif)



### 12. 抽屉

正在生产中


###  Issues Report

You can provide feedback or report [issues](https://github.com/jacklee1995/widgets_easier/issues) on this project's GitHub. If you feel that this library is missing a feature, please create a feature request. Pull requests are also welcome.







