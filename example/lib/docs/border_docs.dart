import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class BorderDocs extends StatelessWidget {
  final int c;
  const BorderDocs(this.c, {super.key});
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header1('$c. 边框'),
        Write.header2('$c.1 实线边框（Solod）'),
        Write.paragraph('实线边框（Solid Border）是最普通、最常见地边框类型。'),
        Write.paragraph('其主要特点包括：'),
        Write.orderedList([
          Write.listItem(
              '均匀的边缘：实线边框的特点是其边缘是均匀的、连续的实线，与周围的内容形成分隔。与脊线边框和槽线边框相比，实线边框的边缘没有凸起或凹陷的效果，而是平整地围绕着目标区域。'),
          Write.listItem('清晰的界限：边框的边缘通常很清晰，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界。'),
          Write.listItem(
              '简洁的外观：实线边框呈现出简洁、直接的外观，没有额外的装饰或深度效果。这种简洁的外观有时候更适合需要注重内容本身而不是外观装饰的界面设计。'),
        ]),
        Write.paragraph(
            '实线边框通常用于需要简洁、清晰的界面布局中，例如表格的边框、按钮、输入框等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用实线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HighlightView(
              '''Container(
  width: 100,
  height: 50,
  decoration: ShapeDecoration(
    shape: SolidBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Center(child: Text("Hello, World!")),
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
            Container(
              height: 150,
              width: 300,
              decoration: ShapeDecoration(
                shape: SolidBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Center(child: Text("Hello, World!")),
            ),
          ],
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
            Container(
              height: 150,
              width: 300,
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
          ],
        ),
        Write.header2('$c.2 虚线边框（Dotted）'),
        Write.paragraph('虚线边框（Dotted Border）是一种在界面设计中另外一种边框类型。'),
        Write.paragraph('其主要特点包括：'),
        Write.orderedList([
          Write.listItem(
              '点线组成：虚线边框的特点是其边缘由一系列间隔的点线组成，而不是连续的实线。这种点线的组合在视觉上形成了一种虚化的边界，使得目标区域的边缘变得更加柔和；'),
          Write.listItem(
              '轻盈的外观：虚线边框呈现出轻盈、细腻的外观，与实线边框相比更加柔和。这种轻盈的外观使得虚线边框在需要突出显示目标区域但又不希望过于强调边缘的场景中非常适用；'),
          Write.listItem(
              '视觉分隔：虽然虚线边框没有实线边框那么明确的界限，但它仍然能够提供视觉上的分隔效果，使得用户能够清晰地识别出目标区域的边界。虚线边框也常用于突出显示特定内容或者作为装饰性边框使用。'),
        ]),
        Write.paragraph(
            '虚线边框通常用于需要柔和、轻盈的界面布局中，例如卡片、面板、图像边框等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用虚线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Write.paragraph('一个例子如下：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
            ),
          ],
        ),
        const Gap(20),
        Write.paragraph('你还可以设置更多的参数例如：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
            ),
          ],
        ),
        const Gap(20),
        Write.paragraph('即使是虚线，也是可以指定连变色的，例如：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
            Container(
              height: 150,
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
            ),
          ],
        ),
        const Gap(20),
        Write.header2('$c.3 破折线式边框（Dashed）'),
        Write.paragraph(
            '破折线式边框（Dashed Border）是界面设计中常见的边框样式之一，与实线边框和虚线边框相比，其外观和特点略有不同。'),
        Write.paragraph('其主要特点包括：'),
        Write.orderedList([
          Write.listItem(
              '破折线组成：破折线式边框的特点是其边缘由一系列间隔的短线段组成，这些短线段以一定的间隔排列，形成了一种破折的边缘效果。这种破折的外观在视觉上给人一种活泼、有趣的感觉。'),
          Write.listItem(
              '动态的外观：与实线边框和虚线边框相比，破折线式边框呈现出更具有动态感和活力感的外观。这种外观特点使得破折线边框常被用于需要突出显示目标区域并且希望引起用户注意的场景中。'),
          Write.listItem(
              '视觉分隔：尽管破折线式边框的边缘不像实线边框那样连续、明确，但它仍然能够提供一定程度的视觉分隔效果，帮助用户识别出目标区域的边界。'),
        ]),
        Write.paragraph(
            '破折线式边框通常用于需要活泼、有趣的界面布局中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用破折线式边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Write.paragraph('一个基本用法示例如下：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
            ),
          ],
        ),
        Write.paragraph('当然你也可以指定更多参数，比如：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
            ),
          ],
        ),
        Write.header2('$c.4 点划线边框（Dotted Dash）'),
        Write.paragraph(
            '点划线边框（Dotted Dash Border）是一种在界面设计中另外一种边框类型，，与实线边框、虚线边框、破折线边框等相比，其外观和特点略有不同。其主要特点有：'),
        Write.orderedList([
          Write.listItem(
              '点划线组成：点划线边框的特点是其边缘由一系列交替排列的点和短线段组成。这些点和短线段的组合形成了一种交替变化的边缘效果，使得边框的外观既有点线的连续性，又有短线段的间隔感；'),
          Write.listItem(
              '间隔分隔：点划线边框的点和短线段之间通常有一定的间隔，使得边框看起来更加轻盈和柔和。这种间隔分隔的外观特点使得点划线边框常被用于需要突出显示目标区域但又不希望过于强调边缘的场景中；'),
          Write.listItem(
              '视觉分隔：尽管点划线边框的边缘没有实线边框那样连续、明确，但它仍然能够提供一定程度的视觉分隔效果，帮助用户识别出目标区域的边界。'),
        ]),
        Write.paragraph(
            '点划线边框通常用于需要轻盈、柔和的界面布局中，例如卡片、面板、图像边框等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用点划线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Write.paragraph(''),
        Row(
          children: [
            HighlightView(
              '''Container(
  width: 200,
  height: 200,
  decoration: const ShapeDecoration(
    shape: DottedDashBorder(),
  ),
  child: const Center(child: Text("Circle Dots and Red Dashes")),
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
            Container(
              width: 200,
              height: 200,
              decoration: const ShapeDecoration(
                shape: DottedDashBorder(),
              ),
              child: const Center(child: Text("Circle Dots and Red Dashes")),
            )
          ],
        ),
        const Gap(20),
        Write.paragraph('你可可以指定跟多参数，比如点线的颜色，点的类型，以及点、线的尺寸等。'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
          ],
        ),
        Write.paragraph(''),
        Write.paragraph(''),
        Write.header2('$c.4 双线边框Double'),
        Write.paragraph(
            '双线边框（Double Border）是一种常见的边框样式，在界面设计中用于突出显示或分隔不同区域。与单线边框相比，双线边框具有更加突出和立体的外观。'),
        Write.paragraph('其主要特点包括：'),
        Write.orderedList([
          Write.listItem(
              '双线结构：双线边框的特点是其边缘由两条平行的线条组成，这两条线条之间通常有一定的间隔，形成了一种双重的边界效果。这种双线结构在视觉上增强了边框的立体感和厚度感;'),
          Write.listItem(
              '突出的外观：由于双线边框具有两条线条，其边缘呈现出更加突出和立体的外观，与单线边框相比更加引人注目。这种突出的外观使得双线边框在需要强调目标区域或者提供视觉分隔的场景中非常适用;'),
          Write.listItem(
              '清晰的界限：双线边框的两条线条通常是清晰、连续的，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界。'),
        ]),
        Write.paragraph(
            '双线边框常用于需要突出显示目标区域或者为元素增加立体感的界面布局中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用双线边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Write.paragraph('一个简单的例子如下：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
          ],
        ),
        const Gap(20),
        Write.paragraph('当然可以指定更多的参数：'),
        Row(
          children: [
            HighlightView(
              '''Container(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
          ],
        ),
        const Gap(20),
        Write.header2('$c.5 槽线式边框Groove'),
        Write.paragraph(
            '槽线式边框（Groove Border）是一种3D效果的边框，用于突出显示或分隔不同区域。与其它边框相比，槽线边框呈现出相反的外观特点。'),
        Write.paragraph('其主要特点包括：'),
        Write.orderedList([
          Write.listItem(
              '凹陷的外观：槽线式边框的特点是其边缘呈现出一种凹陷的外观，与周围的内容形成明显的分隔。与脊线边框相比，槽线边框的边缘向内凹陷，这种外观给人一种深度感和压缩感；'),
          Write.listItem(
              '边缘明显：边框的边缘通常也比较明显，尽管是向内凹陷的，但同样可以吸引用户的注意力，同时提供视觉上的分隔。这使得界面元素之间的边界更加清晰；'),
          Write.listItem(
              '视觉层次感：槽线式边框同样可以带来视觉上的层次感，使得界面元素之间的关系更加清晰。通过外观的深度变化，用户可以更轻松地理解界面中不同部分之间的关系。'),
        ]),
        Write.paragraph(
            '槽线式边框通常用于与脊线边框相对应的场景，例如突出显示对话框、表格的单元格或者突出显示重要内容等。在设计中，选择使用槽线边框还是脊线边框取决于设计师对界面元素的整体风格和布局的需求。'),
        Write.paragraph(
            '你可以在 MDN 网站上尝试CSS版本，与这里的实现效果是一样的：https://developer.mozilla.org/zh-CN/docs/Web/CSS/border-style。'),
        Write.paragraph('槽线式边框有两个颜色。亮色表示阴影，暗色表示实线，可以自行指定，也可以不指定。一个简单的例子如下：'),
        Row(
          children: [
            HighlightView(
              '''Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: GrooveBorder(width: 12),
  ),
  child: const Center(
    child: Text('Groove Border Example'),
  ),
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
          ],
        ),
        const Gap(20),
        Write.header2('$c.6 脊线式边框Ridge'),
        Write.paragraph('脊线式边框（Ridge Border）一种3D效果的边框，通常用于突出显示或分隔不同区域。其特点包括：'),
        Write.orderedList([
          Write.listItem('凸起的外观： 脊线式边框的特点是其边缘呈现出一种凸起的外观，与周围的内容形成明显的分隔;'),
          Write.listItem('边缘明显： 边框的边缘通常比较明显，可以吸引用户的注意力，同时提供视觉上的分隔；'),
          Write.listItem('视觉层次感： 脊线式边框可以带来视觉上的层次感，使得界面元素之间的关系更加清晰。'),
        ]),
        Write.paragraph('这种边框常见于用户界面设计中，例如突出显示对话框、表格的单元格或者突出显示重要内容等场景。'),
        Write.paragraph(
            '你可以在 MDN 网站上尝试CSS版本，与这里的实现效果是一样的：https://developer.mozilla.org/zh-CN/docs/Web/CSS/border-style。'),
        Write.paragraph(
            '实际上脊线式边框和槽线式边框是完全对应的，相当于做了一个镜像。它也有两个颜色。亮色表示阴影，暗色表示实线。'),
        Row(
          children: [
            HighlightView(
              '''Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: RidgeBorder(width: 6),
  ),
  child: const Center(child: Text("Ridge Border Example")),
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
            Container(
              height: 150,
              width: 300,
              decoration: const ShapeDecoration(
                shape: RidgeBorder(width: 6),
              ),
              child: const Center(child: Text("Ridge Border Example")),
            ),
          ],
        ),
        const Gap(20),
        Write.header2('$c.7 内嵌式边框Inset'),
        Write.paragraph(
            '内嵌式边框（Inset Border）也是一种3D效果的边框，它类似于Gooove边框。只不过没有内测阴影效果。'),
        Write.orderedList([
          Write.listItem(
              '向内凹陷的外观：内嵌式边框的特点是其边缘呈现出向内凹陷的外观，与周围的内容形成一种凹陷的边界。这种外观让用户感觉目标区域被边框所包裹，形成了一种立体感；'),
          Write.listItem('清晰的界限：边框的边缘通常是清晰的，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界；'),
          Write.listItem(
              '视觉深度感：内嵌式边框带来了一种视觉深度感，使得目标区域看起来更加突出。这种效果有时候可以增强界面元素之间的层次感，提高用户对界面布局的理解；'),
          Write.paragraph(
              '内嵌式边框（Inset Border）常用于突出显示或分隔不同区域。与外凸式边框（Outset Border）相对应，内嵌式边框的特点是其边缘呈现出向内凹陷的外观。'),
        ]),
        Write.paragraph(
            '内嵌式边框常见于用户界面设计中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用内嵌式边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Row(
          children: [
            HighlightView(
              '''Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: InsetBorder(width: 8),
  ),
  child: const Center(child: Text("Inset Border Example")),
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
            Container(
              height: 150,
              width: 300,
              decoration: const ShapeDecoration(
                shape: InsetBorder(width: 8),
              ),
              child: const Center(child: Text("Inset Border Example")),
            ),
          ],
        ),
        const Gap(20),
        Write.header2('$c.8 外凸式边框Outset'),
        Write.paragraph(
            '外凸式边框（Outset Border）也是一种3D效果的边框，它类似于Ridge边框。只不过没有内测阴影效果。与内嵌式边框相对应，其特点是边缘呈现出向外凸起的外观。'),
        Write.paragraph('其主要特点包括：'),
        Write.orderedList([
          Write.listItem(
              '向外凸起的外观：外凸式边框的特点是其边缘呈现出向外凸起的外观，与周围的内容形成一种凸起的边界。这种外观让用户感觉目标区域的边缘被突出，形成了一种立体感；'),
          Write.listItem('清晰的界限：边框的边缘通常是清晰的，提供了明确的视觉分隔线，使得用户能够清晰地识别出目标区域的边界；'),
          Write.listItem(
              '视觉突出感：外凸式边框带来了一种视觉突出感，使得目标区域看起来更加突出。这种效果有时候可以增强界面元素之间的层次感，提高用户对界面布局的理解。'),
        ]),
        Write.paragraph(
            '外凸式边框同样常见于用户界面设计中，例如卡片、面板、按钮等元素的边框，或者用于突出显示特定内容的边界。在设计中，选择使用外凸式边框还是其他边框样式取决于设计师对界面整体风格和用户体验的需求。'),
        Row(
          children: [
            HighlightView(
              '''Container(
  height: 150,
  width: 300,
  decoration: const ShapeDecoration(
    shape: OutsetBorder(width: 8),
  ),
  child: const Center(
    child: Text('Outset Border Example'),
  ),
),''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(60),
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
          ],
        ),
        Write.header2('$c.9 边框包装器BorderWrapper'),
        Write.paragraph(
            '通过使用BorderWrapper组件，可以在其它的组件上使用边框，边框外部的内容将被按照边框轮廓裁剪掉。例如：'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HighlightView(
              '''BorderWrapper(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(40),
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
            ),
          ],
        ),
        const Gap(20),
        Write.paragraph(
            '这个例子中，所使用的 SolidStarBorder 是基于Flutter原生的StarBorder实现的，在StarBorder上实现了Solid Border的效果。这使得你可以在SolidStarBorder上指定线宽、颜色，渐变色。'),
        Write.paragraph('边框包装器可以用于实现带有边框的裁剪，这使得改变原部件形状的同时在外围添加指定的线形效果。'),
        Write.paragraph(
            '因此，为了实现更多边框形状，你可以实现类似于SolidStarBorder的，带有绘制线形的形状裁剪器。不过不用担心，此库后续将不断实现新的边框形状。'),
        const Gap(20),
      ],
    );
  }
}
