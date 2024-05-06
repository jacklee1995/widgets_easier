import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class ButtonGroupDocs extends StatelessWidget {
  final int c;
  const ButtonGroupDocs(this.c, {super.key});
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header1('$c. 按钮组'),
        Write.header2('$c.1 基本用法'),
        Write.paragraph(
            'Widgets Easier组件库中的按钮组是多个SemanticButton的集合，他们具有统一的语义，并且以紧密的方式进行排列。'),
        const Gap(20),
        Row(
          children: [
            HighlightView(
              '''ButtonGroup(
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
)''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(20),
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
            ),
          ],
        ),
        const Gap(20),
        Write.paragraph(
            '你可以像使用SemanticButton那样，为ButtonGroup添加一个type参数。这将使得ButtonGroup中的每一个SemanticButton都具有相同的type属性。'),
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
        const Gap(20),
        Write.header2('$c.2 按钮组圆角'),
        Write.paragraph(
            '通过为按钮组指定 radius 属性可以手动修改按钮组圆角。若不指定，默认圆角大小为4。一个手动指定按钮组圆角的示例如下：'),
        const Gap(20),
        Center(
          child: ButtonGroup(
            radius: 20,
            buttons: [
              SemanticButton(text: 'Group But1', onTap: () {}),
              SemanticButton(text: 'Group But2', onTap: () => {}),
              SemanticButton(text: 'Group But3', onTap: () => {}),
            ],
          ),
        ),
        const Gap(20),
        Write.header2('$c.3 按钮组尺寸'),
        Write.header3('$c.3.1 枚举尺寸'),
        Write.paragraph('可以使用尺寸枚举值为按钮组指定尺寸。例如：'),
        ButtonGroup(
          size: SizeEnum.small,
          buttons: [
            SemanticButton(text: 'small But1', onTap: () {}),
            SemanticButton(text: 'small But2', onTap: () => {}),
            SemanticButton(text: 'small But3', onTap: () => {}),
          ],
        ),
        const Gap(20),
        ButtonGroup(
          size: SizeEnum.defaultSize,
          buttons: [
            SemanticButton(text: 'defaultSize But1', onTap: () {}),
            SemanticButton(text: 'defaultSize But2', onTap: () => {}),
            SemanticButton(text: 'defaultSize But3', onTap: () => {}),
          ],
        ),
        const Gap(20),
        ButtonGroup(
          size: SizeEnum.large,
          buttons: [
            SemanticButton(text: 'large But1', onTap: () {}),
            SemanticButton(text: 'large But2', onTap: () => {}),
            SemanticButton(text: 'large But3', onTap: () => {}),
          ],
        ),
        const Gap(20),
        Write.header3('$c.3.2 数值尺寸'),
        Write.paragraph(
            '数值尺寸是更加灵活的大小指定方式。一旦使用数值尺寸，则指定的枚举尺寸将自动失效。你可以通过height属性来指定数值尺寸，例如：'),
        const Gap(20),
        Center(
          child: ButtonGroup(
            radius: 20,
            type: SemanticEnum.info,
            height: 60,
            buttons: [
              SemanticButton(text: 'But1', onTap: () {}),
              SemanticButton(text: 'But2', onTap: () => {}),
              SemanticButton(text: 'But3', onTap: () => {}),
            ],
          ),
        ),
        const Gap(20),
        Write.header2('$c.4 使用前后缀图标'),
        Write.paragraph(
            '虽然ButtonGroup中可以有多个SemanticButton，但是在ButtonGroup上只能为第一个按钮添加前缀图标以及最后一个按钮添加后缀图标。这用起来十分简单，只需要为ButtonGroup指定prefixIcon参数或者suffixIcon参数。例如：'),
        const Gap(20),
        Row(
          children: [
            HighlightView(
              '''ButtonGroup(
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
),''',
              language: 'dart',
              theme: vs2015Theme,
              padding: const EdgeInsets.all(12),
            ),
            const Gap(20),
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
            ),
          ],
        ),
        Write.header2('$c.5 收缩行为'),
        Write.paragraph(
            '类似于SemanticButton，你可以为ButtonGroup指定收缩行为。这在类似于需要单个按钮组占满容器宽度的时候特别有用。例如，指定shrink为false使按钮组占满整行：'),
        const Gap(10),
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
        const Gap(20),
      ],
    );
  }
}
