import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../widgets/docs_widget.dart';
import 'dynamic_tags_example.dart';

class TagDocs extends StatelessWidget {
  final int c;
  const TagDocs(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        const Gap(20),
        Write.header1('$c. 标签'),
        Write.header2('$c.1 语义类型'),
        const Gap(20),
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
        const Gap(20),
        Write.header2('$c.2 主题'),
        Write.paragraph(
            'Tag有3个主题，plain、light和dark，默认情况下为palin，正如上一节所展示的那样。下面展示light和dark两个主题：'),
        Write.header3('$c.2.1 light主题'),
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
        const Gap(20),
        Write.header3('$c.2.2 dark主题'),
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
        const Gap(20),
        Write.header2('$c.2 尺寸'),
        Write.header3('$c.2.1 枚举尺寸'),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Tag('SizeEnum.small', size: SizeEnum.small),
            Tag('SizeEnum.defaultSize', size: SizeEnum.defaultSize),
            Tag('SizeEnum.large', size: SizeEnum.large),
          ],
        ),
        const Gap(20),
        Write.header3('$c.2.2 数值尺寸'),
        const Gap(20),
        Write.header2('$c.3 可关闭标签'),
        Write.paragraph(''),
        const Tag(
          '可关闭',
          closable: true,
        ),
        const Gap(20),
        const DynamicTagsExample(),
        const Gap(40),
      ],
    );
  }
}
