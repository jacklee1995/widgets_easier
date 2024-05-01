import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class ButtonDocs extends StatelessWidget {
  const ButtonDocs({super.key});
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header2('3.1 按钮语义'),
        Write.paragraph('将语义应用于按钮，可以获得色彩主题差异化的不同按钮。'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
            ),
          ],
        ),
        const Gap(20),
        Write.header2('3.2 轮廓按钮'),
        const Gap(20),
        Write.header3('3.2.1 基本用法'),
        Write.paragraph('SemanticButton默认为普通按钮（非轮廓按钮）。'),
        Write.paragraph(
            '通过设置SemanticButton类的isOutlined属性参数值为true，则按钮将一轮廓形式显示，例如：'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
          ],
        ),
        const Gap(20),
        Write.header3('3.2.2 轮廓类型'),
        Write.paragraph(
            '除了默认的实线轮廓外，还可以手动指定outlineStyle参数值设置伦托类型以及去轮廓。实线轮廓（OutlineStyle.solide）是默认的，因此这里不再重复给出例子。'),
        Write.header4('1 Dotted轮廓'),
        Write.paragraph(
            'Dotted 轮廓由一系列间隔相等的点组成，这些点连接在一起形成物体的边缘。通过指定outlineStyle: OutlineStyle.dotted，可以设置Dotted轮廓。例如：'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
          ],
        ),
        const Gap(20),
        Write.header4('2 Dashed轮廓'),
        Write.paragraph(
            'Dashed 轮廓由一系列间隔的虚线组成，这些虚线连接在一起形成物体的边缘。通过指定outlineStyle: OutlineStyle.dashed，可以设置Dashed轮廓。例如：'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
          ],
        ),
        const Gap(20),
        Write.header4('2 禁用轮廓'),
        Write.paragraph('通过指定outlineStyle: OutlineStyle.none，可以禁用轮廓。例如：'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
          ],
        ),
        const Gap(20),
        Write.header2('3.3 回调函数与禁用状态'),
        Write.paragraph('通过设置按钮ontap属性值可以指定一个函数作为按钮点击时间的回调函数。'),
        Write.paragraph('如果没有指定回调函数，或者指定onTap属性的值为null，则按钮状态成为禁用状态。例如：'),
        const Row(
          children: [
            SemanticButton(
              text: 'A disabled button',
              shrink: true,
            ),
            Gap(10),
            SemanticButton(
              text: 'A disabled Outlined button',
              shrink: true,
              isOutlined: true,
            ),
          ],
        ),
        Write.paragraph(
            '对于桌面端或者Web平台，一个被禁用的按钮不仅无法被点击，而且在hover时，不会像正常按钮那样拥有海拔变化。图标上也从寿星图标转换为禁用图标。'),
        Write.header2('3.4 圆角大小'),
        Write.paragraph('按钮圆角的默认值为4。在某些场景中，依据你的需求，可以手动调整按钮的圆角大小。'),
        const Gap(10),
        Row(
          children: [
            const Gap(10),
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
          ],
        ),
        Write.paragraph('从0.0.2版本开始，按钮中新增了borderRadius属性，可以为指定角添加圆角。例如：'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SemanticButton(
              text: 'topLeft: Radius.circular(20)',
              shrink: true,
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
              shrink: true,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(20)),
              type: SemanticEnum.warning,
              isOutlined: true,
              onTap: () {},
              radius: 20,
            ),
          ],
        ),
        const Gap(10),
        Write.paragraph('如果指定了非null的borderRadius属性，则radius属性将自动失效。'),
        const Gap(20),
        Write.header2('3.5 按钮尺寸'),
        Write.header3('3.5.1 尺寸枚举'),
        Write.paragraph('通过尺寸枚举，可以使用预设大小。例如：'),
        const Gap(10),
        Row(
          children: [
            const Gap(10),
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
          ],
        ),
        const Gap(10),
        Write.header3('3.5.2 数值尺寸'),
        Write.paragraph(
            '除了尺寸枚举，你还可以通过具体的数值来指定按钮的尺寸，一旦指定数值则枚举尺寸自动失效。一个通过数值指定尺寸的例子如：'),
        const Gap(10),
        SemanticButton(
          text: 'Size By Button Height: 60',
          type: SemanticEnum.info,
          height: 60,
          shrink: true,
          onTap: () {},
        ),
        const Gap(10),
        Write.header2('3.6 文本样式'),
        Write.header3('3.6.1 文本样式'),
        Write.paragraph('通过设置fontSize属性，可以指定文本的大小。例如：'),
        const Gap(10),
        SemanticButton(
          text: 'fontSize: 22',
          fontSize: 22,
          onTap: () {},
          shrink: true,
        ),
        const Gap(10),
        Write.header3('3.6.2 粗体字'),
        Write.paragraph('通过fontWeight属性，可以指定字体粗细程度，例如：'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
          ],
        ),
        Write.header2('3.7 按钮图标'),
        Write.header3('3.7.1 前缀图标的使用'),
        Write.paragraph(
            '在 SemanticButton 中，可以通过 prefixIcon 属性添加一个前缀图标。这个图标显示在按钮文本的左侧，通常用于增强按钮的语义或者提供视觉提示。例如，一个电话图标可以用在“呼叫”按钮上，以直观地表明按钮的功能。例如：'),
        const Gap(20),
        SemanticButton(
          text: "Call",
          onTap: () {},
          shrink: true,
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.amber,
          ),
          type: SemanticEnum.primary,
        ),
        const Gap(20),
        Write.header3('3.7.2 后缀图标的使用'),
        Write.paragraph(
            '与前缀图标类似，SemanticButton 也支持后缀图标，通过 suffixIcon 属性设置。后缀图标显示在按钮文本的右侧，适用于指示按钮的次要操作或额外的功能，如展开箭头或信息图标。例如：'),
        const Gap(20),
        SemanticButton(
          text: "Options",
          onTap: () {},
          shrink: true,
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          type: SemanticEnum.primary,
        ),
        const Gap(20),
        Write.paragraph(
            '不论前缀图标还是后缀图标，类型都是Widget?，这意味着你可以灵活使用组件作为图标。通过这种方式，SemanticButton 的 prefixIcon 和 suffixIcon 属性为Flutter开发者提供了一种灵活的方法来设计更具表达性和功能性的用户界面。'),
        const Gap(20),
        Write.header2('3.8 收缩行为'),
        Write.paragraph(
            '在 SemanticButton 组件中，shrink 参数用于控制按钮的收缩行为。当 shrink 设置为 true 时，按钮会根据其内容自适应宽度，而不是占据所有可用空间。这在某些情况下很有用，例如当你想要将多个按钮并排放置，并且希望每个按钮的宽度与其内容相匹配时。'),
        Write.paragraph('下面通过例子具体看一下 shrink 参数的作用。'),
        Write.header3('3.8.1 默认行为（shrink = false）'),
        Write.orderedList([
          Write.listItem('当 shrink 设置为 false（默认值）时，按钮将占据其父容器提供的所有可用宽度。'),
          Write.listItem('在这种情况下，按钮的宽度由其父容器的约束决定，而不是由按钮的内容决定。'),
          Write.listItem('按钮内容（文本和图标）将在按钮的可用空间内居中对齐。'),
        ]),
        Write.paragraph('下面是一个shrink = false的例子，假设下面这个按钮在一个Column中，这一行没有其它部件：'),
        SemanticButton(
          text: 'shrink = false',
          type: SemanticEnum.primary,
          onTap: () {},
        ),
        Write.paragraph('从这个例子可以看到，按钮占满了全部父容器宽度。'),
        Write.header3('3.8.2 收缩行为（shrink = true）'),
        Write.orderedList([
          Write.listItem('当 shrink 设置为 true 时，按钮将根据其内容自适应宽度。'),
          Write.listItem('按钮的宽度将由其内容（文本和图标）的实际宽度决定，而不是占据所有可用空间。'),
          Write.listItem('这意味着按钮将收缩到恰好容纳其内容所需的宽度。'),
        ]),
        Write.paragraph('下面是一个shrink = true的例子，假设下面这个按钮在一个Column中，这一行没有其它部件：'),
        const Gap(20),
        SemanticButton(
          text: 'shrink = true',
          shrink: true,
          type: SemanticEnum.primary,
          onTap: () {},
        ),
        const Gap(20),
        Write.header2('3.9 自定义颜色'),
        Write.header3('3.9.1 自定义按钮单色'),
        Write.paragraph(
            '通过按钮的 color 参数可以自定义颜色。color参数具有更高的优先级。如果自定义颜色，则 type 参数带来的颜色效果将消失。'),
        Write.paragraph('下面的例子展示了如何实现 color参数。'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ),
          ],
        ),
        Write.paragraph(
            '可见你仅仅需要指定一个颜色参数，而相关颜色参数是自动计算的，比如背景色、轮廓色等等，这使得我们用起来更加方便。'),
        const Gap(40),
        Write.header3('3.9.2 渐变色'),
        Write.paragraph(
            '为了实现更加好看的外观，你还可以通过gradient参数指定按钮渐变色。例如，下面的例子展示了两个渐变色按钮：'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
          ],
        ),
        const Gap(20),
      ],
    );
  }
}
