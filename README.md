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

`BasicShadow` is a component that provides basic shadow effects. It utilizes `DecoratedBox` to achieve the shadow effect, suitable for elements that require subtle highlighting. This shadow effect is not too strong but is sufficient to add some depth and dimension to the element.

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

`LightShadow` provides a lighter shadow effect compared to `BasicShadow`. It also utilizes `DecoratedBox`, with a subtler shadow that is suitable for interface elements that do not require much prominence but still want subtle differentiation.

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

`LighterShadow` is the lightest among the four shadows. It is almost invisible, providing only the slightest shadow effect when necessary. It is suitable for extremely delicate user interface designs where each detail requires meticulous handling.

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

`DarkShadow` provides the most intense shadow effect, implemented using `DecoratedBox`. This type of shadow is suitable for elements that require clear distinction, significantly enhancing the visual hierarchy of elements and drawing the user's attention effectively.

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

### 3. Buttons

#### 3.1 Basic Usage of SemanticButton

SemanticButton is a highly customizable button component that supports various visual and interactive effects. It allows developers to set the button's text, icon, color, border style, shadow, and visual feedback during interactions. Additionally, buttons can be configured with prefix and suffix icons to enhance their expressiveness and functionality.

Applying the semantic enumerations of SemanticButton to buttons allows for different buttons with color theme differentiations.

For example:

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

#### 3.2 Outline Button

##### 3.2.1 Basic Usage

By default, SemanticButton is a regular button (non-outline button). By setting the isOutlined property parameter of the SemanticButton class to true, the button will be displayed in outline form, for example:

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

##### 3.2.2 Outline Styles

In addition to the default solid outline, you can manually specify the outlineStyle parameter value to set different types of outlines or remove the outline. The solid outline (OutlineStyle.solide) is the default, so examples are not repeated here.

###### Dotted Outline

A dotted outline consists of a series of equally spaced dots connected together to form the edge of an object. By specifying outlineStyle: OutlineStyle.dotted, you can set a dotted outline. For example:

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

###### Dashed Outline

A dashed outline consists of a series of spaced dash lines connected together to form the edge of an object. By specifying outlineStyle: OutlineStyle.dashed, you can set a dashed outline. For example:

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

###### Disabled Outline

By specifying outlineStyle: OutlineStyle.none, you can disable the outline. For example:

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

#### 3.3 Callback Functions and Disabled State

By setting the onTap property of the button, you can specify a function as the callback function for the button click event. If no callback function is specified, or if the value of the onTap property is null, the button becomes disabled. For example:

