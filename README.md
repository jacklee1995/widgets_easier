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




### Borders

#### Solid Border

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

### Dotted Border

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

### Dashed Border

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

### Dotted Dash Border

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

### Double Border

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

### Groove Border

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

### Ridge Border

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

### Inset Border

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

### Outset Border

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

#### BorderWrapper

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



