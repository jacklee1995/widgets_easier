# Widgets Easier

[中文文档](https://github.com/jacklee1995/widgets_easier/blob/master/README_CN.md)

Widgets Easier is a Flutter component library of open-source widgets, featuring multiple pre-built UI components. It aims to make development faster, simpler, and more efficient, turning development into an enjoyable task.


![widgets_easier.png](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/assets/widgets_easier.png)

## Features


WidgetsEasier offers a wide range of features to streamline your Flutter development process:

- **Pre-built UI Components**: Save time and effort with our collection of ready-to-use UI widgets, including buttons, cards, lists, and more.
- **Customization Options**: Easily customize each component to match your app's unique design and branding requirements.
- **Responsive Design**: Ensure your app looks great on any screen size with built-in responsiveness features.
- **Cross-platform Compatibility**: Build once and deploy across multiple platforms, including iOS, Android, and web, with ease.
- **Open Source and Community-driven**: Benefit from an active community of developers contributing to the library's growth and improvement.
- **Easy Integration**: Seamlessly integrate WidgetsEasier into your existing Flutter projects with simple installation steps.
- **Regular Updates**: Stay up-to-date with the latest Flutter trends and best practices, as we continuously update and enhance WidgetsEasier.

## Getting Started

In your Flutter project, run the following commands:

```bash
flutter pub add widgets_easier
flutter pub add flutter_easy_animations
```

This will install the latest version of the Widgets Easier library. The animation part is encapsulated into the flutter_easy_animations library. When dealing with animation-related functionalities, you need to install it separately.


## Usage




### 1. Borders

#### 1.1 Solid Border

A Solid Border is the most common and basic type of border. Its main characteristics include:

1. Uniform edges: The defining feature of a Solid Border is its even, continuous line that separates it from the surrounding content. Unlike Ribbed Borders or Grooved Borders, there are no raised or sunken effects along the edges of a Solid Border; instead, it uniformly surrounds the target area.
   
2. Clear demarcation: The edges of the border are typically sharp, providing a distinct visual separation that allows users to clearly identify the boundaries of the target area.

3. Simple appearance: Solid Borders present a clean, straightforward appearance without additional decoration or depth effects. This simplicity is sometimes more suitable for interface designs that prioritize the content itself over decorative elements.

Solid Borders are commonly used in layouts that require a clean, clear design, such as table borders, buttons, input fields, and other elements where borders are necessary, or to highlight specific content boundaries. In design, the choice between using a Solid Border or other border styles depends on the designer's requirements for the overall style of the interface and user experience.

 

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

#### 1.2 Dotted Border

A Dotted Border is another type of border commonly used in interface design.

1. Dot pattern: The defining characteristic of a Dotted Border is that its edges are composed of a series of spaced dots rather than a continuous solid line. This combination of dots creates a blurred boundary visually, making the edges of the target area softer.

2. Delicate appearance: Dotted Borders present a lightweight, delicate appearance compared to Solid Borders. This light appearance makes Dotted Borders particularly suitable for scenarios where you want to highlight the target area without emphasizing the edges too much.

3. Visual separation: While Dotted Borders may not have the sharp delineation of Solid Borders, they still provide a visual separation effect, allowing users to discern the boundaries of the target area clearly. Dotted Borders are also commonly used to highlight specific content or as decorative borders.

Dotted Borders are typically used in layouts that require a soft, delicate design, such as borders for cards, panels, image frames, and other elements, or to emphasize specific content boundaries. In design, the choice between using a Dotted Border or other border styles depends on the designer's requirements for the overall style of the interface and user experience.

An example is provided below:


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

#### 1.3 Dashed Border

A Dashed Border is a common border style in interface design, slightly different in appearance and characteristics from Solid Borders and Dotted Borders. Its main features include:

1. Dash pattern: The defining feature of a Dashed Border is that its edges are composed of a series of spaced short dashes arranged at intervals, creating a dashed edge effect. This dashed appearance gives a lively and playful feeling visually.

2. Dynamic appearance: Compared to Solid Borders and Dotted Borders, Dashed Borders present a more dynamic and lively appearance. This characteristic makes Dashed Borders often used in scenarios where you want to highlight the target area and draw the user's attention.

3. Visual separation: Although the edges of Dashed Borders are not as continuous and distinct as Solid Borders, they still provide a certain degree of visual separation, helping users identify the boundaries of the target area.

Dashed Borders are typically used in layouts that require a lively and playful design, such as borders for cards, panels, buttons, and other elements, or to highlight specific content boundaries. In design, the choice between using a Dashed Border or other border styles depends on the designer's requirements for the overall style of the interface and user experience.

An example is provided below:

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

![alt text](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_7v9Ey30ZDN.png)

#### 1.4 Dotted Dash Border

A Dotted Dash Border is another type of border commonly used in interface design, with slight differences in appearance and characteristics compared to Solid Borders, Dotted Borders, and Dashed Borders. Its main features include:

1. Dot-dash pattern: The defining feature of a Dotted Dash Border is that its edges are composed of a series of alternately arranged dots and short dashes. This combination of dots and short dashes creates an alternating edge effect, giving the border both the continuity of dots and the spacing of short dashes.

2. Spaced separation: There is typically a certain spacing between the dots and short dashes of a Dotted Dash Border, making the border appear lighter and softer. This spaced separation characteristic makes Dotted Dash Borders often used in scenarios where you want to highlight the target area without emphasizing the edges too much.

3. Visual separation: Although the edges of a Dotted Dash Border are not as continuous and distinct as Solid Borders, they still provide a certain degree of visual separation, helping users identify the boundaries of the target area.

Dotted Dash Borders are typically used in layouts that require a light, soft design, such as borders for cards, panels, image frames, and other elements, or to highlight specific content boundaries. In design, the choice between using a Dotted Dash Border or other border styles depends on the designer's requirements for the overall style of the interface and user experience.

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

#### 1.5 Double Border

A Double Border is a common border style used in interface design to highlight or separate different areas. Compared to a single-line border, a Double Border has a more prominent and three-dimensional appearance. Its main features include:

1. Double-line structure: The defining feature of a Double Border is that its edges are composed of two parallel lines, typically with a certain spacing between them, creating a double boundary effect. This double-line structure enhances the border's sense of depth and thickness visually.

2. Prominent appearance: With two parallel lines, the edges of a Double Border have a more prominent and three-dimensional appearance compared to a single-line border, making it more eye-catching. This prominent appearance makes Double Borders particularly suitable for scenarios where you need to emphasize the target area or provide visual separation.

3. Clear demarcation: The two lines of a Double Border are typically clear and continuous, providing a distinct visual separation line that allows users to clearly identify the boundaries of the target area.

Double Borders are commonly used in interface layouts that require highlighting the target area or adding depth to elements, such as borders for cards, panels, buttons, and other elements, or to highlight specific content boundaries. In design, the choice between using a Double Border or other border styles depends on the designer's requirements for the overall style of the interface and user experience.

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

#### 1.6 Groove Border

A Groove Border is a 3D effect border used to highlight or separate different areas. In contrast to other borders, a Groove Border presents opposite visual characteristics. Its main features include:

1. Concave appearance: The defining feature of a Groove Border is its edges presenting a concave appearance, forming a distinct separation from the surrounding content. Compared to Ridge Borders, the edges of Groove Borders are inwardly concave, providing a sense of depth and compression.

2. Prominent edges: Despite being inwardly concave, the edges of the border are usually quite prominent, attracting the user's attention while also providing visual separation. This makes the boundaries between interface elements clearer.

3. Visual hierarchy: Groove Borders also create a sense of visual hierarchy, making the relationships between interface elements clearer. Through variations in depth, users can more easily understand the relationships between different parts of the interface.

Groove Borders are typically used in scenarios corresponding to Ridge Borders, such as highlighting dialog boxes, table cells, or emphasizing important content. In design, the choice between using a Groove Border or a Ridge Border depends on the designer's overall style and layout requirements for interface elements.

You can try the CSS version on the MDN website, which achieves the same effect as described here: [MDN - border-style](https://developer.mozilla.org/en-US/docs/Web/CSS/border-style).

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

#### 1.7 Ridge Border

A Ridge Border is typically used to highlight or separate different areas. Its characteristics include:

1. Raised appearance: The defining feature of a Ridge Border is its edges presenting a raised appearance, forming a distinct separation from the surrounding content.
  
2. Prominent edges: The edges of the border are usually quite prominent, attracting the user's attention while also providing visual separation.

3. Visual hierarchy: Ridge Borders create a sense of visual hierarchy, making the relationships between interface elements clearer.
  
   This type of border is common in user interface design, such as highlighting dialog boxes, table cells, or emphasizing important content.

You can try the CSS version on the MDN website, which achieves the same effect as described here: [MDN - border-style](https://developer.mozilla.org/en-US/docs/Web/CSS/border-style).

In reality, Ridge Borders and Groove Borders are completely opposite, essentially creating a mirror effect. They also have two colors: a light color representing the highlight and a dark color representing the solid line.

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

#### 1.8 Inset Border

An Inset Border is another type of 3D effect border, similar to a Groove border, but without the inner shadow effect.

1. Concave appearance: The defining feature of an Inset Border is its edges presenting a concave appearance, creating an inwardly sunken border compared to the surrounding content. This appearance gives users the perception that the target area is enveloped by the border, creating a sense of depth.

2. Clear demarcation: The edges of the border are typically clear, providing a distinct visual separation line that allows users to easily identify the boundaries of the target area.

3. Visual depth perception: Inset Borders introduce a sense of visual depth, making the target area more prominent. This effect can sometimes enhance the hierarchy between interface elements, improving user understanding of the interface layout.

4. Inset Borders are commonly used to highlight or separate different areas. In contrast to Outset Borders, the defining feature of Inset Borders is their edges presenting a concave appearance.

Inset Borders are commonly seen in user interface design, such as borders for cards, panels, buttons, and other elements, or to highlight specific content boundaries. In design, the choice between using an Inset Border or other border styles depends on the designer's requirements for the overall style and user experience of the interface.

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

#### 1.9 Outset Border

An Outset Border is another type of 3D effect border, similar to a Ridge border, but without the inner shadow effect. In contrast to an Inset Border, its defining feature is edges that appear to protrude outward.

1. Protruding appearance: The defining feature of an Outset Border is its edges presenting a protruding appearance, creating an outwardly bulging border compared to the surrounding content. This appearance gives users the perception that the edges of the target area are emphasized, creating a sense of depth.

2. Clear demarcation: The edges of the border are typically clear, providing a distinct visual separation line that allows users to easily identify the boundaries of the target area.

3. Visual emphasis: Outset Borders bring a visual emphasis, making the target area stand out more. This effect can sometimes enhance the hierarchy between interface elements, improving user understanding of the interface layout.

Outset Borders are also commonly seen in user interface design, such as borders for cards, panels, buttons, and other elements, or to highlight specific content boundaries. In design, the choice between using an Outset Border or other border styles depends on the designer's requirements for the overall style and user experience of the interface.

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

#### 1.10 BorderWrapper

The BorderWrapper component allows you to apply borders to other components, with content outside the border being clipped according to the border's outline. For example:

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

In this example, the SolidStarBorder used is based on Flutter's native StarBorder implementation, with the Solid Border effect added onto it. This allows you to specify line width, color, and gradients on the SolidStarBorder. The BorderWrapper can be used to achieve clipping with borders, enabling the addition of specified line effects while changing the shape of the original widget. Therefore, to implement more border shapes, you can create shape clippers similar to SolidStarBorder that draw lines. However, rest assured that this library will continue to implement new border shapes in the future.







### 2. Shadow Boxes

#### 2.1 Introduction to Shadow Boxes

Inspired by the **[Element-Plus](https://element-plus.org/)** component library in **Widgets Easier**, specific shadow effects are provided. These shadow effects can be added to other components in a component-like manner.

Similar to **[Element-Plus](https://element-plus.org/)**, in the **Widgets Easier** library, typical shadow effects are encapsulated into the following four components: **BasicShadow**, **LightShadow**, **LighterShadow**, **DarkShadow**. Each component uses DecoratedBox to implement a specific shadow effect.


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

类似于SemanticButton，ButtonGroup也可以使用枚举尺寸和数值尺寸两种方式来指定尺寸。

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

虽然ButtonGroup中可以有多个SemanticButton，但是在ButtonGroup上只能为第一个按钮添加前缀图标以及最后一个按钮添加后缀图标。这用起来十分简单，只需要为ButtonGroup指定prefixIcon参数或者suffixIcon参数。例如：
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

类似于SemanticButton，你可以为ButtonGroup指定收缩行为。这在类似于需要单个按钮组占满容器宽度的时候特别有用。例如，指定shrink参数值为false使按钮组占满整行：
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

按钮组ButtonGroup是由多个SemanticButton按照一定方式组织的整体。你可以为在ButtonGroup中的SemanticButton指定更多参数——语法这上没有错误。但是并不是每一个SemanticButton的参数在ButtonGroup中都会生效，因为在按钮组中需要按照自己的方式去进行管理。可以指定的主要是每一个按钮的文本、回调事件等，因为这些参数不属于整体，是单元特有的。





### 5. 加减器

#### 5.1 加减器组件简介

**CounterInput**`是一个用于数值输入和调整的 **Flutter** 组件，它提供了一个直观的界面，允许用户通过点击加号和减号按钮或直接输入数值来改变当前值。改组件包含以下特性：

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

![example_uoLPuBTKzb](J:\widgets_easier\assets\example_uoLPuBTKzb.png)

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



![example_h0k4KWue9E](J:\widgets_easier\assets\example_h0k4KWue9E.png)

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

![example_1JTzG6Hlaf](J:\widgets_easier\assets\example_1JTzG6Hlaf.png)

##### 2 数值尺寸

如果枚举尺寸不能满足要求还可以指定数值：

```dart
CounterInput(
  height: 50,
  controller: CounterInputController(),
),
```

![example_eDBmo5IVT9](J:\widgets_easier\assets\example_eDBmo5IVT9.png)

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

![example_tjpQHhVKRl](J:\widgets_easier\assets\example_tjpQHhVKRl.png)

#### 5.6 圆角加减器

通过`radius`属性可以很方便地为加减器设置圆角.例如：

```dart
const CounterInput(
  type: SemanticEnum.info,
  radius: 20,
  step: 3,
)
```

![example_4AXqYeLDKp](J:\widgets_easier\assets\example_4AXqYeLDKp.gif)

#### 5.7 自动宽度和固定宽度

默认情况下宽度是自动的，加减器文本输入区的宽度随着位数的增加而增加。但是也可以指定一个固定的文本输入区宽度。例如：

```dart

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

![example_wzi2mFQRMk](J:\widgets_easier\assets\example_wzi2mFQRMk.gif)

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



![example_fMYLgu8hR9](J:\widgets_easier\assets\example_fMYLgu8hR9.gif)


##### 4 值变化事件



```dart
CounterInput(
  onValueChanged: (oldValue, newValue) {
    print('oldValue is $oldValue, newValue is $newValue');
  },
)
```

![example_Jfs459a3CF](J:\widgets_easier\assets\example_Jfs459a3CF.gif)

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