![example_3spR0CNRPN](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics//example_3spR0CNRPN.gif)

For desktop or web platforms, a disabled button not only cannot be clicked, but also does not have elevation changes on hover like a normal button. Additionally, icons on the button switch from active to disabled icons.

#### 3.4 Text Styles

By setting the fontSize property, you can specify the size of the text. For example:

```dart
SemanticButton(
  text: 'fontSize: 22',
  fontSize: 22,
  onTap: () {},
  shrink: true,
),
```

![example_CKynxsm8dc](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_CKynxsm8dc.png)

By using the fontWeight property, you can specify the thickness of the font, for example:


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

#### 3.5 Corner Radius

##### 3.5.1 Specifying the Radius with the radius Parameter

The radius parameter of SemanticButton is used to uniformly specify the radius of all four corners of the button. It is a double type parameter. By default, the radius parameter value is 4. In some scenarios, depending on your needs, you can manually adjust the corner radius of the button. For example:

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

##### 3.5.2 Using the borderRadius Property

The `borderRadius` of **SemanticButton** is more flexible and can also be used to specify the radius of circular borders. For example, the following example demonstrates two buttons, each specifying rounded corners for their top-left and bottom-right corners:

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

#### 3.6 Button Sizes

##### 3.6.1 Size Enumerations

By using size enumerations, you can utilize preset sizes. For example:

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

##### 3.6.2 Numeric Sizes

In addition to size enumerations, you can also specify the size of the button using specific numerical values. Once a numerical value is specified, the enumerated sizes automatically become inactive. An example of specifying size using numerical values is:

```dart
SemanticButton(
  text: 'Size By Button Height: 60',
  type: SemanticEnum.info,
  height: 60,
  shrink: true,
  onTap: () {},
),
```

#### 3.7 Shrink Behavior

In the SemanticButton component, the shrink parameter controls the button's shrink behavior. When shrink is set to true, the button will adapt its width based on its content rather than occupying all available space. This is useful in certain cases, such as when you want to place multiple buttons side by side and want each button's width to match its content. Let's look at the effect of the shrink parameter through an example.

##### 3.7.1 Default Behavior (shrink = false)

1. When shrink is set to false (the default value), the button will occupy all available width provided by its parent container.
2. In this case, the button's width is determined by the constraints of its parent container rather than its content.
3. The button's content (text and icon) will be centered within the available space of the button.

Suppose the following button is in a Column, and there are no other widgets in this row:

```dart
SemanticButton(
  text: 'shrink = false',
  type: SemanticEnum.primary,
  onTap: () {},
),
```
##### 3.7.2 Shrink Behavior (shrink = true)

1. When shrink is set to true, the button will adapt its width based on its content.
2. The width of the button will be determined by the actual width of its content (text and icon) rather than occupying all available space.
3. This means the button will shrink to fit the width required by its content.

Here's an example with shrink = true. Suppose the following button is in a Column, and there are no other widgets in this row:

```dart
SemanticButton(
  text: 'shrink = true',
  shrink: true,
  type: SemanticEnum.primary,
  onTap: () {},
),
```
Here's a comparison between the two:

1. When shrink is set to true, the button will adapt its width based on its content.
2. The width of the button will be determined by the actual width of its content (text and icon) rather than occupying all available space.
3. This means the button will shrink to fit the width required by its content.

#### 3.8 Button Icons

##### 3.8.1 Using Prefix Icons

In `SemanticButton`, you can add a prefix icon using the `prefixIcon` property. This icon is displayed to the left of the button text and is typically used to enhance the button's semantics or provide visual cues. For example, a phone icon can be used on a "Call" button to visually indicate the button's function.

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

In the above code, `Icon(Icons.phone)` is passed as the `prefixIcon` to the `SemanticButton`, allowing users to visually identify this as a button for making phone calls.

##### 3.8.2 Using Suffix Icons

Similar to prefix icons, `SemanticButton` also supports suffix icons, set through the `suffixIcon` property. Suffix icons are displayed to the right of the button text and are suitable for indicating secondary actions or additional functionalities, such as an expand arrow or information icon.

```dart
SemanticButton(
  text: "Options",
  onTap: () {},
  shrink: true,
  suffixIcon: Icon(Icons.arrow_drop_down),
  type: SemanticEnum.primary,
)
```

In this example, `Icon(Icons.arrow_drop_down)` is set as the `suffixIcon`, indicating that this button may expand to show more options or a menu.

![example_9RPs3ZX2Ti](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_9RPs3ZX2Ti.png)

Whether it's a prefix icon or a suffix icon, the type is **Widget?**, which means you can flexibly use widgets as icons. In this way, the `prefixIcon` and `suffixIcon` properties of `SemanticButton` provide Flutter developers with a flexible way to design more expressive and functional user interfaces.

#### 3.9 Customizing Colors

##### 3.9.1 General Colors

You can customize the color through the button's color parameter. The color parameter has higher priority. If a custom color is specified, the color effect brought by the type parameter will disappear. The following example demonstrates how to implement the color parameter.

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

##### 3.9.2 Gradient Buttons

For a more visually appealing appearance, you can also specify button gradient colors through the gradient parameter. For example, the following example demonstrates two gradient color buttons:

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

### 4. Button Groups

Button groups in the Widgets Easier component library are collections of multiple SemanticButtons. They have unified semantics and are arranged closely together.

#### 4.1 Combining SemanticButtons in a ButtonGroup

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
In ButtonGroup, the event callback function for each button is directly specified on the onTap property of SemanticButton. Similarly, the text for each individual button is directly specified through the text parameter of each SemanticButton.

#### 4.2 Using Semantic Types

Similar to SemanticButton, you can also specify different type properties for ButtonGroup to obtain button groups with different symbolic colors representing different meanings. For example:

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

#### 4.3 Button Group Corner Radius

You can manually modify the corner radius of the button group by specifying the radius property for the button group. If not specified, the default corner radius is 4. An example of manually specifying the button group corner radius is as follows:

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

#### 4.4 Button Group Sizes

Similar to SemanticButton, ButtonGroup can also specify sizes using enumeration sizes and numerical sizes.

##### 4.4.1 Enumeration Sizes

Enumeration size values can be used to specify the size of the button group. For example:![example_KLiWhn18t5](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_KLiWhn18t5.gif)

##### 4.4.2 Numeric Sizes

Numeric sizes provide a more flexible way to specify sizes. Once a numeric size is used, the specified enumeration size will automatically become inactive. You can specify numeric sizes using the height property, for example:

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

#### 4.5 Using Prefix and Suffix Icons

While ButtonGroup can contain multiple SemanticButtons, only the first button in ButtonGroup can have a prefix icon and the last button can have a suffix icon. This is straightforward to implement, simply by specifying the prefixIcon parameter or suffixIcon parameter for the ButtonGroup. For example:

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

#### 4.6 Shrink Behavior

Similar to SemanticButton, you can specify the shrink behavior for ButtonGroup. This is particularly useful in situations where you need a single button group to occupy the full container width. For example, specifying the shrink parameter value as false to make the button group occupy the entire row:

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

#### 4.7 Helpful Tips

ButtonGroup is a whole composed of multiple SemanticButtons organized in a certain way. You can specify more parameters for SemanticButtons in ButtonGroup—there are no syntax errors here. However, not every parameter of SemanticButton will take effect in ButtonGroup because the buttons in the group need to be managed in their own way. The main parameters that can be specified are the text and callback events for each button because these parameters do not belong to the whole but are specific to each unit.

### 5. Counter

#### 5.1 Introduction to the Counter Component

**CounterInput** is a **Flutter** widget for numerical input and adjustment. It provides an intuitive interface that allows users to change the current value by clicking plus and minus buttons or directly inputting numbers. This component includes the following features:

1. Supports increasing or decreasing the current value by clicking plus and minus buttons.
2. Supports directly inputting numbers in the text field.
3. Customizable minimum value, maximum value, and step size.
4. Customizable styles, including size, color, and border style.
5. Provides multiple callback events for monitoring value changes and boundary conditions.
6. Supports continuous value change by long-pressing plus and minus buttons.
7. Supports disabling and enabling component interaction.

#### 5.2 Using Semantic Types

Like other components, you can specify semantic enumeration values through the `type` property to obtain different semantic colors. For example:

```dart
CounterInput(type: SemanticEnum.primary)
```

![example_uoLPuBTKzb](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_uoLPuBTKzb.png)

#### 5.3 Custom Colors

If you want to specify the colors of each part more flexibly, that's also possible. Specifically, there are the following color parameters:

1. iconColor: Color of the plus and minus icons
2. backgroundColor: Background color of the input field
3. buttonColor: Color of the buttons
4. textColor: Text color of the input field

Here's an example:

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

#### 5.4 Sizes

##### 5.4.1 Enumeration Sizes

You can specify enumeration sizes through the size parameter, including SizeEnum.small, SizeEnum.defaultSize, and SizeEnum.large. If not specified, the default is SizeEnum.defaultSize. For example:

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

##### 5.4.2 Numeric Sizes

If enumeration sizes cannot meet your requirements, you can also specify numerical values:

```dart
CounterInput(
  height: 50,
  controller: CounterInputController(),
),
```

![example_eDBmo5IVT9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_eDBmo5IVT9.png)

#### 5.5 Outline Style

By setting the value of `isOutlined` to true, you can set the counter as an outline style. For example:

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

#### 5.6 Rounded Counter

You can easily set the counter with rounded corners using the `radius` property, for example:

```dart
const CounterInput(
  type: SemanticEnum.info,
  radius: 20,
  step: 3,
)
```

![example_4AXqYeLDKp](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_4AXqYeLDKp.gif)

#### 5.7 Automatic Width and Fixed Width

By default, the width is automatic, and the width of the counter's text input area increases as the number of digits increases. However, you can also specify a fixed width for the text input area. For example:

```dart
CounterInput(
  textFieldWidth: 60,
  controller: CounterInputController(),
),
```



#### 5.8 Callback Events

##### 5.8.1 Increment and Decrement Callbacks

The increment callback is used to listen for value increase events, triggered when the value increases; similarly, the decrement callback is used to listen for decrease events, triggered when the value decreases.

- The `onIncrement` callback is used to monitor value increase events.
- The `onDecrement` callback is used to monitor value decrease events.

In the following example, with an initial value of 7 and a step of 2, when incrementing or decrementing, the new and old values are printed on the console:

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

> Note: Specifying an initial value requires using the CounterInputController controller, as shown in this example.



##### 5.8.2 Boundary Reached Callbacks

The counter has a maximum value and a minimum value, with the default minimum value being 0 and the maximum value being 100. When it reaches the minimum value, the minimum value callback is triggered. The following example demonstrates executing the relevant callbacks when reaching the maximum/minimum values. Here, the maximum value is set to 10, the minimum value to 1, the initial value to 6, and the step to 2. A popup message appears whenever the minimum or maximum value is reached.

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

Through this example, it can be observed that `onMax` and `onMin` are only called when reaching the maximum or minimum values, but they are not called if attempting to continue clicking the buttons beyond those limits. Using the GIF image above as an example, when incrementing to 10, the `onMax` method will be called, but attempting to increment further beyond 10 will not be handled.

##### 5.8.3 Overflow Callback

The overflow callback is used to respond to scenarios where operations continue beyond the maximum value when incrementing or beyond the minimum value when decrementing. For example:

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


##### 4. Value Change Events



```dart
CounterInput(
  onValueChanged: (oldValue, newValue) {
    print('oldValue is $oldValue, newValue is $newValue');
  },
)
```

![example_Jfs459a3CF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Jfs459a3CF.gif)

The corresponding clicks in the image result in the following console output:

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







