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
        Write.header1('5.按钮'),
        Write.header2('5.1 按钮语义'),
        Write.paragraph('将语义应用于按钮，可以获得色彩主题差异化的不同按钮。'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        Write.header2('5.2 轮廓按钮'),
        Write.header3('5.2.1 基本用法'),
        Write.paragraph('SemanticButton默认为普通按钮（非轮廓按钮）。'),
        Write.paragraph(
            '通过设置SemanticButton类的isOutlined属性参数值为true，则按钮将一轮廓形式显示，例如：'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        Write.header3('5.2.2 轮廓类型'),
        Write.paragraph(
            '除了默认的实线轮廓外，还可以手动指定outlineStyle参数值设置伦托类型以及去轮廓。实线轮廓（OutlineStyle.solide）是默认的，因此这里不再重复给出例子。'),
        Write.header4('1 Dotted轮廓'),
        Write.paragraph(
            'Dotted 轮廓由一系列间隔相等的点组成，这些点连接在一起形成物体的边缘。通过指定outlineStyle: OutlineStyle.dotted，可以设置Dotted轮廓。例如：'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        Write.header4('2 Dashed轮廓'),
        Write.paragraph(
            'Dashed 轮廓由一系列间隔的虚线组成，这些虚线连接在一起形成物体的边缘。通过指定outlineStyle: OutlineStyle.dashed，可以设置Dashed轮廓。例如：'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        Write.header4('2 禁用轮廓'),
        Write.paragraph('通过指定outlineStyle: OutlineStyle.none，可以禁用轮廓。例如：'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
        Write.header2('5.3 回调函数与禁用状态'),
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
        Write.header2('5.4 圆角大小'),
        Write.paragraph('按钮圆角的默认值为4。再某些场景中，依据你的需求，可以手动调整按钮的圆角大小。'),
        Row(
          children: [
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
        Write.header2('5.5 按钮尺寸'),
        Write.header3('5.5.1 尺寸枚举'),
        Row(
          children: [
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
        Write.header3('5.5.2 数值尺寸'),
        Write.paragraph('除了尺寸枚举，你还可以通过具体的数值来指定按钮的尺寸，一旦指定数值则枚举尺寸自动失效。'),
        Write.header2('5.6 文本样式'),
        Write.header3('5.6.1 文本样式'),
        Write.paragraph('通过设置fontSize属性，可以指定文本的大小。例如：'),
        SemanticButton(
          text: 'fontSize: 22',
          fontSize: 22,
          onTap: () {},
          shrink: true,
        ),
        Write.header3('5.6.2 粗体字'),
        Write.paragraph(''),
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
        Write.header2('5.7 按钮图标'),
        Write.header2('5.8 收缩行为'),
        Write.paragraph(
            '在 SemanticButton 组件中，shrink 参数用于控制按钮的收缩行为。当 shrink 设置为 true 时，按钮会根据其内容自适应宽度，而不是占据所有可用空间。这在某些情况下很有用，例如当你想要将多个按钮并排放置，并且希望每个按钮的宽度与其内容相匹配时。'),
        Write.paragraph('下面具体看一下 shrink 参数的作用。'),
        Write.header3('5.8.1 默认行为（shrink = false）'),
        Write.orderedList([
          Write.listItem('当 shrink 设置为 false（默认值）时，按钮将占据其父容器提供的所有可用宽度。'),
          Write.listItem('在这种情况下，按钮的宽度由其父容器的约束决定，而不是由按钮的内容决定。'),
          Write.listItem('按钮内容（文本和图标）将在按钮的可用空间内居中对齐。'),
        ]),
        Write.paragraph('下面是一个shrink = false的例子：'),
        SemanticButton(
          text: 'shrink = false',
          type: SemanticEnum.primary,
          onTap: () {},
        ),
        Write.paragraph('从这个例子可以看到，按钮占满了全部父容器宽度。'),
        Write.header3('5.8.2 收缩行为（shrink = true）'),
        Write.orderedList([
          Write.listItem('当 shrink 设置为 true 时，按钮将根据其内容自适应宽度。'),
          Write.listItem('按钮的宽度将由其内容（文本和图标）的实际宽度决定，而不是占据所有可用空间。'),
          Write.listItem('这意味着按钮将收缩到恰好容纳其内容所需的宽度。'),
        ]),
        Write.paragraph(
            '在 SemanticButton 组件的 build 方法中，根据 shrink 参数的值，使用了不同的部件来包装按钮内容'),
      ],
    );
  }
}
